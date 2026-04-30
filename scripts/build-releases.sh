#!/bin/bash

# Exit on error
set -e

# Grab version from VERSION file
VERSION=$(cat VERSION)

# Define output directory and filename
DIST_DIR="dist"
FILENAME="release-v${VERSION}-linux-macos-dor_agents.tar.gz"

# Create dist directory if it doesn't exist
mkdir -p "$DIST_DIR"

# --- Pre-release Warning and Pause ---
# Skip interactive prompt if running in CI (e.g. GitHub Actions)
if [[ -z "${CI}" ]]; then
    echo "****************************************************************"
    echo "WARNING: This script will TAG the current commit as v${VERSION}"
    echo "and PUSH it to origin, triggering a GitHub Release."
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
    sed -n "/## \[${VERSION}\]/,/## \[/p" CHANGELOG.md | sed '$d' > dist/release-notes.md
    
    if [ ! -s dist/release-notes.md ]; then
        echo "Warning: Could not extract release notes for version ${VERSION}. Using generic message."
        echo "Release v${VERSION}" > dist/release-notes.md
    fi
fi

echo "Packaging release v${VERSION}..."

# Create the tarball
# Includes .agents/ folder and BMILD_ONBOARDING.md
# Using tar with -z (gzip) and -c (create) -f (file)
# We use relative paths to ensure the structure is preserved within the archive
tar -czf "${DIST_DIR}/${FILENAME}" .agents/ BMILD_ONBOARDING.md

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
