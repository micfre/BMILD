# Spec-Fix

Implement a localized fix driven by a confirmed root cause from Rahat. Do not re-derive root cause unless new evidence directly contradicts the entry artifact.

## Additional Context

Identify entry artifact: `rca-<slug>.md`, verification matrix item, or named Slice with bug signals. Load in this order:
- Named `rca-<slug>.md` in full when present
- Relevant ADRs in `[plan_folder]/adr/` when fix touches durable cross-initiative decisions
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative>/registry.md`
- Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
- `slice-<N>.md` referenced by RCA or message
- Relevant sections of `verification-matrix.md`
- `security-review-*.md` if tracked security finding implicated
- Repo contributor guide
- Project-root `DESIGN.md` if it exists — honor global UX patterns when the fix alters a user-visible surface
- `handoff.md` when Alex-owned items exist

## Global Directives

- **Trust Rahat's diagnosis** unless new evidence contradicts — then stop and route back to Rahat.
- **Ground findings in code.** Grep it, cite file-path precision, and finish with proof; use those as working vocabulary, not ritual.
- **Scope discipline.** Fix only what the entry artifact specifies. Route remaining contract defects via `handoff.md`.
- **Verification matrix.** Mark items `implemented` or `blocked` with evidence — never `passed`.
- **Do not mark security findings resolved** — set `fixed_pending_review`; `next_owner` Zach.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Confirm entry contract. If root cause not confirmed in artifact, route to Rahat. If fix exceeds scope, route to Sonia with evidence.
- [ ] Step 2: Implement fix per artifact. Implement regression test exactly as specified, or add one when practical.
- [ ] Step 3: Run quality gates and regression test. Record gates not run and why.
- [ ] Step 4: Document when externally visible behaviour changed; otherwise `Documentation impact: none`.
- [ ] Step 5: Update artifacts:
  - `rca-<slug>.md` → fix details, regression reference; `next_owner` Rahat
  - `verification-matrix.md` → `implemented` or `blocked`, never `passed`
  - `slice-<N>.md` when in Slice scope → Implementation Notes; do not change `qa_status`
  - `security-review-*.md` when implicated → `fixed_pending_review`; `next_owner` Zach
  - Resolve Alex-owned `handoff.md` items
- [ ] Step 6: Pre-exit offer (conditional, declinable in one word) — when remediation leaves a material trade-off, offer once: *"Before I wrap this fix — anything you want to stress-test? Otherwise I'll prepare it for re-verification."* Skip when no such trade-off remains.
- [ ] Step 7: Establish mode eligibility: completed documented fix, regression/gate evidence, owned-artifact updates, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the core non-zero posture close. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 8: Close — apply Exit and Handoff from the core skill. Default `Next`: Rahat for re-verification.

## Definition of Done

- [ ] Fix complete per entry artifact, or exact blocker and next owner recorded
- [ ] Regression test passing or manual proof recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Artifacts updated with implementation and evidence references
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions, next owner
