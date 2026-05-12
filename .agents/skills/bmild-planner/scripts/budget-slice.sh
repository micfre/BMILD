#!/usr/bin/env bash
set -euo pipefail

READS=()
EDITS=()
NEW_FILES=0
SRC_DIR=""

find_bmild_toml() {
    local dir="$1"
    while [[ "$dir" != "/" ]]; do
        [[ -f "$dir/.bmild.toml" ]] && echo "$dir/.bmild.toml" && return
        dir="$(dirname "$dir")"
    done
}

read_toml_number() {
    local file="$1" key="$2" default="$3"
    [[ -f "$file" ]] || { echo "$default"; return; }
    local line val
    line=$(grep -E "^${key}[[:space:]]*=" "$file" | head -1) || true
    [[ -z "$line" ]] && { echo "$default"; return; }
    val=$(echo "$line" | sed "s/^${key}[[:space:]]*=[[:space:]]*//" | tr -d '"')
    echo "${val:-$default}"
}

_bmild_toml=$(find_bmild_toml "$(pwd)")
TARGET=$(read_toml_number "$_bmild_toml" "slice_target" "170000")
BASE=$(read_toml_number "$_bmild_toml" "tokenizer_base" "0")
MULT=$(read_toml_number "$_bmild_toml" "tokenizer_multiplier" "1.0")

EDIT_PENALTY=2.0
TIER_1_THRESH=500
TIER_2_THRESH=1500
TIER_1_WEIGHT=1.3
TIER_2_WEIGHT=2.0

resolve_path() {
  local target="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$target"
  elif readlink -f . >/dev/null 2>&1; then
    readlink -f "$target"
  else
    local dir
    while [[ -L "$target" ]]; do
      dir="$(dirname "$target")"
      target="$(readlink "$target")"
      [[ "$target" != /* ]] && target="$dir/$target"
    done
    echo "$target"
  fi
}

estimate_avg_raw_tokens_for_dir() {
  local target_dir="$1"
  [[ -d "$target_dir" ]] || return 1

  local file_count total_bytes
  read -r file_count total_bytes < <(
    find "$target_dir" -type f -printf '%s\n' |
      awk '{ files++; bytes += $1 } END { print files + 0, bytes + 0 }'
  )

  [[ "$file_count" -gt 0 ]] || return 1
  awk "BEGIN { printf \"%.0f\", (${total_bytes} / ${file_count}) / 4 }"
}

tier_weight() {
    local lines="$1"
    if [[ "$lines" -gt "$TIER_2_THRESH" ]]; then
        echo "$TIER_2_WEIGHT"
    elif [[ "$lines" -gt "$TIER_1_THRESH" ]]; then
        echo "$TIER_1_WEIGHT"
    else
        echo "1.0"
    fi
}

usage() {
  echo "Usage: budget-slice.sh [--target <tokens>] [--base <tokens>] [--multiplier <n>] [--reads <read-file>...] [--edits <edit-file>...] [--new <count> --src <dir>]"
  echo ""
  echo "Estimate implementation-session context tokens for a set of files."
  echo "Read files are read-only context; edit files are existing files Alex will modify or extend."
  echo "New-file estimates use --new with --src to approximate created-file cost from nearby source files."
  echo "Edit files receive an additional ${EDIT_PENALTY}x penalty to account for test files and rework."
  echo ""
  echo "Options:"
  echo "  --target <n>  Token budget (default: from .bmild.toml slice_target, fallback 170000)"
  echo "  --base <n>    Tokenizer base adjustment (default: from .bmild.toml tokenizer_base, fallback 0)"
  echo "  --multiplier <n>  Tokenizer multiplier (default: from .bmild.toml tokenizer_multiplier, fallback 1.0)"
  echo "  --reads       Subsequent positional args are read-only context files"
  echo "  --edits       Subsequent positional args are existing edit targets (${EDIT_PENALTY}x penalty)"
  echo "  --new <n>     Estimated count of new files Alex will create"
  echo "  --src <dir>   Directory used to estimate average new-file size"
  echo ""
  echo "File-size tiers (read files only):"
  echo "  < ${TIER_1_THRESH} lines:   1.0x"
  echo "  ${TIER_1_THRESH}-${TIER_2_THRESH} lines: ${TIER_1_WEIGHT}x"
  echo "  > ${TIER_2_THRESH} lines:  ${TIER_2_WEIGHT}x"
  echo ""
  echo "Edit penalty: flat ${EDIT_PENALTY}x on raw tokens (accounts for test files and rework)"
  echo ""
  echo "Formula: (sum(read tier-weighted) + sum(edit raw x${EDIT_PENALTY})) x multiplier + base"
  echo ""
  echo "Output:"
  echo "  JSON with status, budget, per-file breakdown, and skipped files."
  exit "${1:-0}"
}

mode="reads"
while [[ $# -gt 0 ]]; do
  case $1 in
    --target)
        [[ $# -ge 2 ]] || { echo "Error: --target requires a value" >&2; usage 1; }
        TARGET="$2"
        shift 2
        ;;
    --base)
        [[ $# -ge 2 ]] || { echo "Error: --base requires a value" >&2; usage 1; }
        BASE="$2"
        shift 2
        ;;
    --multiplier)
        [[ $# -ge 2 ]] || { echo "Error: --multiplier requires a value" >&2; usage 1; }
        MULT="$2"
        shift 2
        ;;
    --new)
        [[ $# -ge 2 ]] || { echo "Error: --new requires a value" >&2; usage 1; }
        NEW_FILES="$2"
        shift 2
        ;;
    --src)
        [[ $# -ge 2 ]] || { echo "Error: --src requires a value" >&2; usage 1; }
        SRC_DIR="$2"
        shift 2
        ;;
    --reads) mode="reads"; shift ;;
    --edits) mode="edits"; shift ;;
    --help|-h) usage 0 ;;
    --) shift
        if [[ "$mode" == "reads" ]]; then READS+=("$@"); else EDITS+=("$@"); fi
        break ;;
    -*) echo "Unknown option: $1" >&2; usage 1 ;;
    *)
      if [[ "$mode" == "reads" ]]; then READS+=("$1"); else EDITS+=("$1"); fi
      shift ;;
  esac
done

if [[ ${#READS[@]} -eq 0 && ${#EDITS[@]} -eq 0 && "$NEW_FILES" -eq 0 ]]; then
  echo "Error: no files provided" >&2
  usage 1
fi

if ! [[ "$NEW_FILES" =~ ^[0-9]+$ ]]; then
  echo "Error: --new must be a non-negative integer" >&2
  usage 1
fi

if [[ "$NEW_FILES" -gt 0 && -z "$SRC_DIR" ]]; then
  echo "Error: --new requires --src" >&2
  usage 1
fi

total_reads=0
total_edits=0
total_raw=0
read_rows=()
edit_rows=()
skipped_reads=()
skipped_edits=()
skipped_new=()
new_file_avg_raw=0
new_file_raw_total=0
new_file_weighted_total=0

for f in "${READS[@]+"${READS[@]}"}"; do
  if [[ ! -f "$f" ]]; then
    skipped_reads+=("$f")
    continue
  fi
  if [[ -L "$f" ]]; then f="$(resolve_path "$f")"; fi
  lines=$(wc -l < "$f")
  chars=$(wc -c < "$f")
  raw=$(( chars / 4 ))
  tier=$(tier_weight "$lines")
  weighted=$(awk "BEGIN { printf \"%.0f\", ${raw} * ${tier} }")
  total_reads=$(( total_reads + weighted ))
  total_raw=$(( total_raw + raw ))
  read_rows+=("${weighted}|${raw}|${lines}|${tier}|${f}")
done

for f in "${EDITS[@]+"${EDITS[@]}"}"; do
  if [[ ! -f "$f" ]]; then
    skipped_edits+=("$f")
    continue
  fi
  if [[ -L "$f" ]]; then f="$(resolve_path "$f")"; fi
  lines=$(wc -l < "$f")
  chars=$(wc -c < "$f")
  raw=$(( chars / 4 ))
  tier=$(tier_weight "$lines")
  weighted=$(awk "BEGIN { printf \"%.0f\", ${raw} * ${EDIT_PENALTY} }")
  total_edits=$(( total_edits + weighted ))
  total_raw=$(( total_raw + raw ))
  edit_rows+=("${weighted}|${raw}|${lines}|${tier}|${f}")
done

if [[ "$NEW_FILES" -gt 0 ]]; then
  if new_file_avg_raw=$(estimate_avg_raw_tokens_for_dir "$SRC_DIR"); then
    new_file_raw_total=$(( NEW_FILES * new_file_avg_raw ))
    new_file_weighted_total=$(awk "BEGIN { printf \"%.0f\", ${new_file_raw_total} * ${EDIT_PENALTY} }")
    total_edits=$(( total_edits + new_file_weighted_total ))
    total_raw=$(( total_raw + new_file_raw_total ))
  else
    skipped_new+=("$SRC_DIR")
  fi
fi

total_weighted=$(( total_reads + total_edits ))
grand_total=$(awk "BEGIN { printf \"%.0f\", ${total_weighted} * ${MULT} + ${BASE} }")

if [[ $grand_total -le $TARGET ]]; then
  status="WITHIN BUDGET"
  delta=$(( TARGET - grand_total ))
else
  status="OVER BUDGET"
  delta=$(( grand_total - TARGET ))
fi

cat <<EOF
{
  "status": "${status}",
  "budget": {
    "target": ${TARGET},
    "estimated_total": ${grand_total},
    "delta": ${delta},
    "raw_file_tokens": ${total_raw},
    "weighted_reads": ${total_reads},
    "weighted_edits": ${total_edits},
    "tokenizer_base": ${BASE},
    "tokenizer_multiplier": ${MULT}
  },
  "reads": [
EOF

first=1
for row in "${read_rows[@]+"${read_rows[@]}"}"; do
  IFS='|' read -r weighted raw lines tier path <<< "$row"
  path="${path//\\/\\\\}"
  path="${path//\"/\\\"}"
  if [[ $first -eq 1 ]]; then first=0; else echo ","; fi
  printf '    { "path": "%s", "raw_tokens": %s, "tokens": %s, "lines": %s, "tier": %s }' "$path" "$raw" "$weighted" "$lines" "$tier"
done

echo ""
echo '  ],'
echo '  "edits": ['

first=1
for row in "${edit_rows[@]+"${edit_rows[@]}"}"; do
  IFS='|' read -r weighted raw lines tier path <<< "$row"
  path="${path//\\/\\\\}"
  path="${path//\"/\\\"}"
  if [[ $first -eq 1 ]]; then first=0; else echo ","; fi
  printf '    { "path": "%s", "raw_tokens": %s, "tokens": %s, "lines": %s, "tier": %s }' "$path" "$raw" "$weighted" "$lines" "$tier"
done

if [[ "$NEW_FILES" -gt 0 && "$new_file_weighted_total" -gt 0 ]]; then
  src_path="${SRC_DIR//\\/\\\\}"
  src_path="${src_path//\"/\\\"}"
  if [[ $first -eq 1 ]]; then first=0; else echo ","; fi
  printf '    { "path": "%s", "raw_tokens": %s, "tokens": %s, "lines": 0, "tier": "estimated_new_files", "new_files": %s, "avg_raw_tokens_per_file": %s }' "$src_path" "$new_file_raw_total" "$new_file_weighted_total" "$NEW_FILES" "$new_file_avg_raw"
fi

echo ""
echo '  ],'
echo '  "skipped_reads": ['
first=1
for s in "${skipped_reads[@]+"${skipped_reads[@]}"}"; do
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  if [[ $first -eq 1 ]]; then first=0; else echo ","; fi
  printf '    "%s"' "$s"
done

echo ""
echo '  ],'
echo '  "skipped_new": ['
first=1
for s in "${skipped_new[@]+"${skipped_new[@]}"}"; do
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  if [[ $first -eq 1 ]]; then first=0; else echo ","; fi
  printf '    "%s"' "$s"
done

echo ""
echo '  ],'
echo '  "new_file_estimate": {'
printf '    "count": %s,\n' "$NEW_FILES"
src_path="${SRC_DIR//\\/\\\\}"
src_path="${src_path//\"/\\\"}"
printf '    "src": "%s",\n' "$src_path"
printf '    "avg_raw_tokens_per_file": %s,\n' "$new_file_avg_raw"
printf '    "estimated_raw_tokens": %s,\n' "$new_file_raw_total"
printf '    "estimated_tokens": %s\n' "$new_file_weighted_total"
echo '  },'
echo '  "skipped_edits": ['
first=1
for s in "${skipped_edits[@]+"${skipped_edits[@]}"}"; do
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  if [[ $first -eq 1 ]]; then first=0; else echo ","; fi
  printf '    "%s"' "$s"
done

echo ""
echo '  ]'
echo '}'
