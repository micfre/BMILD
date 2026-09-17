# expected-findings.md — seeded-defect exercise grading key

A passing live run surfaces all three seeded defect classes. Location phrasing
may vary; the class, the mechanism, and the cited evidence must not.

## 1. Implicit-branch defect — Edge-Case Hunter

- Class: unhandled implicit branch (fixed set member).
- Mechanism: the change re-handles `json` and `tsv`; `csv` from the documented
  set `json | tsv | csv` now falls into the `*` default of `format_report`,
  emitting JSON with exit status 0 for every csv request — a silent
  wrong-format regression.
- Field check: finding carries `location` (the `*` arm or the case list),
  `trigger_condition` (a `csv` request), `guard_snippet` (a `csv` case calling
  `emit_csv` or equivalent), `potential_consequence` (csv consumers silently
  receive JSON).

## 2. Deletion regression — Edge-Case Hunter (deletion check)

- Class: removed behavior neither re-established nor retired.
- Mechanism: the deleted `normalize_field` sanitized field content; the
  `emit_json` comment still assumes pre-normalized fields, and a value like
  `unit cost` now emits malformed content with nothing re-establishing the
  contract.
- Field check: deletion reading — `location` = the removed item,
  `trigger_condition` = the behavior it enforced, `guard_snippet` = where/how
  to re-establish, `potential_consequence` = the regression or orphan.

## 3. Verification gaps — Verification-Gap lens

- **Regression gap:** the csv format has no test at all; the change's
  behavior at that consumer is unverified.
- **Broken-verification gap:** `test_report.sh` executes `json` and `tsv` but
  asserts only the exit status; it never observes emitted output, so output
  regressions ship green. Evidence must name the test and why it does not
  count.
- **Missing-adoption gap (acceptable additional catch):** `emit_row` survives
  beside `emit_fields` and `emit_tsv` still calls it — qualifies via the
  rename narrative as a supersession signal plus shared observable contract.

## Claims check (Edge-Case Hunter, Step 4)

- The "csv was unused" claim is falsifiable against the header comment
  documenting the three-member set; the finding cites where the code
  contradicts the claim.
- The "all callers updated" claim is false — `emit_tsv` calls `emit_row`.
- The "emitters handle field content exactly as before" claim is false —
  the `emit_json` comment contradicts it.
- The "covers all three output formats" claim is false — the test loop runs
  `json tsv` only.

A run that misses any of the three numbered defect classes fails the live
defect-detection NFR for this exercise.
