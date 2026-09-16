#!/usr/bin/env bash
# State-lifecycle contract test.
#
# Guards the unified Rahat review lifecycle:
#   - every Slice-capable review mode reconciles closure itself and archives
#     only after status done;
#   - Rahat writes QA, security, and code-review outcomes;
#   - Alex requests QA and code review but never signs either off;
#   - the final review mode closes directly, with no reviewer self-handoff.
# Drift in any rule fails the test rather than silently re-creating ambiguous
# completion state (LLM second-guessing, git-history archaeology).
#
# Mechanism: bash + rg. Layout-portable: scans known skill roots
# (.agents/skills, .claude/skills) relative to the repo root, never hardcoding one.
set -euo pipefail

# Resolve repo root from this script's location (<root>/tests/state-lifecycle-contract.sh).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SKILL_ROOTS=()
for candidate in ".agents/skills" ".claude/skills"; do
  if [ -d "${REPO_ROOT}/${candidate}" ]; then
    SKILL_ROOTS+=("${REPO_ROOT}/${candidate}")
  fi
done

if [ "${#SKILL_ROOTS[@]}" -eq 0 ]; then
  echo "FAIL: no skill root found (.agents/skills or .claude/skills) under ${REPO_ROOT}" >&2
  exit 1
fi

failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

for root in "${SKILL_ROOTS[@]}"; do
  echo "== state-lifecycle contract: ${root} =="

  # 1. Every Slice-capable review mode owns terminal reconciliation.
  for mode in verification security-review code-review comprehensive-review qa-handback; do
    resource="${root}/bmild-qa/resources/${mode}.md"
    [ -f "${resource}" ] || { fail "missing ${resource}"; continue; }
    rg -q -F 'status: done' "${resource}" || fail "${resource}: no done-gated reconciliation"
    rg -q -F 'move `slice-<N>.md`' "${resource}" || fail "${resource}: no terminal archive move"
    rg -q -F 'do not hand back to Rahat' "${resource}" \
      || rg -q -F 'never create a Rahat-to-Rahat closure handoff' "${resource}" \
      || rg -q -F 'never hand back to Rahat' "${resource}" \
      || fail "${resource}: reviewer self-handoff prohibition missing"
  done

  # 2. QA/security/code-review outcome writers live under Rahat.
  security_review="${root}/bmild-qa/resources/security-review.md"
  comprehensive="${root}/bmild-qa/resources/comprehensive-review.md"
  code_review="${root}/bmild-qa/resources/code-review.md"
  for writer in "${security_review}" "${comprehensive}"; do
    rg -q -F 'security_status: findings_open' "${writer}" || fail "${writer}: no security findings_open writer"
    rg -q -F 'security_status: findings_open | cleared' "${writer}" || fail "${writer}: no security cleared writer"
  done
  for writer in "${code_review}" "${comprehensive}"; do
    rg -q -F 'code_review_status: findings_open' "${writer}" || fail "${writer}: no code-review findings_open writer"
    rg -q -F 'code_review_status: findings_open | cleared' "${writer}" || fail "${writer}: no code-review cleared writer"
  done
  rg -q -F 'qa_status: verified | failed | blocked' "${comprehensive}" || fail "${comprehensive}: no QA outcome writer"

  # 3. Review-requested writers (Alex).
  spec_dev="${root}/bmild-dev/resources/spec-dev.md"
  [ -f "${spec_dev}" ] || fail "missing ${spec_dev}"
  rg -q -F 'qa_status: review_requested' "${spec_dev}" || fail "${spec_dev}: no QA review request writer"
  rg -q -F 'code_review_status: review_requested' "${spec_dev}" || fail "${spec_dev}: no code-review request writer"

  # 4. status done writer (Rahat).
  qa_verification="${root}/bmild-qa/resources/verification.md"
  [ -f "${qa_verification}" ] || fail "missing ${qa_verification}"
  rg -q -F 'status: done' "${qa_verification}" || fail "${qa_verification}: no status done writer"

  # 5. Review independence: Alex can request review, never sign it off.
  if rg -q -F 'qa_status: verified' "${root}/bmild-dev/resources"; then
    fail "${root}/bmild-dev: Alex must not author qa_status verified"
  fi
  if rg -q -F 'security_status: cleared' "${root}/bmild-dev/resources"; then
    fail "${root}/bmild-dev: Alex must not author security clearance"
  fi
  if rg -q -F 'code_review_status: cleared' "${root}/bmild-dev/resources"; then
    fail "${root}/bmild-dev: Alex must not author code-review clearance"
  fi
  gap="${root}/bmild-dev/references/gap-resolution.md"
  rg -q -F 'Alex may author implementation-complete' "${gap}" || fail "${gap}: missing Alex boundary"
  rg -q -F 'Rahat alone authors QA evidence' "${gap}" || fail "${gap}: missing Rahat evidence ownership"
  rg -q -F 'security findings and clearance' "${gap}" || fail "${gap}: missing Rahat security ownership"
  rg -q -F 'code-review outcomes' "${gap}" || fail "${gap}: missing Rahat code-review ownership"
done

if [ "${failures}" -gt 0 ]; then
  echo "state-lifecycle-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "state-lifecycle-contract: PASS (${#SKILL_ROOTS[@]} root(s))"
