# CLAIMS.md — clean-fixture exercise (author narrative; testimony, not evidence)

- The `json` and `tsv` formats are emitted with stricter handling than
  before.
- Every member of the format set `json | tsv | csv` is handled; an
  unrecognized format fails loudly with a non-zero status.
- Field normalization runs ahead of every emitter, so a field value like
  `unit cost` cannot emit malformed content.
- `emit_fields` is the only row-level emitter; no old emitter name survives.
- `test_report.sh` asserts the emitted output of all three formats.
