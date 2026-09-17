#!/usr/bin/env bash
# Unified review-depth contract: artifact-review gate, finalize hooks, review lenses,
# findings triage, wiring, and failure semantics.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$REPO_ROOT/.agents/skills"
PLANNER="$ROOT/bmild-planner"
QA="$ROOT/bmild-qa"
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }
require_literal() { rg -q -F "$2" "$1" || fail "$1: missing '$2'"; }
forbid_literal() { if rg -q -F "$2" "$1"; then fail "$1: forbidden '$2' present"; fi; }

# --- Sonia: Artifact Reviewer Gate -----------------------------------------

gate="$PLANNER/resources/artifact-review.md"
[ -f "$gate" ] || fail "missing $gate"
# shellcheck disable=SC2016 # Markdown backticks are literal contract text.
for literal in \
  '`prd.md`, `ux-design.md`, or `system-design.md`' \
  'never determines outcome readiness, authorizes implementation, or sets Rahat' \
  'rubric-walker.md`, `adversarial-lens.md`' \
  'both, always' \
  'isolated reviewer context' \
  'the result is `incomplete`; no fallback path may produce `clear`' \
  'never independent' \
  'only a compact summary' \
  'Recheck identity immediately before consolidation' \
  'invalidates the run' \
  'clear | findings_open | incomplete' \
  'critical | high | medium | low' \
  'strong | adequate | thin | broken' \
  'apply | discuss | defer | ignore' \
  'unset disposition per finding' \
  'standalone continuation prompts' \
  'repeats the full fixed baseline against the new artifact identity' \
  'Targeted remediation checks may close individual findings but can never issue `clear`' \
  'reviews/artifact-review-' \
  'not approvals and not `qa_status` values'; do
  require_literal "$gate" "$literal"
done
forbid_literal "$gate" 'qa_status: verified'
forbid_literal "$gate" 'qa_status: review_requested'

planner_core="$PLANNER/SKILL.md"
require_literal "$planner_core" '**Mode 4: Artifact Review**'
require_literal "$planner_core" 'resources/artifact-review.md'
require_literal "$planner_core" 'never a readiness gate, and never sets QA statuses'
require_literal "$planner_core" 'Artifact Reviewer Gate'

rubric="$PLANNER/assets/artifact-review/rubric-walker.md"
adversarial="$PLANNER/assets/artifact-review/adversarial-lens.md"
for f in "$rubric" "$adversarial"; do
  [ -f "$f" ] || fail "missing $f"
  require_literal "$f" 'type: Artifact Review Report'
  require_literal "$f" 'Disposition (owner):* [apply | discuss | defer | ignore — unset]'
  require_literal "$f" 'do not edit the artifact under review'
  require_literal "$f" 'compact summary'
done
for dimension in \
  'Decision-readiness' \
  'Substance over theater' \
  'Strategic coherence' \
  'Done-ness clarity' \
  'Scope honesty' \
  'Downstream usability' \
  'Shape fit' \
  'Bloat and overspecification'; do
  require_literal "$rubric" "$dimension"
done
for literal in 'strong | adequate | thin | broken' 'critical|high|medium|low'; do
  require_literal "$rubric" "$literal"
done
require_literal "$adversarial" 'what the author talks past'

# --- Design-persona finalize hooks ------------------------------------------

hook_reference=""
for hooked in \
  "$ROOT/bmild-pm/resources/write-prd.md" \
  "$ROOT/bmild-pm/resources/refine-prd.md" \
  "$ROOT/bmild-ux/resources/ux-design.md" \
  "$ROOT/bmild-ux/resources/ux-refinement.md" \
  "$ROOT/bmild-arch/resources/architecture-design.md" \
  "$ROOT/bmild-arch/resources/architecture-refinement.md"; do
  [ -f "$hooked" ] || { fail "missing $hooked"; continue; }
  block="$(sed -n '/<!-- artifact-review-hook:start -->/,/<!-- artifact-review-hook:end -->/p' "$hooked")"
  [ -n "$block" ] || { fail "$hooked: missing artifact-review-hook block"; continue; }
  if [ -z "$hook_reference" ]; then
    hook_reference="$block"
  else
    [ "$block" = "$hook_reference" ] || fail "$hooked: artifact-review-hook block drifted"
  fi
  rg -q -F 'resources/artifact-review.md' <<<"$block" || fail "$hooked: hook does not name the gate resource"
  rg -q -F 'never independent approval' <<<"$block" || fail "$hooked: hook lacks non-approval rule"
done
# product-brief.md is not a gate-eligible artifact type (FR-001 boundary).
forbid_literal "$ROOT/bmild-pm/resources/write-product-brief.md" 'artifact-review-hook:start'

# --- Rahat: lenses and findings triage --------------------------------------

edge="$QA/resources/lens-edge-case-hunter.md"
vgap="$QA/resources/lens-verification-gap.md"
triage="$QA/resources/findings-triage.md"
for f in "$edge" "$vgap" "$triage"; do
  [ -f "$f" ] || fail "missing $f"
done

for literal in \
  'location' \
  'trigger_condition' \
  'guard_snippet' \
  'potential_consequence' \
  'Implicit branches' \
  'Handle lifetime' \
  'callee' \
  'Deletion check' \
  'Claims check' \
  'kind: deletion' \
  'kind: claim' \
  'confidence: high | medium | low' \
  'max 15 words' \
  'Do not assign severity labels, rankings, or priority levels'; do
  require_literal "$edge" "$literal"
done

require_literal "$vgap" 'would verification fail?'
for literal in \
  'regression-gap' \
  'missing-adoption-gap' \
  'broken-verification-gap' \
  'gap_shape' \
  'consumer' \
  'evidence'; do
  require_literal "$vgap" "$literal"
done
for literal in \
  'Read a test before claiming what it covers' \
  'search the whole repository' \
  'how far you looked' \
  'Do not assign severity, confidence, priority, or ranking'; do
  require_literal "$vgap" "$literal"
done

for literal in \
  'high | medium | low | false | maybe-false' \
  'exactly one verdict' \
  'Disregard reviewer-supplied severity' \
  'shared root cause' \
  'edits the specification under review' \
  'incomplete-review warning' \
  'only their counts'; do
  require_literal "$triage" "$literal"
done

# --- Wiring ------------------------------------------------------------------

qa_core="$QA/SKILL.md"
require_literal "$qa_core" 'resources/lens-edge-case-hunter.md'

for literal in \
  '**Mode 1: Comprehensive Review**' \
  '**Mode 7: Code Review**' \
  '**Mode 8: Targeted Verification (FR/NFR)**'; do
  require_literal "$qa_core" "$literal"
done

code_review="$QA/resources/code-review.md"
comprehensive="$QA/resources/comprehensive-review.md"
verification="$QA/resources/verification.md"
for f in "$code_review" "$comprehensive"; do
  for lens in 'lens-edge-case-hunter.md' 'lens-verification-gap.md' 'findings-triage.md'; do
    require_literal "$f" "resources/$lens"
  done
done
for lens in 'lens-verification-gap.md' 'findings-triage.md'; do
  require_literal "$verification" "resources/$lens"
done
require_literal "$verification" 'Edge-Case Hunter does not run merely because targeted verification was requested'
if rg -q -F 'lens-edge-case-hunter' "$verification"; then
  fail "$verification: Edge-Case Hunter wired into targeted verification"
fi

if [ "$failures" -gt 0 ]; then
  echo "review-depth-contract: $failures failure(s)" >&2
  exit 1
fi

echo "review-depth-contract: PASS"
