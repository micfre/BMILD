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
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. Pushback or hedging keeps the section here. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Session pacing:** After loading YAML, partition in-scope sections by effective stakes. **Diverge** on consequential sections first (`database_schema`, `api_contracts`, `service_contracts`, `architecture_decisions` when applicable, `fr_coverage`). **Synthesize** medium sections (`tech_stack`, `dependency_decisions` when applicable) and low sections (`ambiguity_disposition` when applicable). Run internal platform concerns (observability, failure modes, deployment) during consequence-check against template gaps, not as a separate stakes walk. **Reopen** any synthesized section the user steers back to consequential pacing.

**Expert compression:** When the user demonstrably gives crisp, complete answers for a consequential section, I may replace one-question-at-a-time pacing with one confirmation synthesis. Keep consequential pacing for ambiguity, material trade-offs, or missing evidence.

## Global Directives

- **Discovery before invention**: Before accepting a greenfield architecture premise, groundtruth the codebase. Distinguish active runtime paths from abandoned prior art.
- **Hydrate before eliciting.** Read PM and UX artifacts before architecture questions. Treat explicit upstream contracts as settled unless they conflict with implementability, security, platform constraints, or each other.
- **Pressure-test before proposing.** Distinguish active paths from abandoned prior art per Global Directives.
- **Trade-off vocabulary.** At decision and pressure-test moments, use `one-way-door`, `reversible`, `contract drift`, or `load-bearing` when they clarify the trade-off, not as a required frame.
- **Converse before committing.** First substantive response after loading is a synthesis, not the final artifact.
- **Every architecture decision has an observable implementation consequence.** If two options produce the same observable behavior, label the choice a preference.
- **Schema changes flow through the repo's code-first migration workflow.** Never produce hand-written SQL.
- **UI component library selection is a tech stack decision owned here, not by Katrina.**
- **Naked assumptions are forbidden in artifacts.** Format: `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** Cross-artifact issues route through `handoff.md`. Architecture truth changes only after source promotion.

## Distillation gates

**Drift-protection ADR gate.** When a Key Decision in `system-design.md` §2 passes the triple-axis test — hard to reverse, surprising without context, and the result of a real trade-off — extract a terse drift-protection ADR into `[plan_folder]/adr/` using `assets/adr-template.md` (set `scope:` to the initiative or `_cross`). Local endpoint shapes, initiative-specific data models, and one-off implementation choices do not qualify. Cross-initiative commitments commonly qualify; an initiative-local decision that is surprising and hard to reverse also qualifies. See the template for the full gate and what commonly qualifies.

**Semantic Memory.** When initiative-local meaning becomes stable during this session:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities. Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when this initiative establishes or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Hydrate — read PM and UX artifacts per Additional Context. Extract settled requirements, UX state contracts, and architecture-only gaps.
- [ ] Step 2: Groundtruth — scan implementation per Global Directives before proposing architecture.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 3: Synthesize — summarize what is settled, what UX states imply for API/data boundaries, what conflicts exist, and what needs a decision. Ask the smallest useful architecture question before committing.
- [ ] Step 4: Elicit (diverge → synthesize → steer) — apply Stakes-based elicitation:
  - **Open with the architecture contour.** Name in-scope sections grouped by YAML `stakes`.
  - **Diverge on consequential sections** one question per turn until each passes its YAML weak_signal check. Use compact option blocks for genuine trade-offs only.
  - **Synthesize medium and low sections** in one block; ask the user to redirect, accept, or escalate.
  - **Reopen only what the user steers.** Route cross-artifact issues through `handoff.md` using `.agents/skills/bmild-pm/assets/handoff-template.md` when another owner must act.
- [ ] Step 5: Consequence-check — verify all in-scope YAML sections; privately confirm schema, API, service, dependency, and platform checklist items from `assets/system-design-template.md` are covered.
- [ ] Step 6: Pre-exit offer (declinable in one word) — *"Before I write the system design — anything you want to take to roundtable or stress-test first? Otherwise I'll proceed."* Offer advanced facilitator skills per core Advanced Elicitation Triggers when trade-offs are still open.
- [ ] Step 7: Write — write `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`.
  - **Initiative naming.** Initiative names are lowercase-kebab-case identifiers (e.g. `py-tokenizer`) — safe across filesystems, shells, and links. If the user supplies a kebab-case-compliant slug, use it directly. Otherwise confirm a kebab-case slug with the user before writing; never silently transform a proposed name.
- [ ] Step 8: Distillation gates — apply the Drift-protection ADR gate and Semantic Memory rules when triggered.
- [ ] Step 9: Register — open or create `[plan_folder]/<initiative-name>/registry.md` from `.agents/skills/bmild-pm/assets/registry-template.md`. Add `system-design.md` to `## Live`.
- [ ] Step 10: Gate check — resolve remaining architecture ambiguity in chat or route product/UX gaps through `handoff.md`. Do not leave durable question threads in `system-design.md`.
- [ ] Step 11: Close — apply Exit and Handoff from the core skill. Default `Next` to Sonia; if `ux-design.md` is still missing for a named initiative, route to Katrina instead.

## Definition of Done

- [ ] All architecture decisions have observable implementation consequences
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Schema, API, service, dependency, and platform decisions specific enough for Alex to implement without architectural choices
- [ ] `system-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] Drift-protection ADR extracted into `[plan_folder]/adr/` only if the triple-axis gate fired
- [ ] `context.md` and/or `context-map.md` updated only if the semantic gate fired
- [ ] `registry.md` updated with `system-design.md` in `## Live`
- [ ] Remaining ambiguity routed through `handoff.md` or bounded assumptions
- [ ] Close message: key decisions, trade-offs, queued or deferred governance items, next owner
