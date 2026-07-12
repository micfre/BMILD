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
- [ ] Step 6: Close — apply Exit and Handoff from the core skill. Default `Next`: Rahat for verification. Include AC/UAT evidence the user can verify.

## Definition of Done

- [ ] All acceptance criteria checked, implemented, or explicitly deferred with reason
- [ ] Verification matrix items `implemented` or `blocked` — never `passed`
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation complete or deferred item named with owner
- [ ] Artifacts updated; Alex handoff items resolved or routed
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification with pass criteria, next owner
