# CHANGE.md — seeded-defect exercise

## What changed

`report.sh` re-handles the `json` and `tsv` formats with stricter emission.
The `csv` case was dropped from `format_report` as unused, along with the
`normalize_field` helper it motivated. `emit_row` was renamed to `emit_fields`
and all callers updated. The companion `test_report.sh` is updated to run the
json, tsv, and csv formats.

## How to run this fixture's review

Treat `report.sh` and `test_report.sh` as the full changed files. `CLAIMS.md`
is the claims file for the claims check.

## Seeded defects (grader-only — do not show the reviewer)

1. **Implicit branch (Edge-Case Hunter, Step 1):** the change re-handles
   `json` and `tsv` from the fixed format set `json | tsv | csv` documented in
   the header comment; `csv` is now an implicit branch that falls into the
   `*` default and emits JSON with exit status 0 — a silent wrong-format
   regression for every csv consumer.
2. **Deletion regression (Edge-Case Hunter, Step 3):** the deleted
   `normalize_field` sanitized field content (whitespace) that `emit_json`
   still assumes is pre-normalized — its comment says so. Field values with
   spaces now emit malformed output; nothing re-establishes the contract.
3. **Verification gaps (Verification-Gap lens):** `test_report.sh` never runs
   the csv format at all (regression gap: no test covering that use), and
   where it does execute a format it asserts only the exit status — it never
   observes emitted output (broken-verification gap). The surviving `emit_row`
   beside `emit_fields`, with the narrative claiming all callers updated, is a
   missing-adoption gap and a falsified claim.

The clean-fixture counterpart (`../clean-fixture/`) contains none of these.
