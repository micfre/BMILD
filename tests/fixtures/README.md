# Golden-test fixtures

Curated inputs for `run-golden.sh`. The runner also generates three inputs at
runtime that cannot be committed cleanly:

- `minified.js` — a single long line (bytes-per-line above the noise threshold);
  generated so the exact byte count is deterministic without committing a
  600-byte one-liner.
- `binary.bin` — a file containing NUL bytes (skipped by the estimator);
  generated from `/dev/zero` since NUL bytes cannot be written as text.
- tab-bearing `--src` path — a string containing an embedded tab, built with
  `printf '\t'` to exercise the TSV-injection rejection in `normalize_path`.
  Cannot be committed cleanly because a literal tab in a path breaks shells,
  editors, and diffs.

Committed fixtures:

- `small.py` — small file, no size or noise penalty (baseline).
- `medium.py` — deterministic byte count; used with a low
  `penalty_size_threshold` to activate the superlinear size penalty.
- `vendor/vendor-file.go` — path matches `*/vendor/*`, activating the noise
  penalty via the vendor-pattern signal.
- `-src-dir/sample.py` — directory whose name starts with `-`; used as a
  `--src` argument to exercise leading-dash normalization (the `./`-prefix
  guard in `normalize_path`). Without the guard `find "$src"` treats the name
  as a predicate and silently returns nothing.
- `.hidden-config.yaml` — dot-prefixed file exercising the hidden-file
  fixture from system-design §7 (`find` includes it by default; PowerShell
  requires `-Force` in `measure_source_dir_profile`). Measured, not skipped.

These exercise the bash-tokenizer acceptance criteria FR1, FR4–FR12, FR15.
The cross-platform equivalence runners (`tests/equivalence.sh`,
`tests/equivalence.ps1`) generate the runtime fixtures above into a temp dir
and run both estimators over this committed set plus the generated ones.
