#!/bin/bash

# Exit on error
set -e

# Resolve project root relative to this script's location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Grab version from VERSION file
# Crrently 0.2.1
VERSION=$(cat "$PROJECT_ROOT/VERSION")

# Define output directory and filename
DIST_DIR="$PROJECT_ROOT/dist"
FILENAME="release-v${VERSION}-linux-macos-dor_agents.tar.gz"
STAGING_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$STAGING_DIR"
}

trap cleanup EXIT

sync_skill_versions() {
    local skill_file

    while IFS= read -r skill_file; do
        awk -v version="$VERSION" '
            BEGIN {
                in_frontmatter = 0
                frontmatter_delimiters = 0
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
            in_frontmatter && /^[[:space:]]+version:[[:space:]]*"/ {
                sub(/version:[[:space:]]*"[^"]*"/, "version: \"" version "\"")
            }
            { print }
        ' "$skill_file" > "${skill_file}.tmp"
        mv "${skill_file}.tmp" "$skill_file"
    done < <(find "$STAGING_DIR/.agents/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | sort)
}

# Create dist directory if it doesn't exist
mkdir -p "$DIST_DIR"

# --- Pre-release Warning and Pause ---
# Skip interactive prompt if running in CI (e.g. GitHub Actions)
if [[ -z "${CI}" ]]; then
    echo "****************************************************************"
    echo "WARNING: This script will TAG the current commit as v${VERSION}"
    echo "update skill metadata, and PUSH it to origin, thereby"
    echo "triggering a GitHub Release."
    echo ""
    echo "CRITICAL: Ensure you have COMMITTED and PUSHED all your changes"
    echo "to the current branch BEFORE continuing."
    echo "****************************************************************"
    read -r -p "Press Enter to continue or Ctrl+C to abort..." _
fi

# --- Release Notes Extraction ---
if [[ -z "${CI}" ]]; then
    # Locally, we just note we're building. 
    # The CI will handle the actual extraction for the GitHub Release.
    echo "Preparing version ${VERSION}..."
else
    # In CI, extract the section for this version from CHANGELOG.md
    # Look for the line starting with ## [VERSION] and capture until the next ## line
    echo "Extracting release notes from CHANGELOG.md..."
    sed -n "/## \[${VERSION}\]/,/## \[/p" "$PROJECT_ROOT/CHANGELOG.md" | sed '$d' > "$DIST_DIR/release-notes.md"
    
    if [ ! -s "$DIST_DIR/release-notes.md" ]; then
        echo "Warning: Could not extract release notes for version ${VERSION}. Using generic message."
        echo "Release v${VERSION}" > "$DIST_DIR/release-notes.md"
    fi
fi

echo "Packaging release v${VERSION}..."

# Stage release contents so packaged skill versions can be normalized without
# mutating tracked workspace files.
cp -R "$PROJECT_ROOT/.agents" "$STAGING_DIR/.agents"
sync_skill_versions

# Create the tarball
# Includes .agents/ folder
# Using tar with -z (gzip) and -c (create) -f (file)
# We use relative paths to ensure the structure is preserved within the archive
tar -czf "${DIST_DIR}/${FILENAME}" -C "$STAGING_DIR" .agents

echo "Successfully created ${DIST_DIR}/${FILENAME}"

# --- Git Integration ---
# Skip git tagging/pushing if already in CI (avoids recursion)
if [[ -z "${CI}" ]]; then
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

echo "Contents of archive:"
tar -tf "${DIST_DIR}/${FILENAME}"
