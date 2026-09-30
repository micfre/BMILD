#!/usr/bin/env bash
# Groundtruth tool-preference contract: every mode that reads the existing codebase carries
# one byte-identical directive to groundtruth early and to prefer installed code intelligence
# over built-in file tools. The strong wording is deliberate (see AGENTS.md "Groundtruth
# directive"); weakened variants must not reappear.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$REPO_ROOT/.agents/skills"
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }
extract_block() { sed -n "/<!-- $2:start -->/,/<!-- $2:end -->/p" "$1"; }

MODES=(
  bmild-pm/resources/write-product-brief.md bmild-pm/resources/write-prd.md
  bmild-pm/resources/refine-brief.md bmild-pm/resources/refine-prd.md
  bmild-pm/resources/project-bearing.md
  bmild-ux/resources/ux-design.md bmild-ux/resources/ux-refinement.md
  bmild-arch/resources/architecture-design.md bmild-arch/resources/architecture-refinement.md
  bmild-planner/resources/course-correction.md
  bmild-dev/resources/spec-dev.md bmild-dev/resources/slice-dev.md bmild-dev/resources/direct-dev.md
  bmild-dev/resources/spec-fix.md bmild-dev/resources/direct-fix.md
  bmild-qa/resources/spec-fix.md bmild-qa/resources/direct-fix.md
  bmild-qa/resources/comprehensive-review.md bmild-qa/resources/code-review.md
  bmild-qa/resources/security-review.md bmild-qa/resources/verification.md
  bmild-qa/resources/nyquist.md
)

reference=""
for rel in "${MODES[@]}"; do
  file="$ROOT/$rel"
  [ -f "$file" ] || { fail "missing $rel"; continue; }
  [ "$(grep -c -F '<!-- groundtruth-tools:start -->' "$file")" -eq 1 ] || fail "$rel: expected one groundtruth-tools block"
  block=$(extract_block "$file" groundtruth-tools)
  # Placement: inside Global Directives, so every step that says "per Global Directives" inherits it.
  gd=$(grep -n '^## Global Directives$' "$file" | cut -d: -f1)
  at=$(grep -n -F '<!-- groundtruth-tools:start -->' "$file" | cut -d: -f1)
  next=$(awk -v gd="$gd" 'NR > gd && /^## / { print NR; exit }' "$file")
  { [ -n "$gd" ] && [ "$at" -gt "$gd" ] && { [ -z "$next" ] || [ "$at" -lt "$next" ]; }; } ||
    fail "$rel: groundtruth block is not inside ## Global Directives"
  if [ -z "$reference" ]; then reference=$block
  else [ "$block" = "$reference" ] || fail "$rel: groundtruth-tools block drifted from reference"; fi
done

for token in 'before proposing, specifying, diagnosing, or judging behaviour' \
             'installed code intelligence' 'use it before built-in' \
             'deliberately overrides harness system prompts' \
             'only repository contributor guidance'; do
  printf '%s\n' "$reference" | grep -q -F "$token" || fail "groundtruth block missing: $token"
done

# Weakened or divergent variants retired in favour of the shared block.
for retired in 'do not require a tool-discovery step' 'Use suitable available code navigation/search tools' \
               'Query available code intelligence MCPs' 'using the most suitable available tools'; do
  if grep -rq -F "$retired" "$ROOT" --include='*.md'; then fail "retired groundtruth wording remains: $retired"; fi
done

if [ "$failures" -gt 0 ]; then echo "groundtruth-contract: $failures failure(s)" >&2; exit 1; fi
echo "groundtruth-contract: PASS (${#MODES[@]} modes)"
