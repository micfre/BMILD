#!/usr/bin/env bash
# Fix Election + RCA protocol identity contract for bmild-qa.
#
# Asserts the marked fix-election and rca-protocol blocks read byte-identically
# across Rahat's Spec-Fix and Direct-Fix resources, that election sits before
# the commit-eligibility step, and that Diagnostic mode has been absorbed.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

QA_FIX_FILES=(
  .agents/skills/bmild-qa/resources/spec-fix.md
  .agents/skills/bmild-qa/resources/direct-fix.md
)

failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

extract_block() {
  local file=$1 marker=$2
  sed -n "/<!-- ${marker}:start -->/,/<!-- ${marker}:end -->/p" "$file"
}

# Diagnostic mode must be gone.
if [ -f "${ROOT}/.agents/skills/bmild-qa/resources/diagnostic.md" ]; then
  fail "resources/diagnostic.md still exists — Diagnostic mode should be absorbed"
fi
rg -q 'resources/diagnostic\.md' "${ROOT}/.agents/skills/bmild-qa/SKILL.md" && \
  fail "bmild-qa/SKILL.md still references resources/diagnostic.md"
rg -q 'Mode 4: Diagnostic' "${ROOT}/.agents/skills/bmild-qa/SKILL.md" && \
  fail "bmild-qa/SKILL.md still lists Mode 4: Diagnostic"

reference_election=""
reference_protocol=""
for rel in "${QA_FIX_FILES[@]}"; do
  file="${ROOT}/${rel}"
  [ -f "$file" ] || { fail "missing $file"; continue; }

  for marker in fix-election rca-protocol; do
    count=$(rg -c -F "<!-- ${marker}:start -->" "$file" || true)
    [ "$count" -eq 1 ] || fail "$file: expected one ${marker} block, found $count"
  done

  election=$(extract_block "$file" fix-election)
  protocol=$(extract_block "$file" rca-protocol)
  if [ -z "$reference_election" ]; then
    reference_election=$election
    reference_protocol=$protocol
  else
    [ "$election" = "$reference_election" ] || fail "$file: fix-election block drifted from reference"
    [ "$protocol" = "$reference_protocol" ] || fail "$file: rca-protocol block drifted from reference"
  fi

  election_line=$(rg -n -F '<!-- fix-election:start -->' "$file" | cut -d: -f1)
  eligibility_line=$(rg -n -F 'Establish mode eligibility:' "$file" | cut -d: -f1)
  [ -n "$election_line" ] || fail "$file: fix-election start marker missing"
  [ -n "$eligibility_line" ] || fail "$file: eligibility step missing"
  [ "$election_line" -lt "$eligibility_line" ] || fail "$file: fix-election is not before eligibility"

  # Required election semantics present in the shared block.
  printf '%s\n' "$election" | rg -q 'Skip when the entry artifact already confirmed' || \
    fail "$file: fix-election missing skip rule"
  printf '%s\n' "$election" | rg -q 'I can implement the fix now' || \
    fail "$file: fix-election missing offer phrasing"
  printf '%s\n' "$election" | rg -q 'Never commit-ready' || \
    fail "$file: fix-election missing never-commit-ready on decline"

  # Required RCA protocol semantics.
  printf '%s\n' "$protocol" | rg -q 'Write 5–7 distinct candidate causes' || \
    fail "$file: rca-protocol missing full-RCA hypothesize step"
  printf '%s\n' "$protocol" | rg -q 'Query available code intelligence MCPs' || \
    fail "$file: rca-protocol missing code-intelligence directive"
done

# RCA template carries the context-carrier section and election disposition.
rca_template="${ROOT}/.agents/skills/bmild-qa/assets/rca-template.md"
[ -f "$rca_template" ] || fail "missing $rca_template"
rg -q '^## Implementation Context$' "$rca_template" || fail "rca-template missing ## Implementation Context"
rg -q 'Fix election: offered' "$rca_template" || fail "rca-template missing Fix election disposition line"

if [ "$failures" -gt 0 ]; then
  echo "fix-election-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "fix-election-contract: PASS (${#QA_FIX_FILES[@]} placement(s))"
