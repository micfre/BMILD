# Direct-Fix

Investigate and fix a localized defect reported outside a tracked artifact. Reproduction comes before edits. If root cause remains uncertain after targeted investigation, stop and route to Rahat.

## Additional Context

Load in this order:
- Error output, stack trace, failing test, or reproduction details from the message
- Repo context relevant to the reported failure path
- Local implementation files along the suspected code path
- Repo contributor guide
- Project-root `DESIGN.md` if it exists — honor global UX patterns when the fix alters a user-visible surface (project-root repo context, not BMILD planning memory)

Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — re-evaluate against core Mode Lookup before proceeding.

## Global Directives

- **Ground findings in code.** Grep it, cite file-path precision, and finish with proof; use those as working vocabulary, not ritual.
- **Reproduction before edit.** Reproduce via test, log, or code-path inspection. If root cause unclear after targeted investigation: stop; route to Rahat with symptoms, hypotheses checked, evidence, and next diagnostic question.
- **Minimal fix scope.** Smallest fix for confirmed root cause. No adjacent refactors. No scope expansion.
- **Promote durable truth** when fix changes externally visible behaviour or reveals facts future specs should account for — `system-design.md` or `handoff.md`. Trivial local fixes with no future relevance need no BMILD artifact.
- **Security or QA artifacts implicated** → re-evaluate against Spec-Fix before closing.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Investigate before edit — reproduce, identify root cause with evidence, confirm localized scope. Route to Rahat per Global Directives when uncertain.
- [ ] Step 2: Implement minimal confirmed fix.
- [ ] Step 3: Run quality gates. Add regression test when practical; otherwise record manual proof sequence Rahat can re-run.
- [ ] Step 4: Document when externally visible behaviour changed; otherwise `Documentation impact: none`.
- [ ] Step 5: Promote durable technical truth per Global Directives.
- [ ] Step 6: Establish mode eligibility: confirmed root cause, completed minimal fix, regression/manual proof, gate evidence, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the core non-zero posture close. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 7: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Root cause confirmed before edit, or escalation to Rahat recorded
- [ ] Fix scoped to confirmed root cause
- [ ] Regression test passing or manual proof recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Durable truth promoted or no BMILD artifact warranted
- [ ] Close message: files changed, root cause summary, gates run, documentation impact, next owner if any
