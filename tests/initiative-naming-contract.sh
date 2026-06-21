#!/usr/bin/env bash
# Initiative-naming identity contract test (guards ADR-0004).
#
# Asserts the canonical kebab-case naming block reads identically across the
# entry-persona skill resources that commit an initiative name to disk (their
# Write step). Drift in any one copy fails the test, forcing realignment
# against plans/adr/0004-kebab-case-initiative-names.md rather than silent drift.
#
# Mechanism: bash + rg. Layout-portable: scans known skill roots
# (.agents/skills, .claude/skills) relative to the repo root, never hardcoding one.
set -euo pipefail

# Resources that carry the canonical block at the initiative disk-commit (Write) step.
PLACEMENT_FILES=(
  "bmild-pm/resources/write-product-brief.md"
  "bmild-pm/resources/write-prd.md"
  "bmild-ux/resources/ux-design.md"
  "bmild-arch/resources/architecture-design.md"
)

# Resolve repo root from this script's location (<root>/tests/initiative-naming-contract.sh).
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

# Stable anchor (no special chars): the ADR every copy must cite.
ADR_REF="0004-kebab-case-initiative-names.md"

for root in "${SKILL_ROOTS[@]}"; do
  echo "== initiative-naming contract: ${root} =="

  reference=""
  for rel in "${PLACEMENT_FILES[@]}"; do
    file="${root}/${rel}"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi

    # Exactly one canonical block line per file.
    matches=$(rg -N -F "Initiative names are lowercase-kebab-case identifiers" "${file}" || true)
    count=$(printf '%s\n' "${matches}" | grep -c . || true)
    if [ "${count}" -ne 1 ]; then
      fail "${file}: expected exactly 1 canonical block line, found ${count}"
      continue
    fi

    # Stable anchor: cites the ADR.
    if ! rg -q -F "${ADR_REF}" "${file}"; then
      fail "${file}: canonical block does not cite ${ADR_REF}"
    fi

    # Identity: every copy byte-identical to the first (reference) copy.
    if [ -z "${reference}" ]; then
      reference="${matches}"
    elif [ "${matches}" != "${reference}" ]; then
      fail "${file}: canonical block drifted from reference copy"
    fi
  done
done

if [ "${failures}" -gt 0 ]; then
  echo "initiative-naming-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "initiative-naming-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#PLACEMENT_FILES[@]} placement(s))"
