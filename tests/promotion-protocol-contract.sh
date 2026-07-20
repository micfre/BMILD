#!/usr/bin/env bash
# Promotion-protocol identity + placement contract.
#
# Asserts three byte-identical references/promotion-protocol.md copies under
# advanced facilitators, required load/placement wiring, close-state markers,
# and no cross-skill or docs/ protocol loads.
#
# Mechanism: bash + rg + cmp. Layout-portable: scans known skill roots
# (.agents/skills, .claude/skills) relative to the repo root.
set -euo pipefail

FACILITATORS=(
  "bmild-roundtable"
  "bmild-elicit"
  "bmild-brainstorming"
)

# Files that must load the local promotion protocol.
LOAD_FILES=(
  "bmild-roundtable/SKILL.md"
  "bmild-roundtable/resources/step-03-synthesise.md"
  "bmild-roundtable/resources/step-04-close.md"
  "bmild-elicit/SKILL.md"
  "bmild-elicit/resources/step-02-execute.md"
  "bmild-brainstorming/SKILL.md"
  "bmild-brainstorming/resources/step-04-organise.md"
)

CLOSE_STATES=(
  "ratified_and_promoted"
  "ratified_and_routed"
  "ratified_pending_authorization"
  "ratified_with_documentation_deferred"
)

CONSUMER_PERSONAS=(
  "bmild-pm"
  "bmild-ux"
  "bmild-arch"
  "bmild-planner"
  "bmild-dev"
  "bmild-qa"
  "bmild-sec"
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
  echo "== promotion-protocol contract: ${root} =="

  reference=""
  for skill in "${FACILITATORS[@]}"; do
    file="${root}/${skill}/references/promotion-protocol.md"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi
    if [ -z "${reference}" ]; then
      reference="${file}"
    elif ! cmp -s "${reference}" "${file}"; then
      fail "${file}: drifted from ${reference}"
    fi
    # Protocol body must name all close states and action classes.
    for state in "${CLOSE_STATES[@]}"; do
      if ! rg -q "${state}" "${file}"; then
        fail "${file}: missing close state ${state}"
      fi
    done
    if ! rg -q 'canonical-route' "${file}"; then
      fail "${file}: missing canonical-route action class"
    fi
  done

  for rel in "${LOAD_FILES[@]}"; do
    file="${root}/${rel}"
    if [ ! -f "${file}" ]; then
      fail "missing load wiring file ${file}"
      continue
    fi
    if ! rg -q 'references/promotion-protocol\.md' "${file}"; then
      fail "${file}: expected references/promotion-protocol.md"
    fi
    if rg -q '\.\./bmild-(roundtable|elicit|brainstorming)/' "${file}"; then
      fail "${file}: cross-skill protocol path forbidden"
    fi
    if rg -q 'docs/promotion-protocol\.md' "${file}"; then
      fail "${file}: must not reference docs/promotion-protocol.md"
    fi
  done

  # Roundtable step-03 must distinguish Context A gate vs Context B no double-gate.
  step03="${root}/bmild-roundtable/resources/step-03-synthesise.md"
  if [ -f "${step03}" ]; then
    if ! rg -q 'no double-gate' "${step03}"; then
      fail "${step03}: expected Context B no double-gate language"
    fi
    if ! rg -q 'Ratification→Promotion gate \(Context A only\)' "${step03}"; then
      fail "${step03}: expected Context A promotion gate heading"
    fi
  fi

  for persona in "${CONSUMER_PERSONAS[@]}"; do
    file="${root}/${persona}/SKILL.md"
    if [ ! -f "${file}" ]; then
      fail "missing consumer ${file}"
      continue
    fi
    if ! rg -q 'Facilitator promotion close states' "${file}"; then
      fail "${file}: expected Facilitator promotion close states pointer"
    fi
    for state in "${CLOSE_STATES[@]}"; do
      if ! rg -q "${state}" "${file}"; then
        fail "${file}: missing close state ${state}"
      fi
    done
  done

  # Planner must preserve slice exclusion.
  planner="${root}/bmild-planner/SKILL.md"
  if [ -f "${planner}" ] && ! rg -q 'Slice authoring or recut' "${planner}"; then
    fail "${planner}: expected Slice exclusion under promotion close states"
  fi
done

if [ "${failures}" -gt 0 ]; then
  echo "promotion-protocol-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "promotion-protocol-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#FACILITATORS[@]} copies, ${#LOAD_FILES[@]} load sites)"
