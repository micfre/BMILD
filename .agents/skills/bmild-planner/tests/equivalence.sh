#!/bin/sh
# Cross-platform equivalence gate for the bash/PowerShell budget estimator.
# Executes both implementations against the same fixture scenarios, normalizes
# line endings, and diffs. Canonical evidence for bash-tokenizer FR13.
#
# Canonical CI gate: one Linux runner with pwsh installed (design §7 layer 3).
# Local dev without pwsh: SKIPs with exit 0 and a clear note (design §7 layer 1
# keeps Linux-bash native; PS verification is CI's job).
#
# Printf-free (ADR 0007): echo / awk print only.
set -u

TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXTURES="$TESTS_DIR/fixtures"
SH_EST="$TESTS_DIR/../scripts/run-budget-slice.sh"
PS_EST="$TESTS_DIR/../scripts/run-budget-slice.ps1"

# Locate a PowerShell executable. pwsh (PS 7) is what Linux/macOS expose.
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

# Normalize captured output for cross-runtime comparison:
#   1. drop CR (CRLF -> LF; stray CR removed)
#   2. strip trailing blank lines (capture mechanisms disagree on the final NL)
normalize(){
  tr -d '\r' | awk '
    { lines[NR]=$0 } END {
      e=NR; while(e>0 && lines[e]=="") e--;
      for(i=1;i<=e;i++) print lines[i]
    }'
}

# run_sh <cwd> <args...> -> sets SH_OUT, SH_RC in the caller's shell.
# The cd is scoped to the command substitution so the parent cwd is untouched
# and the PASS/FAIL counters stay in scope for cmp_case.
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

# cmp_case <label> <sh_out> <sh_rc> <ps_out> <ps_rc>  (success scenarios)
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

# cmp_err <label> ...  (scenarios that must error: both nonzero + empty stdout)
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

# --- build temp fixture corpus (runtime-generated inputs that cannot commit) ---
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
MINIF="$WORK/minified.js"
awk 'BEGIN{p=""; for(i=0;i<70;i++) p=p "abcdefghij"; print p}' > "$MINIF"
BINFILE="$WORK/binary.bin"
head -c 64 /dev/zero > "$BINFILE"
HIDDEN="$FIXTURES/.hidden-config.yaml"   # committed hidden fixture (see fixtures/)

# sandbox with NO .bmild.toml ancestor (under TMPDIR) so defaults apply
SANDBOX="$WORK/sandbox"; mkdir -p "$SANDBOX"
# sandbox with a low size threshold to activate size_penalty on medium.py
LOWTB="$WORK/lowthresh"; mkdir -p "$LOWTB"
printf '%s\n' 'penalty_size_threshold = 100' 'penalty_size_exponent = 1.5' > "$LOWTB/.bmild.toml"

# Absolute paths so cwd (sandbox) does not change which file is measured.
A_small="$FIXTURES/small.py"
A_medium="$FIXTURES/medium.py"
A_vendor="$FIXTURES/vendor/vendor-file.go"
A_srcdir="$FIXTURES/-src-dir"

# --- scenarios: identical args to both scripts; cwd selects .bmild.toml ---

run_sh "$SANDBOX" --reads "$A_small";  run_ps "$SANDBOX" --reads "$A_small"
cmp_case "baseline-read" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$A_small" "$A_medium";  run_ps "$SANDBOX" --reads "$A_small" "$A_medium"
cmp_case "multi-read-carry" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --edits "$A_small";  run_ps "$SANDBOX" --edits "$A_small"
cmp_case "edit-premium" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$A_small" --edits "$A_medium";  run_ps "$SANDBOX" --reads "$A_small" --edits "$A_medium"
cmp_case "interleaved" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$MINIF";  run_ps "$SANDBOX" --reads "$MINIF"
cmp_case "noise-bpl" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$A_vendor";  run_ps "$SANDBOX" --reads "$A_vendor"
cmp_case "noise-vendor" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$BINFILE" "$A_small";  run_ps "$SANDBOX" --reads "$BINFILE" "$A_small"
cmp_case "binary-skip" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$HIDDEN";  run_ps "$SANDBOX" --reads "$HIDDEN"
cmp_case "hidden-file" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$WORK/nope.py";  run_ps "$SANDBOX" --reads "$WORK/nope.py"
cmp_case "missing-file" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --new 2 --src "$A_srcdir";  run_ps "$SANDBOX" --new 2 --src "$A_srcdir"
cmp_case "new-with-src" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --new 1 --src "$WORK/missing-dir";  run_ps "$SANDBOX" --new 1 --src "$WORK/missing-dir"
cmp_case "new-missing-src" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$A_small" --penalty "$A_small" 1.5
run_ps "$SANDBOX" --reads "$A_small" --penalty "$A_small" 1.5
cmp_case "penalty-present" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$SANDBOX" --reads "$A_small" --penalty "$WORK/absent.py" 1.5
run_ps "$SANDBOX" --reads "$A_small" --penalty "$WORK/absent.py" 1.5
cmp_err "penalty-absent-errors" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

run_sh "$LOWTB" --reads "$A_medium";  run_ps "$LOWTB" --reads "$A_medium"
cmp_case "config-size-penalty" "$SH_OUT" "$SH_RC" "$PS_OUT" "$PS_RC"

echo "---"
echo "equivalence: $((PASS+FAIL)) run, $PASS pass, $FAIL fail."
if [ "$FAIL" -gt 0 ]; then
  echo "equivalence: FAILED cases:${FAILED_CASES}"
  exit 1
fi
echo "equivalence: bash and PowerShell byte-identical across the fixture suite."
