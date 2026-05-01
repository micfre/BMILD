#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
skills_dir="$root/.agents/skills"

fail=0

section_required=(
  "## BMILD Working Team"
  "## Activation"
  "## Workflow"
  "## Capabilities"
  "## Definition of Done"
  "## Gotchas"
)

required_artifact_patterns=(
  "approved_scope:"
  "qa_status:"
  "security_status:"
  "## Likely Required Reads Check"
  "next_owner:"
  "## Closure Evidence"
)

standard_required=(
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

is_standard_skill() {
  local name="$1"
  local item
  for item in "${standard_skills[@]}"; do
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
    /^## Workflow$/ { in_workflow = 1; has_progress = 0; next }
    in_workflow && /^## / {
      if (!has_progress) {
        print FILENAME " Workflow section missing Progress checklist"
        exit 1
      }
      in_workflow = 0
    }
    in_workflow && /^Progress:$/ { has_progress = 1 }
    END {
      if (in_workflow && !has_progress) {
        print FILENAME " Workflow section missing Progress checklist"
        exit 1
      }
    }
  ' "$skill_file" || report "$skill_file missing Progress checklist in Workflow"

  if is_standard_skill "$skill_name"; then
    for section in "${standard_required[@]}"; do
      grep -q "^${section}$" "$skill_file" || report "$skill_file missing standard section '$section'"
    done
  fi
done < <(find "$skills_dir" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

if grep -R --include='*.md' -nE '^### [0-9]+\.' "$skills_dir" >/tmp/bmild-numbered-headings.txt; then
  cat /tmp/bmild-numbered-headings.txt >&2
  report "numbered markdown headings found; use '### Step N:' plus a Progress checklist for task flows"
fi

while IFS= read -r -d '' step_file; do
  if grep -qE '^## .*(SEQUENCE|WORKFLOW|ORCHESTRATION|APPLICATION|IDENTIFICATION)' "$step_file" && ! grep -q '^Progress:$' "$step_file"; then
    report "$step_file has a sequence-like section without a Progress checklist"
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

artifact_templates=(
  "$skills_dir/bmild-planner/assets/artifact-template.md"
  "$skills_dir/bmild-qa/assets/artifact-template.md"
  "$skills_dir/bmild-sec/assets/artifact-template.md"
)

for pattern in "${required_artifact_patterns[@]}"; do
  if ! grep -q "$pattern" "${artifact_templates[@]}"; then
    report "artifact templates missing cross-flow marker '$pattern'"
  fi
done

if (( fail )); then
  exit 1
fi

printf 'Skill validation passed.\n'
