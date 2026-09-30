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
rg -q -F 'for harness in codex claude-code opencode' "$build" || fail "release build does not package each harness"

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
CI=1 bash "$build" >"$out/build.log" || fail "CI release build failed"
for harness in codex claude-code opencode; do
  archive="$REPO_ROOT/dist/release-v${VERSION}-${harness}.tar.gz"
  project="$out/$harness"
  mkdir -p "$project"
  [ -s "$archive" ] || { fail "$harness archive missing"; continue; }
  tar -xzf "$archive" -C "$project" || { fail "$harness archive cannot be extracted"; continue; }
  case "$harness" in
    codex) skill_root=.agents/skills; agent_root=.codex/agents; suffix=toml ;;
    claude-code) skill_root=.claude/skills; agent_root=.claude/agents; suffix=md ;;
    opencode) skill_root=.opencode/skills; agent_root=.opencode/agents; suffix=md ;;
  esac
  [ "$(find "$project/$skill_root" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l)" -eq 9 ] || fail "$harness missing skills"
  [ "$(find "$project/$agent_root" -maxdepth 1 -name "bmild-*-consult.$suffix" | wc -l)" -eq 6 ] || fail "$harness missing consult agents"
  [ ! -e "$project/.bmild.toml" ] || fail "$harness archive ships project preferences"
  [ ! -e "$project/harness" ] || fail "$harness archive retains staging tree"
  [ ! -e "$project/.codex/config.toml" ] || fail "$harness archive requires Codex config merge"
  sh "$project/$skill_root/bmild-articulate/scripts/methods.sh" categories >/dev/null || fail "$harness selector failed after extraction"
  cp "$REPO_ROOT/tests/fixtures/prd-lint/clean.md" "$project/prd.md"
  sh "$project/$skill_root/bmild-pm/scripts/lint-prd.sh" --root "$project" --artifact prd.md >/dev/null || fail "$harness linter failed after extraction"
  python3 - "$project" "$skill_root" "$agent_root" "$suffix" <<'CHECK' || fail "$harness installed paths invalid"
from pathlib import Path
import re, sys, tomllib
project, skill_root, agent_root, suffix = sys.argv[1:]
project = Path(project)
skills = project / skill_root
for skill in skills.glob('bmild-*'):
    for file in skill.rglob('*.md'):
        content = file.read_text()
        assert '`.agents/skills/bmild-' not in content, file
        for path in re.findall(r'`(\.\./bmild-[^`]+)`', content):
            if '*' in path:
                continue
            assert (skill / path).exists(), (file, path)
for agent in (project / agent_root).glob(f'bmild-*-consult.{suffix}'):
    content = agent.read_text()
    name = agent.stem.removesuffix('-consult')
    assert f'Skill directory: {skill_root}/{name}' in content, agent
    if suffix == 'toml':
        data = tomllib.loads(content)
        assert data['name'] == agent.stem and data['developer_instructions'].strip()
        assert 'model' not in data and 'model_reasoning_effort' not in data
CHECK
done

if [ "$failures" -gt 0 ]; then
  echo "release-build-contract: $failures failure(s)" >&2
  exit 1
fi

echo "release-build-contract: PASS"
