# Nyquist

Author or repair an upfront verification matrix. Backup and repair path — Sonia owns the default readiness-time matrix. Use when the matrix is missing, incomplete, stale, or explicitly requested as a QA-led pass.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/adr/` entries relevant to the verification target
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- Relevant live source requirements for the authorized phase/outcome (PRD or other sufficient governing contract)
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists
- `[plan_folder]/<initiative-name>/system-design.md` if it exists
- Any existing `verification-matrix.md` for this initiative
- Repo contributor guide for testing conventions and commands

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Proof discipline.** Each matrix row names demonstrable proof — implementation status alone is not proof.
- **Planning-artifact discipline.** Sonia-authored matrices are validated and repaired here, not treated as already proven.
- **Handoff-artifact discipline.** Include proof that authoritative source promotion occurred before handoff outcomes are treated as complete.

## Tasks

Progress:

- [ ] Step 1: Map requirements — every spec requirement to a demonstrable test case, including error paths and edge cases.
- [ ] Step 2: Define infrastructure — test commands and tooling Alex will use.
- [ ] Step 3: Draft scaffolding — test files, mocks, fixtures when the project supports it.
- [ ] Step 4: Check coverage directly against the authorized phase/outcome, including proof obligations omitted from an existing matrix; preserve other outcomes and current evidence.
- [ ] Step 5: Write — create or update `verification-matrix.md` using `.agents/skills/bmild-planner/assets/verification-matrix-template.md` (canonical; Planner owns it, QA repairs in place). Record QA authorship where applicable; keep source obligations separate from implementation and independent proof. No Slice is required.
- [ ] Step 6: Register — add `verification-matrix.md` to `## Live` in `registry.md`.
- [ ] Step 7: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Every requirement mapped to demonstrable test case
- [ ] Test infrastructure and commands defined
- [ ] Scaffolding drafted when applicable
- [ ] `verification-matrix.md` written or repaired
- [ ] `registry.md` updated
- [ ] Close message: coverage summary, uncovered requirements, next owner
