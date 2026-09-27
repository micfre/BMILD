# Slice-Dev

Implement and independently verify one explicitly requested Slice. Continue a series only when the user explicitly authorizes it; implementation-only requests stop at review readiness.

## Additional Context

Read repository guidance, the initiative registry, `slices.md`, the selected `slice-<N>.md`, its parent `O-###` in `verification-matrix.md`, and relevant live source sections and ADRs. Read dependency evidence, not every historical Slice. Never consume stale artifacts as authority. Reuse already-current context; reload changed sources after repairs or replanning.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Selection.** Execute the named Slice if eligible. Otherwise select the sole next eligible Slice within authorized scope: live, unfinished, sufficiently defined, and with dependencies independently accepted on current evidence. When several candidates qualify and the request does not disambiguate, ask which one. With none eligible, report the dependency or source blocker; never silently substitute another Slice or expand phase authority. A named Slice awaiting review resumes review rather than repeating implementation.
- **Stable boundaries, flexible implementation.** Keep acceptance boundaries and dependencies stable during execution. Alex chooses private structure, task order, file changes, and tests. Sonia resolves boundary or dependency changes through Slice Planning; product, UX, and architecture commitments retain their existing owner rules. Before: a new internal helper triggers needless replanning. After: implement and test it directly; seek Sonia only if the Slice's promised behavior or prerequisites must change.
- **Evidence under the outcome.** The matrix is authoritative. Record Slice-scoped implementation and independent evidence under its parent outcome; do not create an outcome for each Slice. Create a missing parent only from an actual authorized outcome, minting the next unused `O-###`, updating the Outcome Index and rollup activation mechanically. A legacy Slice may gain a parent reference when touched; completed history needs no migration.
- **Review scope.** A passing Slice accepts only its boundary. Keep the parent active while source obligations remain. When the last Slice completes implementation, its review also reconciles current source coverage and integrated verification across the whole outcome. All Slices passing alone never establishes outcome acceptance.
- **Repair and resume.** Suspend this Slice for a bounded Spec-Fix or Direct-Fix according to governing contract or tracked defect context, including newly discovered context. Resume this Slice and independent re-verification afterward. Explicit fix-only requests stop at their requested boundary; bounded repairs never expand product scope.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Initialize once per user invocation. Mode switches, bounded repairs, authorized Slice series, and dispatched workers share the original baseline, path ledger, downgrade state, and commit-attempt flag. Workers return evidence and paths; only the coordinator commits. Re-entry reuses this state, never a fresh commit allowance.

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Resolve selection, parent outcome, authorized phase, source acceptance, dependencies, and proof obligations. Record actual blockers and continue only independent work inside the selected boundary.
- [ ] Step 2: Implement the Slice with relevant tests and required documentation. Record useful durable facts as `observed` with code/evidence provenance; resolve proposed commitment changes through the owner criteria before dependent work.
- [ ] Step 3: Update the parent's Slice evidence with source references, actual change identity, commands/results, open obligations, and next action. Mark affected prior proof pending while preserving history and unaffected evidence. Project implementation status into `slice-<N>.md` and `slices.md`; set Slice `ready_for_review`, `qa_status: review_requested`, `security_status: review_requested`, and `code_review_status: review_requested` only when its implementation obligations are met. Do not set parent readiness from a partial Slice.
- [ ] Step 4: Establish mode eligibility: Slice implementation `ready_for_review`, required documentation and implementation proof recorded, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready. Implementation commit readiness is not independent acceptance.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Defer execution while authorized review, repairs, or further Slices remain; run at the final eligible invocation boundary using the accumulated ledger and final evidence. If a commit was already attempted in this invocation, skip Git mutation and preserve later changes uncommitted; never treat the resulting HEAD change as a new baseline. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, mark the invocation commit attempt consumed, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the compact core commit line from Exit and Handoff. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 5: Unless implementation-only, dispatch full Comprehensive Review in a fresh isolated context that did not implement the changes or inherit the development transcript. Supply Slice and parent ID, live source links, change identity, runnable evidence, and known issues. The QA consult leaf cannot substitute for full acceptance. Honor an explicit separate-window preference. If isolation is unavailable, persist a usable review transition and leave acceptance pending.
- [ ] Step 6: Repair authorized findings, then obtain independent re-verification. A reviewer-authored production repair requires a different independent reviewer. Only Rahat accepts and archives Slices or marks the parent done. On the last Slice, include source completeness and integrated verification in the same review; uncovered requirements stay open even if every Slice passed.
- [ ] Step 7: Close — report implemented versus independently accepted scope and the next continuation link. Stop after this Slice unless a series was explicitly authorized; even in a series, respect dependencies, fresh review, and phase limits. Stop an unchanged failing approach and identify the missing evidence or decision.

## Definition of Done

- Selected Slice implemented with current source-linked proof, or precise blockers and continuation recorded.
- Matrix evidence and Slice projections agree; parent status reflects remaining source and integration obligations.
- Independent acceptance completed or explicitly pending; implementation-only work claims review readiness only.
- No silent boundary changes, future-phase work, self-acceptance, or unrequested series continuation.
