#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION_FILE="$PROJECT_ROOT/VERSION"
SKILLS_DIR="$PROJECT_ROOT/.agents/skills"
README_FILE="$PROJECT_ROOT/README.md"

if [[ ! -f "$VERSION_FILE" ]]; then
    echo "Error: VERSION file not found at $VERSION_FILE" >&2
    exit 1
fi

if [[ ! -d "$SKILLS_DIR" ]]; then
    echo "Error: skills directory not found at $SKILLS_DIR" >&2
    exit 1
fi

if [[ ! -f "$README_FILE" ]]; then
    echo "Error: README file not found at $README_FILE" >&2
    exit 1
fi

VERSION="${1:-$(cat "$VERSION_FILE")}"

updated_count=0

update_skill_version() {
    local skill_file="$1"
    local tmp_file

    tmp_file="$(mktemp "${TMPDIR:-/tmp}/bmild-skill-version.XXXXXX")"

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

update_readme_version() {
    local tmp_file

    tmp_file="$(mktemp "${TMPDIR:-/tmp}/bmild-readme-version.XXXXXX")"

    if ! awk -v version="$VERSION" '
        BEGIN {
            updated = 0
            expect_badge = 0
        }
        /^<!-- bmild-version-badge -->$/ {
            print
            expect_badge = 1
            next
        }
        expect_badge == 1 {
            if ($0 !~ /^!\[Version\]/) {
                exit 3
            }

            line = $0
            if (line !~ /[0-9]+\.[0-9]+\.[0-9]+/) {
                exit 4
            }

            sub(/[0-9]+\.[0-9]+\.[0-9]+/, version, line)
            print line
            updated = 1
            expect_badge = 0
            next
        }
        { print }
        END {
            if (!updated) {
                exit 2
            }
            if (expect_badge == 1) {
                exit 5
            }
        }
    ' "$README_FILE" > "$tmp_file"; then
        rm -f "$tmp_file"
        echo "Error: failed to update version line in $README_FILE" >&2
        exit 1
    fi

    mv "$tmp_file" "$README_FILE"
    echo "Updated $README_FILE"
}

while IFS= read -r skill_file; do
    update_skill_version "$skill_file"
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md | sort)

if [[ "$updated_count" -eq 0 ]]; then
    echo "Error: no SKILL.md files found under $SKILLS_DIR" >&2
    exit 1
fi

update_readme_version

echo "Synced $updated_count skill files and README to version $VERSION"
