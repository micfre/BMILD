#!/usr/bin/env bash
# Parallel-run stress test for the peak_live_v2 sh estimator.
#
# Concurrent invocations must each return their own correct result. Guards
# against temp-file identity collisions (PID-based names collapse whenever two
# runs share `$$` — e.g. sourced execution or POSIX subshell `$$` semantics,
# which is how harnesses that fan out subagents can invoke the script).
#
# Cases:
#   1. baseline-determinism  — two sequential runs, identical args, identical output
#   2. parallel-exec         — 8 concurrent `sh script` runs, identical args: all rc=0, all == baseline
#   3. parallel-mixed        — 2×4 concurrent runs with different args: each == its own baseline
#   4. parallel-shared-pid   — 4 concurrent sourced runs (shared `$$`): each == its own baseline
#
# Case 4 fails on PID-suffixed temp names; all cases must pass after the fix.
set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${TESTS_DIR}/.." && pwd)"
FIXTURES="${TESTS_DIR}/fixtures"
SH_EST="${REPO_ROOT}/.agents/skills/bmild-planner/scripts/run-budget-slice.sh"

[ -f "${SH_EST}" ] || { echo "FAIL: missing ${SH_EST}" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT

SANDBOX="${WORK}/sandbox"
mkdir -p "${SANDBOX}"

A_small="${FIXTURES}/small.py"
A_medium="${FIXTURES}/medium.py"

PASS=0
FAIL=0
fail() { echo "FAIL: $*" >&2; FAIL=$((FAIL + 1)); }
pass() { echo "PASS: $*"; PASS=$((PASS + 1)); }

run_seq() {
  # run_seq <outfile> <args...>
  _out="$1"; shift
  (cd "${SANDBOX}" && sh "${SH_EST}" "$@") > "${_out}" 2>/dev/null
}

# --- 1. baseline determinism ---
run_seq "${WORK}/base1.out" --full-reads "${A_small}"
run_seq "${WORK}/base2.out" --full-reads "${A_small}"
if cmp -s "${WORK}/base1.out" "${WORK}/base2.out"; then
  pass "baseline-determinism"
else
  fail "baseline-determinism: sequential identical runs diverge"
fi

# --- 2. parallel-exec: 8 concurrent identical runs ---
pids=()
for i in 1 2 3 4 5 6 7 8; do
  (cd "${SANDBOX}" && sh "${SH_EST}" --full-reads "${A_small}") > "${WORK}/par${i}.out" 2>/dev/null &
  pids+=($!)
done
rc_ok=1
for p in "${pids[@]}"; do
  wait "${p}" || rc_ok=0
done
ident_ok=1
for i in 1 2 3 4 5 6 7 8; do
  cmp -s "${WORK}/par${i}.out" "${WORK}/base1.out" || ident_ok=0
done
if [ "${rc_ok}" -eq 1 ] && [ "${ident_ok}" -eq 1 ]; then
  pass "parallel-exec"
else
  fail "parallel-exec: rc_ok=${rc_ok} identical_to_baseline=${ident_ok}"
fi

# --- 3. parallel-mixed: two arg shapes, 4 jobs each ---
run_seq "${WORK}/baseA.out" --full-reads "${A_small}"
run_seq "${WORK}/baseB.out" --full-reads "${A_small}" "${A_medium}" --symbol-edits "${A_medium}"
pids=()
for i in 1 2 3 4; do
  (cd "${SANDBOX}" && sh "${SH_EST}" --full-reads "${A_small}") > "${WORK}/mixA${i}.out" 2>/dev/null &
  pids+=($!)
  (cd "${SANDBOX}" && sh "${SH_EST}" --full-reads "${A_small}" "${A_medium}" --symbol-edits "${A_medium}") > "${WORK}/mixB${i}.out" 2>/dev/null &
  pids+=($!)
done
rc_ok=1
for p in "${pids[@]}"; do
  wait "${p}" || rc_ok=0
done
mix_ok=1
for i in 1 2 3 4; do
  cmp -s "${WORK}/mixA${i}.out" "${WORK}/baseA.out" || mix_ok=0
  cmp -s "${WORK}/mixB${i}.out" "${WORK}/baseB.out" || mix_ok=0
done
if [ "${rc_ok}" -eq 1 ] && [ "${mix_ok}" -eq 1 ]; then
  pass "parallel-mixed"
else
  fail "parallel-mixed: rc_ok=${rc_ok} outputs_match_baselines=${mix_ok}"
fi

# --- 4. parallel-shared-pid: sourced runs share the parent's $$ ---
pids=()
for i in 1 2; do
  # shellcheck disable=SC1090
  ( cd "${SANDBOX}"; set -- --full-reads "${A_small}"; . "${SH_EST}" ) > "${WORK}/srcA${i}.out" 2>/dev/null &
  pids+=($!)
  # shellcheck disable=SC1090
  ( cd "${SANDBOX}"; set -- --full-reads "${A_small}" "${A_medium}" --symbol-edits "${A_medium}"; . "${SH_EST}" ) > "${WORK}/srcB${i}.out" 2>/dev/null &
  pids+=($!)
done
rc_ok=1
for p in "${pids[@]}"; do
  wait "${p}" || rc_ok=0
done
src_ok=1
for i in 1 2; do
  cmp -s "${WORK}/srcA${i}.out" "${WORK}/baseA.out" || src_ok=0
  cmp -s "${WORK}/srcB${i}.out" "${WORK}/baseB.out" || src_ok=0
done
if [ "${rc_ok}" -eq 1 ] && [ "${src_ok}" -eq 1 ]; then
  pass "parallel-shared-pid"
else
  fail "parallel-shared-pid: rc_ok=${rc_ok} outputs_match_baselines=${src_ok}"
fi

if [ "${FAIL}" -gt 0 ]; then
  echo "parallel-budget: ${FAIL} failure(s), ${PASS} pass(es)" >&2
  exit 1
fi
echo "parallel-budget: PASS (${PASS} cases)"
