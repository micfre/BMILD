#!/usr/bin/env bash
# Scribe-path identity + placement contract.
#
# Asserts seven byte-identical references/scribe-path.md copies under each
# standard persona, and that runtime consumers point at the local skill copy
# rather than docs/scribe-path.md (which never ships).
#
# Mechanism: bash + rg + cmp. Layout-portable: scans known skill roots
# (.agents/skills, .claude/skills) relative to the repo root.
set -euo pipefail

PERSONAS=(
  "bmild-pm"
  "bmild-ux"
  "bmild-arch"
  "bmild-planner"
  "bmild-dev"
  "bmild-qa"
  "bmild-sec"
)

CONSUMER_FILES=(
  "bmild-pm/SKILL.md"
  "bmild-ux/SKILL.md"
  "bmild-arch/SKILL.md"
  "bmild-planner/SKILL.md"
  "bmild-dev/SKILL.md"
  "bmild-qa/SKILL.md"
  "bmild-sec/SKILL.md"
  "bmild-planner/resources/course-correction.md"
  "bmild-pm/assets/handoff-template.md"
)

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
  echo "== scribe-path contract: ${root} =="

  reference=""
  for persona in "${PERSONAS[@]}"; do
    file="${root}/${persona}/references/scribe-path.md"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi
    if [ -z "${reference}" ]; then
      reference="${file}"
    elif ! cmp -s "${reference}" "${file}"; then
      fail "${file}: drifted from ${reference}"
    fi
  done

  for rel in "${CONSUMER_FILES[@]}"; do
    file="${root}/${rel}"
    if [ ! -f "${file}" ]; then
      fail "missing consumer ${file}"
      continue
    fi
    if ! rg -q 'references/scribe-path\.md' "${file}"; then
      fail "${file}: expected references/scribe-path.md"
    fi
    if rg -q 'docs/scribe-path\.md' "${file}"; then
      fail "${file}: must not reference docs/scribe-path.md"
    fi
  done

  # No skill tree may still point at the non-shipping docs path.
  if rg -q 'docs/scribe-path\.md' "${root}"; then
    fail "${root}: docs/scribe-path.md still referenced under skill tree"
    rg -n 'docs/scribe-path\.md' "${root}" >&2 || true
  fi
done

if [ "${failures}" -gt 0 ]; then
  echo "scribe-path-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "scribe-path-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#PERSONAS[@]} copies, ${#CONSUMER_FILES[@]} consumers)"
