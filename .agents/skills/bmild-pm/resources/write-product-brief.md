---
name: bmild-pm / write-product-brief
description: "Entry mode for new initiatives. Elicits and documents the problem, users, competitive context, success criteria, scope, and vision into product-brief.md."
---

## Write-Product-Brief Mode

In product brief mode, you help the user articulate the product vision, capability posture, user value, strategic rationale, and longer-horizon direction. The user owns the vision; you own making it explicit, coherent, weighted, and durable.
Elicit and document the product brief for a new initiative.

1. **Entry** — Load in this order:
   - [ ] `README.md` at the project root if it exists — anchors product context and audience
   - [ ] `plans/CHARTER.md` if it exists — constrains product vision and competitive positioning (emergent; absent on most projects)
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] Do not load other initiative folders or `## Archived` entries

   If none exist, you are starting fresh.

2. **Groundtruth** — Before accepting any premise, quickly verify the current state of the codebase. Identify any existing implementation that shapes the product context. Do not invent greenfield solutions in a brownfield environment.

3. **Elicit** — Probe sequentially through the `assets/product-brief-template.md` sections. Do not dump all questions at once. Establish the problem and success criteria before asking about features. Apply all Craft Standards from the core skill. For each section, surface one open question at a time; group only when questions are clearly inter-related.

4. **Consequence-check** — Before writing, privately verify:
   - [ ] Core problem and who feels it is explicit
   - [ ] Target users are named, not generic
   - [ ] At least one success criterion is measurable
   - [ ] Scope is a tight boundary, not a feature list
   - [ ] Open Product Questions have target responder, status, recommendation, and consequence if deferred

5. **Write** — Write `[plan_folder]/<initiative-name>/product-brief.md` using `assets/product-brief-template.md`. Substitute `[user_name]` from `.bmild.toml`.

6. **Distillation gate (emergent CHARTER):** `plans/CHARTER.md` is not authored by default. Seed or update it only when **at least one** of the following is true:
   - This initiative's product-brief conflicts with an existing sibling initiative's product-brief (cross-initiative contradiction).
   - This initiative establishes a project-level invariant — vision, target user model, or competitive positioning — that future unrelated initiatives must align with.
   - The user explicitly asks for project-level vision/positioning to be captured.

   If the gate fires, write or update `plans/CHARTER.md` using `assets/charter-template.md` and append an entry to its Distillation Log. If the gate does not fire, do not write to the canonical tier.

7. **Register in context memory** — Open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `product-brief.md` to `## Live`.

8. **Close** — Apply the Exit and Handoff format from the core skill. Offer to continue into Write-PRD mode or hand off to Katrina or Lance.

---

## Definition of Done

- [ ] Problem, target users, competitive context, success criteria, scope, and vision are documented
- [ ] Open Product Questions have target responder, status, recommendation, and consequence if deferred
- [ ] `product-brief.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `CHARTER.md` seeded or updated only if the distillation gate fired (cross-initiative conflict, new project-level invariant, or explicit user request)
- [ ] `_context.md` updated with `product-brief.md` in `## Live`
- [ ] Close message: artifacts written, open/deferred items, next owner
