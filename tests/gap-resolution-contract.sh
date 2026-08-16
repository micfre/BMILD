#!/usr/bin/env bash
# Unified gap-resolution identity, wiring, ownership, and scenario contract.
set -euo pipefail

PERSONAS=(bmild-pm bmild-ux bmild-arch bmild-planner bmild-dev bmild-qa bmild-sec)
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

# Ladder and close-the-loop invariants.
# shellcheck disable=SC2016 # Markdown backticks are literal contract text.
for literal in \
  'Simplified scribe' \
  'Capability-gated guest voice' \
  'Owner consult' \
  'Durable inter-agent handoff' \
  'User-approved Course-Correction' \
  'Resume the exact suspended mode step' \
  'do not retry or substitute' \
  'OpenCode always inherits' \
  'including project-root `DESIGN.md`, `context-map.md`, and ADRs'; do
  require_literal "$reference" "$literal"
done

# Scenario fixtures expressed as enforceable contract assertions.
require_literal "$reference" 'status mirroring, registry/matrix/roadmap synchronization'
require_literal "$reference" 'A bounded Sonia planning consult may recut affected delivery artifacts as its own episode'
require_literal "$reference" 'Batch all same-owner consequences across owned artifacts before returning'
# shellcheck disable=SC2016 # Markdown backticks are literal contract text.
require_literal "$ROOT/bmild-arch/agents/consult.md" 'including `[plan_folder]/adr/`'
require_literal "$reference" 'Independent consequences owned by different personas are separate ladder episodes'
require_literal "$reference" 'wait for explicit user confirmation before entering it'
require_literal "$reference" 'persist one durable handoff for the affected episode'
require_literal "$reference" 'close that item and point its Promotion Record at the authoritative edit; never create a replacement'
require_literal "$reference" 'Alex may author implementation-complete'
require_literal "$reference" 'Rahat alone authors QA evidence'
require_literal "$reference" 'Zach alone authors security findings'
for scenario in \
  'Dev-time API gap' \
  'Same-owner batch' \
  'Canonical ADR' \
  'Independent owners' \
  'Coupled change' \
  'Rejected pair' \
  'Existing queue item'; do
  require_literal "$reference" "$scenario"
done

rg -q 'auto-enqueue' "$ROOT" && fail "obsolete automatic handoff cascade remains"

if [ "$failures" -gt 0 ]; then
  echo "gap-resolution-contract: $failures failure(s)" >&2
  exit 1
fi

echo "gap-resolution-contract: PASS (${#PERSONAS[@]} copies, mode wiring, scenarios)"
