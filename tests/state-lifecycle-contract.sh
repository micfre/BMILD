#!/usr/bin/env bash
# State-lifecycle contract test.
#
# Guards the slice/QA/security lifecycle ownership rules:
#   - exactly one Slice archive-move instruction exists, it lives in
#     bmild-qa/resources/verification.md, and it fires only at status done
#     (never at ready-for-review — Archived is terminal, not "superseded");
#   - security_status has writers: findings_open/cleared in the slice review,
#     cleared in sec handback;
#   - qa_status ready_for_verification has a writer (Alex, spec-dev);
#   - status done has a writer (Rahat, verification).
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

  # 1. Exactly one Slice archive-move instruction, in qa/verification.md, gated on done.
  archive_hits=$(rg -N -F 'move `slice-<N>.md`' "${root}" --glob '*.md' || true)
  archive_count=$(printf '%s\n' "${archive_hits}" | grep -c . || true)
  if [ "${archive_count}" -ne 1 ]; then
    fail "${root}: expected exactly 1 Slice archive-move instruction, found ${archive_count}"
  else
    case "${archive_hits}" in
      *"bmild-qa/resources/verification.md"*) ;;
      *) fail "${root}: Slice archive-move instruction lives outside bmild-qa/resources/verification.md: ${archive_hits}" ;;
    esac
    case "${archive_hits}" in
      *"status: done"*) ;;
      *) fail "${root}: Slice archive-move instruction is not gated on status done: ${archive_hits}" ;;
    esac
  fi

  # 2. security_status writers.
  slice_review="${root}/bmild-sec/resources/slice-security-review.md"
  [ -f "${slice_review}" ] || fail "missing ${slice_review}"
  rg -q -F 'security_status: findings_open' "${slice_review}" || fail "${slice_review}: no findings_open writer"
  rg -q -F 'security_status: cleared' "${slice_review}" || fail "${slice_review}: no cleared writer (clean-review path)"
  sec_handback="${root}/bmild-sec/resources/sec-handback.md"
  [ -f "${sec_handback}" ] || fail "missing ${sec_handback}"
  rg -q -F 'security_status: cleared' "${sec_handback}" || fail "${sec_handback}: no cleared writer at closure"

  # 3. qa_status ready_for_verification writer (Alex).
  spec_dev="${root}/bmild-dev/resources/spec-dev.md"
  [ -f "${spec_dev}" ] || fail "missing ${spec_dev}"
  rg -q -F 'qa_status: ready_for_verification' "${spec_dev}" || fail "${spec_dev}: no ready_for_verification writer"

  # 4. status done writer (Rahat).
  qa_verification="${root}/bmild-qa/resources/verification.md"
  [ -f "${qa_verification}" ] || fail "missing ${qa_verification}"
  rg -q -F 'status: done' "${qa_verification}" || fail "${qa_verification}: no status done writer"

  # 5. Review independence: Alex can request verification, never sign it off.
  if rg -q -F 'qa_status: verified' "${root}/bmild-dev/resources"; then
    fail "${root}/bmild-dev: Alex must not author qa_status verified"
  fi
  if rg -q -F 'security_status: cleared' "${root}/bmild-dev/resources"; then
    fail "${root}/bmild-dev: Alex must not author security clearance"
  fi
  gap="${root}/bmild-dev/references/gap-resolution.md"
  rg -q -F 'Alex may author implementation-complete' "${gap}" || fail "${gap}: missing Alex boundary"
  rg -q -F 'Rahat alone authors QA evidence' "${gap}" || fail "${gap}: missing Rahat evidence ownership"
  rg -q -F 'Zach alone authors security findings' "${gap}" || fail "${gap}: missing Zach clearance ownership"
done

if [ "${failures}" -gt 0 ]; then
  echo "state-lifecycle-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "state-lifecycle-contract: PASS (${#SKILL_ROOTS[@]} root(s))"
