#!/usr/bin/env bash
# Golden tests for the POSIX sh peak_live_v2 slice-budget estimator.
# Invariants: symbol caps, full-file size sensitivity, linear breadth,
# supported TOML keys, legacy-key warnings, Actuals telemetry schema.
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

run_est(){
  RUN_OUT=""; RUN_RC=0
  if RUN_OUT="$(sh "$ESTIMATOR" "$@" 2>/tmp/bmild-est-err.$$)"; then RUN_RC=0; else RUN_RC=$?; fi
  rm -f /tmp/bmild-est-err.$$
}
budget_val(){ echo "$1" | awk -F '\t' -v k="$2" '$1==k{print $2; exit}'; }
row_cell(){ echo "$1" | awk -F '\t' -v sec="$2" -v p="$3" -v c="$4" '
  $0==sec{insec=1;next} insec && NF<=1{insec=0} insec && $1==p{print $c; exit}'; }

# --- FR1 / FR9: runs, exit 0, all eight fixed sections + model ---
run_est --full-reads "$FIXTURES/small.py"
missing=""
echo "$RUN_OUT" | grep -q '^STATUS	' || missing="${missing} STATUS"
for s in BUDGET READS EDITS SKIPPED_READS SKIPPED_EDITS SKIPPED_NEW NEW_FILE_ESTIMATE; do
  echo "$RUN_OUT" | grep -q "^${s}$" || missing="${missing} ${s}"
done
if [ "$RUN_RC" -eq 0 ] && [ -z "$missing" ]; then ok "FR1/FR9 exit0 + fixed sections"; else bad "FR1/FR9" "rc=$RUN_RC missing:${missing}"; fi
expect_eq "model peak_live_v2" "$(budget_val "$RUN_OUT" model)" "peak_live_v2"

# --- FR4: raw_tokens = bytes / 4 (internal ratio) ---
bytes=$(wc -c < "$FIXTURES/small.py"); exp_raw=$((bytes/4))
got_raw=$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 3)
expect_eq "FR4 raw_tokens=bytes/4 ($exp_raw)" "$got_raw" "$exp_raw"
expect_eq "full access on --full-reads" "$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 4)" "full"

# --- Symbol read caps large files; full read remains size-sensitive ---
large=$(mktemp)
# ~40k bytes => ~10000 raw tokens; symbol cap is 2500
awk 'BEGIN{for(i=0;i<4000;i++)printf "abcdefghij"}' > "$large"
run_est --symbol-reads "$large"
expect_eq "symbol access" "$(row_cell "$RUN_OUT" READS "$large" 4)" "symbol"
expect_eq "symbol_reads capped at 2500" "$(budget_val "$RUN_OUT" symbol_reads)" "2500"
sym_peak=$(budget_val "$RUN_OUT" estimated_peak)

run_est --full-reads "$large"
full_eff=$(row_cell "$RUN_OUT" READS "$large" 6)
expect_ge "full read exceeds symbol cap" "$full_eff" 2501
full_peak=$(budget_val "$RUN_OUT" estimated_peak)
expect_ge "full peak > symbol peak" "$full_peak" "$((sym_peak + 1))"
rm -f "$large"

# --- Symbol edit cap exceeds symbol read cap ---
# Build a file between 2500 and 5000 raw tokens (~12k-20k bytes)
mid=$(mktemp)
awk 'BEGIN{for(i=0;i<3500;i++)printf "abcdefghij"}' > "$mid"  # 35000 bytes => 8750 raw
run_est --symbol-reads "$mid"
expect_eq "symbol_read cap 2500" "$(budget_val "$RUN_OUT" symbol_reads)" "2500"
run_est --symbol-edits "$mid"
expect_eq "symbol_edit cap 5000" "$(budget_val "$RUN_OUT" symbol_edits)" "5000"
rm -f "$mid"

# --- Linear breadth: K items grow item_overhead linearly; no carry saturation ---
run_est --full-reads "$FIXTURES/small.py"
k1=$(budget_val "$RUN_OUT" K)
oh1=$(budget_val "$RUN_OUT" item_overhead)
p1=$(budget_val "$RUN_OUT" estimated_peak)
run_est --full-reads "$FIXTURES/small.py" "$FIXTURES/small.py" "$FIXTURES/small.py"
k3=$(budget_val "$RUN_OUT" K)
oh3=$(budget_val "$RUN_OUT" item_overhead)
p3=$(budget_val "$RUN_OUT" estimated_peak)
expect_eq "K=1" "$k1" "1"
expect_eq "K=3" "$k3" "3"
expect_eq "item_overhead K=1 is 500" "$oh1" "500"
expect_eq "item_overhead K=3 is 1500" "$oh3" "1500"
expect_ge "peak grows with breadth" "$p3" "$((p1 + 1))"

# --- --reads/--edits aliases map to full access ---
run_est --reads "$FIXTURES/small.py"
expect_eq "--reads alias full" "$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 4)" "full"
run_est --edits "$FIXTURES/small.py"
expect_eq "--edits alias full" "$(row_cell "$RUN_OUT" EDITS "$FIXTURES/small.py" 4)" "full"

# --- New files contribute ---
run_est --new 2 --src "$FIXTURES/-src-dir"
nf=$(budget_val "$RUN_OUT" new_file_tokens)
expect_ge "new_file_tokens > 0" "$nf" 1
expect_eq "NEW_FILE count" "$(budget_val "$RUN_OUT" count)" "2"

# --- FR10: informed_guess label ---
n_lab=$(echo "$RUN_OUT" | grep -c 'informed_guess' || true)
expect_ge "FR10 informed_guess in STATUS+BUDGET" "$n_lab" 2

# --- FR11: --penalty on present path; absent path errors ---
run_est --full-reads "$FIXTURES/small.py"
base_eff=$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 6)
exp_pen=$(awk -v r="$base_eff" 'BEGIN{print int(r*1.5+0.5)}')
run_est --full-reads "$FIXTURES/small.py" --penalty "$FIXTURES/small.py" 1.5
expect_eq "FR11 --penalty applies" "$(row_cell "$RUN_OUT" READS "$FIXTURES/small.py" 6)" "$exp_pen"
run_est --full-reads "$FIXTURES/small.py" --penalty "$FIXTURES/nope.md" 2.0
if [ "$RUN_RC" -ne 0 ]; then ok "FR11 --penalty absent path errors"; else bad "FR11 absent" "rc=$RUN_RC (want non-zero)"; fi

# --- FR12 / telemetry schema in slice template ---
if grep -q '^## Actuals' "$TEMPLATE" \
  && grep -q 'turns_taken' "$TEMPLATE" \
  && grep -q 'compaction_count' "$TEMPLATE" \
  && grep -q 'peak_live_context' "$TEMPLATE" \
  && grep -q 'peak_context_pct' "$TEMPLATE" \
  && grep -q 'unexpected_whole_file_source_reads' "$TEMPLATE" \
  && grep -q 'estimated_peak' "$TEMPLATE" \
  && grep -q 'peak_live_v2' "$TEMPLATE"; then
  ok "FR12 Actuals + peak_live_v2 template schema"
else
  bad "FR12" "template missing Actuals / peak_live_v2 fields"
fi

# --- Supported TOML keys: slice_target, tokenizer_base, tokenizer_multiplier ---
box=$(mktemp -d)
{
  echo 'slice_target = 90000'
  echo 'tokenizer_base = 11000'
  echo 'tokenizer_multiplier = 2.0'
} > "$box/.bmild.toml"
out15=$(cd "$box" && sh "$ESTIMATOR" --full-reads "$FIXTURES/small.py")
expect_eq "config slice_target" "$(budget_val "$out15" target)" "90000"
expect_eq "config tokenizer_base" "$(budget_val "$out15" tokenizer_base)" "11000"
expect_eq "config tokenizer_multiplier" "$(budget_val "$out15" tokenizer_multiplier)" "2.00"
# multiplier doubles variable portion: peak should exceed base+turn_reserve
peak15=$(budget_val "$out15" estimated_peak)
expect_ge "multiplier affects peak" "$peak15" 31001
rm -rf "$box"

# --- Defaults when no config ---
box=$(mktemp -d)
out_def=$(cd "$box" && sh "$ESTIMATOR" --full-reads "$FIXTURES/small.py")
expect_eq "default multiplier 1.00" "$(budget_val "$out_def" tokenizer_multiplier)" "1.00"
expect_eq "default base 15000" "$(budget_val "$out_def" tokenizer_base)" "15000"
expect_eq "turn_reserve 20000" "$(budget_val "$out_def" turn_reserve)" "20000"
rm -rf "$box"

# --- Legacy keys warn and are ignored ---
box=$(mktemp -d)
{
  echo 'tokenizer_ratio = 8.0'
  echo 'carry_cap = 1.5'
  echo 'edit_premium = 9.0'
  echo 'penalty_cap = 3.0'
  echo 'slice_target = 120000'
} > "$box/.bmild.toml"
out_leg=""; err_leg=""; rc_leg=0
if out_leg="$(cd "$box" && sh "$ESTIMATOR" --full-reads "$FIXTURES/small.py" 2>/tmp/bmild-leg-err.$$)"; then rc_leg=0; else rc_leg=$?; fi
err_leg="$(cat /tmp/bmild-leg-err.$$)"
rm -f /tmp/bmild-leg-err.$$
expect_eq "legacy keys still exit 0" "$rc_leg" "0"
expect_eq "legacy does not change target" "$(budget_val "$out_leg" target)" "120000"
leg_field=$(budget_val "$out_leg" legacy_keys_ignored)
if echo "$leg_field" | grep -q 'tokenizer_ratio' \
  && echo "$leg_field" | grep -q 'carry_cap'; then
  ok "legacy key migration warning"
elif echo "$err_leg" | grep -q 'ignoring legacy .bmild.toml keys' \
  && echo "$err_leg" | grep -q 'tokenizer_ratio' \
  && echo "$err_leg" | grep -q 'carry_cap'; then
  ok "legacy key migration warning"
else
  bad "legacy warn" "field=[$leg_field] stderr=[$err_leg]"
fi
# ratio ignored: raw still bytes/4
bytes=$(wc -c < "$FIXTURES/small.py"); exp_raw=$((bytes/4))
expect_eq "legacy ratio ignored" "$(row_cell "$out_leg" READS "$FIXTURES/small.py" 3)" "$exp_raw"
rm -rf "$box"

# --- ADR 0007: no printf ---
if ! grep -q 'printf' "$ESTIMATOR"; then ok "ADR0007 no printf in estimator"; else bad "ADR0007" "printf present"; fi

# --- Vuln1: tab-rejection + leading-dash normalization ---
tab_src="${FIXTURES}$(printf '\t')evil"
run_est --new 1 --src "$tab_src"
if [ "$RUN_RC" -ne 0 ]; then ok "Vuln1 tab in --src rejected"; else bad "Vuln1 tab" "rc=$RUN_RC (want non-zero)"; fi

sample_bytes=$(( $(wc -c < "$FIXTURES/-src-dir/sample.py") ))
run_est --new 1 --src "$FIXTURES/-src-dir"
expect_eq "Vuln1 baseline avg_bytes (absolute dir)" "$(budget_val "$RUN_OUT" avg_bytes_per_file)" "$sample_bytes"
RUN_OUT=""; RUN_RC=0
if RUN_OUT="$(cd "$FIXTURES" && sh "$ESTIMATOR" --new 1 --src "-src-dir" 2>/dev/null)"; then RUN_RC=0; else RUN_RC=$?; fi
if [ "$RUN_RC" -eq 0 ] \
  && [ "$(budget_val "$RUN_OUT" avg_bytes_per_file)" = "$sample_bytes" ] \
  && [ "$(budget_val "$RUN_OUT" src)" = "./-src-dir" ]; then
  ok "Vuln1 leading-dash --src normalized + measured"
else
  bad "Vuln1 leading-dash" "rc=$RUN_RC avg=$(budget_val "$RUN_OUT" avg_bytes_per_file) src=$(budget_val "$RUN_OUT" src)"
fi

# --- Monotonic: adding a full read never decreases peak ---
run_est --full-reads "$FIXTURES/small.py"
mono1=$(budget_val "$RUN_OUT" estimated_peak)
run_est --full-reads "$FIXTURES/small.py" --full-reads "$FIXTURES/medium.py"
mono2=$(budget_val "$RUN_OUT" estimated_peak)
expect_ge "monotonic peak" "$mono2" "$mono1"

echo "---"
echo "passed=$PASS failed=$FAIL"
[ "$FAIL" -eq 0 ]
