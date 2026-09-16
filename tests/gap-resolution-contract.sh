#!/usr/bin/env bash
# Unified gap-resolution identity, wiring, ownership, and scenario contract.
set -euo pipefail

PERSONAS=(bmild-pm bmild-ux bmild-arch bmild-planner bmild-dev bmild-qa)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$REPO_ROOT/.agents/skills"
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }
require_literal() { rg -q -F "$2" "$1" || fail "$1: missing '$2'"; }

reference="$ROOT/bmild-pm/references/gap-resolution.md"
[ -f "$reference" ] || fail "missing $reference"

for persona in "${PERSONAS[@]}"; do
  gap="$ROOT/$persona/references/gap-resolution.md"
  core="$ROOT/$persona/SKILL.md"
  agent="$ROOT/$persona/agents/consult.md"
  [ -f "$gap" ] || { fail "missing $gap"; continue; }
  cmp -s "$reference" "$gap" || fail "$gap: drifted from $reference"
  require_literal "$core" 'references/gap-resolution.md'
  require_literal "$core" 'emit its exact migration message, and stop before mode detection; never map legacy values'
  require_literal "$agent" 'references/gap-resolution.md'
  require_literal "$agent" 'Never dispatch, guest-author, invoke Course-Correction'

  while IFS= read -r mode; do
    require_literal "$mode" 'references/gap-resolution.md'
  done < <(find "$ROOT/$persona/resources" -type f -name '*.md' -exec rg -l '^## Global Directives$' {} +)

  [ ! -e "$ROOT/$persona/references/scribe-path.md" ] || fail "$persona: obsolete scribe-path.md remains"
  [ ! -e "$ROOT/$persona/references/consult-path.md" ] || fail "$persona: obsolete consult-path.md remains"
done

if rg -q 'references/(scribe|consult)-path\.md' "$ROOT"; then
  fail "obsolete scribe/consult reference remains under skill tree"
  rg -n 'references/(scribe|consult)-path\.md' "$ROOT" >&2 || true
fi

# Shared authority, continuity, and independence invariants.
for literal in \
  'Simplified scribe' \
  'Authorized owner voice' \
  'Owner consult' \
  'Durable handoff' \
  'User-approved Course-Correction' \
  'do not retry or substitute' \
  'OpenCode always inherits' \
  'All unspecified tiers inherit' \
  'Resume the suspended work' \
  'Rahat alone authors QA evidence' \
  'fresh context that did not implement' \
  'without the developer transcript' \
  'Source promotion' \
  'slice_target'; do
  require_literal "$reference" "$literal"
done
if rg -q 'exactly match|exact harness-attested tier parity|requires exact' "$reference"; then
  fail "model-identity authorization gate returned"
fi
require_literal "$ROOT/bmild-qa/agents/consult.md" 'without the development transcript'
require_literal "$ROOT/bmild-qa/agents/consult.md" 'leave acceptance pending for another reviewer'

rg -q 'auto-enqueue' "$ROOT" && fail "obsolete automatic handoff cascade remains"

if [ "$failures" -gt 0 ]; then
  echo "gap-resolution-contract: $failures failure(s)" >&2
  exit 1
fi

echo "gap-resolution-contract: PASS (${#PERSONAS[@]} copies, mode wiring, scenarios)"
