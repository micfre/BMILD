#!/bin/bash

# Refresh third-party reference snapshots in external_references/.
#
# Each folder under external_references/ is a plain snapshot (no .git) of an
# upstream repository. This script fetches the latest default branch of every
# configured repository and swaps it in place of the existing snapshot.
#
# Usage:
#   scripts/update-external-references.sh                # update all snapshots
#   scripts/update-external-references.sh bmad-method    # update named snapshots
#   scripts/update-external-references.sh bmad-method mattpocock
#
# Requires git and network access to github.com.
# Replacement is destructive: anything inside the target folder — including
# local edits, which AGENTS.md forbids anyway — is discarded. The previous
# snapshot is kept until the new one is fully in place, and restored if the
# swap fails.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
EXTERNAL_DIR="$PROJECT_ROOT/external_references"

# Snapshot folder name -> upstream repository (fetched at its default branch).
declare -A REPOS=(
    [bmad-method]="https://github.com/bmad-code-org/bmad-method.git"
    [mattpocock]="https://github.com/mattpocock/skills.git"
)
# Fixed update order when no targets are named.
ORDERED_NAMES=(bmad-method mattpocock)

usage() {
    echo "Usage: $(basename "$0") [${ORDERED_NAMES[*]} ...]" >&2
    echo "Refreshes external_references/<name> from upstream. No arguments refreshes all." >&2
}

fail() {
    echo "Error: $1" >&2
    exit 1
}

command -v git &>/dev/null || fail "git not found. Install git first."
[[ -d "$EXTERNAL_DIR" ]] || fail "missing directory: $EXTERNAL_DIR"

if (($# > 0)); then
    TARGETS=("$@")
    for name in "${TARGETS[@]}"; do
        [[ -n "${REPOS[$name]:-}" ]] || { usage; fail "unknown reference: '$name'"; }
    done
else
    TARGETS=("${ORDERED_NAMES[@]}")
fi

# Stage inside external_references/ (gitignored) so swaps stay on one
# filesystem and are cheap renames. The trap removes the staging directory
# even when the script aborts.
STAGING_DIR="$(mktemp -d "$EXTERNAL_DIR/.update-staging.XXXXXX")"
cleanup() {
    rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

sync_ref() {
    local name="$1"
    local repo_url="${REPOS[$name]}"
    local target_dir="$EXTERNAL_DIR/$name"
    local clone_dir="$STAGING_DIR/$name"
    local branch commit file_count

    echo "Fetching $name from $repo_url ..."
    if ! git clone --quiet --depth 1 "$repo_url" "$clone_dir"; then
        return 1
    fi
    branch="$(git -C "$clone_dir" rev-parse --abbrev-ref HEAD)"
    commit="$(git -C "$clone_dir" rev-parse --short HEAD)"
    rm -rf "$clone_dir/.git"

    # Swap the snapshot in; keep the old one until the new one is in place.
    if [[ -d "$target_dir" ]]; then
        mv "$target_dir" "$STAGING_DIR/$name.old"
        if ! mv "$clone_dir" "$target_dir"; then
            mv "$STAGING_DIR/$name.old" "$target_dir"
            return 1
        fi
        rm -rf "$STAGING_DIR/$name.old"
    else
        mv "$clone_dir" "$target_dir"
    fi

    file_count="$(find "$target_dir" -type f | wc -l)"
    echo "Updated external_references/$name -> $branch @ $commit ($((file_count)) files)"
}

FAILED=0
for name in "${TARGETS[@]}"; do
    if ! sync_ref "$name"; then
        echo "Error: failed to update '$name'; previous snapshot (if any) left untouched" >&2
        FAILED=1
    fi
done

((FAILED == 0)) || fail "one or more references failed to update"
echo "Done."
