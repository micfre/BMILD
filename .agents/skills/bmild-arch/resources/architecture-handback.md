---
name: bmild-arch / architecture-handback
description: "Handback resolution mode. Activated when Architecture Handoff Questions arrive from Faisal, Katrina, or Alex. Resolve the questions and route answers back."
---

## Architecture-Handback Mode

Resolve Architecture Handoff Questions received from Faisal, Katrina, or Alex. Route answers back to the originating persona.

1. **Entry** — Identify the source of the handback and the specific questions to be resolved. Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` in full
   - [ ] The originating artifact containing the Handoff Questions (`prd.md`, `ux-design.md`, or `slice-<N>.md`)
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Assess** — Read each Architecture Handoff Question targeted at Lance. Determine which can be answered from existing design decisions and which require new decisions. For each requiring a new decision, apply the Decision Trade-offs format from the core skill — compact option blocks, not unstructured prose.

3. **Resolve** — Provide clear answers or decisions for each question. Apply all Craft Standards from the core skill. For each answer that results in a design change:
   - [ ] Update `system-design.md` with the decision
   - [ ] Note the consequence for the originating persona's artifact

4. **Defer** — If a question cannot be resolved without additional product or UX input: name the specific constraint missing, route back to Faisal or Katrina with one precise question, and mark the Handoff Question as `routed`.

5. **Write** — If design changes result from resolving handback questions, update `[plan_folder]/<initiative-name>/system-design.md`. Update the `updated` frontmatter date.

6. **Distillation gate** — Do any resolved decisions qualify for distillation to `plans/ARCHITECTURE.md`? Apply the same gate as Architecture-Design mode.

7. **Close** — Apply the Exit and Handoff format from the core skill. Explicitly name each question resolved, each deferred, and the next owner for each.

---

## Definition of Done

- [ ] Every Architecture Handoff Question assessed and either resolved or explicitly deferred with reason
- [ ] Design changes from resolutions written to `system-design.md`
- [ ] `ARCHITECTURE.md` updated if distillation gate triggered
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: questions resolved, questions deferred, next owner
