#!/usr/bin/env bash
# Session-wrapper identity + semantic-contract guard for standard personas.
#
# Asserts:
#   1. Seven byte-identical <!-- session-opening-contract --> blocks
#   2. Seven byte-identical <!-- session-closing-contract --> blocks
#   3. Opening contract derives stance from loaded SOUL (no hardcoded persona traits)
#   4. Closing contract requires plain Markdown + literal For you:/Next: labels
#   5. Legacy rigid "I'll work on…" opening templates are gone
#   6. Opening/closing markers appear once per SKILL.md
#
# Mechanism: bash + rg. Layout-portable across .agents/skills and .claude/skills.
set -euo pipefail

PERSONAS=(
  bmild-pm
  bmild-ux
  bmild-arch
  bmild-planner
  bmild-dev
  bmild-qa
  bmild-sec
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

extract_block() {
  local file=$1 marker=$2
  sed -n "/<!-- ${marker}:start -->/,/<!-- ${marker}:end -->/p" "$file"
}

REQUIRED_OPENING_TOKENS=(
  'already-loaded sibling'
  'SOUL.md'
  'session throughline'
  "I'll work on…"
  'Identity rail'
  'code fence, blockquote, italics, or table'
)

REQUIRED_CLOSING_TOKENS=(
  'For you:'
  'Next:'
  'Ordinary Markdown paragraphs only'
  'session throughline established at open'
  'copyable message-only commit payload'
)

LEGACY_OPENING_PHRASES=(
  "I'll work on product framing"
  "I'll work on UX decisions"
  "I'll work on system design"
  "I'll work on readiness and planning"
  "I'll work on implementation"
  "I'll work on diagnosis and tests"
  "I'll work the security angle"
)

for root in "${SKILL_ROOTS[@]}"; do
  echo "== session-wrapper contract: ${root} =="

  reference_opening=""
  reference_closing=""

  for persona in "${PERSONAS[@]}"; do
    file="${root}/${persona}/SKILL.md"
    if [ ! -f "${file}" ]; then
      fail "missing ${file}"
      continue
    fi

    for marker in session-opening-contract session-closing-contract; do
      count=$(rg -c -F "<!-- ${marker}:start -->" "${file}" || true)
      [ "${count}" -eq 1 ] || fail "${file}: expected one ${marker} block, found ${count}"
    done

    opening=$(extract_block "${file}" session-opening-contract)
    closing=$(extract_block "${file}" session-closing-contract)
    [ -n "${opening}" ] || fail "${file}: empty opening contract"
    [ -n "${closing}" ] || fail "${file}: empty closing contract"

    if [ -z "${reference_opening}" ]; then
      reference_opening=${opening}
      reference_closing=${closing}
    else
      [ "${opening}" = "${reference_opening}" ] || fail "${file}: opening contract drift"
      [ "${closing}" = "${reference_closing}" ] || fail "${file}: closing contract drift"
    fi

    # Opening must not hardcode persona-specific SOUL vocabulary/catchphrases.
    if printf '%s\n' "${opening}" | rg -q 'Faisal|Katrina|Lance|Sonia|Alex|Rahat|Zach'; then
      fail "${file}: opening contract hardcodes a persona name (should use placeholders)"
    fi

    for bad in "${LEGACY_OPENING_PHRASES[@]}"; do
      if rg -q -F "${bad}" "${file}"; then
        fail "${file}: legacy opening phrase still present: ${bad}"
      fi
    done

    # Closing specimen blockquotes removed (contract forbids wrapping close in blockquote).
    # Persona-specific rules may remain after the marked closing block.
    if ! rg -q -F 'Persona-specific rules:' "${file}"; then
      fail "${file}: missing persona-specific closing rules section"
    fi
  done

  # Token presence on the shared reference blocks
  for token in "${REQUIRED_OPENING_TOKENS[@]}"; do
    printf '%s\n' "${reference_opening}" | rg -q -F "${token}" || fail "opening contract missing token: ${token}"
  done
  for token in "${REQUIRED_CLOSING_TOKENS[@]}"; do
    printf '%s\n' "${reference_closing}" | rg -q -F "${token}" || fail "closing contract missing token: ${token}"
  done

  # SOUL remains the sole personality source — no lens enumeration list in core.
  if printf '%s\n' "${reference_opening}" | rg -qi 'stance lens|Faisal:|Katrina:|vocabulary:'; then
    fail "opening contract appears to enumerate persona lenses"
  fi
done

if [ "${failures}" -gt 0 ]; then
  echo "session-wrapper-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "session-wrapper-contract: PASS (${#SKILL_ROOTS[@]} root(s), ${#PERSONAS[@]} personas)"
