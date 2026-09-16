#!/usr/bin/env bash
# Generate first-class Claude Code, Codex, and OpenCode leaf consult agents
# from the skill-local canonical agents/consult.md definitions.
set -euo pipefail

SKILLS_DIR=".agents/skills"
OUT_DIR="."

usage() {
  cat <<'USAGE'
Usage: generate-consult-agents.sh [--skills-dir PATH] [--out DIR]

  --skills-dir  skill root containing bmild-*/agents/consult.md (default: .agents/skills)
  --out         output root for harness/ tree (default: .)
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skills-dir) SKILLS_DIR="$2"; shift 2 ;;
    --out) OUT_DIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [ ! -d "$SKILLS_DIR" ]; then
  echo "FAIL: skills dir not found: $SKILLS_DIR" >&2
  exit 1
fi

fm_value() {
  awk -v key="$1" '
    NR == 1 && $0 != "---" { exit 1 }
    NR > 1 && $0 == "---" { exit }
    NR > 1 && $1 == key ":" { sub("^[^:]+:[[:space:]]*", ""); gsub(/^"|"$/, ""); print; exit }
  ' "$2"
}

CLAUDE_DIR="$OUT_DIR/harness/claude-code/agents"
OPENCODE_DIR="$OUT_DIR/harness/opencode/agent"
CODEX_DIR="$OUT_DIR/harness/codex"
CODEX_AGENT_DIR="$CODEX_DIR/agents"
mkdir -p "$CLAUDE_DIR" "$OPENCODE_DIR" "$CODEX_AGENT_DIR"

CODEX_TOML="$CODEX_DIR/config.toml"
{
  echo "# BMILD leaf consult roles — merge into Codex config.toml."
  echo "# Dispatchers apply .bmild.toml [intelligence.codex.<tier>] with runtime"
  echo "# spawn model/reasoning overrides. Invalid explicit pairs must not retry."
  echo "[features.multi_agent_v2]"
  echo "enabled = true"
  echo "expose_spawn_agent_model_overrides = true"
  echo ""
} > "$CODEX_TOML"

count=0
for consult in "$SKILLS_DIR"/bmild-*/agents/consult.md; do
  [ -f "$consult" ] || continue
  name="$(fm_value name "$consult")"
  description="$(fm_value description "$consult")"
  intelligence_tier="$(fm_value intelligence_tier "$consult")"
  body="$(awk 'BEGIN{n=0} /^---$/{n++; next} n>=2{print}' "$consult")"
  skill_dir="$(dirname "$(dirname "$consult")")"
  count=$((count + 1))

  case "$intelligence_tier" in
    design|planning|implementation|reviewer) ;;
    *) echo "FAIL: invalid intelligence_tier '$intelligence_tier' in $consult" >&2; exit 1 ;;
  esac

  # Claude Code: every tier inherits unless explicitly selected at dispatch.
  # Agent/Task tools
  # are excluded from the allowlist so consults remain leaves.
  {
    echo "---"
    echo "name: $name"
    echo "description: \"$description\""
    echo "model: inherit"
    echo "tools: Read, Grep, Glob, Edit, Write, Bash"
    echo "---"
    echo ""
    echo "Skill directory: $skill_dir"
    echo ""
    echo "$body"
  } > "$CLAUDE_DIR/$name.md"

  # OpenCode intentionally inherits the user's harness-wide model and
  # variant. Do not emit either field or attempt runtime synchronization.
  {
    echo "---"
    echo "description: $description"
    echo "mode: subagent"
    echo "permission:"
    echo "  task: deny"
    echo "---"
    echo ""
    echo "Skill directory: $skill_dir"
    echo ""
    echo "$body"
  } > "$OPENCODE_DIR/$name.md"

  # Codex named roles point at schema-valid role config files. The role file
  # inherits the active model/effort for every tier unless
  # the dispatcher supplies runtime model/reasoning overrides.
  {
    echo "[agents.$name]"
    echo "description = \"$description\""
    echo "config_file = \"agents/$name.toml\""
    echo ""
  } >> "$CODEX_TOML"

  {
    echo "name = \"$name\""
    echo "description = \"$description\""
    echo "developer_instructions = \"\"\""
    echo "Skill directory: $skill_dir"
    echo ""
    echo "$body"
    echo "\"\"\""
  } > "$CODEX_AGENT_DIR/$name.toml"
done

if [ "$count" -eq 0 ]; then
  echo "FAIL: no consult definitions found under $SKILLS_DIR" >&2
  exit 1
fi

echo "Generated $count consult agents for Claude Code, Codex, and OpenCode."
