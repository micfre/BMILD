# CHANGE.md — clean-fixture exercise

## What changed

`report.sh` re-emits the `json` and `tsv` formats with stricter handling.
All three members of the format set — `json | tsv | csv` — remain handled,
field normalization is retained ahead of every emitter, the emitter helper is
named `emit_fields`, and `test_report.sh` asserts the emitted output of every
format.

## How to run this fixture's review

Treat `report.sh` and `test_report.sh` as the full changed files. `CLAIMS.md`
is the claims file for the claims check.

## Grader note

This fixture is intentionally clean: a passing run produces zero surviving
`high | medium | low` findings. Reviewer claims that do not verify must be
reported as `false` or `maybe-false` with evidence, never promoted.
