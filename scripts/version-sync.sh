#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION_FILE="$PROJECT_ROOT/VERSION"
SKILLS_DIR="$PROJECT_ROOT/.agents/skills"

if [[ ! -f "$VERSION_FILE" ]]; then
    echo "Error: VERSION file not found at $VERSION_FILE" >&2
    exit 1
fi

if [[ ! -d "$SKILLS_DIR" ]]; then
    echo "Error: skills directory not found at $SKILLS_DIR" >&2
    exit 1
fi

VERSION="${1:-$(cat "$VERSION_FILE")}"

updated_count=0

update_skill_version() {
    local skill_file="$1"
    local skill_dir
    local tmp_file

    skill_dir="$(dirname "$skill_file")"
    tmp_file="$(mktemp "$skill_dir/.SKILL.md.tmp.XXXXXX")"

    if ! awk -v version="$VERSION" '
        BEGIN {
            in_frontmatter = 0
            frontmatter_delimiters = 0
            updated = 0
        }
        /^---$/ {
            frontmatter_delimiters++
            if (frontmatter_delimiters == 1) {
                in_frontmatter = 1
            } else if (frontmatter_delimiters == 2) {
                in_frontmatter = 0
            }
            print
            next
        }
        in_frontmatter && updated == 0 && /^[[:space:]]*version:[[:space:]]*"/ {
            sub(/version:[[:space:]]*"[^"]*"/, "version: \"" version "\"")
            updated = 1
        }
        { print }
        END {
            if (frontmatter_delimiters < 2) {
                exit 2
            }
            if (!updated) {
                exit 3
            }
        }
    ' "$skill_file" > "$tmp_file"; then
        rm -f "$tmp_file"
        echo "Error: failed to update version frontmatter in $skill_file" >&2
        exit 1
    fi

    mv "$tmp_file" "$skill_file"
    updated_count=$((updated_count + 1))
    echo "Updated $skill_file"
}

while IFS= read -r skill_file; do
    update_skill_version "$skill_file"
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md | sort)

if [[ "$updated_count" -eq 0 ]]; then
    echo "Error: no SKILL.md files found under $SKILLS_DIR" >&2
    exit 1
fi

echo "Synced $updated_count skill files to version $VERSION"
