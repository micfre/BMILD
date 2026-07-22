#!/usr/bin/env bash
# Contract: Slice Actuals telemetry schema for peak_live_v2 calibration.
# Ensures future runs can supply valid per-turn peak data without including
# cached-token aggregates that must not drive calibration.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$ROOT/.agents/skills/bmild-planner/assets/slice-template.md"
EST_SH="$ROOT/.agents/skills/bmild-planner/scripts/run-budget-slice.sh"
EST_PS="$ROOT/.agents/skills/bmild-planner/scripts/run-budget-slice.ps1"

PASS=0
FAIL=0
ok(){ echo "PASS $1"; PASS=$((PASS+1)); }
bad(){ echo "FAIL $1 :: ${2:-}"; FAIL=$((FAIL+1)); }

require(){
  if grep -qE "$2" "$1"; then ok "$3"; else bad "$3" "missing /$2/ in $(basename "$1")"; fi
}
forbid(){
  if grep -qiE "$2" "$1"; then bad "$3" "found forbidden /$2/"; else ok "$3"; fi
}

require "$TEMPLATE" '^## Actuals' "Actuals section present"
require "$TEMPLATE" 'turns_taken:' "turns_taken field"
require "$TEMPLATE" 'compaction_count:' "compaction_count field"
require "$TEMPLATE" 'peak_live_context:' "peak_live_context field"
require "$TEMPLATE" 'peak_context_pct:' "peak_context_pct field"
require "$TEMPLATE" 'unexpected_whole_file_source_reads:' "unexpected_whole_file_source_reads field"
require "$TEMPLATE" 'unplanned_reads:' "unplanned_reads field"
require "$TEMPLATE" 'felt_budget:' "felt_budget field"
require "$TEMPLATE" 'peak_live_v2' "token estimate names peak_live_v2"
require "$TEMPLATE" 'estimated_peak:' "estimated_peak in raw values"

# Cached / cumulative billing signals must not be calibration fields.
forbid "$TEMPLATE" 'cached[_ -]?tokens|input_cached|cumulative_cached|cache_read' "no cached-token Actuals fields"
forbid "$TEMPLATE" 'actual_total|cumulative_total|billing_total' "no cumulative-total Actuals fields"

# Estimators declare the model id.
require "$EST_SH" 'peak_live_v2' "POSIX estimator declares peak_live_v2"
require "$EST_PS" 'peak_live_v2' "PowerShell estimator declares peak_live_v2"

# Only three user-facing TOML keys remain in scripts' config readers for budgeting.
if grep -E 'tokenizer_ratio|penalty_size_|edit_premium|carry_cap' "$EST_SH" | grep -v 'note_legacy\|legacy\|Warning\|ignoring' >/dev/null; then
  # Allow legacy key names only inside the warning/legacy path.
  if grep -E 'CFG_RATIO|CFG_SIZE_THRESHOLD|CFG_EDIT_PREMIUM|CFG_CARRY_CAP' "$EST_SH" >/dev/null; then
    bad "POSIX no live legacy config vars" "found CFG_* for removed keys"
  else
    ok "POSIX no live legacy config vars"
  fi
else
  ok "POSIX no live legacy config vars"
fi
if grep -E 'CFG_RATIO|CFG_SIZE_THRESHOLD|CFG_EDIT_PREMIUM|CFG_CARRY_CAP' "$EST_PS" >/dev/null; then
  bad "PS no live legacy config vars" "found CFG_* for removed keys"
else
  ok "PS no live legacy config vars"
fi

echo "---"
echo "passed=$PASS failed=$FAIL"
[ "$FAIL" -eq 0 ]
