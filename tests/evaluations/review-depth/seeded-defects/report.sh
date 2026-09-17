#!/usr/bin/env bash
# Fixture: report formatter, AFTER a change that (1) re-handles json and tsv
# but drops the csv case from the fixed format set, (2) deletes field
# normalization that emitters still assume, and (3) renames emit_row ->
# emit_fields without adopting it in emit_tsv. All regressions keep exit
# status 0. See CHANGE.md.
set -euo pipefail

# Output formats: json | tsv | csv
format_report() {
  local format="$1"
  shift
  case "$format" in
    json)
      # Re-handled: proper member escaping.
      emit_json "$@"
      ;;
    tsv)
      # Re-handled: strict tab separation.
      emit_tsv "$@"
      ;;
    # The csv case previously called emit_csv; dropped in this change as
    # "unused". (normalize_field and its calls were deleted alongside it.)
    *)
      # Default fallback for anything unrecognized.
      emit_json "$@"
      ;;
  esac
}

emit_json() {
  local fields="$1"
  # Fields are assumed pre-normalized (see deleted normalize_field).
  printf '{"fields": "%s"}\n' "$fields"
}

emit_tsv() {
  # emit_row was renamed emit_fields; this caller was not updated.
  emit_row "$1"
}

emit_fields() {
  printf '%s\n' "$1"
}

emit_row() {
  # Old name kept alive for the one remaining caller above.
  printf '%s\n' "$1"
}

emit_csv() {
  # Orphaned helper: no production caller since the csv case was dropped.
  printf '%s\n' "$1" | tr ' ' ','
}

format_report "$@"
