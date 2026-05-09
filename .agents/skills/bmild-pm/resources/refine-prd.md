---
name: bmild-pm / refine-prd
description: "Refinement mode. Activated when both product-brief.md and prd.md exist, or when the user explicitly requests a refine/edit/update. Revisits and improves existing PM artifacts."
---

## Refine-PRD Mode

Revisit and improve existing PM artifacts. Probe what changed, challenge stale content, and update. Existing specs are a starting point to challenge, not a contract to honour.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` in full
   - [ ] `[plan_folder]/<initiative-name>/prd.md` in full (if it exists)
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Identify refinement target** — Determine what has changed or what is being challenged. If the user has not specified, ask one question. Possible triggers:
   - Scope has shifted since the brief was written
   - User needs or competitive context has changed
   - Downstream personas (Katrina, Lance) surfaced gaps that require product decisions
   - The user wants to stress-test or improve existing content

3. **Challenge** — Treat all existing content as a starting point. Probe what was assumed vs. what has been validated. Surface any unresolved Open Product Questions or assumptions that haven't been tested. Apply all Elicitation Standards from the core skill.

   If live UX or architecture artifacts contain Product Handoff Questions targeted to Faisal, resolve them in the refined spec or explicitly defer them with user consent.

4. **Elicit refinements** — Probe the specific sections requiring change. Apply the same depth and rigour as initial authoring. Do not skip elicitation because upstream work already exists.

5. **Write** — Load `./resources/brief-completion-criteria.yaml` and `./resources/prd-completion-criteria.yaml` and privately check each. Update the relevant artifacts. Use `assets/product-brief-template.md` and `assets/prd-template.md` as structural references. Preserve sections not being changed. Update the `updated` frontmatter date.

6. **Gate check** — Walk the user through any remaining Open Product Questions. Confirm all user-owned questions are resolved or explicitly deferred. Route UX or architecture gaps as Handoff Questions targeted to Katrina or Lance.

7. **Distillation gate** — Does the refined content change the product's fundamental vision, user model, or competitive position? If yes, update `plans/CHARTER.md`.

8. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Move any superseded predecessor to `## Archived`. Confirm `product-brief.md` and `prd.md` remain in `## Live`.

9. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done
- [ ] Refinement target identified and all relevant sections updated
- [ ] Existing content challenged, not just preserved
- [ ] Handoff Questions from Katrina or Lance resolved in the spec or explicitly deferred
- [ ] All Open Product Questions resolved or explicitly deferred by user
- [ ] Updated artifacts written; `updated` date current
- [ ] `CHARTER.md` updated if distillation gate triggered
- [ ] `_context.md` reflects current artifact state
- [ ] Close message: what changed, open/deferred items, next owner
