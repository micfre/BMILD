# Commit posture

Applies only to Spec-Fix and Direct-Fix. Load before the mode's commit-posture preflight; no other Rahat mode reads commit settings or renders commit output.

<!-- commit-posture-config:start -->
Read the top-level `commit`, `format`, and `branch` keys from `.bmild.toml` after mode selection. Missing `commit` or `commit = 0` preserves the old workflow exactly: do not inspect message format, mutate Git state, author a commit message, or render posture output. `commit = 1` requests a rich message and one eligible local commit; `commit = 2` requests the message only. The only named MVP format is `conventional-commits`; when `format` is omitted, infer a coherent structure from at most 10 locally reachable non-merge messages, requiring at least 3 usable messages and 60% agreement, or fall back to Conventional Commits. `branch` defaults to `current` and may be `current` or `initiative`.

Malformed, duplicate, or ambiguous `commit` assignments become posture `0` with a warning. An unknown explicit format warns and falls back to `conventional-commits`. An invalid branch under posture `1` downgrades to posture `2`. Contributor and harness guidance always wins and may only reduce authority. Commit posture performs local Git operations only: never fetch, pull, push, open a PR, stash, amend, rebase, reset, bypass hooks, or rewrite history.

The selected mode owns the full preflight and completion algorithms at their point of use. A mode switch or bounded repair retains the original invocation ledger and commit limit; never restart preflight as a fresh entitlement or create a second commit.
<!-- commit-posture-config:end -->
