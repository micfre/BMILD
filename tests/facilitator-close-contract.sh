#!/usr/bin/env bash
# Facilitator close-shape contract test.
#
# Guards the seamless facilitator return across the three advanced facilitators
# convened by a persona (roundtable, brainstorming):
#   - each close resource carries the guarded in-turn resume branch
#     (default when the convener's suspended session is present) AND the
#     copy-ready fallback branch (fresh window), both grounded in the
#     convener's Same-Session Resumption contract;
#   - each facilitator SKILL.md Exit section states the same rule;
#   - the old anti-resume phrasing ("cannot resume", "turn ends at sign-off",
#     "promise you cannot keep") is gone everywhere.
# Drift between the three facilitators fails the test, forcing realignment
# rather than silently divergent close behaviour.
#
# Mechanism: bash + rg. Layout-portable: scans known skill roots
# (.agents/skills, .claude/skills) relative to the repo root, never hardcoding one.
set -euo pipefail

CLOSE_RESOURCES=(
  "bmild-roundtable/resources/step-04-close.md"
  "bmild-brainstorming/resources/step-04-organise.md"
)

FACILITATOR_SKILLS=(
  "bmild-roundtable/SKILL.md"
  "bmild-brainstorming/SKILL.md"
)

# Resolve repo root from this script's location (<root>/tests/facilitator-close-contract.sh).
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
  echo "== facilitator-close contract: ${root} =="

  for rel in "${CLOSE_RESOURCES[@]}"; do
    file="${root}/${rel}"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi

    # In-turn resume branch (default).
    rg -q -F "resume in-turn" "${file}" || fail "${file}: missing in-turn resume branch"
    rg -q -F "Same-Session Resumption" "${file}" || fail "${file}: in-turn resume not grounded in Same-Session Resumption"

    # Copy-ready fallback branch (fresh window).
    rg -q -F "suspended state not in this conversation" "${file}" || fail "${file}: missing copy-ready fallback branch"
    rg -q -F "with the message" "${file}" || fail "${file}: fallback copy-ready invocation removed"

    # Old anti-resume phrasing must be gone.
    if rg -q "cannot resume another persona|turn ends at sign-off|promise you cannot keep" "${file}"; then
      fail "${file}: old anti-resume phrasing remains"
    fi
  done

  for rel in "${FACILITATOR_SKILLS[@]}"; do
    file="${root}/${rel}"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi
    rg -q -F "in-turn" "${file}" || fail "${file}: Exit section missing in-turn resume rule"
    rg -q -F "Same-Session Resumption" "${file}" || fail "${file}: Exit section not grounded in Same-Session Resumption"
    rg -q -F "copy-ready resume invocation" "${file}" || fail "${file}: Exit section missing fallback rule"
    if rg -q "cannot resume another persona|turn ends at sign-off|promise you cannot keep" "${file}"; then
      fail "${file}: old anti-resume phrasing remains"
    fi
  done
done

# Articulation is persona-run: a standard persona applies its methods in its own voice, so
# there is no facilitator suspension to resume. Standalone sessions keep the Facilitator close.
for root in "${SKILL_ROOTS[@]}"; do
  art="${root}/bmild-articulate"
  rg -q -F "resources/persona-run.md" "${art}/SKILL.md" || fail "${art}/SKILL.md: persona-active routing to persona-run.md missing"
  rg -q -F "do not become the facilitator" "${art}/SKILL.md" || fail "${art}/SKILL.md: mid-session load must stay in persona voice"
  rg -q -F "Same-Session Resumption" "${art}/SKILL.md" || fail "${art}/SKILL.md: persona-run resume not grounded in Same-Session Resumption"
  [ -f "${art}/resources/persona-run.md" ] || fail "missing ${art}/resources/persona-run.md"
  rg -q -F -- "— Facilitator ⚡" "${art}/resources/step-02-execute.md" || fail "${art}: standalone close sign-off missing"
  # Natural-language turns: no BMAD-style lettered menus.
  if rg -q -F -e '[x]' -e '[r]' -e '[a]' -e '[y]' -e '[n]' "${art}/SKILL.md" "${art}/resources/step-01-select.md" "${art}/resources/step-02-execute.md" "${art}/resources/persona-run.md"; then
    fail "${art}: lettered menu tokens remain; articulation uses natural-language turns"
  fi
done

if [ "${failures}" -gt 0 ]; then
  echo "facilitator-close-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "facilitator-close-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#CLOSE_RESOURCES[@]} close resource(s), ${#FACILITATOR_SKILLS[@]} skill file(s))"
