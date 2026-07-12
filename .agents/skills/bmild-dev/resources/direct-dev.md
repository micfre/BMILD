# Direct-Dev

Implement bounded repo work outside a formal Slice. No Slice, spec, UX design, architecture design, or verification matrix is required.

## Additional Context

- Load repo context and the contributor guide; project-root `DESIGN.md` if it exists — global UX patterns (palette, typography, component rules) to honor when work has a user-visible surface (project-root repo context, not BMILD planning memory, so the conditional below does not gate it).
- Load BMILD memory only when the request names an initiative, depends on documented behaviour, or might alter durable product or architecture understanding.
- If scope is unclear, ask one question for the smallest concrete target before proceeding.

## Global Directives

- **Discovery before invention**: Read the contributor guide and search the codebase for existing implementations before writing code. Match project patterns — only where the project actually has them.
- **Match repo patterns.** Read contributor guide and existing implementations before writing. Extend abstractions; do not bypass established layers.
- **Work classification** before implementing:
  - *Throwaway* — exploratory, disposable, not intended to persist
  - *Exploratory* — may inform a future spec; leaves reusable code or documented finding
  - *Durable* — changes production behaviour; others will build on it
- **Do not over-engineer** toward a spec that does not exist.
- **Promote durable truth.** When work changes durable repo behaviour or reveals facts future specs should account for: update `system-design.md` or `handoff.md` as appropriate. Throwaway work with no future relevance needs no BMILD artifact.
- **Route upstream decisions** per core Routing heuristics — do not resolve product, UX, or architecture choices unilaterally.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Classify work and groundtruth codebase per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 2: Implement smallest coherent change satisfying the request.
- [ ] Step 3: Run quality gates. Add or update tests when they prove the prototype, protect durable behaviour, or the user asked for tests.
- [ ] Step 4: Document when durable behaviour changes or user explicitly asks; otherwise `Documentation impact: none`.
- [ ] Step 5: Promote durable technical truth per Global Directives.
- [ ] Step 6: Pre-exit offer (conditional, declinable in one word) — when the prototype leaves a material trade-off, offer once: *"Before I wrap this — anything you want to stress-test? Otherwise I'll close it out."* Skip when no such trade-off remains.
- [ ] Step 7: Establish mode eligibility: completed bounded work, gate evidence or recorded unavailability, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the core non-zero posture close. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 8: Close — apply Exit and Handoff from the core skill. Route upstream when Routing heuristics apply.

## Definition of Done

- [ ] Implementation or prototype complete, or exact blocker and next owner recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Durable truth promoted or no BMILD artifact warranted
- [ ] Close message: files changed, gates run, documentation impact, next owner if any
