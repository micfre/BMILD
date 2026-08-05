#!/usr/bin/env bash
# Pre-exit offer contract test.
#
# Guards the design-tier closing offer:
#   - every authoring/refinement pre-exit step carries the same-turn
#     continuation rule (a decline or proceed signal continues to Write/update
#     in the same turn — no second stop before authoring);
#   - each resource carries an embedded bmild-elicit method shortlist whose
#     names all exist in bmild-elicit/resources/methods.yaml (methods are never
#     invented from memory; the elicit skill itself is only loaded on
#     acceptance — lazy loading preserved).
#
# Mechanism: bash + rg. Layout-portable: scans known skill roots
# (.agents/skills, .claude/skills) relative to the repo root, never hardcoding one.
set -euo pipefail

# Resources that carry the pre-exit offer at their authoring/refinement close.
PLACEMENT_FILES=(
  "bmild-pm/resources/write-product-brief.md"
  "bmild-pm/resources/write-prd.md"
  "bmild-pm/resources/refine-brief.md"
  "bmild-pm/resources/refine-prd.md"
  "bmild-ux/resources/ux-design.md"
  "bmild-ux/resources/ux-refinement.md"
  "bmild-arch/resources/architecture-design.md"
  "bmild-arch/resources/architecture-refinement.md"
)

CONTINUATION="in the same turn — no further confirmation"

# Resolve repo root from this script's location (<root>/tests/pre-exit-offer-contract.sh).
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
  echo "== pre-exit-offer contract: ${root} =="

  methods_yaml="${root}/bmild-elicit/resources/methods.yaml"
  if [ ! -f "${methods_yaml}" ]; then
    fail "missing ${methods_yaml}"
    continue
  fi

  for rel in "${PLACEMENT_FILES[@]}"; do
    file="${root}/${rel}"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi

    # 1. Same-turn continuation rule: exactly one occurrence per resource.
    count=$(rg -c -F "${CONTINUATION}" "${file}" || true)
    if [ "${count}" != "1" ]; then
      fail "${file}: expected exactly 1 same-turn continuation rule, found ${count:-0}"
    fi

    # 2. Shortlist present and every cited method name exists in methods.yaml.
    shortlist=$(sed -n 's/.*shortlist (\([^)]*\)).*/\1/p' "${file}")
    if [ -z "${shortlist}" ]; then
      fail "${file}: no embedded method shortlist found"
      continue
    fi
    names=$(printf '%s' "${shortlist}" | grep -o '\*\*[^*]*\*\*' | sed 's/\*\*//g')
    name_count=$(printf '%s\n' "${names}" | grep -c . || true)
    if [ "${name_count}" -lt 2 ]; then
      fail "${file}: shortlist must cite at least 2 methods, found ${name_count}"
      continue
    fi
    while IFS= read -r name; do
      [ -n "${name}" ] || continue
      if ! rg -q -x -F "  method_name: ${name}" "${methods_yaml}"; then
        fail "${file}: method '${name}' not found in bmild-elicit methods.yaml"
      fi
    done <<< "${names}"
  done
done

if [ "${failures}" -gt 0 ]; then
  echo "pre-exit-offer-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "pre-exit-offer-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#PLACEMENT_FILES[@]} placement(s))"
