---
name: bmild-arch / architecture-refinement
description: "Refinement mode. Activated when system-design.md already exists. Extends or updates the existing design for new requirements or changed constraints."
---

## Architecture-Refinement Mode

Extend or update an existing `system-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

1. **Entry** — Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` in full — this is the contract you are modifying
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` for current requirements
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Identify refinement target** — Determine what has changed or what is being challenged. If the user has not specified, ask one question. Surface any existing Open Technical Questions in `system-design.md` before proceeding.

3. **Groundtruth** — Verify any new codebase reality relevant to the change. Check that the existing design still reflects the active runtime path — not deprecated or bypassed code.

4. **Synthesize and probe** — Present what appears settled, what the change affects, and what decisions are newly required. Apply all Design Standards from the core skill. Use compact option blocks for trade-offs. Do not silently absorb unresolved issues into the updated design.

   If live product or UX artifacts contain Architecture Handoff Questions targeted to Lance, resolve them in this refinement or explicitly defer them with user consent.

5. **Write** — Load `./resources/completion-criteria.yaml` and privately re-check the sections being modified. Update `[plan_folder]/<initiative-name>/system-design.md`. Update the `updated` frontmatter date. Use `assets/system-design-template.md` as a structural reference; preserve sections not being changed.

6. **Distillation gate** — Do any refined decisions qualify for distillation to `plans/ARCHITECTURE.md`? Apply the same gate as Architecture-Design mode: cross-initiative schema patterns, auth contracts, or shared infrastructure decisions only.

7. **Register in context memory** — Confirm `system-design.md` remains in `## Live` in `_context.md`. Move any superseded predecessor to `## Archived` if a new version was created.

8. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not just preserved
- [ ] Handoff Questions from Faisal or Katrina resolved in the design or explicitly deferred
- [ ] All Open Technical Questions resolved or explicitly deferred by user
- [ ] Updated `system-design.md` written; `updated` date current
- [ ] `ARCHITECTURE.md` updated if distillation gate triggered
- [ ] `_context.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, deferred risks, next owner
