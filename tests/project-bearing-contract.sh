#!/usr/bin/env bash
# Project Bearing contract: keeps project-level direction lightweight, grounded,
# and continuous with existing PM and Course-Correction flows.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_ROOT="${REPO_ROOT}/.agents/skills"
PM_SKILL="${SKILL_ROOT}/bmild-pm/SKILL.md"
BEARING_RESOURCE="${SKILL_ROOT}/bmild-pm/resources/project-bearing.md"
PLANNER_SKILL="${SKILL_ROOT}/bmild-planner/SKILL.md"
COURSE_CORRECTION="${SKILL_ROOT}/bmild-planner/resources/course-correction.md"
ROLLUP_TEMPLATE="${SKILL_ROOT}/bmild-planner/assets/rollup-template.md"

failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }
require_literal() {
  local file="$1"
  local literal="$2"
  rg -q -F "$literal" "$file" || fail "$file: missing [$literal]"
}

for file in "$PM_SKILL" "$BEARING_RESOURCE" "$PLANNER_SKILL" "$COURSE_CORRECTION" "$ROLLUP_TEMPLATE"; do
  [ -f "$file" ] || fail "missing $file"
done

require_literal "$PM_SKILL" "Mode 2: Project Bearing"
require_literal "$PM_SKILL" "resources/project-bearing.md"
require_literal "$PM_SKILL" "what is the next logical lift?"
require_literal "$PM_SKILL" "Project bearing disambiguation:"
require_literal "$PM_SKILL" "When a user accepts a Project Bearing continuation into another Faisal mode"

require_literal "$BEARING_RESOURCE" "what bearing should we take next?"
require_literal "$BEARING_RESOURCE" "Think in lifts, not task inventories."
require_literal "$BEARING_RESOURCE" "2–4 genuinely distinct candidate bearings"
require_literal "$BEARING_RESOURCE" "Specific evidence that would overturn the choice"
require_literal "$BEARING_RESOURCE" "User authority is explicit."
require_literal "$BEARING_RESOURCE" "## Current Bearing"
require_literal "$BEARING_RESOURCE" "one declinable offer"
require_literal "$BEARING_RESOURCE" "Do not create the folder or normalize a slug here"
require_literal "$BEARING_RESOURCE" "resources/write-product-brief.md"
require_literal "$BEARING_RESOURCE" "offer Sonia Course-Correction"
require_literal "$BEARING_RESOURCE" "do not manufacture an edit"

if rg -q -F "Initiative names are lowercase-kebab-case identifiers" "$BEARING_RESOURCE"; then
  fail "Project Bearing duplicates the initiative-naming block instead of reusing Write-Product-Brief"
fi

require_literal "$PLANNER_SKILL" "a user-accepted Project Bearing continuation identifies a ≥2-owner source-artifact impact"
require_literal "$COURSE_CORRECTION" "user-accepted Project Bearing continuation"
require_literal "$COURSE_CORRECTION" "user authorization to enter Course-Correction"

require_literal "$ROLLUP_TEMPLATE" "bearing_owner: Faisal (PM)"
require_literal "$ROLLUP_TEMPLATE" "## Current Bearing"
for field in "Direction:" "Why now:" "Set:" "Reconsider when:"; do
  require_literal "$ROLLUP_TEMPLATE" "$field"
done

if [ "$failures" -gt 0 ]; then
  echo "project-bearing-contract: ${failures} failure(s)" >&2
  exit 1
fi

echo "project-bearing-contract: PASS"
