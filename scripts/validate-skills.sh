#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
skills_dir="$root/.agents/skills"

fail=0
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

report() {
  printf 'ERROR: %s\n' "$*" >&2
  fail=1
}

find_skill_markdown_files() {
  if [[ -d "$skills_dir" ]]; then
    find "$skills_dir" -type f -name '*.md' -print0
  fi
}

has_frontmatter_key() {
  local key="$1"
  local path="$2"
  awk -v key="$key" '
    NR == 1 && $0 != "---" { exit 1 }
    NR > 1 && $0 == "---" { exit(found ? 0 : 1) }
    NR > 1 && $1 == key ":" { found = 1 }
    END {
      if (NR == 0) exit 1
      if (!found) exit 1
    }
  ' "$path"
}

frontmatter_value() {
  local key="$1"
  local path="$2"
  awk -v key="$key" '
    NR == 1 && $0 != "---" { exit 1 }
    NR > 1 && $0 == "---" { exit }
    NR > 1 && $1 == key ":" {
      line = $0
      sub("^[^:]+:[[:space:]]*", "", line)
      gsub(/^"|"$/, "", line)
      print line
      found = 1
      exit
    }
    END {
      if (NR == 0 || !found) exit 1
    }
  ' "$path"
}

has_step_checklist() {
  local path="$1"
  grep -qE '^- \[ \] Step [0-9]+:' "$path"
}

has_workflow_without_checklist() {
  local path="$1"
  awk '
    BEGIN {
      in_code = 0
      in_section = 0
      has_checklist = 0
      section_needs_checklist = 0
      reported = 0
    }
    /^```/ {
      in_code = !in_code
      next
    }
    in_code { next }
    /^##+[[:space:]]+/ {
      if (in_section && section_needs_checklist && !has_checklist) {
        reported = 1
        print FILENAME " section '"'"'" section_title "'"'"' is missing a step checklist"
        exit 1
      }
      section_title = $0
      lowered = tolower($0)
      in_section = 1
      has_checklist = 0
      section_needs_checklist = (lowered ~ /(^|[^[:alpha:]])(workflow|sequence|orchestration)([^[:alpha:]]|$)/)
      next
    }
    in_section && /^- \[ \] Step [0-9]+:/ {
      has_checklist = 1
    }
    END {
      if (!reported && in_section && section_needs_checklist && !has_checklist) {
        print FILENAME " section '"'"'" section_title "'"'"' is missing a step checklist"
        exit 1
      }
    }
  ' "$path"
}

collect_numbered_headings() {
  local output="$1"
  # shellcheck disable=SC2016
  find_skill_markdown_files | xargs -0 awk '
    BEGIN { in_code = 0 }
    /^```/ { in_code = !in_code; next }
    in_code { next }
    /^###[[:space:]]+[0-9]+\./ {
      printf "%s:%d:%s\n", FILENAME, FNR, $0
    }
  ' >"$output"
}

collect_table_rows() {
  local output="$1"
  # shellcheck disable=SC2016
  find_skill_markdown_files | xargs -0 awk '
    BEGIN { in_code = 0 }
    /^```/ { in_code = !in_code; next }
    in_code { next }
    /^\|.*\|$/ {
      printf "%s:%d:%s\n", FILENAME, FNR, $0
    }
  ' >"$output"
}

skill_count=0
while IFS= read -r -d '' skill_file; do
  skill_count=$((skill_count + 1))

  has_frontmatter_key "name" "$skill_file" || report "$skill_file missing frontmatter key 'name'"
  has_frontmatter_key "description" "$skill_file" || report "$skill_file missing frontmatter key 'description'"

  description_value="$(frontmatter_value "description" "$skill_file" 2>/dev/null || true)"
  if [[ -z "$description_value" ]]; then
    report "$skill_file has an empty frontmatter description"
  elif [[ ${#description_value} -gt 1024 ]]; then
    report "$skill_file description exceeds 1024 characters"
  fi

  has_step_checklist "$skill_file" || report "$skill_file missing step checklist"
  if workflow_error="$(has_workflow_without_checklist "$skill_file" 2>&1)"; then
    :
  else
    report "$workflow_error"
  fi
done < <(find "$skills_dir" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

if (( skill_count == 0 )); then
  report "no SKILL.md files found under $skills_dir"
fi

while IFS= read -r -d '' md_file; do
  if workflow_error="$(has_workflow_without_checklist "$md_file" 2>&1)"; then
    :
  else
    report "$workflow_error"
  fi
done < <(find_skill_markdown_files)

numbered_headings_report="$tmp_dir/numbered-headings.txt"
collect_numbered_headings "$numbered_headings_report"
if [[ -s "$numbered_headings_report" ]]; then
  cat "$numbered_headings_report" >&2
  report "numbered markdown headings found; prefer checklist-based task flows over numbered headings"
fi

table_rows_report="$tmp_dir/table-rows.txt"
collect_table_rows "$table_rows_report"
if [[ -s "$table_rows_report" ]]; then
  cat "$table_rows_report" >&2
  report "markdown table rows found outside fenced code blocks; prefer more resilient bullet structures"
fi

if (( fail )); then
  exit 1
fi

printf 'Skill validation passed.\n'
