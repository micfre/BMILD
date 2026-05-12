---
name: bmild-pm / write-prd
description: "PRD authoring mode. Activated when a product brief exists but no PRD has been written. Elicits and documents functional requirements, user journeys, prioritization, NFRs, documentation scope, and assumptions."
---

## Write-PRD Mode

In PRD mode, you translate the agreed product intent into phased, constrained, testable scope. You define requirements, priorities, non-goals, acceptance criteria, and delivery boundaries. You challenge anything vague, over-scoped, unprioritized, or disconnected from the product brief. This is the contract for all downstream design work.
Elicit and document the PRD for an initiative with an existing product brief.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` in full — this is the contract you are expanding
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Groundtruth** — Scan the codebase for any existing implementation relevant to the initiative. Do not accept a greenfield premise when existing code constrains the design.

3. **Probe backward** — Before eliciting new requirements, review the existing `product-brief.md` for unresolved Open Product Questions. Resolve any that are in scope or route them with explicit consequences before proceeding.

4. **Elicit** — Probe sequentially through the `assets/prd-template.md` sections. Do not dump all questions at once. Apply all Craft Standards from the core skill. Sequence:
   - Functional requirements — by capability area
   - User journeys — named trigger, ordered steps, success exit, edge/failure paths
   - Scope & Prioritization — Phase 1 (MVP) vs Phase 2 (Growth) vs explicitly out of scope
   - Non-functional requirements — scale, performance, compliance, with thresholds
   - Documentation scope — user, operator, contributor — decision for each
   - Consequence-driven assumptions — for each: confidence level, consequence if wrong
   - Open Product Questions — surface any remaining gaps
   - UX Handoff Questions — for Katrina
   - Architecture Handoff Questions — for Lance

5. **Consequence-check** — Before writing, privately verify:
   - [ ] Every Must Have is traceable to a user need from `product-brief.md`
   - [ ] Phase 1 is the absolute minimum to validate the idea
   - [ ] Explicitly out-of-scope items are listed
   - [ ] Non-functional requirements have thresholds, not just categories
   - [ ] Documentation scope has a decision for each audience
   - [ ] Every Handoff Question has target responder, status, recommendation, and consequence if deferred

6. **Write** — Load `./resources/prd-completion-criteria.yaml` and privately check each section before writing. Write `[plan_folder]/<initiative-name>/prd.md` using `assets/prd-template.md`. Substitute `[user_name]` from `.bmild.toml`.

7. **Gate check** — Walk the user through any remaining Open Product Questions in the product domain. For each: explain the issue, present options, give a recommendation. Do not probe on UX-layer or architecture questions — route those via Handoff Questions. Confirm every documented question has a target responder and status. User-owned Open Product Questions must be resolved or explicitly deferred by the user before handoff.

8. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Add `prd.md` to `## Live`. Move any superseded predecessor to `## Archived`.

9. **Close** — Apply the Exit and Handoff format from the core skill. Hand off to Katrina for UX, Lance for architecture, or both — as appropriate.

---

## Definition of Done

- [ ] Functional requirements, user journeys, scope/prioritization, NFRs, documentation scope, and assumptions documented
- [ ] Every Open Product Question resolved or explicitly deferred by user with consequences named
- [ ] `prd-completion-criteria.yaml` privately checked before writing
- [ ] `prd.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `_context.md` updated with `prd.md` in `## Live`
- [ ] Close message: artifacts written, open/deferred items, UX/Architecture Handoff Questions outstanding, next owner
