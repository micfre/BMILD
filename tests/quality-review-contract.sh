#!/usr/bin/env bash
# Unified Rahat quality/security/code-review contract.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$REPO_ROOT/.agents/skills"
QA="$ROOT/bmild-qa"
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }
require_literal() { rg -q -F "$2" "$1" || fail "$1: missing '$2'"; }

[ ! -e "$ROOT/bmild-sec" ] || fail "retired security persona directory remains"
[ ! -e "$ROOT/code-review" ] || fail "standalone code-review skill remains after integration"

core="$QA/SKILL.md"
for literal in \
  '**Mode 1: Comprehensive Review**' \
  '**Mode 6: Security Review**' \
  '**Mode 7: Code Review**' \
  '**Mode 8: Targeted Verification (FR/NFR)**' \
  '"comprehensive review"' \
  '**Legacy Slice normalization.**' \
  'A missing field is never implicitly terminal.' \
  'Runs outcome completeness, security, and Standards/Spec review in one independent context'; do
  require_literal "$core" "$literal"
done

for resource in verification security-review code-review comprehensive-review; do
  [ -f "$QA/resources/$resource.md" ] || fail "missing Rahat review resource: $resource.md"
done
[ -f "$QA/resources/security-categories.yaml" ] || fail "missing security taxonomy"
[ -f "$QA/resources/code-review-categories.yaml" ] || fail "missing code-review taxonomy"
[ -f "$QA/assets/security-review-template.md" ] || fail "missing Rahat security-review template"

comprehensive="$QA/resources/comprehensive-review.md"
for literal in \
  '## Verification' \
  '## Security' \
  '## Standards' \
  '## Spec' \
  'one context load' \
  'do not hand back to Rahat'; do
  require_literal "$comprehensive" "$literal"
done

security_review="$QA/resources/security-review.md"
require_literal "$security_review" 'architecture contract, approved phase/outcome, or bounded change set'
require_literal "$security_review" 'system-design.md'
require_literal "$security_review" 'Explicit PR, diff, branch, commit range, worktree, or file set'

code_review="$QA/resources/code-review.md"
# shellcheck disable=SC2016 # Markdown backticks are literal contract text.
for literal in \
  'phase/outcome' \
  'verification-matrix.md' \
  'staged, unstaged, and untracked' \
  '## Standards' \
  '## Spec'; do
  require_literal "$code_review" "$literal"
done
if rg -q -F 'git diff <fixed-point>...HEAD' "$code_review"; then
  fail "$code_review: imported pinned fixed-point convention"
fi
if rg -q -F 'ask for it' "$code_review"; then
  fail "$code_review: requires user-supplied fixed point"
fi

require_literal "$QA/assets/security-review-template.md" 'owner: Rahat'
require_literal "$ROOT/bmild-planner/assets/verification-matrix-template.md" 'code_review_status:'
require_literal "$ROOT/bmild-dev/resources/spec-dev.md" 'code_review_status: review_requested'

if rg -n 'Zach|bmild-sec' \
  "$ROOT" "$REPO_ROOT/README.md" "$REPO_ROOT/AGENTS.md" "$REPO_ROOT/docs" "$REPO_ROOT/scripts" "$REPO_ROOT/tests" \
  --glob '!quality-review-contract.sh' >/dev/null; then
  fail "retired security persona remains in active product guidance"
fi

if [ "$failures" -gt 0 ]; then
  echo "quality-review-contract: $failures failure(s)" >&2
  exit 1
fi

echo "quality-review-contract: PASS"
