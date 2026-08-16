# Project Bearing

Answer one project-level question: **what bearing should we take next?** A bearing is both direction toward the project destination and the work that carries the most useful downstream load. This mode is not an initiative plan, decision-ticket system, backlog grooming session, or execution gate.

## Additional Context

Load in this order:

- Project-root `README.md` or equivalent product statement if it exists.
- `[plan_folder]/rollup.md` in full as an index, not as unquestioned truth.
- `[plan_folder]/context-map.md` in full if it exists.
- Every immediate initiative directory with a `registry.md`; read each registry before trusting the rollup's initiative status.
- For each live or paused initiative relevant to a plausible bearing, load only the current summary surface from its live artifacts: product scope or requirements, current roadmap/readiness, open verification or RCA outcome, and any named future direction. Do not load archived artifacts.
- Recent repository history and current repository evidence needed to test a candidate direction. Use code intelligence before broad searches when it is available.

If the rollup conflicts with a registry or current artifact, name the mismatch and reason from the live source. Repairing a stale summary may be a side effect of recording a user-selected bearing; it is never the bearing by itself.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Ground project reality before recommending direction.** A visible UI opportunity does not outrank integrity, operationalization, evidence, or a dependency merely because it feels rewarding.
- **Think in lifts, not task inventories.** A candidate bearing is an outcome that may later create, resume, or redirect one or more initiatives. It is not a Slice, an issue list, or a mandatory process gate.
- **Keep uncertainty proportionate.** Surface only unknowns that could change the recommendation. Do not manufacture a tree of future decisions, tickets, claims, fog, or a separate backlog.
- **Prefer qualitative judgment to false precision.** Compare what each option unlocks, what load it bears, its cost or risk, and what would overturn it. Do not score options numerically unless the project already has an accepted decision model.
- **User authority is explicit.** Project direction is consequential: recommend one bearing, then wait for the user's selection or correction before recording it or starting downstream work.
- **Preserve artifact authority.** The bearing records direction and rationale in `rollup.md`; product, UX, architecture, delivery, verification, and security truth remain in their owning artifacts.

## Tasks

Progress:

- [ ] Step 1: Orient — state the project's destination and present position in one or two evidence-backed sentences. Distinguish current truth from stale rollup claims.
- [ ] Step 2: Form 2–4 genuinely distinct candidate bearings. Include an existing initiative when it already carries the direction; otherwise describe the outcome without prematurely minting an initiative.
- [ ] Step 3: Compare each candidate in a compact block:
  - Direction and likely initiative relation
  - What it unlocks or protects
  - Why it is load-bearing now
  - Principal cost, risk, or opportunity forgone
  - Specific evidence that would overturn the choice
- [ ] Step 4: Recommend one bearing conditionally. Name why the alternatives are not first, not merely why they are valid.
- [ ] Step 5: Ask the user to select, modify, or reject the recommendation. Do not write a bearing or begin initiative work before that response.
- [ ] Step 6: On selection, update `[plan_folder]/rollup.md`:
  - Add or replace `## Current Bearing` with `Direction`, `Why now`, `Set`, and `Reconsider when`.
  - Append one concise `## Decision Log` line when the choice has durable cross-initiative value.
  - Preserve Sonia's Initiative Registry and unrelated history.
- [ ] Step 7: Determine the continuation from current initiative state, then make **one declinable offer**. Never make a handoff item merely because the user declines.
  - **No existing initiative:** offer to create one and continue into Write-Product-Brief. Do not create the folder or normalize a slug here; on acceptance, enter `resources/write-product-brief.md`, whose existing initiative-naming step confirms a kebab-case slug before writing.
  - **Existing initiative with no `product-brief.md`:** offer Write-Product-Brief.
  - **Existing initiative with `product-brief.md` but no `prd.md`:** offer Write-PRD.
  - **Existing initiative whose problem, users, success criteria, scope boundary, or vision changes:** offer Refine-Brief.
  - **Existing initiative whose requirements, phase priority, journeys, NFRs, or documentation scope changes:** offer Refine-PRD.
  - **Independent source-artifact consequences across owners:** run separate gap-resolution episodes; multiple owners alone do not justify Course-Correction.
  - **Coupled consequences that materially alter scope, sequencing, or proof boundaries:** offer Sonia Course-Correction once. On acceptance, carry a transient continuation packet — selected bearing, why now, target initiative, rejected alternatives, reconsideration condition, and suspected affected artifacts — into Sonia's session. User acceptance authorizes the transition; it does not create a `handoff.md` item or skip normal Course-Correction reads.
  - **Existing artifacts already express the bearing:** do not manufacture an edit. Offer the genuinely appropriate downstream owner or let the user stop.
- [ ] Step 8: If the user accepts a Faisal continuation, load the selected resource and continue in the same session without a closing block, a second Opening Stance, or repeated groundtruth. If the user accepts Course-Correction, activate Sonia with the continuation packet; Sonia opens once in her own voice and follows normal Course-Correction. If the user declines, close with the bearing recorded and a clear later re-entry point.

## Definition of Done

- [ ] Project destination and present position grounded against live initiative state
- [ ] Any rollup-versus-live-state contradiction surfaced
- [ ] 2–4 distinct load-bearing bearings compared with overturn conditions
- [ ] One conditional recommendation and user selection request presented
- [ ] A selected bearing recorded only after user choice
- [ ] One declinable, state-appropriate continuation offer made
- [ ] Accepted continuation preserves the chosen bearing; declined continuation creates no artificial governance work
