# review-depth live exercises (maintainer-run)

These fixtures support the two maintainer-run live NFR checks from the
review-depth PRD:

- **Live defect detection** — a seeded-defect review exercise catches the
  implicit-branch, deletion-regression, and verification-gap defects that
  today's review flow misses.
- **Live noise rejection** — a known-clean change produces zero surviving
  `high | medium | low` findings; disproved or unresolved claims remain
  inspectable as `false | maybe-false`.

Deterministic contract tests (`tests/review-depth-contract.sh`) guard
structure only; semantic acceptance evidence comes from running these
exercises with a live model. Each run must use a fresh Rahat session (or
isolated reviewer workers) that did not author the fixtures.

## Seeded-defect exercise (`seeded-defects/`)

1. Open a fresh Rahat session and request a comprehensive review of
   `tests/evaluations/review-depth/seeded-defects/` — supply `report.sh` and
   `test_report.sh` as the changed files and `CLAIMS.md` as the claims file
   for Edge-Case Hunter's claims check. `CHANGE.md` describes the change;
   its grader section stays hidden from the reviewer.
2. Expected: Edge-Case Hunter surfaces the implicit-branch defect (csv
   falling into the default arm) and the deletion regression (removed field
   normalization still assumed by `emit_json`); Verification-Gap classifies
   the never-tested csv format (regression gap) and the exit-status-only test
   (broken-verification gap) with `evidence` naming what was inspected.
3. Grade against `expected-findings.md`. All three numbered defect classes
   must be caught.

## Clean-fixture exercise (`clean-fixture/`)

1. Open a fresh Rahat session and request a comprehensive review of
   `tests/evaluations/review-depth/clean-fixture/` — supply `report.sh` and
   `test_report.sh` as the changed files and `CLAIMS.md` as the claims file.
2. Expected: zero surviving `high | medium | low` findings. Reviewer claims
   that do not verify must land as `false` or `maybe-false` with evidence,
   visible in the detailed report and counted in the compact summary.
3. Any surviving actionable finding on this fixture is a false positive —
   record it as evidence against the noise-rejection NFR.

Record both exercise results (date, harness, model, verdict counts) in the
review-depth `verification-matrix.md` outcome evidence.
