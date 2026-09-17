#!/usr/bin/env bash
# Fixture: report formatter, clean counterpart. All members of the fixed
# format set are handled, field normalization is retained, the rename is
# fully adopted, and the companion test observes emitted output for every
# format.
set -euo pipefail

# Output formats: json | tsv | csv
normalize_field() {
  local field="$1"
  printf '%s' "${field// /_}"
}

format_report() {
  local format="$1"
  shift
  case "$format" in
    json)
      emit_json "$(normalize_field "$1")"
      ;;
    tsv)
      emit_fields "$(normalize_field "$1")"
      ;;
    csv)
      emit_csv "$(normalize_field "$1")"
      ;;
    *)
      echo "unknown format: $format" >&2
      return 1
      ;;
  esac
}

emit_json() {
  printf '{"fields": "%s"}\n' "$1"
}

emit_fields() {
  printf '%s\n' "$1"
}

emit_csv() {
  printf '%s\n' "$1" | tr '_' ','
}

format_report "$@"
