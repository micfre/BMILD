#!/usr/bin/env bash
# Companion test for the report.sh change. Observes the emitted output of
# every format in the fixed set, so a format regression fails here.
set -euo pipefail

fixture_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

check() {
  local format="$1" expected="$2"
  local actual
  actual="$(bash "$fixture_dir/report.sh" "$format" "unit cost")"
  if [ "$actual" != "$expected" ]; then
    echo "unexpected $format output: $actual" >&2
    exit 1
  fi
}

check json '{"fields": "unit_cost"}'
check tsv 'unit_cost'
check csv 'unit,cost'

echo "test_report: ok"
