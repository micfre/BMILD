---
name: bmild-ux / ux-refinement
description: "Refinement mode. Activated when ux-design.md already exists. Extends or updates the existing UX design for new requirements or changed constraints."
---

## UX-Refinement Mode

Extend or update an existing `ux-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

1. **Entry** — Load in this order:
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/ux-design.md` in full — this is the design you are modifying
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` for current requirements
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Identify refinement target** — Determine what has changed or what is being challenged. If the user has not specified, ask one question. Surface any existing Open UX Questions in `ux-design.md` before proceeding.

   If live product or architecture artifacts contain UX Handoff Questions targeted to Katrina, resolve them in this refinement or explicitly defer them with user consent.

3. **Groundtruth** — Verify any new codebase reality relevant to the change. Check that existing patterns in `DESIGN.md` still constrain the refined design.

4. **Probe** — Present what appears settled, what the change affects, and what decisions are newly required. Apply all Design Standards from the core skill. Elicit before modifying; write at a meaningful checkpoint. Do not silently absorb unresolved issues.

5. **Write** — Load `./criteria/completion-criteria.yaml` and privately re-check the sections being modified. Update `[plan_folder]/<initiative-name>/ux-design.md`. Update the `updated` frontmatter date. Preserve sections not being changed.

6. **Distillation gate** — Do any refined decisions qualify for distillation to project-root `DESIGN.md`? Apply the same gate as UX-Design mode: global interaction principles and visual language decisions only.

7. **Register in context memory** — Confirm `ux-design.md` remains in `## Live` in `_context.md`. Move any superseded predecessor to `## Archived` if applicable.

8. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not just preserved
- [ ] Handoff Questions from Faisal or Lance resolved in the design or explicitly deferred
- [ ] All Open UX Questions resolved or explicitly deferred by user
- [ ] Updated `ux-design.md` written; `updated` date current
- [ ] `DESIGN.md` updated if distillation gate triggered
- [ ] `_context.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, deferred risks, next owner
