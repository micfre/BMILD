# UX-Design

Design the frontend experience required for an authorized outcome while preserving initiative-wide UX invariants. Produce observable, testable UX decisions — not visual preferences or binding designs for deferred phases.

## Additional Context

Load in this order:
- Project-root `DESIGN.md` if it exists — design must be consistent with established global UX patterns
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
- `[plan_folder]/<initiative-name>/system-design.md` if it exists — technical constraints only; not a source of UX intent
- `./resources/completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

If no `product-brief.md` or `prd.md` exists: probe for key user needs and requirements before proceeding. Entry at the UX stage is not permission to skip problem framing.

Resolve the authorized outcome or phase from the request and upstream sources. Read later-phase requirements for coherence, but treat them as deferred unless the user authorized initiative-wide UX. Defining a phase in `prd.md` is not implementation authority.

## Stakes-based elicitation

Per-section `stakes` in `completion-criteria.yaml` sets elicitation depth. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. Pushback or hedging keeps the section here. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Session pacing:** After loading YAML, partition in-scope sections by effective stakes. **Diverge** on consequential sections first (`outcome_scope`, `information_architecture`, `user_flows`, `interaction_model`, `edge_states`, `fr_coverage`). **Synthesize** medium sections (`visual_design_language`, `accessibility` when not elevated by `stakes_note`) and low sections (`contract_disposition`, `ambiguity_disposition` when applicable) in one compact block. **Reopen** any synthesized section the user steers back to consequential pacing.

**Expert compression:** When the user demonstrably gives crisp, complete answers for a consequential section, I may replace one-question-at-a-time pacing with one confirmation synthesis. Keep consequential pacing for ambiguity, material trade-offs, or missing evidence.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Discovery before invention**: Before accepting a greenfield UX premise, verify repository reality and any existing global design system. Do not invent patterns that contradict established global UX.
- **Observable decisions only.** A UX decision exists only if an observable user behavior or testable screen state distinguishes it from alternatives; otherwise label it preference.
- **Outcome granularity.** Separate initiative-wide UX invariants from the design committed for the authorized outcome. Later phases are coherence context, not present authority; do not specify binding screens, flows, or states for them unless they are necessary cross-phase foundations or separately authorized.
- **Commitment strength.** Apply the core skill's UX contract defaults. Commit consequential user-observable behavior; delegate standard component mechanics and private state when established conventions suffice; label illustrative and observed content when it could be mistaken for intent.
- **Hydrate before eliciting.** Read PM artifacts and architecture constraints before asking UX questions. Do not reopen settled PM requirements unless artifacts conflict, contradict existing UX patterns, or require a UX trade-off PM did not decide. Do not infer user goals from backend shape.
- **Preserve source journey evidence.** When a flow translates an applicable PRD journey, the named protagonist, relevant inline context, climax, and failure path survive the translation, and the journey's Firsthand or Illustrative evidence label carries through — never rewrite an illustrative source as observed behavior. Reuse evidence already recorded in a live source without re-asking for it.
- **Close the surface graph, never invent into it.** Trace every user-facing need in the authorized outcome to a serving surface, and every outcome surface back to a journey that reaches it. A shared or supporting surface carries a specific rationale instead of a forced artificial journey. A missing link is named with its source and surfaced to the operator for a decision — do not invent a screen, token, or component to make coverage appear complete.
- **Token and component references resolve or surface.** Reference a `DESIGN.md` token the design depends on by its resolvable `{path.to.token}` name; an unresolved token is a finding, never an invitation to invent one. Give every named in-scope component both a visual rule and a behavioral rule, or name the established design-system rule (with source) that supplies either. Walk each in-scope surface through the applicable states among empty, cold-load, error, offline, and permission-denied, recording the behavior or a genuine non-applicability reason.
- **Two-pass validation.** Run the mechanical pass first: journey, token, component, and surface-state references exist and resolve. Then run the judgment pass: whether the content names real user behavior and recovery, whether inherited claims have honest sources, and whether the contract is proportionate rather than overspecified. Passing the mechanical pass means entries exist — a tautological rule, a state with no usable behavior, or a shared non-applicability reason that hides a material exception fails the judgment pass.
- **Elicit before writing.** Write at the end or at a meaningful checkpoint.
- **Naked assumptions are forbidden in artifacts.** Every assumption, deferral, and open question carries `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** `handoff.md` is for source defects, cross-artifact conflicts, and promotion requests requiring another owner. Live elicitation in chat unless async continuity requires a governed handoff. Bounded assumptions only when low-risk and reversible.

## Global pattern distillation

When this initiative's decisions establish interaction principles, visual language, or UX patterns that **all future initiatives must conform to**, distill those elements into project-root `DESIGN.md` using `assets/design-md-template.md`. Initiative-local flows, screen-specific states, and scoped interaction decisions do not qualify.

## Semantic Memory

When initiative-local meaning becomes stable during this session:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities. Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when this initiative establishes or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Hydrate and scope — read PM artifacts and architecture constraints per Additional Context. Resolve the authorized outcome/phase, its user-facing FRs and journeys, affected existing surfaces, initiative-wide UX invariants, deferred work, and open UX-only decisions.
- [ ] Step 2: Groundtruth — verify codebase and global design system per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 3: Synthesize — summarize what is settled, what user-state hypotheses follow, what is missing, and what conflicts exist. Ask the smallest useful UX question before committing to an interaction model; use `friction map`, error/empty-state probing, or `show the work` where they clarify the flow, not as a script.
- [ ] Step 4: Elicit (diverge → synthesize → steer) — apply Stakes-based elicitation:
  - **Open with the UX contour.** Name in-scope sections grouped by YAML `stakes`.
  - **Diverge on consequential sections** one question per turn until each passes its YAML weak_signal check.
  - **Synthesize medium and low sections** in one block; ask the user to redirect, accept, or escalate.
  - **Reopen only what the user steers.** Capture tangents in chat for the next probe or synthesis block.
- [ ] Step 5: Consequence-check — privately verify all applicable YAML sections; confirm outcome scope, binding-versus-delegated treatment, applicable empty/cold-load/error/offline/permission-denied states, mobile, accessibility, authorized FR coverage, bidirectional need-to-surface closure, journey evidence preservation, token and component reference resolution, and deferred-phase containment for consequential flows. Run the two-pass validation: mechanical coverage before judgment.
- [ ] Step 6: Pre-exit offer (declinable in one word) — name 1–2 session-appropriate bmild-elicit methods from this artifact's shortlist (**User Persona Focus Group**, **Challenge from Critical Perspective**), chosen by what was actually contentious: *"Before I write the UX design — I could run **User Persona Focus Group** or **Challenge from Critical Perspective** in a bmild-elicit session, or take anything to roundtable. Otherwise I'll proceed."* On acceptance, swap to `bmild-elicit` with the method pre-selected; offer roundtable per core Advanced Elicitation Triggers when trade-offs are still open. Any decline or proceed signal continues directly to the Write step in the same turn — no further confirmation.
- [ ] Step 7: Write — write `[plan_folder]/<initiative-name>/ux-design.md` using `assets/ux-design-template.md`.
  - **Initiative naming.** Initiative names are lowercase-kebab-case identifiers (e.g. `py-tokenizer`) — safe across filesystems, shells, and links. If the user supplies a kebab-case-compliant slug, use it directly. Otherwise confirm a kebab-case slug with the user before writing; never silently transform a proposed name.
- [ ] Step 8: Distillation gates — apply Global pattern distillation (DESIGN.md) and Semantic Memory (`context.md` / `context-map.md`) rules when triggered.
- [ ] Step 9: Register — open or create `[plan_folder]/<initiative-name>/registry.md` from `.agents/skills/bmild-pm/assets/registry-template.md`. Add `ux-design.md` (and `DESIGN.md` if updated) to `## Live`.
- [ ] Step 10: Gate check — resolve UX ambiguity in chat and run product/architecture gaps through the ladder. Do not leave durable question threads in `ux-design.md`.
- [ ] Step 11: Close — apply Exit and Handoff from the core skill.

<!-- artifact-review-hook:start -->
### Optional artifact-review offer

Before closing finalization, offer once: an independent Artifact Reviewer Gate run by Sonia over the just-finalized artifact (`.agents/skills/bmild-planner/resources/artifact-review.md`). Acceptance and decline are both normal closes; the higher the artifact's stakes, the more forcefully the offer is made. Never run the gate from this session — a finalize offer is never independent approval of this persona's own work. On acceptance, hand off with the artifact path and initiative name; on decline, close normally.
<!-- artifact-review-hook:end -->

## Definition of Done

- [ ] All UX decisions are observable or testable — preferences labelled as such
- [ ] Authorized outcome, source requirements, initiative-wide UX invariants, and deferred work are explicit
- [ ] Binding user-observable behavior is distinguishable from delegated mechanics, illustrative examples, and observed behavior
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Empty, cold-load, error, offline, permission-denied, and accessibility states considered per applicable surface
- [ ] User-facing needs and outcome surfaces close in both directions, with a specific rationale for shared or supporting surfaces
- [ ] Token references resolve into DESIGN.md and named components carry visual plus behavioral rules or a named inherited source
- [ ] `ux-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `DESIGN.md` updated only if global pattern distillation gate fired
- [ ] `context.md` and/or `context-map.md` updated only if the semantic gate fired
- [ ] `registry.md` updated with artifacts in `## Live`
- [ ] Remaining ambiguity resolved in chat or through the ladder, persisted asynchronously when required, or handled as a bounded assumption
- [ ] Close message: key decisions, trade-offs, queued or deferred governance items, next owner
