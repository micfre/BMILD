# Direct-Dev

Implement exploratory or bounded repo work without a governing specification. When a live specification governs the request, use Spec-Dev; absence of a Slice is not a reason to select Direct-Dev.

## Additional Context

- Load relevant repository guidance and implementation; read project-root `DESIGN.md` for user-visible surfaces.
- Load BMILD memory only when the request names an initiative, depends on documented behaviour, or might alter durable product or architecture understanding.
- If scope is unclear, ask one question for the smallest concrete target before proceeding.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Groundtruth once.** Read relevant repository guidance and existing implementations, then choose a coherent change matching established boundaries. No throwaway/exploratory/durable classification gate is required.
- **Do not over-engineer** toward a spec that does not exist.
- **Promote durable truth.** When work reveals a durable implementation fact future specs should account for, Alex may add an `observed` item to `system-design.md` with code/evidence provenance. Observations are descriptive. A new or changed `committed` architecture item requires Lance's criteria through gap resolution and any required user decision. Use `handoff.md` only when resolution genuinely leaves the session. Throwaway work with no future relevance needs no BMILD artifact.
- **Repair and resume.** Use Spec-Fix for governing contracts or tracked defects, including context discovered during work; otherwise use Direct-Fix. Preserve the suspended development target, and resume it after bounded repairs. Explicit fix-only requests take precedence.
- **Route upstream decisions** per core Execution authority — do not resolve product, UX, or committed architecture choices unilaterally.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Initialize once per user invocation. Mode switches, bounded repairs, authorized Slice series, and dispatched workers share the original baseline, path ledger, downgrade state, and commit-attempt flag. Workers return evidence and paths; only the coordinator commits. Re-entry reuses this state, never a fresh commit allowance.

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Groundtruth the requested change. If a governing specification emerges, continue in Spec-Dev with the same scope and explicit completion boundary; do not restart discovery.
- [ ] Step 2: Implement a coherent change fully satisfying the request and applicable quality expectations.
- [ ] Step 3: Run quality gates. Add or update tests when they prove the prototype, protect durable behaviour, or the user asked for tests.
- [ ] Step 4: Document when durable behaviour changes or user explicitly asks; otherwise `Documentation impact: none`.
- [ ] Step 5: Reconcile durable technical truth per Global Directives: record useful implementation facts as `observed`, or resolve proposed commitment changes through Lance's criteria.
- [ ] Step 6: Pre-exit offer (conditional, declinable in one word) — when the prototype leaves a material trade-off, offer once: *"Before I wrap this — anything you want to stress-test? Otherwise I'll close it out."* Skip when no such trade-off remains.
- [ ] Step 7: Establish mode eligibility: completed bounded work, gate evidence or recorded unavailability, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Defer execution while authorized review, repairs, or further Slices remain; run at the final eligible invocation boundary using the accumulated ledger and final evidence. If a commit was already attempted in this invocation, skip Git mutation and preserve later changes uncommitted; never treat the resulting HEAD change as a new baseline. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, mark the invocation commit attempt consumed, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the compact core commit line from Exit and Handoff. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 8: Close — default to completed implementation with local proof. When independent verification was explicitly requested, dispatch Comprehensive Review in a fresh context without the development transcript; supply request, change identity, tests, and known issues. Use the governing contract if one emerged. Coordinate authorized bounded repairs and independent re-verification; a reviewer-authored repair requires a different reviewer. If isolation is unavailable, leave acceptance pending with a usable new-window transition. Route upstream when core Execution authority applies.

## Definition of Done

- [ ] Implementation or prototype complete, or exact blocker and next owner recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Durable truth promoted or no BMILD artifact warranted
- [ ] Close message: files changed, gates run, documentation impact, next owner if any
