# CLAIMS.md — seeded-defect exercise (author narrative; testimony, not evidence)

- The `json` and `tsv` formats are emitted with stricter escaping and
  separation than before.
- "Dropping the `csv` case is safe: it was unused — no caller requests csv."
- "Removing `normalize_field` loses nothing; emitters handle field content
  exactly as before."
- "`emit_row` was renamed to `emit_fields` and all callers updated."
- `test_report.sh` "covers all three output formats end to end."
