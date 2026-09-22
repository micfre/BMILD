#!/usr/bin/env bash
# Release metadata and first-class harness packaging contract.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(cat "$REPO_ROOT/VERSION")"
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "invalid semantic version: $VERSION"
rg -q -F "## [$VERSION] - " "$REPO_ROOT/CHANGELOG.md" || fail "dated changelog release missing"
rg -q -F "Version-$VERSION-orange" "$REPO_ROOT/README.md" || fail "README badge out of sync"
rg -q -F "first-class harness targets are Codex, Claude Code, and OpenCode" "$REPO_ROOT/README.md" \
  || fail "README first-class harness scope missing"

while IFS= read -r skill; do
  rg -q -F "version: \"$VERSION\"" "$skill" || fail "$skill metadata out of sync"
done < <(find "$REPO_ROOT/.agents/skills" -mindepth 2 -maxdepth 2 -name SKILL.md)

build="$REPO_ROOT/scripts/build-releases.sh"
rg -q -F 'generate-consult-agents.sh' "$build" || fail "release build does not generate harness agents"
rg -q -F '.agents harness' "$build" || fail "release archive does not package skills + harness definitions"

# --- CHANGELOG reconciliation by the release build (local lane) ---
cl="$(mktemp -d)"
mkdir -p "$cl/scripts"
cp "$build" "$cl/scripts/build-releases.sh"
printf '9.9.9\n' > "$cl/VERSION"
cat > "$cl/CHANGELOG.md" <<'EOF'
# Changelog

## [Unreleased]

### Added

- Fixture feature.
EOF
status=0
run_out="$(echo | env -u CI bash "$cl/scripts/build-releases.sh" 2>&1)" || status=$?
[ "$status" -ne 0 ] || fail "release build proceeds without a dated changelog release"
rg -q -F '## [9.9.9] - ' "$cl/CHANGELOG.md" || fail "release build does not promote Unreleased to a dated release"
unreleased_count="$(rg -c '^## \[Unreleased\]$' "$cl/CHANGELOG.md" || true)"
[ "$unreleased_count" = "1" ] || fail "promotion drops the Unreleased heading"
rg -q -F 'Fixture feature.' "$cl/CHANGELOG.md" || fail "promotion loses Unreleased content"
rg -q 'Promoted CHANGELOG' <<<"$run_out" || fail "promotion message missing"

status=0
run_out="$(echo | env -u CI bash "$cl/scripts/build-releases.sh" 2>&1)" || status=$?
dated_count="$(rg -c -F '## [9.9.9] - ' "$cl/CHANGELOG.md" || true)"
[ "$dated_count" = "1" ] || fail "changelog reconciliation is not idempotent"
if rg -q 'Promoted CHANGELOG' <<<"$run_out"; then fail "idempotent re-run promotes again"; fi

printf '8.8.8\n' > "$cl/VERSION"
cat > "$cl/CHANGELOG.md" <<'EOF'
# Changelog

## [0.1.0] - 2026-01-01

### Added

- Old entry.
EOF
status=0
run_out="$(echo | env -u CI bash "$cl/scripts/build-releases.sh" 2>&1)" || status=$?
[ "$status" -ne 0 ] || fail "release build proceeds with an unreconcilable changelog"
rg -q 'no dated' <<<"$run_out" || fail "unreconcilable changelog error missing"
rm -rf "$cl"

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
