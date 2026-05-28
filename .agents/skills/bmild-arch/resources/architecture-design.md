# Architecture-Design

Design the system for a new initiative. Produce concrete, implementable contracts — not high-level diagrams.

## Additional Context

Load in this order:
- Relevant ADRs in `[plan_folder]/adr/` if they exist
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists — interaction and user-state contract inputs
- `./resources/completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

If no `product-brief.md` or `prd.md` exists: probe for key requirements before proceeding.

## Stakes-based elicitation

Per-section `stakes` in `completion-criteria.yaml` sets elicitation depth. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/costs and a conditional recommendation. Pushback or hedging keeps the section here. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Session pacing:** After loading YAML, partition in-scope sections by effective stakes. **Diverge** on consequential sections first (`database_schema`, `api_contracts`, `service_contracts`, `architecture_decisions` when applicable, `fr_coverage`). **Synthesize** medium sections (`tech_stack`, `dependency_decisions` when applicable) and low sections (`ambiguity_disposition` when applicable). Run internal platform concerns (observability, failure modes, deployment) during consequence-check against template gaps, not as a separate stakes walk. **Reopen** any synthesized section the user steers back to consequential pacing.

## Global Directives

- **Hydrate before eliciting.** Read PM and UX artifacts before architecture questions. Treat explicit upstream contracts as settled unless they conflict with implementability, security, platform constraints, or each other.
- **Pressure-test before proposing.** Groundtruth per core NON-NEGOTIABLES; distinguish active paths from abandoned prior art.
- **Converse before committing.** First substantive response after loading is a synthesis, not the final artifact.
- **Every architecture decision has an observable implementation consequence.** If two options produce the same observable behavior, label the choice a preference.
- **Schema changes flow through the repo's code-first migration workflow.** Never produce hand-written SQL.
- **UI component library selection is a tech stack decision owned here, not by Katrina.**
- **Naked assumptions are forbidden in artifacts.** Format: `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** Cross-artifact issues route through `handoff.md`. Architecture truth changes only after source promotion.

## ADR distillation gate

When `system-design.md` contains decisions — schema patterns, auth contracts, shared infrastructure — that **future unrelated initiatives must build against**, distill them into `[plan_folder]/adr/` using `assets/adr-template.md`. Local endpoint shapes, initiative-specific data models, and one-off implementation choices do not qualify.

## Tasks

Progress:

- [ ] Step 1: Hydrate — read PM and UX artifacts per Additional Context. Extract settled requirements, UX state contracts, and architecture-only gaps.
- [ ] Step 2: Groundtruth — scan implementation per core NON-NEGOTIABLES before proposing architecture.
- [ ] Step 3: Synthesize — summarize what is settled, what UX states imply for API/data boundaries, what conflicts exist, and what needs a decision. Ask the smallest useful architecture question before committing.
- [ ] Step 4: Elicit (diverge → synthesize → steer) — apply Stakes-based elicitation:
  - **Open with the architecture contour.** Name in-scope sections grouped by YAML `stakes`.
  - **Diverge on consequential sections** one question per turn until each passes its YAML weak_signal check. Use compact option blocks for genuine trade-offs only.
  - **Synthesize medium and low sections** in one block; ask the user to redirect, accept, or escalate.
  - **Reopen only what the user steers.** Route cross-artifact issues through `handoff.md` using `.agents/skills/bmild-pm/assets/handoff-template.md` when another owner must act.
- [ ] Step 5: Consequence-check — verify all in-scope YAML sections; privately confirm schema, API, service, dependency, and platform checklist items from `assets/system-design-template.md` are covered.
- [ ] Step 6: Pre-exit offer (declinable in one word) — *"Before I write the system design — anything you want to take to roundtable or stress-test first? Otherwise I'll proceed."* Offer advanced facilitator skills per core Advanced Elicitation Triggers when trade-offs are still open.
- [ ] Step 7: Write — write `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`.
- [ ] Step 8: ADR distillation gate — apply ADR distillation rules when triggered.
- [ ] Step 9: Register — open or create `[plan_folder]/<initiative-name>/registry.md` from `.agents/skills/bmild-pm/assets/registry-template.md`. Add `system-design.md` to `## Live`.
- [ ] Step 10: Gate check — resolve remaining architecture ambiguity in chat or route product/UX gaps through `handoff.md`. Do not leave durable question threads in `system-design.md`.
- [ ] Step 11: Close — apply Exit and Handoff from the core skill. Default `Next` to Sonia; if `ux-design.md` is still missing for a named initiative, route to Katrina instead.

## Definition of Done

- [ ] All architecture decisions have observable implementation consequences
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Schema, API, service, dependency, and platform decisions specific enough for Alex to implement without architectural choices
- [ ] `system-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] ADRs updated only if distillation gate fired
- [ ] `registry.md` updated with `system-design.md` in `## Live`
- [ ] Remaining ambiguity routed through `handoff.md` or bounded assumptions
- [ ] Close message: key decisions, trade-offs, queued or deferred governance items, next owner
