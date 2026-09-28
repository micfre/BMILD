#!/usr/bin/env bash
# Generate first-class Claude Code, Codex, and OpenCode leaf consult agents
# from the skill-local canonical agents/consult.md definitions.
set -euo pipefail

SKILLS_DIR=".agents/skills"
OUT_DIR="."
HARNESS="all"

usage() {
  cat <<'USAGE'
Usage: generate-consult-agents.sh [--skills-dir PATH] [--out DIR] [--harness NAME]

  --skills-dir  skill root containing bmild-*/agents/consult.md (default: .agents/skills)
  --out         target project root (default: .)
  --harness     codex, claude-code, opencode, or all (default: all)
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skills-dir) SKILLS_DIR="$2"; shift 2 ;;
    --out) OUT_DIR="$2"; shift 2 ;;
    --harness) HARNESS="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$HARNESS" in
  codex|claude-code|opencode|all) ;;
  *) echo "FAIL: invalid harness: $HARNESS" >&2; exit 2 ;;
esac

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

CLAUDE_DIR="$OUT_DIR/.claude/agents"
OPENCODE_DIR="$OUT_DIR/.opencode/agents"
CODEX_AGENT_DIR="$OUT_DIR/.codex/agents"
case "$HARNESS" in
  codex) mkdir -p "$CODEX_AGENT_DIR" ;;
  claude-code) mkdir -p "$CLAUDE_DIR" ;;
  opencode) mkdir -p "$OPENCODE_DIR" ;;
  all) mkdir -p "$CODEX_AGENT_DIR" "$CLAUDE_DIR" "$OPENCODE_DIR" ;;
esac

count=0
for consult in "$SKILLS_DIR"/bmild-*/agents/consult.md; do
  [ -f "$consult" ] || continue
  name="$(fm_value name "$consult")"
  description="$(fm_value description "$consult")"
  intelligence_tier="$(fm_value intelligence_tier "$consult")"
  body="$(awk 'BEGIN{n=0} /^---$/{n++; next} n>=2{print}' "$consult")"
  skill_name="$(basename "$(dirname "$(dirname "$consult")")")"
  count=$((count + 1))

  case "$intelligence_tier" in
    design|planning|implementation|reviewer) ;;
    *) echo "FAIL: invalid intelligence_tier '$intelligence_tier' in $consult" >&2; exit 1 ;;
  esac

  # Claude Code: every tier inherits unless explicitly selected at dispatch.
  # Agent/Task tools
  # are excluded from the allowlist so consults remain leaves.
  if [[ "$HARNESS" == all || "$HARNESS" == claude-code ]]; then
    {
      echo "---"
      echo "name: $name"
      echo "description: \"$description\""
      echo "model: inherit"
      echo "tools: Read, Grep, Glob, Edit, Write, Bash"
      echo "---"
      echo ""
      echo "Skill directory: .claude/skills/$skill_name"
      echo ""
      echo "$body"
    } > "$CLAUDE_DIR/$name.md"
  fi

  # OpenCode intentionally inherits the user's harness-wide model and
  # variant. Do not emit either field or attempt runtime synchronization.
  if [[ "$HARNESS" == all || "$HARNESS" == opencode ]]; then
    {
      echo "---"
      echo "description: $description"
      echo "mode: subagent"
      echo "permissions:"
      echo "  - action: subagent"
      echo "    resource: \"*\""
      echo "    effect: deny"
      echo "---"
      echo ""
      echo "Skill directory: .opencode/skills/$skill_name"
      echo ""
      echo "$body"
    } > "$OPENCODE_DIR/$name.md"
  fi

  # Standalone project agents are discovered from .codex/agents. Keeping the
  # model pair absent preserves parent inheritance and dispatch overrides.
  if [[ "$HARNESS" == all || "$HARNESS" == codex ]]; then
    {
      echo "name = \"$name\""
      echo "description = \"$description\""
      echo "developer_instructions = \"\"\""
      echo "Skill directory: .agents/skills/$skill_name"
      echo ""
      echo "$body"
      echo "\"\"\""
    } > "$CODEX_AGENT_DIR/$name.toml"
  fi
done

if [ "$count" -eq 0 ]; then
  echo "FAIL: no consult definitions found under $SKILLS_DIR" >&2
  exit 1
fi

echo "Generated $count consult agents for $HARNESS."
