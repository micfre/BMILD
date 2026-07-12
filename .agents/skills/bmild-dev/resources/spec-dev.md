# Spec-Dev

Implement a well-defined Slice inside a documented initiative against a complete design contract.

## Additional Context

- Confirm `slice-<N>.md` at `[plan_folder]/<initiative>/slice-<N>.md`. If missing, flag and operate at reduced fidelity: work from available contracts, note inferences, flag gaps.
- Load in this order:
  - `[plan_folder]/context-map.md` if it exists
  - Relevant ADRs in `[plan_folder]/adr/` when the Slice depends on a durable cross-initiative decision
  - `[plan_folder]/rollup.md` if it exists
  - `[plan_folder]/<initiative>/registry.md`
  - Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
  - `slice-<N>.md` in full
  - Relevant sections of `verification-matrix.md` when present
  - Design contracts referenced by the Slice
  - Project-root `DESIGN.md` if it exists — honor global UX patterns (palette, typography, component rules) when the work has a user-visible surface
  - Repo contributor guide (`AGENTS.md`, `CONTRIBUTING.md`, or equivalent)
  - `handoff.md` when Alex-owned items exist — resolve during execution

## Global Directives

- **Discovery before invention**: Read the contributor guide and search the codebase for existing implementations before writing code. Match project patterns — only where the project actually has them.
- **Ground findings in code.** Grep it, cite file-path precision, and finish with proof; use those as working vocabulary, not ritual.
- **Match repo patterns.** Extend existing abstractions before introducing new ones. Do not bypass established layers or commit secrets.
- **Slice scope only.** A missing import is not a design gap; a missing API contract is. A better architectural approach noticed mid-Slice goes in Implementation Notes for Lance — do not detour.
- **Contract discipline.** Do not resolve contract gaps by inference. Route genuine gaps via `handoff.md` per core Routing heuristics. Promote durable technical truth into `system-design.md` when no other owner's judgment is required.
- **Verification matrix.** Binding QA contract when present — mark items `implemented` with evidence; never `passed` (Rahat owns pass).
- **Documentation chain.** Docs named in `prd.md` are part of the work — Faisal defines, Alex writes, Rahat verifies.
- **QA loop closure.** Close documented Rahat open items explicitly: reference, fix or defer with reason, record in artifacts — not chat-only.
- **`Likely Required Reads` may underfit.** Files defining the current integration boundary matter more than files that merely mention the feature.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Groundtruth codebase per Global Directives before writing code.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 2: Work acceptance criteria one by one; honor every design contract referenced by the Slice. Route contract defects per Global Directives.
- [ ] Step 3: Run quality gates per contributor guide. Record any gate not run and why.
- [ ] Step 4: Write or update documentation required by spec, Slice, or contributor guide. Name deferred doc items with change required and next owner.
- [ ] Step 5: Update artifacts in order:
  - `slice-<N>.md` → `ready-for-review`, AC checked off, Implementation Notes, QA/Security Follow-up
  - `slices.md` → Slice status `ready-for-review`
  - `verification-matrix.md` → relevant items `implemented` or `blocked`, never `passed`
  - `registry.md` → move `slice-<N>.md` to `## Archived`; add new live docs to `## Live`
  - `rca-<slug>.md` when implementing fixes → fix details, regression reference; `next_owner` Rahat
  - `security-review-*.md` when implementing fixes → `fixed_pending_review`; `next_owner` Zach
  - Resolve Alex-owned `handoff.md` items with `Owner Disposition` and `Promotion Record`
- [ ] Step 6: Pre-exit offer (conditional, declinable in one word) — when a material implementation trade-off remains, offer once: *"Before I wrap this Slice — anything you want to stress-test? Otherwise I'll prepare it for review."* Skip when no such trade-off remains.
- [ ] Step 7: Establish mode eligibility: `ready-for-review`, every AC disposition, artifact/docs updates, gate evidence, verification items `implemented` or `blocked`, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the core non-zero posture close. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 8: Close — apply Exit and Handoff from the core skill. Default `Next`: Rahat for verification. Include AC/UAT evidence the user can verify.

## Definition of Done

- [ ] All acceptance criteria checked, implemented, or explicitly deferred with reason
- [ ] Verification matrix items `implemented` or `blocked` — never `passed`
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation complete or deferred item named with owner
- [ ] Artifacts updated; Alex handoff items resolved or routed
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification with pass criteria, next owner
