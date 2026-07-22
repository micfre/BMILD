#!/bin/sh
# BMILD slice-budget estimator (POSIX sh) — peak_live_v2.
# Predicts peak live context occupancy for an implementation session under
# code-intel / LSP workflows (full contract reads + capped symbol excerpts).
# Emits TSV with fixed sections: STATUS, BUDGET, READS, EDITS, SKIPPED_*,
# NEW_FILE_ESTIMATE. No format-string emission (ADR 0007); awk uses print only.
set -eu

TAB='	'
NL='
'

# --- user-configurable defaults (overridable via .bmild.toml / CLI) ---
DEFAULT_TARGET=170000
DEFAULT_BASE=15000
DEFAULT_MULTIPLIER=1.0

# --- peak_live_v2 internal constants (model definition, not preferences) ---
MODEL_ID=peak_live_v2
BYTES_PER_TOKEN=4
TURN_RESERVE=20000
SYMBOL_READ_CAP=2500
SYMBOL_EDIT_CAP=5000
ITEM_OVERHEAD=500

CFG_TARGET=$DEFAULT_TARGET
CFG_BASE=$DEFAULT_BASE
CFG_MULTIPLIER=$DEFAULT_MULTIPLIER

OF_TARGET=""
OF_BASE=""
OF_MULTIPLIER=""
NEW_SET=0
NEW_VAL=""
src=""
mode="full_read"
reads_n=0
edits_n=0
LEGACY_WARN=""

WORKDIR="${TMPDIR:-/tmp}"
RECFILE="$WORKDIR/bmild-budget.rec.$$"
SKIPFILE="$WORKDIR/bmild-budget.skip.$$"
PENFILE="$WORKDIR/bmild-budget.pen.$$"
cleanup(){ rm -f "$RECFILE" "$SKIPFILE" "$PENFILE"; }
trap cleanup EXIT
: > "$RECFILE"
: > "$SKIPFILE"
: > "$PENFILE"

NEW_AVG_BYTES=""
NEW_AVG_RAW=0
NEW_EST_RAW=0

usage(){
cat <<'EOF'
Usage: run-budget-slice.sh [options]

Estimate peak live context tokens for one implementation Slice (peak_live_v2).
Assumes code-intelligence / LSP workflows: contracts and docs are full-file
context; source navigation is capped symbol excerpts. Output is TSV with
fixed sections: STATUS, BUDGET, READS, EDITS, SKIPPED_READS, SKIPPED_EDITS,
SKIPPED_NEW, NEW_FILE_ESTIMATE.

Options:
  --target <int>           token budget override (slice_target)
  --base <int>             mandatory-context overhead override (tokenizer_base)
  --multiplier <float>     residual safety margin override (tokenizer_multiplier)
  --full-reads <path>...   switch to full-read mode; collect full-file reads
  --symbol-reads <path>... switch to symbol-read mode; collect capped excerpts
  --full-edits <path>...   switch to full-edit mode; collect full-file edits
  --symbol-edits <path>... switch to symbol-edit mode; collect capped edits
  --reads <path>...        alias for --full-reads (compatibility)
  --edits <path>...        alias for --full-edits (compatibility)
  --new <int>              count of new files to estimate
  --src <path>             representative source dir (required when --new > 0)
  --penalty <path> <float> multiplicative indicator penalty (repeatable)
  -h, --help               show this help and exit

User-facing .bmild.toml keys: slice_target, tokenizer_base, tokenizer_multiplier.
Byte/token ratio, turn reserve, symbol caps, and per-item overhead are fixed
by peak_live_v2. Every estimate is an informed guess.
EOF
}

fail(){ echo "Error: $1" >&2; exit 1; }

is_uint(){
  case "$1" in ''|*[!0-9]*) return 1 ;; esac
  return 0
}
is_num(){
  case "$1" in ''|*[!0-9.]*|*.*.*) return 1 ;; esac
  return 0
}
is_pos(){
  awk -v x="$1" 'BEGIN{exit !(x>0)}'
}

find_bmild_toml(){
  _d="$1"
  while :; do
    if [ -f "$_d/.bmild.toml" ]; then echo "$_d/.bmild.toml"; return 0; fi
    case "$_d" in
      /) return 1 ;;
    esac
    _nd="${_d%/*}"
    if [ "$_nd" = "$_d" ]; then
      if [ -f "/.bmild.toml" ]; then echo "/.bmild.toml"; return 0; fi
      return 1
    fi
    _d="$_nd"
    [ -z "$_d" ] && _d="/"
  done
}

note_legacy(){
  case "$LEGACY_WARN" in
    *"$1"*) ;;
    *) LEGACY_WARN="${LEGACY_WARN}${LEGACY_WARN:+ }$1" ;;
  esac
}

read_config(){
  _cp="$1"
  [ -n "$_cp" ] && [ -f "$_cp" ] || return 0
  while IFS= read -r _line || [ -n "$_line" ]; do
    case "$_line" in ''|'#'*) continue ;; esac
    case "$_line" in *=*) : ;; *) continue ;; esac
    _key=${_line%%=*}
    _val=${_line#*=}
    # shellcheck disable=SC2086  # intentional word-split to trim whitespace
    set -- $_key; _key=${1:-}
    [ -n "$_key" ] || continue
    case "$_key" in *[!A-Za-z0-9_]*) continue ;; esac
    # shellcheck disable=SC2086  # intentional word-split to trim whitespace
    set -- $_val; _val=${1:-}
    case "$_val" in \"*\") _val=${_val#\"}; _val=${_val%\"} ;; esac
    case "$_key" in
      slice_target) is_uint "$_val" && CFG_TARGET=$_val ;;
      tokenizer_base) is_uint "$_val" && CFG_BASE=$_val ;;
      tokenizer_multiplier) is_num "$_val" && CFG_MULTIPLIER=$_val ;;
      tokenizer_ratio|penalty_size_threshold|penalty_size_exponent|penalty_noise_bpl|penalty_noise_factor|penalty_cap|edit_premium|carry_cap)
        note_legacy "$_key"
        ;;
    esac
  done < "$_cp"
}

normalize_path(){
  case "$1" in *"$TAB"*|*"$NL"*) fail "path contains tab or newline: $1" ;; esac
  case "$1" in -*) echo "./$1" ;; *) echo "$1" ;; esac
}

is_binary(){
  _n=$(head -c 4096 "$1" 2>/dev/null | tr -cd '\000' | wc -c)
  # shellcheck disable=SC2086  # intentional word-split to strip wc padding
  set -- ${_n:-0}
  [ "${1:-0}" -gt 0 ]
}

# role is one of: full_read | symbol_read | full_edit | symbol_edit
measure_file(){
  _p=$(normalize_path "$1")
  _role="$2"
  case "$_role" in
    full_read|symbol_read) _skiprole="read" ;;
    *) _skiprole="edit" ;;
  esac
  if [ ! -f "$_p" ]; then
    echo "${_skiprole}${TAB}${_p}" >> "$SKIPFILE"
    return
  fi
  # shellcheck disable=SC2046  # intentional: split wc's "lines bytes" output
  set -- $(wc -l -c < "$_p"); _lines=$1; _bytes=$2
  if is_binary "$_p"; then
    echo "${_skiprole}${TAB}${_p}" >> "$SKIPFILE"
    return
  fi
  if [ "$_bytes" -gt 0 ] && [ -n "$(tail -c 1 "$_p")" ]; then
    _lines=$((_lines + 1))
  fi
  echo "${_role}${TAB}${_p}${TAB}${_bytes}${TAB}${_lines}" >> "$RECFILE"
}

measure_source_dir(){
  _src="$1"
  [ -d "$_src" ] && [ -r "$_src" ] || return 1
  _sum=0; _cnt=0; _found=0
  _files=$(find "$_src" -type f 2>/dev/null) || _files=""
  [ -n "$_files" ] || return 0
  _oldIFS=$IFS; IFS="$NL"
  for _f in $_files; do
    IFS="$_oldIFS"
    [ -f "$_f" ] || { IFS="$NL"; continue; }
    if is_binary "$_f"; then IFS="$NL"; continue; fi
    # shellcheck disable=SC2046  # intentional: capture wc byte count
    set -- $(wc -c < "$_f"); _b=$1
    _sum=$((_sum + _b)); _cnt=$((_cnt + 1)); _found=1
    IFS="$NL"
  done
  IFS="$_oldIFS"
  [ "$_found" = 1 ] || return 0
  NEW_AVG_BYTES=$((_sum / _cnt))
  return 0
}

# --- argument parsing ---
while [ $# -gt 0 ]; do
  case "$1" in
    --help|-h) usage; exit 0 ;;
    --full-reads|--reads) mode="full_read"; shift ;;
    --symbol-reads) mode="symbol_read"; shift ;;
    --full-edits|--edits) mode="full_edit"; shift ;;
    --symbol-edits) mode="symbol_edit"; shift ;;
    --target|--base|--multiplier)
      [ $# -ge 2 ] || fail "$1 requires a value"
      case "$1" in
        --target) is_uint "$2" || fail "--target must be a non-negative integer"; OF_TARGET=$2 ;;
        --base) is_uint "$2" || fail "--base must be a non-negative integer"; OF_BASE=$2 ;;
        --multiplier) is_num "$2" || fail "--multiplier must be numeric"; OF_MULTIPLIER=$2 ;;
      esac
      shift 2
      ;;
    --new)
      [ $# -ge 2 ] || fail "--new requires a value"
      NEW_SET=1; NEW_VAL=$2; shift 2
      ;;
    --src)
      [ $# -ge 2 ] || fail "--src requires a value"
      src=$(normalize_path "$2"); shift 2
      ;;
    --penalty)
      [ $# -ge 3 ] || fail "--penalty requires <path> <factor>"
      _ppath=$(normalize_path "$2")
      is_num "$3" || fail "--penalty factor must be a positive float: $3"
      is_pos "$3" || fail "--penalty factor must be positive: $3"
      echo "${_ppath}${TAB}$3" >> "$PENFILE"
      shift 3
      ;;
    --*) fail "unknown option: $1" ;;
    *)
      case "$mode" in
        full_read|symbol_read)
          measure_file "$1" "$mode"; reads_n=$((reads_n + 1))
          ;;
        *)
          measure_file "$1" "$mode"; edits_n=$((edits_n + 1))
          ;;
      esac
      shift
      ;;
  esac
done

# --- resolve new-file count ---
if [ "$NEW_SET" = 1 ]; then
  is_uint "$NEW_VAL" || fail "--new must be a non-negative integer"
  new_count=$NEW_VAL
else
  new_count=0
fi

if [ "$new_count" -gt 0 ] && [ -z "$src" ]; then
  fail "--new requires --src"
fi
if [ "$reads_n" -eq 0 ] && [ "$edits_n" -eq 0 ] && [ "$new_count" -eq 0 ]; then
  fail "no reads, edits, or new files were provided"
fi

# --- config + overrides ---
cfg_path=$(find_bmild_toml "$(pwd -P)" 2>/dev/null || true)
read_config "$cfg_path"
[ -n "$OF_TARGET" ] && CFG_TARGET=$OF_TARGET
[ -n "$OF_BASE" ] && CFG_BASE=$OF_BASE
[ -n "$OF_MULTIPLIER" ] && CFG_MULTIPLIER=$OF_MULTIPLIER

if [ -n "$LEGACY_WARN" ]; then
  echo "Warning: ignoring legacy .bmild.toml keys (${LEGACY_WARN}). peak_live_v2 accepts only slice_target, tokenizer_base, tokenizer_multiplier; remove the obsolete keys." >&2
fi

# --- new-file estimation ---
if [ "$new_count" -gt 0 ]; then
  if ! measure_source_dir "$src"; then
    echo "new${TAB}${src}" >> "$SKIPFILE"
  elif [ -n "$NEW_AVG_BYTES" ]; then
    NEW_AVG_RAW=$((NEW_AVG_BYTES / BYTES_PER_TOKEN))
    NEW_EST_RAW=$((new_count * NEW_AVG_RAW))
    echo "newedit${TAB}<new-files>${TAB}0${TAB}0${TAB}${NEW_EST_RAW}" >> "$RECFILE"
  fi
fi

# --- emit STATUS / BUDGET / READS / EDITS ---
awk -F '\t' -v OFS='\t' \
  -v bpt="$BYTES_PER_TOKEN" -v srcap="$SYMBOL_READ_CAP" -v secap="$SYMBOL_EDIT_CAP" \
  -v ioh="$ITEM_OVERHEAD" -v tres="$TURN_RESERVE" -v model="$MODEL_ID" \
  -v mult="$CFG_MULTIPLIER" -v base="$CFG_BASE" -v target="$CFG_TARGET" \
  -v nrd="$reads_n" -v ned="$edits_n" -v newcount="$new_count" \
  -v PEN="$PENFILE" '
BEGIN{
  fr=0; sr=0; fe=0; se=0; nf=0; rawtot=0
  while((getline pline < PEN) > 0){
    if(split(pline, pa, "\t") >= 2){ pk=pa[1]; pf=pa[2]+0; if(pk in pen) pen[pk]*=pf; else pen[pk]=pf }
  }
  close(PEN)
}
{
  N++; ro[N]=$1; pa[N]=$2; by[N]=$3+0; ln[N]=$4+0
  if(NF >= 5 && $5 != ""){ rv[N]=$5+0; hasrv[N]=1 } else { hasrv[N]=0 }
  seen[$2]=1
}
END{
  for(pk in pen){ if(!(pk in seen)){ print "Error: --penalty path not present in reads/edits: " pk > "/dev/stderr"; bad=1 } }
  if(bad) exit 1
  for(i=1;i<=N;i++){
    if(hasrv[i]) raw = rv[i]
    else raw = int(by[i]/bpt)
    ip = (pa[i] in pen) ? pen[pa[i]] : 1.0
    if(ro[i] == "symbol_read"){
      cap = srcap; access = "symbol"; kind = "read"
      capped = (raw < cap) ? raw : cap
    } else if(ro[i] == "symbol_edit"){
      cap = secap; access = "symbol"; kind = "edit"
      capped = (raw < cap) ? raw : cap
    } else if(ro[i] == "newedit"){
      access = "full"; kind = "edit"; capped = raw
    } else if(ro[i] == "full_edit"){
      access = "full"; kind = "edit"; capped = raw
    } else {
      access = "full"; kind = "read"; capped = raw
    }
    eff = int(capped*ip + 0.5)
    racc[i]=access; rkind[i]=kind; rraw[i]=raw; rcapped[i]=capped; rip[i]=ip; reff[i]=eff
    rawtot += raw
    if(ro[i] == "full_read") fr += eff
    else if(ro[i] == "symbol_read") sr += eff
    else if(ro[i] == "full_edit") fe += eff
    else if(ro[i] == "symbol_edit") se += eff
    else if(ro[i] == "newedit") nf += eff
  }
  K = nrd + ned + newcount
  overhead = K * ioh
  variable = fr + sr + fe + se + nf + overhead
  est = int(base + tres + variable * mult + 0.5)
  within = (est <= target)
  if(within){ stat="WITHIN BUDGET"; delta=target-est } else { stat="OVER BUDGET"; delta=est-target }
  print "STATUS", stat, "informed_guess"
  print ""
  print "BUDGET"
  print "field", "value"
  print "model", model
  print "target", target
  print "estimated_peak", est
  print "estimated_total", est
  print "delta", delta
  print "headroom", (within ? delta : 0 - delta)
  print "raw_file_tokens", rawtot
  print "full_reads", fr
  print "symbol_reads", sr
  print "full_edits", fe
  print "symbol_edits", se
  print "new_file_tokens", nf
  print "item_overhead", overhead
  print "turn_reserve", tres
  print "K", K
  print "tokenizer_base", base
  print "tokenizer_multiplier", fmt(mult)
  print "estimate_confidence", "informed_guess"
  print ""
  print "READS"
  print "path", "bytes", "raw_tokens", "access", "indicator_penalty", "effective_tokens"
  for(i=1;i<=N;i++) if(rkind[i] == "read") print pa[i], by[i], rraw[i], racc[i], fmt(rip[i]), reff[i]
  print ""
  print "EDITS"
  print "path", "bytes", "raw_tokens", "access", "indicator_penalty", "effective_tokens"
  for(i=1;i<=N;i++) if(rkind[i] == "edit") print pa[i], by[i], rraw[i], racc[i], fmt(rip[i]), reff[i]
  print ""
}
function fmt(x, s,w,f){ s=int(x*100+0.5); w=int(s/100); f=s%100; if(f < 10) return w ".0" f; return w "." f }
' "$RECFILE"

# --- emit SKIPPED_* + NEW_FILE_ESTIMATE ---
awk -F '\t' -v OFS='\t' '
{ if($1=="read") rp[++nr]=$2; else if($1=="edit") ep[++ne]=$2; else if($1=="new") np[++nn]=$2 }
END{
  print "SKIPPED_READS"; print "path"; for(i=1;i<=nr;i++) print rp[i]; print ""
  print "SKIPPED_EDITS"; print "path"; for(i=1;i<=ne;i++) print ep[i]; print ""
  print "SKIPPED_NEW"; print "path"; for(i=1;i<=nn;i++) print np[i]; print ""
}
' "$SKIPFILE"

echo "NEW_FILE_ESTIMATE"
echo "field${TAB}value"
echo "count${TAB}${new_count}"
echo "src${TAB}${src}"
echo "avg_bytes_per_file${TAB}${NEW_AVG_BYTES:-0}"
echo "avg_raw_tokens_per_file${TAB}${NEW_AVG_RAW:-0}"
echo "estimated_raw_tokens${TAB}${NEW_EST_RAW:-0}"
echo "estimated_tokens${TAB}${NEW_EST_RAW:-0}"
