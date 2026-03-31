#!/bin/bash

# Exit on error
set -e

# Grab version from VERSION file
VERSION=$(cat VERSION)

# --- Pre-release Warning and Pause ---
echo "**************************************************************"
echo "This script will TAG the current commit as v${VERSION}"
echo "and PUSH it to origin, triggering a GitHub Release."
echo ""
echo "WARNING: Ensure you have COMMITTED and PUSHED all your changes"
echo "to the current branch BEFORE continuing."
echo "**************************************************************"
read -p "Press Enter to continue or Ctrl+C to abort..." ANY_KEY

# Define output directory and filename
DIST_DIR="dist"
FILENAME="release-v${VERSION}-linux_macos-dot_agents.tar.gz"

# Create dist directory if it doesn't exist
mkdir -p "$DIST_DIR"

echo "Packaging release v${VERSION}..."

# Create the tarball
# Includes .agents/ folder and BMILD_ONBOARDING.md
# Using tar with -z (gzip) and -c (create) -f (file)
# We use relative paths to ensure the structure is preserved within the archive
tar -czf "${DIST_DIR}/${FILENAME}" .agents/ BMILD_ONBOARDING.md

echo "Successfully created ${DIST_DIR}/${FILENAME}"

# --- Git Integration ---
TAG="v${VERSION}"
echo "Proceeding with Git tagging: ${TAG}..."

# Check if tag already exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "Warning: Tag $TAG already exists locally."
else
    git tag "$TAG"
    echo "Tag $TAG created locally."
fi

# Push the tag to trigger the GitHub Release workflow
echo "Pushing tag to origin..."
git push origin "$TAG"

echo "Release workflow triggered on GitHub."
echo "Contents of archive:"
tar -tf "${DIST_DIR}/${FILENAME}"
