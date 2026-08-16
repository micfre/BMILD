#!/usr/bin/env bash
# 0.4.0 release metadata and first-class harness packaging contract.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(cat "$REPO_ROOT/VERSION")"
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

[ "$VERSION" = "0.4.0" ] || fail "VERSION is $VERSION, expected 0.4.0"
rg -q -F "## [$VERSION] - 2026-08-16" "$REPO_ROOT/CHANGELOG.md" || fail "dated changelog release missing"
rg -q -F "Version-$VERSION-orange" "$REPO_ROOT/README.md" || fail "README badge out of sync"
rg -q -F "first-class harness targets are Codex, Claude Code, and OpenCode" "$REPO_ROOT/README.md" \
  || fail "README first-class harness scope missing"

while IFS= read -r skill; do
  rg -q -F "version: \"$VERSION\"" "$skill" || fail "$skill metadata out of sync"
done < <(find "$REPO_ROOT/.agents/skills" -mindepth 2 -maxdepth 2 -name SKILL.md)

build="$REPO_ROOT/scripts/build-releases.sh"
rg -q -F 'generate-consult-agents.sh' "$build" || fail "release build does not generate harness agents"
rg -q -F '.agents harness' "$build" || fail "release archive does not package skills + harness definitions"

out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT
bash "$REPO_ROOT/scripts/generate-consult-agents.sh" --skills-dir "$REPO_ROOT/.agents/skills" --out "$out" >/dev/null
actual="$(find "$out/harness" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | paste -sd, -)"
[ "$actual" = "claude-code,codex,opencode" ] || fail "release harness set is '$actual'"

if [ "$failures" -gt 0 ]; then
  echo "release-build-contract: $failures failure(s)" >&2
  exit 1
fi

echo "release-build-contract: PASS"
