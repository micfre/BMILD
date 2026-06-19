# UX-Design

Design the frontend experience for a new initiative. Produce observable, testable UX decisions — not visual preferences.

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

## Stakes-based elicitation

Per-section `stakes` in `completion-criteria.yaml` sets elicitation depth. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. Pushback or hedging keeps the section here. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Session pacing:** After loading YAML, partition in-scope sections by effective stakes. **Diverge** on consequential sections first (`information_architecture`, `user_flows`, `interaction_model`, `edge_states`, `fr_coverage`). **Synthesize** medium sections (`visual_design_language`, `accessibility` when not elevated by `stakes_note`) and low sections (`ambiguity_disposition` when applicable) in one compact block. **Reopen** any synthesized section the user steers back to consequential pacing.

## Global Directives

- **Discovery before invention**: Before accepting a greenfield UX premise, verify repository reality and any existing global design system. Do not invent patterns that contradict established global UX.
- **Observable decisions only.** A UX decision exists only if an observable user behavior or testable screen state distinguishes it from alternatives; otherwise label it preference.
- **Hydrate before eliciting.** Read PM artifacts and architecture constraints before asking UX questions. Do not reopen settled PM requirements unless artifacts conflict, contradict existing UX patterns, or require a UX trade-off PM did not decide. Do not infer user goals from backend shape.
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

- [ ] Step 1: Hydrate — read PM artifacts and architecture constraints per Additional Context. Extract settled requirements, UX constraints, and open UX-only decisions.
- [ ] Step 2: Groundtruth — verify codebase and global design system per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 3: Synthesize — summarize what is settled, what user-state hypotheses follow, what is missing, and what conflicts exist. Ask the smallest useful UX question before committing to an interaction model.
- [ ] Step 4: Elicit (diverge → synthesize → steer) — apply Stakes-based elicitation:
  - **Open with the UX contour.** Name in-scope sections grouped by YAML `stakes`.
  - **Diverge on consequential sections** one question per turn until each passes its YAML weak_signal check.
  - **Synthesize medium and low sections** in one block; ask the user to redirect, accept, or escalate.
  - **Reopen only what the user steers.** Capture tangents in chat for the next probe or synthesis block.
- [ ] Step 5: Consequence-check — privately verify all in-scope YAML sections; confirm empty, loading, error, mobile, and accessibility coverage for consequential flows.
- [ ] Step 6: Pre-exit offer (declinable in one word) — *"Before I write the UX design — anything you want to take to roundtable or stress-test first? Otherwise I'll proceed."* Offer advanced facilitator skills per core Advanced Elicitation Triggers when trade-offs are still open.
- [ ] Step 7: Write — write `[plan_folder]/<initiative-name>/ux-design.md` using `assets/ux-design-template.md`.
- [ ] Step 8: Distillation gates — apply Global pattern distillation (DESIGN.md) and Semantic Memory (`context.md` / `context-map.md`) rules when triggered.
- [ ] Step 9: Register — open or create `[plan_folder]/<initiative-name>/registry.md` from `.agents/skills/bmild-pm/assets/registry-template.md`. Add `ux-design.md` (and `DESIGN.md` if updated) to `## Live`.
- [ ] Step 10: Gate check — resolve remaining UX ambiguity in chat or route product/architecture gaps through `handoff.md`. Do not leave durable question threads in `ux-design.md`.
- [ ] Step 11: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] All UX decisions are observable or testable — preferences labelled as such
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Empty, error, loading, mobile, and accessibility states considered
- [ ] `ux-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `DESIGN.md` updated only if global pattern distillation gate fired
- [ ] `context.md` and/or `context-map.md` updated only if the semantic gate fired
- [ ] `registry.md` updated with artifacts in `## Live`
- [ ] Remaining ambiguity resolved in chat, routed through `handoff.md`, or handled as bounded assumptions
- [ ] Close message: key decisions, trade-offs, queued or deferred governance items, next owner
