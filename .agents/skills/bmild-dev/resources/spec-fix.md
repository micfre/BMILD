# Spec-Fix

Fix a defect governed by a specification or tracked defect context. Reuse a confirmed root cause; otherwise confirm it through targeted investigation and involve Rahat only when uncertainty remains. Newly discovered governing context selects this path without restarting diagnosis.

## Additional Context

Read the governing contract or tracked defect, initiative registry, relevant live source sections and ADRs, affected matrix/Slice evidence, and implicated RCA, security-review, or handoff items. Reload live artifacts; completed archives are history, not current authority. Read the named RCA in full when present. Use rollup only to resolve initiative identity or cross-initiative context. Read repository guidance and relevant implementation; project-root `DESIGN.md` applies to user-visible changes.

## Global Directives

- **Continuation.** Preserve the suspended Spec-Dev, Slice-Dev, or Direct-Dev target and its completion boundary. After bounded repairs, resume development and any authorized independent re-verification. Explicit fix-only requests do not authorize broader development; repair authority never expands product scope.

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Trust Rahat's diagnosis** unless new evidence contradicts — then suspend the affected step and run a Rahat resolution episode.
- **Ground findings in code.** Grep it, cite file-path precision, and finish with proof; use those as working vocabulary, not ritual.
- **Scope discipline.** Fix the confirmed defect within its governing source or tracked entry scope. A governing source is sufficient entry; do not manufacture an RCA or Slice. Resolve remaining contract defects through the owner ladder.
- **Verification matrix.** Mark items `implemented` or `blocked` with evidence — never `passed`.
- **Do not mark review findings resolved** — set security findings `fixed_pending_review` and leave QA/code-review follow-ups open; `next_owner` Rahat.
- **Architecture truth and promotion.** A fix may mechanically record an implementation-confirmed fact as `observed` in `system-design.md` with code/evidence provenance. A new or changed `committed` architecture item requires Lance's criteria through gap resolution and any required user decision; never rewrite a commitment to conceal a defect.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Initialize once per user invocation. Mode switches, bounded repairs, authorized Slice series, and dispatched workers share the original baseline, path ledger, downgrade state, and commit-attempt flag. Workers return evidence and paths; only the coordinator commits. Re-entry reuses this state, never a fresh commit allowance.

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Confirm entry contract. Confirm root cause from existing evidence or targeted investigation; run a Rahat episode only if uncertainty remains. If the fix changes authorized phase or committed contracts, resolve that decision. Internal decomposition/file changes need no planning permission.
- [ ] Step 2: Implement the confirmed fix within its governing scope. Choose regression proof that demonstrates the corrected behavior; preserve the proof obligation while adapting implementation details to evidence.
- [ ] Step 3: Run quality gates and regression test. Record gates not run and why.
- [ ] Step 4: Document when externally visible behaviour changed; otherwise `Documentation impact: none`.
- [ ] Step 5: Update artifacts:
  - `system-design.md` when durable truth warrants it → implementation fact as `observed`, or Lance-resolved commitment change
  - `rca-<slug>.md` → fix details, regression reference; `next_owner` Rahat
  - `verification-matrix.md` → implementation `implemented` or `blocked`, never `passed`; mark affected prior proof pending, record reviewed-state change and independent re-verification needed
  - `slice-<N>.md` when in Slice scope → Implementation Notes; do not change `qa_status`
  - `security-review-*.md` when implicated → `fixed_pending_review`; `next_owner` Rahat
  - Resolve Alex-owned `handoff.md` items
- [ ] Step 6: Pre-exit offer (conditional, declinable in one word) — when remediation leaves a material trade-off, offer once: *"Before I wrap this fix — anything you want to stress-test? Otherwise I'll prepare it for re-verification."* Skip when no such trade-off remains.
- [ ] Step 7: Establish mode eligibility: completed documented fix, regression/gate evidence, owned-artifact updates, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Defer execution while authorized review, repairs, or further Slices remain; run at the final eligible invocation boundary using the accumulated ledger and final evidence. If a commit was already attempted in this invocation, skip Git mutation and preserve later changes uncommitted; never treat the resulting HEAD change as a new baseline. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, mark the invocation commit attempt consumed, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the compact core commit line from Exit and Handoff. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 8: Close — apply Exit and Handoff from the core skill. Continue already-authorized build-and-verify through a fresh independent reviewer, or leave a concise new-window transition with acceptance pending.

## Definition of Done

- [ ] Fix complete within governing source or tracked entry scope, or exact blocker and next owner recorded
- [ ] Regression test passing or manual proof recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Artifacts updated with implementation and evidence references
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions, next owner
