#!/bin/sh
# Cross-platform equivalence gate for peak_live_v2 bash/PowerShell estimators.
# Printf-free (ADR 0007): echo / awk print only.
set -u

TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXTURES="$TESTS_DIR/fixtures"
SH_EST="$TESTS_DIR/../.agents/skills/bmild-planner/scripts/run-budget-slice.sh"
PS_EST="$TESTS_DIR/../.agents/skills/bmild-planner/scripts/run-budget-slice.ps1"

PS_EXE="${PWSH:-}"
if [ -z "$PS_EXE" ]; then
  if command -v pwsh >/dev/null 2>&1; then PS_EXE=pwsh
  elif command -v powershell >/dev/null 2>&1; then PS_EXE=powershell
  fi
fi

if [ -z "$PS_EXE" ]; then
  echo "equivalence: SKIP — no pwsh/powershell on PATH (CI installs pwsh; local dev see design §7)."
  echo "equivalence: 0 run, 0 pass, 0 fail."
  exit 0
fi

PASS=0
FAIL=0
FAILED_CASES=""

normalize(){
  tr -d '\r' | awk '
    { lines[NR]=$0 } END {
      e=NR; while(e>0 && lines[e]=="") e--;
      for(i=1;i<=e;i++) print lines[i]
    }'
}

run_sh(){
  _cwd="$1"; shift
  SH_OUT=""; SH_RC=0
  if SH_OUT="$(cd "$_cwd" && sh "$SH_EST" "$@" 2>/dev/null)"; then :; else SH_RC=$?; fi
}
run_ps(){
  _cwd="$1"; shift
  PS_OUT=""; PS_RC=0
  if PS_OUT="$(cd "$_cwd" && "$PS_EXE" -NoProfile -File "$PS_EST" "$@" 2>/dev/null)"; then :; else PS_RC=$?; fi
}

cmp_case(){
  _label="$1"; _so="$2"; _sr="$3"; _po="$4"; _pr="$5"
  _son="$(printf '%s' "$_so" | normalize)"
  _pon="$(printf '%s' "$_po" | normalize)"
  if [ "$_sr" != "$_pr" ]; then
    echo "FAIL $_label :: exit code sh=$_sr ps=$_pr"; FAIL=$((FAIL+1)); FAILED_CASES="${FAILED_CASES} $_label"; return
  fi
  if [ "$_son" != "$_pon" ]; then
    echo "FAIL $_label :: stdout differs (rc=$_sr)"
    { printf '%s\n' '--- sh (normalized) ---'; printf '%s\n' "$_son"
      printf '%s\n' '--- ps (normalized) ---'; printf '%s\n' "$_pon"; } | sed 's/^/    /'
    FAIL=$((FAIL+1)); FAILED_CASES="${FAILED_CASES} $_label"; return
  fi
  echo "PASS $_label"; PASS=$((PASS+1))
}

cmp_err(){
  _label="$1"; _so="$2"; _sr="$3"; _po="$4"; _pr="$5"
  if [ "$_sr" -eq 0 ] || [ "$_pr" -eq 0 ]; then
    echo "FAIL $_label :: expected both nonzero; sh=$_sr ps=$_pr"; FAIL=$((FAIL+1)); FAILED_CASES="${FAILED_CASES} $_label"; return
  fi
  if [ -n "$_so" ] || [ -n "$_po" ]; then
    echo "FAIL $_label :: expected empty stdout on error"; FAIL=$((FAIL+1)); FAILED_CASES="${FAILED_CASES} $_label"; return
  fi
  echo "PASS $_label (both error, no stdout)"; PASS=$((PASS+1))
}

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
MINIF="$WORK/minified.js"
awk 'BEGIN{p=""; for(i=0;i<70;i++) p=p "abcdefghij"; print p}' > "$MINIF"
BINFILE="$WORK/binary.bin"
head -c 64 /dev/zero > "$BINFILE"
HIDDEN="$FIXTURES/.hidden-config.yaml"
LARGE="$WORK/large.txt"
awk 'BEGIN{for(i=0;i<4000;i++)printf "abcdefghij"}' > "$LARGE"

SANDBOX="$WORK/sandbox"; mkdir -p "$SANDBOX"
CFGBOX="$WORK/cfg"; mkdir -p "$CFGBOX"
printf '%s\n' 'slice_target = 90000' 'tokenizer_base = 11000' 'tokenizer_multiplier = 2.0' > "$CFGBOX/.bmild.toml"
LEGBOX="$WORK/legacy"; mkdir -p "$LEGBOX"
printf '%s\n' 'tokenizer_ratio = 8.0' 'carry_cap = 1.5' 'slice_target = 120000' > "$LEGBOX/.bmild.toml"

A_small="$FIXTURES/small.py"
A_medium="$FIXTURES/medium.py"
A_vendor="$FIXTURES/vendor/vendor-file.go"
A_srcdir="$FIXTURES/-src-dir"

run_sh "$SANDBOX" --full-reads "$A_small";  run_ps "$SANDBOX" --full-reads "$A_small"
cmp_case "baseline-full-read" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$A_small";  run_ps "$SANDBOX" --reads "$A_small"
cmp_case "alias-reads" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --symbol-reads "$LARGE";  run_ps "$SANDBOX" --symbol-reads "$LARGE"
cmp_case "symbol-read-cap" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --symbol-edits "$LARGE";  run_ps "$SANDBOX" --symbol-edits "$LARGE"
cmp_case "symbol-edit-cap" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$A_small" "$A_medium";  run_ps "$SANDBOX" --full-reads "$A_small" "$A_medium"
cmp_case "multi-read-breadth" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-edits "$A_small";  run_ps "$SANDBOX" --full-edits "$A_small"
cmp_case "full-edit" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --edits "$A_small";  run_ps "$SANDBOX" --edits "$A_small"
cmp_case "alias-edits" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$A_small" --symbol-edits "$A_medium"
run_ps "$SANDBOX" --full-reads "$A_small" --symbol-edits "$A_medium"
cmp_case "interleaved-roles" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$MINIF";  run_ps "$SANDBOX" --full-reads "$MINIF"
cmp_case "full-minified" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$A_vendor";  run_ps "$SANDBOX" --full-reads "$A_vendor"
cmp_case "vendor-full-read" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$BINFILE" "$A_small";  run_ps "$SANDBOX" --full-reads "$BINFILE" "$A_small"
cmp_case "binary-skip" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$HIDDEN";  run_ps "$SANDBOX" --full-reads "$HIDDEN"
cmp_case "hidden-file" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$WORK/nope.py";  run_ps "$SANDBOX" --full-reads "$WORK/nope.py"
cmp_case "missing-file" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --new 2 --src "$A_srcdir";  run_ps "$SANDBOX" --new 2 --src "$A_srcdir"
cmp_case "new-with-src" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --new 1 --src "$WORK/missing-dir";  run_ps "$SANDBOX" --new 1 --src "$WORK/missing-dir"
cmp_case "new-missing-src" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$A_small" --penalty "$A_small" 1.5
run_ps "$SANDBOX" --full-reads "$A_small" --penalty "$A_small" 1.5
cmp_case "penalty-present" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --full-reads "$A_small" --penalty "$WORK/absent.py" 1.5
run_ps "$SANDBOX" --full-reads "$A_small" --penalty "$WORK/absent.py" 1.5
cmp_err "penalty-absent-errors" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$CFGBOX" --full-reads "$A_small";  run_ps "$CFGBOX" --full-reads "$A_small"
cmp_case "config-three-keys" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

# Legacy keys: stdout must match (warnings on stderr are stripped by 2>/dev/null)
run_sh "$LEGBOX" --full-reads "$A_small";  run_ps "$LEGBOX" --full-reads "$A_small"
cmp_case "legacy-keys-ignored" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

echo "---"
echo "equivalence: $((PASS+FAIL)) run, $PASS pass, $FAIL fail."
if [ "$FAIL" -gt 0 ]; then
  echo "equivalence: FAILED cases:${FAILED_CASES}"
  exit 1
fi
echo "equivalence: bash and PowerShell byte-identical across the fixture suite."
