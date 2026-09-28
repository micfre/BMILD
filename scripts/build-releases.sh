#!/bin/bash

# Exit on error
set -euo pipefail

# Resolve project root relative to this script's location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Grab version from VERSION file
VERSION=$(cat "$PROJECT_ROOT/VERSION")

# --- CHANGELOG Reconciliation (local lane only) ---
# The release tag points at the current commit, so CHANGELOG.md must already
# carry a dated release heading for VERSION. If only [Unreleased] exists,
# promote it in place and stop: the promotion has to be committed and pushed
# before tagging. With neither heading there is nothing promotable: fail.
if [[ -z "${CI:-}" ]]; then
    CHANGELOG_FILE="$PROJECT_ROOT/CHANGELOG.md"
    if ! grep -qF "## [${VERSION}] - " "$CHANGELOG_FILE"; then
        if grep -q '^## \[Unreleased\][[:space:]]*$' "$CHANGELOG_FILE"; then
            RELEASE_DATE="$(date +%F)"
            CHANGELOG_TMP="$(mktemp "${TMPDIR:-/tmp}/bmild-changelog.XXXXXX")"
            if ! awk -v version="$VERSION" -v release_date="$RELEASE_DATE" '
                !promoted && /^## \[Unreleased\][[:space:]]*$/ {
                    print
                    print ""
                    print "## [" version "] - " release_date
                    promoted = 1
                    next
                }
                { print }
                END { exit promoted ? 0 : 2 }
            ' "$CHANGELOG_FILE" > "$CHANGELOG_TMP"; then
                rm -f "$CHANGELOG_TMP"
                echo "Error: failed to promote the Unreleased section in $CHANGELOG_FILE." >&2
                exit 1
            fi
            mv "$CHANGELOG_TMP" "$CHANGELOG_FILE"
            echo "Promoted CHANGELOG 'Unreleased' to '## [${VERSION}] - ${RELEASE_DATE}'."
            echo "COMMIT and PUSH CHANGELOG.md, then re-run this script so the release tag includes it."
            exit 1
        else
            echo "Error: CHANGELOG.md has no dated [${VERSION}] release and no [Unreleased] section to promote." >&2
            exit 1
        fi
    fi
fi

# Define output directory
DIST_DIR="$PROJECT_ROOT/dist"
STAGING_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$STAGING_DIR"
}

trap cleanup EXIT

# Create dist directory if it doesn't exist
mkdir -p "$DIST_DIR"

# --- Pre-release Warning and Pause ---
# Skip interactive prompt if running in CI (e.g. GitHub Actions)
if [[ -z "${CI:-}" ]]; then
    echo "****************************************************************"
    echo "WARNING: This script will TAG the current commit as v${VERSION}"
    echo "and PUSH it to origin, thereby triggering a GitHub Release."
    echo ""
    echo "CRITICAL: Ensure you have COMMITTED and PUSHED all your changes"
    echo "to the current branch BEFORE continuing. Run scripts/version-sync.sh"
    echo "separately if the skill metadata still needs to be synced. A missing"
    echo "CHANGELOG release is promoted automatically before this point;"
    echo "commit and push that promotion, then re-run."
    echo "****************************************************************"
    read -r -p "Press Enter to continue or Ctrl+C to abort..." _
fi

# --- Release Notes Extraction ---
if [[ -z "${CI:-}" ]]; then
    # Locally, we just note we're building. 
    # The CI will handle the actual extraction for the GitHub Release.
    echo "Preparing version ${VERSION}..."
else
    # In CI, extract the exact version section until the next release heading.
    echo "Extracting release notes from CHANGELOG.md..."
    awk -v header="## [${VERSION}]" '
      index($0, header) == 1 { capture = 1 }
      capture && $0 ~ /^## \[/ && index($0, header) != 1 { exit }
      capture { print }
    ' "$PROJECT_ROOT/CHANGELOG.md" > "$DIST_DIR/release-notes.md"
    
    if [ ! -s "$DIST_DIR/release-notes.md" ]; then
        echo "Warning: Could not extract release notes for version ${VERSION}. Using generic message."
        echo "Release v${VERSION}" > "$DIST_DIR/release-notes.md"
    fi
fi

echo "Packaging release v${VERSION}..."

# Every archive is rooted at the destination project. Skills and consult
# definitions land in the paths discovered by that harness after one extract.
for harness in codex claude-code opencode; do
    package_root="$STAGING_DIR/$harness"
    case "$harness" in
        codex) skill_root=.agents/skills; agent_root=.codex ;;
        claude-code) skill_root=.claude/skills; agent_root=.claude ;;
        opencode) skill_root=.opencode/skills; agent_root=.opencode ;;
    esac
    mkdir -p "$package_root/$skill_root"
    cp -R "$PROJECT_ROOT/.agents/skills"/bmild-* "$package_root/$skill_root/"
    bash "$PROJECT_ROOT/scripts/generate-consult-agents.sh" \
        --skills-dir "$PROJECT_ROOT/.agents/skills" \
        --out "$package_root" \
        --harness "$harness"
    filename="release-v${VERSION}-${harness}.tar.gz"
    if [[ "${skill_root%%/*}" == "$agent_root" ]]; then
        tar -czf "$DIST_DIR/$filename" -C "$package_root" "$agent_root"
    else
        tar -czf "$DIST_DIR/$filename" -C "$package_root" "${skill_root%%/*}" "$agent_root"
    fi
    echo "Successfully created $DIST_DIR/$filename"
done

# --- Git Integration ---
# Skip git tagging/pushing if already in CI (avoids recursion)
if [[ -z "${CI:-}" ]]; then
    TAG="v${VERSION}"
    echo "Proceeding with Git tagging: ${TAG}..."
    
    # Check if tag already exists
    if git rev-parse "$TAG" >/dev/null 2>&1; then
        echo "Warning: Tag $TAG already exists locally. Moving forward with asset build..."
    else
        git tag "$TAG"
        echo "Tag $TAG created locally."
    fi

    # Push the tag to trigger the GitHub Release workflow
    echo "Pushing tag to origin..."
    git push origin "$TAG"

    echo "Release workflow triggered on GitHub."
fi

echo "Contents of archives:"
for harness in codex claude-code opencode; do
    tar -tf "$DIST_DIR/release-v${VERSION}-${harness}.tar.gz"
done
