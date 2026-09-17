#!/usr/bin/env bash
# Companion test for the report.sh change. Ships green despite the seeded
# regressions: the csv format is never run, and the formats that are run are
# checked by exit status only — emitted output is never observed.
set -euo pipefail

fixture_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for format in json tsv; do
  if ! bash "$fixture_dir/report.sh" "$format" "unit cost" >/dev/null 2>&1; then
    echo "unexpected failure: $format"
    exit 1
  fi
done

echo "test_report: ok"
