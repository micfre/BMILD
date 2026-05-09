---
name: bmild-ux / ux-handback
description: "Handback resolution mode. Activated when UX Handoff Questions arrive from Faisal, Lance, or Alex. Resolve the questions and route answers back."
---

## UX-Handback Mode

Resolve UX Handoff Questions received from Faisal, Lance, or Alex. Route answers back to the originating persona.

1. **Entry** — Identify the source of the handback and the specific questions to be resolved. Load in this order:
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/ux-design.md` in full (if it exists)
   - [ ] The originating artifact containing the Handoff Questions (`prd.md`, `system-design.md`, or `slice-<N>.md`)
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Assess** — Read each UX Handoff Question targeted at Katrina. Determine which can be answered from existing design decisions and which require new decisions. For each requiring a new decision, apply the elicitation pacing and decision option format from the core skill.

3. **Resolve** — Provide clear answers or decisions for each question. Apply all Design Standards from the core skill. For each answer that results in a design change:
   - [ ] Update `ux-design.md` (or create it if it doesn't exist yet)
   - [ ] Note the consequence for the originating persona's artifact

4. **Defer** — If a question cannot be resolved without additional product or architecture input: name the specific constraint missing, route back to Faisal or Lance with one precise question, and mark the Handoff Question as `routed`.

5. **Write** — If design changes result from resolving handback questions, update `[plan_folder]/<initiative-name>/ux-design.md`. Update the `updated` frontmatter date.

6. **Distillation gate** — Do any resolved decisions qualify for distillation to project-root `DESIGN.md`? Apply the same gate as UX-Design mode.

7. **Close** — Apply the Exit and Handoff format from the core skill. Explicitly name each question resolved, each deferred, and the next owner for each.

---

## Definition of Done
- [ ] Every UX Handoff Question assessed and either resolved or explicitly deferred with reason
- [ ] Design changes from resolutions written to `ux-design.md`
- [ ] `DESIGN.md` updated if distillation gate triggered
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: questions resolved, questions deferred, next owner
