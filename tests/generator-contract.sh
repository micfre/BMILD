#!/usr/bin/env bash
# Claude Code, Codex, and OpenCode generated consult-agent contract.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

bash "$REPO_ROOT/scripts/generate-consult-agents.sh" --skills-dir "$REPO_ROOT/.agents/skills" --out "$OUT" >/dev/null

claude="$OUT/harness/claude-code/agents"
opencode="$OUT/harness/opencode/agent"
codex="$OUT/harness/codex"
[ "$(find "$OUT/harness" -mindepth 1 -maxdepth 1 -type d | wc -l)" -eq 3 ] || fail "expected exactly three harness outputs"
[ "$(find "$claude" -type f -name 'bmild-*-consult.md' | wc -l)" -eq 7 ] || fail "Claude Code agent count"
[ "$(find "$opencode" -type f -name 'bmild-*-consult.md' | wc -l)" -eq 7 ] || fail "OpenCode agent count"
[ "$(find "$codex/agents" -type f -name 'bmild-*-consult.toml' | wc -l)" -eq 7 ] || fail "Codex role count"

for persona in pm ux arch planner; do
  rg -q '^model: opus$' "$claude/bmild-$persona-consult.md" || fail "Claude $persona model"
  rg -q '^effort: max$' "$claude/bmild-$persona-consult.md" || fail "Claude $persona effort"
  rg -q '^model = "gpt-5.6-sol"$' "$codex/agents/bmild-$persona-consult.toml" || fail "Codex $persona model"
  rg -q '^model_reasoning_effort = "ultra"$' "$codex/agents/bmild-$persona-consult.toml" || fail "Codex $persona effort"
done

for persona in dev qa sec; do
  rg -q '^model: inherit$' "$claude/bmild-$persona-consult.md" || fail "Claude $persona inheritance"
  rg -q '^effort:' "$claude/bmild-$persona-consult.md" && fail "Claude $persona must inherit effort"
  rg -q '^model( |_)' "$codex/agents/bmild-$persona-consult.toml" && fail "Codex $persona must inherit pair"
done

for file in "$claude"/*.md; do
  rg -q '^tools: Read, Grep, Glob, Edit, Write, Bash$' "$file" || fail "$file: leaf tool allowlist"
done
for file in "$opencode"/*.md; do
  rg -q '^  task: deny$' "$file" || fail "$file: task deny"
  rg -q '^(model|variant):' "$file" && fail "$file: OpenCode must inherit model/variant"
done

[ "$(rg -c '^\[agents\.bmild-.*-consult\]$' "$codex/config.toml")" -eq 7 ] || fail "Codex named-role count"
[ "$(rg -c '^config_file = "agents/bmild-.*-consult\.toml"$' "$codex/config.toml")" -eq 7 ] || fail "Codex config_file count"
rg -q '^expose_spawn_agent_model_overrides = true$' "$codex/config.toml" || fail "Codex runtime overrides disabled"

if [ "$failures" -gt 0 ]; then
  echo "generator-contract: $failures failure(s)" >&2
  exit 1
fi

echo "generator-contract: PASS"
