#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_FILE="$ROOT/VERSION"
README_FILE="$ROOT/README.md"

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

[[ -f "$VERSION_FILE" ]] || fail "VERSION file not found: $VERSION_FILE"
[[ -f "$README_FILE" ]] || fail "README file not found: $README_FILE"

version="$(tr -d '\r\n' < "$VERSION_FILE")"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "VERSION must contain a semantic version; found '$version'"

badge_version="$(awk '
    /^<!-- bmild-version-badge -->$/ {
        if (getline == 0 || $0 !~ /^!\[Version\]/) {
            exit 1
        }
        if (match($0, /Version-([0-9]+\.[0-9]+\.[0-9]+)-/, parts)) {
            print parts[1]
            found = 1
        }
        exit
    }
    END { exit(found ? 0 : 1) }
' "$README_FILE" 2>/dev/null)" || fail "README version badge is missing or malformed"

[[ "$badge_version" == "$version" ]] || fail "README badge version '$badge_version' does not match VERSION '$version'. Run scripts/version-sync.sh."

echo "README badge matches VERSION: $version"
