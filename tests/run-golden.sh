#!/usr/bin/env bash
# Golden tests for the POSIX sh slice-budget estimator.
# Exercises bash-tokenizer acceptance criteria FR1, FR4-FR12, FR15 on the
# current host. Cross-platform bash/PowerShell equivalence is owned by Slice 3.
#
# Printf-free (ADR 0007): uses echo / awk print only.
set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXTURES="$TESTS_DIR/fixtures"
ESTIMATOR="$TESTS_DIR/../.agents/skills/bmild-planner/scripts/run-budget-slice.sh"
TEMPLATE="$TESTS_DIR/../.agents/skills/bmild-planner/assets/slice-template.md"

PASS=0
FAIL=0
ok(){ echo "PASS $1"; PASS=$((PASS+1)); }
bad(){ echo "FAIL $1 :: ${2:-}"; FAIL=$((FAIL+1)); }
expect_eq(){ if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "got [$2] want [$3]"; fi; }
expect_ge(){ if [ "$2" -ge "$3" ]; then ok "$1"; else bad "$1" "got [$2] want >=$3"; fi; }

# Run the estimator capturing stdout; sets RUN_OUT and RUN_RC.
run_est(){
  RUN_OUT=""; RUN_RC=0
  if RUN_OUT="$(sh "$ESTIMATOR" "$@" 2>/dev/null)"; then RUN_RC=0; else RUN_RC=$?; fi
}
budget_val(){ echo "$1" | awk -F '\t' -v k="$2" '$1==k{print $2}'; }
row_cell(){ echo "$1" | awk -F '\t' -v sec="$2" -v p="$3" -v c="$4" '
  $0==sec{insec=1;next} insec && NF<=1{insec=0} insec && $1==p{print $c}'; }

# --- FR1 / FR9: runs, exit 0, all eight fixed sections present ---
run_est --reads "$FIXTURES/small.py"
missing=""
echo "$RUN_OUT" | grep -q '^STATUS	' || missing="${missing} STATUS"
for s in BUDGET READS EDITS SKIPPED_READS SKIPPED_EDITS SKIPPED_NEW NEW_FILE_ESTIMATE; do
  echo "$RUN_OUT" | grep -q "^${s}$" || missing="${missing} ${s}"
done
if [ "$RUN_RC" -eq 0 ] && [ -z "$missing" ]; then ok "FR1/FR9 exit0 + fixed sections"; else bad "FR1/FR9" "rc=$RUN_RC missing:${missing}"; fi

# --- FR4: raw_tokens = bytes / ratio ---
bytes=$(wc -c < "$FIXTURES/small.py"); exp_raw=$((bytes/4))
got_raw=$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 3)
expect_eq "FR4 raw_tokens=bytes/ratio ($exp_raw)" "$got_raw" "$exp_raw"

# --- FR5: superlinear size penalty above threshold (low-threshold config) ---
box=$(mktemp -d)
{ echo 'penalty_size_threshold = 100'; echo 'penalty_size_exponent = 1.5'; } > "$box/.bmild.toml"
mb=$(wc -c < "$FIXTURES/medium.py")
exp_sp=$(awk -v b="$mb" -v t=100 -v e=1.5 'BEGIN{x=(b/t)^e;s=int(x*100+0.5);w=int(s/100);f=s%100;if(f<10)print w ".0" f;else print w "." f}')
out5=$(cd "$box" && sh "$ESTIMATOR" --reads "$FIXTURES/medium.py")
got=$(row_cell "$out5" READS "$FIXTURES/medium.py" 4)
expect_eq "FR5 size_penalty=$exp_sp" "$got" "$exp_sp"
rm -rf "$box"

# --- FR6: noise penalty (minified bytes-per-line + vendor path) ---
minif=$(mktemp)
awk 'BEGIN{for(i=0;i<70;i++)p=p "abcdefghij"; print p}' > "$minif"
run_est --reads "$minif" "$FIXTURES/vendor/vendor-file.go"
expect_eq "FR6 noise via bytes-per-line" "$(row_cell "$RUN_OUT" READS "$minif" 5)" "2.00"
expect_eq "FR6 noise via vendor path" "$(row_cell "$RUN_OUT" READS "$FIXTURES/vendor/vendor-file.go" 5)" "2.00"
rm -f "$minif"

# --- FR7: triangular carry-forward (K=3 -> carry 2.00) ---
run_est --reads "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py"
expect_eq "FR7 carry=(K+1)/2" "$(budget_val "$RUN_OUT" carry_factor)" "2.00"
expect_eq "FR7 K=provided count" "$(budget_val "$RUN_OUT" K)" "3"

# --- FR7b: carry_cap bounds the carry factor at high K ---
# Config override caps below the triangular value: K=3 -> 2.0, capped to 1.5
box=$(mktemp -d)
echo 'carry_cap = 1.5' > "$box/.bmild.toml"
out7b=$(cd "$box" && sh "$ESTIMATOR" --reads "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py")
expect_eq "FR7b carry capped to config (1.50)" "$(budget_val "$out7b" carry_factor)" "1.50"
# Default cap (2.5) applies when carry_cap absent: K=10 -> 5.5, capped to 2.50
echo 'slice_target = 231000' > "$box/.bmild.toml"
out7c=$(cd "$box" && sh "$ESTIMATOR" --reads "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py")
expect_eq "FR7b default carry_cap bounds high K (2.50)" "$(budget_val "$out7c" carry_factor)" "2.50"
rm -rf "$box"

# --- FR8: 2x edit premium (same file read vs edit) ---
run_est --reads "$FIXTURES/small.py"
re_ff=$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 7)
run_est --edits "$FIXTURES/small.py"
ed_ff=$(row_cell "$RUN_OUT" EDITS "$FIXTURES/small.py" 7)
expect_eq "FR8 edit premium 2x" "$ed_ff" "$((re_ff * 2))"

# --- FR10: informed_guess label in STATUS and BUDGET ---
n_lab=$(echo "$RUN_OUT" | grep -c 'informed_guess')
expect_ge "FR10 informed_guess in STATUS+BUDGET" "$n_lab" 2

# --- FR11: --penalty on present path applies; absent path errors ---
exp_pen=$(awk -v r="$re_ff" 'BEGIN{print int(r*1.5+0.5)}')
run_est --reads "$FIXTURES/small.py" --penalty "$FIXTURES/small.py" 1.5
expect_eq "FR11 --penalty applies (1.5x -> $exp_pen)" "$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 7)" "$exp_pen"
run_est --reads "$FIXTURES/small.py" --penalty "$FIXTURES/nope.md" 2.0
if [ "$RUN_RC" -ne 0 ]; then ok "FR11 --penalty absent path errors"; else bad "FR11 absent" "rc=$RUN_RC (want non-zero)"; fi

# --- FR12: ## Actuals section in slice template ---
if grep -q '^## Actuals' "$TEMPLATE" && grep -q 'turns_taken' "$TEMPLATE" && grep -q 'unplanned_reads' "$TEMPLATE"; then
  ok "FR12 ## Actuals in slice-template"
else
  bad "FR12" "template missing Actuals fields"
fi

# --- FR15: config-driven params; multiplier defaults to 1.0 ---
box=$(mktemp -d)
echo 'tokenizer_ratio = 8.0' > "$box/.bmild.toml"
out15a=$(cd "$box" && sh "$ESTIMATOR" --reads "$FIXTURES/small.py")
expect_eq "FR15 config override (ratio=8.00)" "$(budget_val "$out15a" tokenizer_ratio)" "8.00"
rm -f "$box/.bmild.toml"
out15b=$(cd "$box" && sh "$ESTIMATOR" --reads "$FIXTURES/small.py")
if [ "$(budget_val "$out15b" tokenizer_multiplier)" = "1.00" ] && [ "$(budget_val "$out15b" tokenizer_ratio)" = "4.00" ]; then
  ok "FR15 defaults (multiplier=1.00, ratio=4.00)"
else
  bad "FR15b" "mult=$(budget_val "$out15b" tokenizer_multiplier) ratio=$(budget_val "$out15b" tokenizer_ratio)"
fi
rm -rf "$box"

# --- ADR 0007: no format-string emission in the estimator script ---
if ! grep -q 'printf' "$ESTIMATOR"; then ok "ADR0007 no printf in estimator"; else bad "ADR0007" "printf present"; fi

# --- --src sanitization: tab-rejection + leading-dash normalization (Vuln 1) ---
# Tab in --src must be rejected (TSV-injection guard in normalize_path).
tab_src="${FIXTURES}$(printf '\t')evil"
run_est --new 1 --src "$tab_src"
if [ "$RUN_RC" -ne 0 ]; then ok "Vuln1 tab in --src rejected"; else bad "Vuln1 tab" "rc=$RUN_RC (want non-zero)"; fi

# Leading-dash --src must be normalized to ./-src-dir so find treats it as a
# path, not a predicate. Without the guard, avg_bytes_per_file silently = 0.
sample_bytes=$(( $(wc -c < "$FIXTURES/-src-dir/sample.py") ))
# Baseline: absolute directory path has no leading dash, so it measures cleanly.
run_est --new 1 --src "$FIXTURES/-src-dir"
expect_eq "Vuln1 baseline avg_bytes (absolute dir)" "$(budget_val "$RUN_OUT" avg_bytes_per_file)" "$sample_bytes"
# Relative leading-dash path: cwd must be $FIXTURES so the dir resolves; the
# estimator must normalize to ./-src-dir and still measure the file.
RUN_OUT=""; RUN_RC=0
if RUN_OUT="$(cd "$FIXTURES" && sh "$ESTIMATOR" --new 1 --src "-src-dir" 2>/dev/null)"; then RUN_RC=0; else RUN_RC=$?; fi
if [ "$RUN_RC" -eq 0 ] \
  && [ "$(budget_val "$RUN_OUT" avg_bytes_per_file)" = "$sample_bytes" ] \
  && [ "$(budget_val "$RUN_OUT" src)" = "./-src-dir" ]; then
  ok "Vuln1 leading-dash --src normalized + measured"
else
  bad "Vuln1 leading-dash" "rc=$RUN_RC avg=$(budget_val "$RUN_OUT" avg_bytes_per_file) src=$(budget_val "$RUN_OUT" src)"
fi

echo "---"
echo "passed=$PASS failed=$FAIL"
[ "$FAIL" -eq 0 ]
