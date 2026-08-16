#!/usr/bin/env bash
# Breaking 0.4 gap-resolution configuration contract.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REFERENCE="$REPO_ROOT/.agents/skills/bmild-pm/references/gap-resolution.md"
EXAMPLE="$REPO_ROOT/.bmild.toml.example"
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

rg -q '^gap_resolution = "auto"' "$EXAMPLE" || fail "example missing automatic default"
for posture in auto ask-consult handoff-only; do
  rg -q -F "$posture" "$REFERENCE" || fail "reference missing posture $posture"
done

for harness in claude_code codex; do
  for tier in design planning; do
    rg -q -F "[intelligence.$harness.$tier]" "$EXAMPLE" || fail "example missing $harness/$tier"
  done
done

claude_efforts='Claude opus: "low", "medium", "high", "max"; Opus 4.7 also "xhigh"'
codex_sol_efforts='Codex gpt-5.6-sol: "low", "medium", "high", "xhigh", "max", "ultra"'
codex_terra_efforts='Codex gpt-5.6-terra: "low", "medium", "high", "xhigh", "max", "ultra"'
[ "$(rg -c -F "$claude_efforts" "$EXAMPLE")" -eq 2 ] || fail "example missing Claude opus effort enums"
[ "$(rg -c -F "$codex_sol_efforts" "$EXAMPLE")" -eq 2 ] || fail "example missing Codex sol effort enums"
[ "$(rg -c -F "$codex_terra_efforts" "$EXAMPLE")" -eq 2 ] || fail "example missing Codex terra effort enums"

if rg -q '^[[:space:]]*(consult|consult_model|consult_effort)[[:space:]]*=' "$EXAMPLE"; then
  fail "example preserves a legacy consult assignment"
fi

migration='Legacy consult configuration is unsupported in BMILD 0.4.0. Remove consult, consult_model, and consult_effort; use gap_resolution and [intelligence.<harness>.<tier>] instead.'
rg -q -F "$migration" "$REFERENCE" || fail "exact migration guidance missing"
rg -q -F 'Do not map, interpret, preserve, or combine legacy values' "$REFERENCE" || fail "legacy no-mapping rule missing"
rg -q -F 'do not retry or substitute' "$REFERENCE" || fail "invalid-pair no-retry rule missing"
rg -q -F 'Report the exact pair and harness error' "$REFERENCE" || fail "invalid-pair report rule missing"

if [ "$failures" -gt 0 ]; then
  echo "configuration-contract: $failures failure(s)" >&2
  exit 1
fi

echo "configuration-contract: PASS"
