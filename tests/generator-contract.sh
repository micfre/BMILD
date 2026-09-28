#!/usr/bin/env bash
# Claude Code, Codex, and OpenCode generated consult-agent contract.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

bash "$REPO_ROOT/scripts/generate-consult-agents.sh" --skills-dir "$REPO_ROOT/.agents/skills" --out "$OUT" >/dev/null

claude="$OUT/.claude/agents"
opencode="$OUT/.opencode/agents"
codex="$OUT/.codex"
[ "$(find "$claude" -type f -name 'bmild-*-consult.md' | wc -l)" -eq 6 ] || fail "Claude Code agent count"
[ "$(find "$opencode" -type f -name 'bmild-*-consult.md' | wc -l)" -eq 6 ] || fail "OpenCode agent count"
[ "$(find "$codex/agents" -type f -name 'bmild-*-consult.toml' | wc -l)" -eq 6 ] || fail "Codex role count"

for persona in pm ux arch planner dev qa; do
  rg -q '^model: inherit$' "$claude/bmild-$persona-consult.md" || fail "Claude $persona inheritance"
  rg -q '^effort:' "$claude/bmild-$persona-consult.md" && fail "Claude $persona must inherit effort"
  rg -q '^model( |_)' "$codex/agents/bmild-$persona-consult.toml" && fail "Codex $persona must inherit pair"
  rg -q -F "Skill directory: .claude/skills/bmild-$persona" "$claude/bmild-$persona-consult.md" || fail "Claude $persona skill path"
  rg -q -F "Skill directory: .opencode/skills/bmild-$persona" "$opencode/bmild-$persona-consult.md" || fail "OpenCode $persona skill path"
  rg -q -F "Skill directory: .agents/skills/bmild-$persona" "$codex/agents/bmild-$persona-consult.toml" || fail "Codex $persona skill path"
done

for file in "$claude"/*.md; do
  rg -q '^tools: Read, Grep, Glob, Edit, Write, Bash$' "$file" || fail "$file: leaf tool allowlist"
done
for file in "$opencode"/*.md; do
  rg -q '^  - action: subagent$' "$file" || fail "$file: child delegation rule missing"
  rg -q '^    effect: deny$' "$file" || fail "$file: child delegation not denied"
  rg -q '^(model|variant):' "$file" && fail "$file: OpenCode must inherit model/variant"
done

[ ! -e "$codex/config.toml" ] || fail "Codex package must not require config.toml"

python3 - "$codex/agents" <<'CHECK'
from pathlib import Path
import sys, tomllib
root = Path(sys.argv[1])
for file in root.glob('bmild-*-consult.toml'):
    data = tomllib.loads(file.read_text())
    assert data['name'] == file.stem
    assert data['description']
    assert data['developer_instructions'].strip()
    assert 'model' not in data and 'model_reasoning_effort' not in data
CHECK

if [ "$failures" -gt 0 ]; then
  echo "generator-contract: $failures failure(s)" >&2
  exit 1
fi

echo "generator-contract: PASS"
