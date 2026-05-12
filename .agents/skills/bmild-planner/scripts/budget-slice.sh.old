#!/usr/bin/env bash
set -euo pipefail

TARGET=170000
OVERHEAD=800
MULTIPLIER=110
FILES=()

resolve_path() {
  local target="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$target"
  elif readlink -f . >/dev/null 2>&1; then
    readlink -f "$target"
  else
    # macOS fallback for BSD readlink
    local dir
    while [[ -L "$target" ]]; do
      dir="$(dirname "$target")"
      target="$(readlink "$target")"
      [[ "$target" != /* ]] && target="$dir/$target"
    done
    echo "$target"
  fi
}

usage() {
  echo "Usage: budget-slice.sh --target <tokens> <file...>"
  echo ""
  echo "Estimate implementation-session context tokens for a set of files."
  echo ""
  echo "Options:"
  echo "  --target <n>  Token budget (default: 170000, override from .bmild.toml slice_target)"
  echo ""
  echo "Output:"
  echo "  Status line, totals, per-file breakdown."
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --target) TARGET="$2"; shift 2 ;;
    --help|-h) usage 0 ;;
    --) shift; FILES+=("$@"); break ;;
    -*) echo "Unknown option: $1" >&2; usage 1 ;;
    *) FILES+=("$1"); shift ;;
  esac
done

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "Error: no files provided" >&2
  usage 1
fi

total_raw=0
file_rows=()
skipped=()

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    skipped+=("$f")
    continue
  fi
  if [[ -L "$f" ]]; then
    f="$(resolve_path "$f")"
  fi
  lines=$(wc -l < "$f")
  chars=$(wc -c < "$f")
  est=$(( chars / 4 ))
  total_raw=$(( total_raw + est ))
  file_rows+=("${est}|${lines}|${f}")
done

accumulated=$(( (total_raw * MULTIPLIER) / 100 ))
grand_total=$(( accumulated + OVERHEAD ))

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
    "planning_overhead": ${OVERHEAD}
  },
  "files": [
EOF

first=1
for row in "${file_rows[@]}"; do
  IFS='|' read -r est lines path <<< "$row"
  # Escape quotes and backslashes for JSON string validity
  path="${path//\\/\\\\}"
  path="${path//\"/\\\"}"
  if [[ $first -eq 1 ]]; then
    first=0
  else
    echo ","
  fi
  printf '    { "path": "%s", "tokens": %s, "lines": %s }' "$path" "$est" "$lines"
done

echo ""
echo '  ],'
echo '  "skipped_files": ['

first=1
for s in "${skipped[@]}"; do
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  if [[ $first -eq 1 ]]; then
    first=0
  else
    echo ","
  fi
  printf '    "%s"' "$s"
done

echo ""
echo "  ]"
echo "}"
