#!/usr/bin/env bash
# Generate per-harness consult subagent definitions from the canonical
# .agents/skills/bmild-*/agents/consult.md sources.
#
# Outputs (under --out, default: project root):
#   harness/claude-code/agents/bmild-<persona>-consult.md
#   harness/opencode/agent/bmild-<persona>-consult.md
#   harness/codex/consult-agents.toml
#
# Tier mapping (from canonical frontmatter):
#   model_tier: frontier -> claude-code: opus | opencode: $FRONTIER_MODEL | codex: $CODEX_FRONTIER_MODEL
#   model_tier: inherit  -> claude-code: inherit | opencode: omit (session model) | codex: omit
#   effort_tier: high    -> codex: reasoning_effort = $CODEX_FRONTIER_EFFORT (default high)
#                           claude-code: not expressible per subagent (comment only)
#                           opencode: provider options placeholder (comment only)
#
# Overrides: FRONTIER_MODEL (opencode model id), CODEX_FRONTIER_MODEL,
# CODEX_FRONTIER_EFFORT env vars. Runtime .bmild.toml consult_model /
# consult_effort are applied by the dispatching persona, not baked in here.
set -euo pipefail

SKILLS_DIR=".agents/skills"
OUT_DIR="."
FRONTIER_MODEL="${FRONTIER_MODEL:-anthropic/claude-opus-4-1}"
CODEX_FRONTIER_MODEL="${CODEX_FRONTIER_MODEL:-Sol}"
CODEX_FRONTIER_EFFORT="${CODEX_FRONTIER_EFFORT:-high}"

usage() {
  cat <<'USAGE'
Usage: generate-consult-agents.sh [--skills-dir PATH] [--out DIR]

  --skills-dir  skill root containing bmild-*/agents/consult.md (default: .agents/skills)
  --out         output root for harness/ tree (default: .)
USAGE
}

while [ $# -gt 0 ]; do
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
mkdir -p "$CLAUDE_DIR" "$OPENCODE_DIR" "$CODEX_DIR"

CODEX_TOML="$CODEX_DIR/consult-agents.toml"
{
  echo "# BMILD consult subagents — merge into ~/.codex/config.toml (or project .codex/config.toml)."
  echo "# Requires Codex multi-agent v2. Frontier pair is overridable at runtime via"
  echo "# .bmild.toml consult_model / consult_effort."
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
  model_tier="$(fm_value model_tier "$consult")"
  effort_tier="$(fm_value effort_tier "$consult")"
  body="$(awk 'BEGIN{n=0} /^---$/{n++; next} n>=2{print}' "$consult")"
  skill_dir="$(dirname "$(dirname "$consult")")"
  count=$((count + 1))

  # --- Claude Code (.claude/agents/<name>.md) ---
  claude_model="inherit"
  [ "$model_tier" = "frontier" ] && claude_model="opus"
  {
    echo "---"
    echo "name: $name"
    echo "description: \"$description\""
    echo "model: $claude_model"
    # Reasoning effort is not expressible per subagent in Claude Code.
    echo "# effort_tier: $effort_tier (not expressible per subagent; session-level only)"
    # Task excluded: consult subagents are leaf nodes (consult-path §5.6).
    echo "tools: Read, Grep, Glob, Edit, Write, Bash"
    echo "---"
    echo ""
    echo "Skill directory: $skill_dir"
    echo ""
    echo "$body"
  } > "$CLAUDE_DIR/$name.md"

  # --- Opencode (.opencode/agent/<name>.md) ---
  {
    echo "---"
    echo "description: $description"
    echo "mode: subagent"
    if [ "$model_tier" = "frontier" ]; then
      echo "model: $FRONTIER_MODEL"
    fi
    # effort_tier: $effort_tier — map to your provider's reasoning option (variant/options) if supported.
    echo "permission:"
    echo "  task: deny"
    echo "---"
    echo ""
    echo "Skill directory: $skill_dir"
    echo ""
    echo "$body"
  } > "$OPENCODE_DIR/$name.md"

  # --- Codex (config.toml fragment) ---
  {
    echo "[agents.$name]"
    if [ "$model_tier" = "frontier" ]; then
      echo "model = \"$CODEX_FRONTIER_MODEL\""
      echo "reasoning_effort = \"$CODEX_FRONTIER_EFFORT\""
    fi
    echo "description = \"$description\""
    echo ""
  } >> "$CODEX_TOML"
done

if [ "$count" -eq 0 ]; then
  echo "FAIL: no consult definitions found under $SKILLS_DIR" >&2
  exit 1
fi

echo "Generated $count consult agents:"
echo "  $CLAUDE_DIR (claude-code)"
echo "  $OPENCODE_DIR (opencode)"
echo "  $CODEX_TOML (codex fragment)"
