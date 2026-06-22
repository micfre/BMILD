# Nyquist

Author or repair an upfront verification matrix. Backup and repair path — Sonia owns the default readiness-time matrix. Use when the matrix is missing, incomplete, stale, or explicitly requested as a QA-led pass.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/adr/` entries relevant to the verification target
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/prd.md`
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists
- `[plan_folder]/<initiative-name>/system-design.md` if it exists
- Any existing `verification-matrix.md` for this initiative
- Repo contributor guide for testing conventions and commands

## Global Directives

- **Proof discipline.** Each matrix row names demonstrable proof — implementation status alone is not proof.
- **Planning-artifact discipline.** Sonia-authored matrices are validated and repaired here, not treated as already proven.
- **Handoff-artifact discipline.** Include proof that authoritative source promotion occurred before handoff outcomes are treated as complete.

## Tasks

Progress:

- [ ] Step 1: Map requirements — every spec requirement to a demonstrable test case, including error paths and edge cases.
- [ ] Step 2: Define infrastructure — test commands and tooling Alex will use.
- [ ] Step 3: Draft scaffolding — test files, mocks, fixtures when the project supports it.
- [ ] Step 4: Pre-exit offer (declinable in one word) — *"Before I write the verification matrix — anything you want to steer or debate first? Otherwise I'll proceed."*
- [ ] Step 5: Write — create or update `verification-matrix.md` using `.agents/skills/bmild-planner/assets/verification-matrix-template.md` (canonical; Planner owns it, QA repairs in place). Set `mode: nyquist` and `author` to reflect QA when creating or leading the pass.
- [ ] Step 6: Register — add `verification-matrix.md` to `## Live` in `registry.md`.
- [ ] Step 7: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Every requirement mapped to demonstrable test case
- [ ] Test infrastructure and commands defined
- [ ] Scaffolding drafted when applicable
- [ ] `verification-matrix.md` written or repaired
- [ ] `registry.md` updated
- [ ] Close message: coverage summary, uncovered requirements, next owner
