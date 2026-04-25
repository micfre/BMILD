#!/usr/bin/env bash
set -euo pipefail

TARGET=170000
OVERHEAD=800
MULTIPLIER=110
FILES=()

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
    f="$(readlink -f "$f")"
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
  delta_msg="headroom: ${delta}"
else
  status="OVER BUDGET"
  delta=$(( grand_total - TARGET ))
  delta_msg="over by: ${delta}"
fi

echo "${status}  (${delta_msg})"
echo "Target: ${TARGET}  Estimated: ${grand_total}"
echo "  File tokens (raw): ${total_raw}"
echo "  After accumulation (1.1x): ${accumulated}"
echo "  Planning overhead: ${OVERHEAD}"
echo ""
echo "Files (${#file_rows[@]}):"

for row in "${file_rows[@]}"; do
  IFS='|' read -r est lines path <<< "$row"
  printf "  %7s  %s  (%s lines)\n" "~${est}" "$path" "$lines"
done

if [[ ${#skipped[@]} -gt 0 ]]; then
  echo ""
  echo "Skipped (${#skipped[@]}):"
  for s in "${skipped[@]}"; do
    echo "  $s  (not found)"
  done
fi
