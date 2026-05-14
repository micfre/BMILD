#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
skills_dir="$root/.agents/skills"

fail=0

section_required=(
  "## BMILD Working Team"
  "## Activation"
  "## Workflow"
  "## Definition of Done"
  "## Gotchas"
)

standard_required=(
  "## Craft Standards"
  "## Scope Boundary"
  "## Exit and Handoff"
)

standard_skills=(
  bmild-arch
  bmild-dev
  bmild-planner
  bmild-pm
  bmild-qa
  bmild-sec
  bmild-ux
)

cross_cutting_skills=(
  bmild-brainstorming
  bmild-debate
  bmild-elicit
)

is_standard_skill() {
  local name="$1"
  local item
  for item in "${standard_skills[@]}"; do
    [[ "$item" == "$name" ]] && return 0
  done
  return 1
}

is_cross_cutting_skill() {
  local name="$1"
  local item
  for item in "${cross_cutting_skills[@]}"; do
    [[ "$item" == "$name" ]] && return 0
  done
  return 1
}

report() {
  printf 'ERROR: %s\n' "$*" >&2
  fail=1
}

while IFS= read -r -d '' skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"

  frontmatter_name="$(awk '
    NR == 1 && $0 != "---" { exit 1 }
    NR > 1 && $0 == "---" { exit 0 }
    NR > 1 && $1 == "name:" { print $2 }
  ' "$skill_file")"

  [[ "$frontmatter_name" == "$skill_name" ]] || report "$skill_file frontmatter name '$frontmatter_name' does not match directory '$skill_name'"

  description_length="$(awk '
    NR == 1 && $0 != "---" { exit 1 }
    NR > 1 && $0 == "---" { exit 0 }
    NR > 1 && $1 == "description:" {
      line = $0
      sub(/^description:[[:space:]]*/, "", line)
      gsub(/^"|"$/, "", line)
      print length(line)
    }
  ' "$skill_file")"

  [[ -n "$description_length" ]] || report "$skill_file missing description"
  [[ -z "$description_length" || "$description_length" -le 1024 ]] || report "$skill_file description exceeds 1024 characters"

  for section in "${section_required[@]}"; do
    grep -q "^${section}$" "$skill_file" || report "$skill_file missing required section '$section'"
  done

  awk '
    /^## Workflow$/ { in_workflow = 1; has_checklist = 0; next }
    in_workflow && /^## / {
      if (!has_checklist) {
        print FILENAME " Workflow section missing step checklist"
        exit 1
      }
      in_workflow = 0
    }
    in_workflow && /^- \[ \] Step [0-9]+:/ { has_checklist = 1 }
    END {
      if (in_workflow && !has_checklist) {
        print FILENAME " Workflow section missing step checklist"
        exit 1
      }
    }
  ' "$skill_file" || report "$skill_file missing step checklist in Workflow"

  if is_standard_skill "$skill_name"; then
    for section in "${standard_required[@]}"; do
      grep -q "^${section}$" "$skill_file" || report "$skill_file missing standard section '$section'"
    done
  fi

  if is_cross_cutting_skill "$skill_name"; then
    grep -q '^## Capabilities$' "$skill_file" || report "$skill_file missing cross-cutting section '## Capabilities'"
  fi
done < <(find "$skills_dir" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

if grep -R --include='*.md' -nE '^### [0-9]+\.' "$skills_dir" >/tmp/bmild-numbered-headings.txt; then
  cat /tmp/bmild-numbered-headings.txt >&2
  report "numbered markdown headings found; use '### Step N:' plus a Progress checklist for task flows"
fi

while IFS= read -r -d '' step_file; do
  if grep -qE '^## .*(SEQUENCE|WORKFLOW|ORCHESTRATION|APPLICATION|IDENTIFICATION)' "$step_file" && ! grep -qE '^- \[ \] Step [0-9]+:' "$step_file"; then
    report "$step_file has a sequence-like section without a step checklist"
  fi
done < <(find "$skills_dir" -path '*/steps/*.md' -print0)

table_targets=(
  "$skills_dir"
  "$root/AGENTS.md"
  "$root/CHANGELOG.md"
  "$root/docs/bmild-skill-best-practices-evaluation.md"
  "$root/docs/agent-skills-docs-inventory.md"
)

if grep -R --include='*.md' -nE '^\|.*\|$' "${table_targets[@]}" >/tmp/bmild-table-rows.txt; then
  cat /tmp/bmild-table-rows.txt >&2
  report "markdown table rows found in checked skill/docs surface"
fi

required_template_checks=(
  "$skills_dir/bmild-planner/assets/slices-template.md:approved_scope:"
  "$skills_dir/bmild-planner/assets/slice-template.md:qa_status:"
  "$skills_dir/bmild-planner/assets/slice-template.md:security_status:"
  "$skills_dir/bmild-planner/assets/slice-template.md:## Likely Required Reads Check"
  "$skills_dir/bmild-qa/assets/rca-template.md:next_owner:"
  "$skills_dir/bmild-sec/assets/security-review-template.md:next_owner:"
  "$skills_dir/bmild-qa/assets/rca-template.md:## Closure Evidence"
  "$skills_dir/bmild-sec/assets/security-review-template.md:## Closure Evidence"
)

for entry in "${required_template_checks[@]}"; do
  path="${entry%%:*}"
  pattern="${entry#*:}"
  if [[ ! -f "$path" ]]; then
    report "required template missing: $path"
    continue
  fi
  grep -q "$pattern" "$path" || report "$path missing required marker '$pattern'"
done

canonical_docs=(
  "$root/plans/CHARTER.md:plans/CHARTER.md"
  "$root/plans/ARCHITECTURE.md:plans/ARCHITECTURE.md"
  "$root/DESIGN.md:DESIGN.md"
)

for entry in "${canonical_docs[@]}"; do
  path="${entry%%:*}"
  label="${entry##*:}"
  if [[ -f "$path" ]]; then
    grep -q '^## Distillation Log$' "$path" || report "$label exists but is missing required '## Distillation Log' section"
  fi
done

if (( fail )); then
  exit 1
fi

printf 'Skill validation passed.\n'
