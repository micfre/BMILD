# Golden-test fixtures

Curated inputs for `run-golden.sh` / `run-golden.ps1` and the equivalence
runners under `peak_live_v2`.

The runners also generate inputs at runtime that cannot be committed cleanly:

- `minified.js` — a single long line (exercises full-file sizing without
  legacy noise penalties).
- `binary.bin` — contains NUL bytes; must be skipped.
- `large.txt` — oversized text used to assert symbol-read / symbol-edit caps.

Committed fixtures:

- `small.py` — small file, baseline full/symbol measurements.
- `medium.py` — deterministic mid-size file for breadth and monotonicity.
- `vendor/vendor-file.go` — path under `vendor/` (no longer a special noise
  signal in v2; still a useful path fixture).
- `-src-dir/sample.py` — directory whose name starts with `-`; used as a
  `--src` representative for new-file averages and leading-dash normalization.
- `.hidden-config.yaml` — hidden file; both platforms must measure it
  (`find` includes hidden by default; PowerShell requires `-Force`).

These exercise peak_live_v2 invariants: fixed TSV sections, symbol caps,
linear item overhead, supported TOML keys (`slice_target`, `tokenizer_base`,
`tokenizer_multiplier`), legacy-key warnings, and Bash/PowerShell parity.
