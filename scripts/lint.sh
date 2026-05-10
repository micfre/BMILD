#!/bin/bash

# Format and lint markdown, then lint shell scripts.
# Runs as a pre-commit hook or standalone.
#
# Usage:
#   scripts/lint.sh          # check only (exit 1 on issues)
#   scripts/lint.sh --fix    # auto-fix, then check

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MD_GLOBS=("*.md" ".agents/**/*.md" "docs/**/*.md")
FIX=false

if [[ "${1:-}" == "--fix" ]]; then
    FIX=true
fi

fail() {
    echo "$1" >&2
    exit 1
}

if ! command -v npx &>/dev/null; then
    fail "npx not found. Install Node.js."
fi

if ! command -v shellcheck &>/dev/null; then
    fail "shellcheck not found. Install: sudo apt install shellcheck"
fi

# --- Markdown ---

if $FIX; then
    echo "Formatting markdown with Prettier..."
    npx --yes prettier --write "${MD_GLOBS[@]/#/$ROOT/}" 2>/dev/null
    echo "Fixing markdown with markdownlint..."
    npx --yes markdownlint-cli2 --fix "${MD_GLOBS[@]/#/$ROOT/}"
fi

echo "Checking markdown..."
npx --yes markdownlint-cli2 "${MD_GLOBS[@]/#/$ROOT/}"

# --- Shell scripts ---

mapfile -t SH_FILES < <(find "$ROOT" -name "*.sh" -not -path "$ROOT/external_references/*")

if ((${#SH_FILES[@]} > 0)); then
    echo "Checking shell scripts..."
    shellcheck "${SH_FILES[@]}"
fi

echo "All checks passed."
