#!/usr/bin/env bash
# Voice-shape contract test for BMILD standard personas.
#
# Asserts:
#   1. Producer-side guard: every standard persona has a co-located SOUL.md
#      containing the required-heading floor (presence, not exact-shape).
#   2. Stub invariant: each SKILL.md points at SOUL.md and carries NO voice body
#      (guards the no-dual-run / voice-stays-canonical invariant).
#   3. Consumer-side loaders: bmild-roundtable step-01-open.md AND step-02-debate.md
#      reference SOUL.md; the old heading-boundary scrape
#      ("### Your Role and Voice" ... "### NON-NEGOTIABLE") is gone.
#
# Mechanism: bash + rg. Layout-portable: scans known skill roots
# (.agents/skills, .claude/skills) relative to the repo root, never hardcoding one.
set -euo pipefail

STANDARD_PERSONAS=(pm ux arch dev qa sec planner)
REQUIRED_HEADINGS=(
  "## Identity"
  "## What I believe"
  "## My vocabulary"
  "## My tensions"
  "## What gets under my skin"
  "## What shaped me"
  "## My perspective in one line"
)

# Resolve repo root from this script's location (<root>/tests/voice-contract.sh).
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
  echo "== voice contract: ${root} =="

  # Producer-side guard: each standard persona ships a SOUL.md with the required-heading floor.
  for p in "${STANDARD_PERSONAS[@]}"; do
    soul="${root}/bmild-${p}/SOUL.md"
    if [ ! -f "${soul}" ]; then
      fail "missing ${soul}"
      continue
    fi
    if ! rg -q -F "I'm " "${soul}"; then
      fail "${soul}: missing narrative ('I'm ...' in Identity Bio)"
    fi
    for h in "${REQUIRED_HEADINGS[@]}"; do
      if ! rg -q -F "${h}" "${soul}"; then
        fail "${soul}: missing required heading '${h}'"
      fi
    done

    # Stub invariant: SKILL.md carries only the stub — it must point at SOUL.md
    # and must NOT carry the voice body (guards the no-dual-run invariant).
    skillmd="${root}/bmild-${p}/SKILL.md"
    if [ -f "${skillmd}" ]; then
      if ! rg -q -F "SOUL.md" "${skillmd}"; then
        fail "${skillmd}: identity stub does not point at SOUL.md"
      fi
      if rg -q -F "## What I believe" "${skillmd}"; then
        fail "${skillmd}: voice body present in SKILL.md (should be only the stub)"
      fi
    fi
  done

  # Consumer-side: roundtable loader must resolve SOUL.md; old scrape must be gone.
  step01="${root}/bmild-roundtable/resources/step-01-open.md"
  if [ -f "${step01}" ]; then
    if ! rg -q -F "SOUL.md" "${step01}"; then
      fail "${step01}: does not reference SOUL.md (attendee-voice loader not migrated)"
    fi
    # The old loader read "from `### Your Role and Voice` up to `### NON-NEGOTIABLE`".
    # That heading-range pairing must no longer appear as the voice-loading instruction.
    if rg -q "Your Role and Voice.*NON-NEGOTIABLE" "${step01}"; then
      fail "${step01}: residual heading-boundary scrape ('Your Role and Voice' -> 'NON-NEGOTIABLE')"
    fi
  else
    fail "missing ${step01}"
  fi

  # Consumer-side: step-02-debate.md attendee-voice references must point at SOUL.md.
  step02="${root}/bmild-roundtable/resources/step-02-debate.md"
  if [ -f "${step02}" ]; then
    if ! rg -q -F "SOUL.md" "${step02}"; then
      fail "${step02}: does not reference SOUL.md (attendee-voice refs not migrated)"
    fi
  fi
done

if [ "${failures}" -gt 0 ]; then
  echo "voice-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "voice-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#STANDARD_PERSONAS[@]} personas)"
