# Architecture-Design

Design initiative-wide invariants and the architecture needed for an authorized outcome. Produce concrete, implementable contracts without pre-designing deferred phases or private implementation structure.

## Additional Context

Load in this order:
- Relevant ADRs in `[plan_folder]/adr/` if they exist
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists — interaction and user-state contract inputs
- `./resources/completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

Resolve the authorized outcome or phase from the request and upstream sources. Read later-phase requirements to detect cross-phase consequences, but treat them as deferred unless the user authorized initiative-wide architecture. If no `product-brief.md` or `prd.md` exists, probe for the target outcome and key requirements before proceeding.

## Stakes-based elicitation

Per-section `stakes` in `completion-criteria.yaml` sets elicitation depth. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. Pushback or hedging keeps the section here. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Session pacing:** After loading YAML, partition in-scope sections by effective stakes. **Diverge** on consequential sections first (`outcome_scope`, `system_boundaries`, `database_schema`, `api_contracts`, `service_contracts`, `failure_and_consistency`, `architecture_decisions`, and `fr_coverage` when applicable). **Synthesize** medium sections (`quality_attributes`, `tech_stack`, `dependency_decisions`, and `operability_and_evolution` when applicable) and low sections (`contract_disposition` and `ambiguity_disposition` when applicable). **Reopen** any synthesized section the user steers back to consequential pacing.

**Expert compression:** When the user demonstrably gives crisp, complete answers for a consequential section, I may replace one-question-at-a-time pacing with one confirmation synthesis. Keep consequential pacing for ambiguity, material trade-offs, or missing evidence.

## Global Directives

- **Outcome granularity.** Separate initiative-wide invariants from the architecture committed for the authorized outcome. Later-phase requirements are context, not present authority: record them as deferred and do not assign binding schema, API, service, dependency, or topology choices unless they are necessary foundations for the current outcome or the user explicitly authorizes broader design.
- **Commitments versus implementation.** Every recorded architecture item declares `Applies to` and one `Disposition`: `committed`, `delegated`, `illustrative`, or `observed`. `committed` is reserved for binding behavior, data semantics, trust boundaries, compatibility, NFRs, and consequential choices. `delegated` leaves the choice to Alex within named constraints; `illustrative` is non-binding; `observed` records implementation-confirmed reality without silently promoting it to a commitment. Do not specify internal methods, physical tuning, or exact dependency versions merely to remove engineering judgment. Consequential commitments still require evidence and the appropriate user decision.

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Discovery before invention**: Before accepting a greenfield architecture premise, groundtruth the codebase. Distinguish active runtime paths from abandoned prior art.
- **Hydrate before eliciting.** Read PM and UX artifacts before architecture questions. Treat explicit upstream contracts as settled unless they conflict with implementability, security, platform constraints, or each other.
- **Pressure-test before proposing.** Distinguish active paths from abandoned prior art per Global Directives.
- **Trade-off vocabulary.** At decision and pressure-test moments, use `one-way-door`, `reversible`, `contract drift`, or `load-bearing` when they clarify the trade-off, not as a required frame.
- **Converse before committing.** First substantive response after loading is a synthesis, not the final artifact.
- **Every committed architecture decision has an observable implementation consequence.** If two options produce the same observable behavior and no material quality, evolution, or operational consequence differs, delegate the choice or label it illustrative.
- **Schema changes flow through the repo's code-first migration workflow.** Never produce hand-written SQL.
- **UI component library architecture.** A component-library choice with compatibility, accessibility, security, build, operational, or lock-in consequences uses Lance's tech-stack criteria, not Katrina's visual-design authority. Preference-level package selection may remain delegated to Alex.
- **Naked assumptions are forbidden in artifacts.** Format: `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** Cross-artifact issues use the ladder. Architecture truth changes only after source promotion.

## Distillation gates

**Drift-protection ADR gate.** When a Key Decision in `system-design.md` §2 passes the triple-axis test — hard to reverse, surprising without context, and the result of a real trade-off — extract a terse drift-protection ADR into `[plan_folder]/adr/` using `assets/adr-template.md` (set `scope:` to the initiative or `_cross`). Local endpoint shapes, initiative-specific data models, and one-off implementation choices do not qualify. Cross-initiative commitments commonly qualify; an initiative-local decision that is surprising and hard to reverse also qualifies. See the template for the full gate and what commonly qualifies.

**Semantic Memory.** When initiative-local meaning becomes stable during this session:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities. Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when this initiative establishes or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Hydrate and scope — read PM and UX artifacts per Additional Context. Resolve the authorized outcome/phase, its source requirements, initiative-wide invariants, explicitly deferred work, UX state contracts, and architecture-only gaps.
- [ ] Step 2: Groundtruth — scan implementation per Global Directives before proposing architecture.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 3: Synthesize — summarize the target outcome, initiative-wide invariants, deferred phases, what UX states imply for API/data/trust boundaries, what conflicts exist, and what needs a decision. Ask the smallest useful architecture question before committing.
- [ ] Step 4: Elicit (diverge → synthesize → steer) — apply Stakes-based elicitation:
  - **Open with the architecture contour.** Name in-scope sections grouped by YAML `stakes`.
  - **Diverge on consequential sections** one question per turn until each passes its YAML weak_signal check. Use compact option blocks for genuine trade-offs only.
  - **Synthesize medium and low sections** in one block; ask the user to redirect, accept, or escalate.
  - **Reopen only what the user steers.** Route cross-artifact issues through `handoff.md` using `.agents/skills/bmild-pm/assets/handoff-template.md` when another owner must act.
- [ ] Step 5: Consequence-check — verify all in-scope YAML sections; confirm every architecture item has an outcome applicability and disposition, every authorized requirement has support, deferred requirements remain non-binding, and applicable boundary, data, API, service, failure, operability, dependency, and evolution consequences are covered.
- [ ] Step 6: Pre-exit offer (declinable in one word) — name 1–2 session-appropriate bmild-elicit methods from this artifact's shortlist (**Architecture Decision Records**, **Failure Mode Analysis**), chosen by what was actually contentious: *"Before I write the system design — I could run **Architecture Decision Records** or **Failure Mode Analysis** in a bmild-elicit session, or take anything to roundtable. Otherwise I'll proceed."* On acceptance, swap to `bmild-elicit` with the method pre-selected; offer roundtable per core Advanced Elicitation Triggers when trade-offs are still open. Any decline or proceed signal continues directly to the Write step in the same turn — no further confirmation.
- [ ] Step 7: Write — write `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`.
  - **Initiative naming.** Initiative names are lowercase-kebab-case identifiers (e.g. `py-tokenizer`) — safe across filesystems, shells, and links. If the user supplies a kebab-case-compliant slug, use it directly. Otherwise confirm a kebab-case slug with the user before writing; never silently transform a proposed name.
- [ ] Step 8: Distillation gates — apply the Drift-protection ADR gate and Semantic Memory rules when triggered.
- [ ] Step 9: Register — open or create `[plan_folder]/<initiative-name>/registry.md` from `.agents/skills/bmild-pm/assets/registry-template.md`. Add `system-design.md` to `## Live`.
- [ ] Step 10: Gate check — resolve architecture ambiguity in chat and run product/UX gaps through the ladder. Do not leave durable question threads in `system-design.md`.
- [ ] Step 11: Close — apply Exit and Handoff from the core skill. Route directly to Alex when implementation is the authorized next move; use Sonia only for an actual readiness, coverage, coordination, or requested delivery-strategy question; route to Katrina when required UX input is missing.

## Definition of Done

- [ ] Authorized outcome, initiative-wide invariants, and deferred phases are explicit; deferred work carries no accidental implementation authority
- [ ] Every architecture item declares `Applies to` and `Disposition`; only `committed` items constrain Alex
- [ ] All committed architecture decisions have observable behavior, quality, evolution, or operational consequences
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Boundary, schema/data, API, service, dependency, failure, operability, and evolution decisions are specific enough to preserve committed behavior, trust boundaries, data semantics, compatibility, and NFRs while Alex chooses delegated implementation details
- [ ] `system-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] Drift-protection ADR extracted into `[plan_folder]/adr/` only if the triple-axis gate fired
- [ ] `context.md` and/or `context-map.md` updated only if the semantic gate fired
- [ ] `registry.md` updated with `system-design.md` in `## Live`
- [ ] Remaining ambiguity resolved through the ladder, persisted asynchronously, or bounded explicitly
- [ ] Close message: key decisions, trade-offs, queued or deferred governance items, next owner
