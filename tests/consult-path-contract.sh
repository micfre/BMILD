#!/usr/bin/env bash
# Consult-path identity + placement contract.
#
# Asserts seven byte-identical references/consult-path.md copies under each
# standard persona, that each persona ships an agents/consult.md definition
# with the correct tier pair, and that runtime consumers point at the local
# skill copy rather than any docs/ path (which never ships).
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

# Frontier-pinned tiers: design-tier (pm/ux/arch) + planner.
# QA/Sec consults inherit the session model.
FRONTIER_PERSONAS=(
  "bmild-pm"
  "bmild-ux"
  "bmild-arch"
  "bmild-planner"
)
INHERIT_PERSONAS=(
  "bmild-dev"
  "bmild-qa"
  "bmild-sec"
)

# Dev's consult definition also inherits: Alex implements; the consult
# mechanism serves gaps in *other* owners' artifacts, and Alex consults
# (implementation questions) do not need Frontier by default.

CONSUMER_FILES=(
  "bmild-pm/SKILL.md"
  "bmild-ux/SKILL.md"
  "bmild-arch/SKILL.md"
  "bmild-planner/SKILL.md"
  "bmild-dev/SKILL.md"
  "bmild-qa/SKILL.md"
  "bmild-sec/SKILL.md"
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
  echo "== consult-path contract: ${root} =="

  # 1. Seven byte-identical references/consult-path.md copies.
  reference=""
  for persona in "${PERSONAS[@]}"; do
    file="${root}/${persona}/references/consult-path.md"
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

  # 2. Each persona ships agents/consult.md with the correct tier pair.
  for persona in "${FRONTIER_PERSONAS[@]}"; do
    file="${root}/${persona}/agents/consult.md"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi
    rg -q '^model_tier: frontier' "${file}" || fail "${file}: expected 'model_tier: frontier'"
    rg -q '^effort_tier: high' "${file}" || fail "${file}: expected 'effort_tier: high'"
    rg -q 'references/consult-path\.md' "${file}" || fail "${file}: expected references/consult-path.md"
  done
  for persona in "${INHERIT_PERSONAS[@]}"; do
    file="${root}/${persona}/agents/consult.md"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi
    rg -q '^model_tier: inherit' "${file}" || fail "${file}: expected 'model_tier: inherit'"
    rg -q '^effort_tier: default' "${file}" || fail "${file}: expected 'effort_tier: default'"
    rg -q 'references/consult-path\.md' "${file}" || fail "${file}: expected references/consult-path.md"
  done

  # 3. Consumers point at the local reference copy; nothing points at docs/.
  for rel in "${CONSUMER_FILES[@]}"; do
    file="${root}/${rel}"
    if [ ! -f "${file}" ]; then
      fail "missing consumer ${file}"
      continue
    fi
    if ! rg -q 'references/consult-path\.md' "${file}"; then
      fail "${file}: expected references/consult-path.md"
    fi
    if rg -q 'docs/consult-path\.md' "${file}"; then
      fail "${file}: must not reference docs/consult-path.md"
    fi
  done

  if rg -q 'docs/consult-path\.md' "${root}"; then
    fail "${root}: docs/consult-path.md still referenced under skill tree"
    rg -n 'docs/consult-path\.md' "${root}" >&2 || true
  fi
done

if [ "${failures}" -gt 0 ]; then
  echo "consult-path-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "consult-path-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#PERSONAS[@]} copies, ${#CONSUMER_FILES[@]} consumers)"
