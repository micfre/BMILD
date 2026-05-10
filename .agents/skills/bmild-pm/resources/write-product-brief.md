---
name: bmild-pm / write-product-brief
description: "Entry mode for new initiatives. Elicits and documents the problem, users, competitive context, success criteria, scope, and vision into product-brief.md."
---

## Write-Product-Brief Mode

Elicit and document the product brief for a new initiative. This is the entry contract for all downstream design work.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists — constrains product vision and competitive positioning
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] Do not load other initiative folders or `## Archived` entries

   If none exist, you are starting fresh.

2. **Groundtruth** — Before accepting any premise, quickly verify the current state of the codebase. Identify any existing implementation that shapes the product context. Do not invent greenfield solutions in a brownfield environment.

3. **Elicit** — Probe sequentially through the `assets/product-brief-template.md` sections. Do not dump all questions at once. Establish the problem and success criteria before asking about features. Apply all Elicitation Standards from the core skill. For each section, surface one open question at a time; group only when questions are clearly inter-related.

4. **Consequence-check** — Before writing, privately verify:
   - [ ] Core problem and who feels it is explicit
   - [ ] Target users are named, not generic
   - [ ] At least one success criterion is measurable
   - [ ] Scope is a tight boundary, not a feature list
   - [ ] Open Product Questions have target responder, status, recommendation, and consequence if deferred

5. **Write** — Write `[plan_folder]/<initiative-name>/product-brief.md` using `assets/product-brief-template.md`. Substitute `[user_name]` from `.bmild.toml`.

6. **Distillation gate** — Does this initiative establish, modify, or conflict with the product's fundamental vision, user model, or competitive position in a way that future unrelated initiatives must align with? If yes, write or update `plans/CHARTER.md` using `assets/charter-template.md`. If no, proceed without writing to the canonical tier.

7. **Register in context memory** — Open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `product-brief.md` to `## Live`.

8. **Close** — Apply the Exit and Handoff format from the core skill. Offer to continue into Write-PRD mode or hand off to Katrina or Lance.

---

## Definition of Done

- [ ] Problem, target users, competitive context, success criteria, scope, and vision are documented
- [ ] Open Product Questions have target responder, status, recommendation, and consequence if deferred
- [ ] `product-brief.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `CHARTER.md` updated if distillation gate triggered
- [ ] `_context.md` updated with `product-brief.md` in `## Live`
- [ ] Close message: artifacts written, open/deferred items, next owner
