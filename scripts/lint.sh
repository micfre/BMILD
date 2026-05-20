#!/bin/bash

# Lint shell scripts.
# Runs as a pre-commit hook or standalone.
#
# Usage:
#   scripts/lint.sh          # check only (exit 1 on issues)

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
