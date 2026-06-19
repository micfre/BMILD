#!/bin/bash

# Lint shell scripts.
# Runs as a pre-commit hook or standalone.
#
# Markdown formatting is intentionally NOT done here. It is handled at edit
# time by the Opencode formatter (markdownlint-cli2 --fix, see opencode.json)
# and verified at CI (.github/workflows/ci.yml). A commit-time markdown gate
# was found to cause friction on prose edits, so markdown moved out of the
# commit path; this hook stays a fast, shell-only check.
#
# Usage:
#   scripts/lint.sh          # check shell scripts (exit 1 on issues)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

fail() {
    echo "$1" >&2
    exit 1
}

if ! command -v shellcheck &>/dev/null; then
    fail "shellcheck not found. Install: sudo apt install shellcheck"
fi

# --- Shell scripts ---

mapfile -t SH_FILES < <(find "$ROOT" -name "*.sh" -not -path "$ROOT/external_references/*")

if ((${#SH_FILES[@]} > 0)); then
    echo "Checking shell scripts..."
    shellcheck "${SH_FILES[@]}"
fi

echo "All checks passed."
