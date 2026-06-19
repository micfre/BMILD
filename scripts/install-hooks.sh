#!/bin/bash

# Enable the shared, version-controlled git hooks for this repo.
# Run once after cloning: scripts/install-hooks.sh
#
# This points core.hooksPath at the repo-tracked hooks/ directory so every
# contributor gets the same pre-commit gate without copying files into .git/.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

git -C "$ROOT" config core.hooksPath hooks
chmod +x "$ROOT/hooks/pre-commit"

echo "Git hooks installed (core.hooksPath = hooks)."
echo "Pre-commit now runs: scripts/lint.sh"
