#!/bin/sh
# BMILD slice-budget estimator (POSIX sh).
# Byte-based token model with superlinear attention-risk penalty layer and
# triangular carry-forward. Emits TSV per the bash-tokenizer system-design
# output contract. No format-string emission (ADR 0007); awk uses print only.
set -eu

TAB='	'
NL='
'

DEFAULT_TARGET=170000
DEFAULT_BASE=15000
DEFAULT_MULTIPLIER=1.0
DEFAULT_RATIO=4.0
DEFAULT_SIZE_THRESHOLD=24000
DEFAULT_SIZE_EXPONENT=1.5
DEFAULT_NOISE_BPL=500
DEFAULT_NOISE_FACTOR=2.0
DEFAULT_PENALTY_CAP=10.0
DEFAULT_EDIT_PREMIUM=2.0

CFG_TARGET=$DEFAULT_TARGET
CFG_BASE=$DEFAULT_BASE
CFG_MULTIPLIER=$DEFAULT_MULTIPLIER
CFG_RATIO=$DEFAULT_RATIO
CFG_SIZE_THRESHOLD=$DEFAULT_SIZE_THRESHOLD
CFG_SIZE_EXPONENT=$DEFAULT_SIZE_EXPONENT
CFG_NOISE_BPL=$DEFAULT_NOISE_BPL
CFG_NOISE_FACTOR=$DEFAULT_NOISE_FACTOR
CFG_PENALTY_CAP=$DEFAULT_PENALTY_CAP
CFG_EDIT_PREMIUM=$DEFAULT_EDIT_PREMIUM

OF_TARGET=""
OF_BASE=""
OF_MULTIPLIER=""
OF_RATIO=""
NEW_SET=0
NEW_VAL=""
src=""
mode="read"
reads_n=0
edits_n=0

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

Estimate implementation-session context tokens (byte-based model).
Output is TSV with fixed sections in order: STATUS, BUDGET, READS,
EDITS, SKIPPED_READS, SKIPPED_EDITS, SKIPPED_NEW, NEW_FILE_ESTIMATE.

Options:
  --target <int>           token budget override
  --base <int>             tokenizer base (K=0 overhead) override
  --multiplier <float>     residual multiplier override (default 1.0)
  --ratio <float>          bytes-per-token ratio override (default 4.0)
  --reads <path>...        switch to read-role mode; collect read files
  --edits <path>...        switch to edit-role mode; collect edit files
  --new <int>              count of new files to estimate
  --src <path>             representative source dir (required when --new > 0)
  --penalty <path> <float> multiplicative indicator penalty (repeatable)
  -h, --help               show this help and exit

Penalty thresholds, exponents, and the edit premium are read from .bmild.toml
and are not exposed as flags. Every estimate is an informed guess.
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
      tokenizer_ratio) is_num "$_val" && CFG_RATIO=$_val ;;
      penalty_size_threshold) is_uint "$_val" && CFG_SIZE_THRESHOLD=$_val ;;
      penalty_size_exponent) is_num "$_val" && CFG_SIZE_EXPONENT=$_val ;;
      penalty_noise_bpl) is_uint "$_val" && CFG_NOISE_BPL=$_val ;;
      penalty_noise_factor) is_num "$_val" && CFG_NOISE_FACTOR=$_val ;;
      penalty_cap) is_num "$_val" && CFG_PENALTY_CAP=$_val ;;
      edit_premium) is_num "$_val" && CFG_EDIT_PREMIUM=$_val ;;
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

measure_file(){
  _p=$(normalize_path "$1")
  _role="$2"
  if [ ! -f "$_p" ]; then
    echo "${_role}${TAB}${_p}" >> "$SKIPFILE"
    return
  fi
  # shellcheck disable=SC2046  # intentional: split wc's "lines bytes" output
  set -- $(wc -l -c < "$_p"); _lines=$1; _bytes=$2
  if is_binary "$_p"; then
    echo "${_role}${TAB}${_p}" >> "$SKIPFILE"
    return
  fi
  if [ "$_bytes" -gt 0 ] && [ -n "$(tail -c 1 "$_p")" ]; then
    _lines=$((_lines + 1))
  fi
  case "$_p" in
    */vendor/*|*/node_modules/*|*/dist/*|*/build/*|*/target/*|*.min.*|*.generated.*|*_generated.*|*.pb.go|*.proto.go) _nf=1 ;;
    *) _nf=0 ;;
  esac
  echo "${_role}${TAB}${_p}${TAB}${_bytes}${TAB}${_lines}${TAB}${TAB}${_bytes}${TAB}${_nf}" >> "$RECFILE"
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
    --reads) mode="read"; shift ;;
    --edits) mode="edit"; shift ;;
    --target|--base|--multiplier|--ratio)
      [ $# -ge 2 ] || fail "$1 requires a value"
      case "$1" in
        --target) is_uint "$2" || fail "--target must be a non-negative integer"; OF_TARGET=$2 ;;
        --base) is_uint "$2" || fail "--base must be a non-negative integer"; OF_BASE=$2 ;;
        --multiplier) is_num "$2" || fail "--multiplier must be numeric"; OF_MULTIPLIER=$2 ;;
        --ratio) is_num "$2" || fail "--ratio must be numeric"; OF_RATIO=$2 ;;
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
      if [ "$mode" = read ]; then
        measure_file "$1" read; reads_n=$((reads_n + 1))
      else
        measure_file "$1" edit; edits_n=$((edits_n + 1))
      fi
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
[ -n "$OF_RATIO" ] && CFG_RATIO=$OF_RATIO

# --- new-file estimation ---
if [ "$new_count" -gt 0 ]; then
  if ! measure_source_dir "$src"; then
    echo "new${TAB}${src}" >> "$SKIPFILE"
  elif [ -n "$NEW_AVG_BYTES" ]; then
    NEW_AVG_RAW=$(awk -v b="$NEW_AVG_BYTES" -v r="$CFG_RATIO" 'BEGIN{print int(b/r)}')
    NEW_EST_RAW=$((new_count * NEW_AVG_RAW))
    echo "newedit${TAB}<new-files>${TAB}0${TAB}0${TAB}${NEW_EST_RAW}${TAB}${NEW_AVG_BYTES}${TAB}0" >> "$RECFILE"
  fi
fi

# --- emit STATUS / BUDGET / READS / EDITS ---
awk -F '\t' -v OFS='\t' \
  -v ratio="$CFG_RATIO" -v thr="$CFG_SIZE_THRESHOLD" -v sexp="$CFG_SIZE_EXPONENT" \
  -v nbpl="$CFG_NOISE_BPL" -v noisef="$CFG_NOISE_FACTOR" -v cap="$CFG_PENALTY_CAP" \
  -v eprem="$CFG_EDIT_PREMIUM" -v mult="$CFG_MULTIPLIER" -v base="$CFG_BASE" \
  -v target="$CFG_TARGET" -v nrd="$reads_n" -v ned="$edits_n" -v newcount="$new_count" \
  -v PEN="$PENFILE" '
BEGIN{
  wr=0; we=0; rawtot=0
  while((getline pline < PEN) > 0){
    if(split(pline, pa, "\t") >= 2){ pk=pa[1]; pf=pa[2]+0; if(pk in pen) pen[pk]*=pf; else pen[pk]=pf }
  }
  close(PEN)
}
{ N++; ro[N]=$1; pa[N]=$2; by[N]=$3+0; ln[N]=$4+0; rv[N]=$5; sb[N]=$6+0; nfg[N]=$7+0; seen[$2]=1 }
END{
  for(pk in pen){ if(!(pk in seen)){ print "Error: --penalty path not present in reads/edits: " pk > "/dev/stderr"; bad=1 } }
  if(bad) exit 1
  for(i=1;i<=N;i++){
    raw = (rv[i] != "") ? (rv[i]+0) : int(by[i]/ratio)
    if(sb[i] <= thr+0) sp=1.0; else sp=(sb[i]/thr)^sexp
    bpl = by[i]/(ln[i] < 1 ? 1 : ln[i])
    if(nfg[i] || bpl > nbpl) np=noisef; else np=1.0
    ip = (pa[i] in pen) ? pen[pa[i]] : 1.0
    prod = sp*np*ip; if(prod > cap) prod=cap
    prem = (ro[i] == "read") ? 1.0 : eprem
    eff = int(raw*prod*prem + 0.5)
    rsp[i]=sp; rnp[i]=np; rip[i]=ip; rraw[i]=raw; reff[i]=eff
    rawtot += raw
    if(ro[i] == "read") wr += eff; else we += eff
  }
  K = nrd + ned + newcount
  carry = (K+1)/2.0
  est = int((wr+we)*carry*mult + base + 0.5)
  within = (est <= target)
  if(within){ stat="WITHIN BUDGET"; delta=target-est } else { stat="OVER BUDGET"; delta=est-target }
  print "STATUS", stat, "informed_guess"
  print ""
  print "BUDGET"
  print "field", "value"
  print "target", target
  print "estimated_total", est
  print "delta", delta
  print "raw_file_tokens", rawtot
  print "weighted_reads", wr
  print "weighted_edits", we
  print "carry_factor", fmt(carry)
  print "K", K
  print "tokenizer_base", base
  print "tokenizer_multiplier", fmt(mult)
  print "tokenizer_ratio", fmt(ratio)
  print "estimate_confidence", "informed_guess"
  print ""
  print "READS"
  print "path", "bytes", "raw_tokens", "size_penalty", "noise_penalty", "indicator_penalty", "effective_tokens"
  for(i=1;i<=N;i++) if(ro[i] == "read") print pa[i], by[i], rraw[i], fmt(rsp[i]), fmt(rnp[i]), fmt(rip[i]), reff[i]
  print ""
  print "EDITS"
  print "path", "bytes", "raw_tokens", "size_penalty", "noise_penalty", "indicator_penalty", "effective_tokens"
  for(i=1;i<=N;i++) if(ro[i] != "read") print pa[i], by[i], rraw[i], fmt(rsp[i]), fmt(rnp[i]), fmt(rip[i]), reff[i]
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
