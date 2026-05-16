#!/usr/bin/env bash
set -euo pipefail

SOURCE_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="${SOURCE_PATH%/*}"
if [[ "${SCRIPT_DIR}" == "${SOURCE_PATH}" ]]; then
  SCRIPT_DIR="."
fi
SCRIPT_DIR="$(cd "${SCRIPT_DIR}" && pwd)"
PYTHON_SCRIPT="${SCRIPT_DIR}/budget-slice.py"

if command -v uv >/dev/null 2>&1; then
  exec uv run "${PYTHON_SCRIPT}" "$@"
fi

if command -v python3 >/dev/null 2>&1; then
  exec python3 "${PYTHON_SCRIPT}" "$@"
fi

if command -v python >/dev/null 2>&1; then
  exec python "${PYTHON_SCRIPT}" "$@"
fi

if command -v py >/dev/null 2>&1; then
  exec py -3 "${PYTHON_SCRIPT}" "$@"
fi

echo "Error: no supported Python runner found. Install uv or Python 3.8+ and retry." >&2
exit 1
