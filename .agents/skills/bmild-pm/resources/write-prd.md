# Write-PRD

Translate the agreed product intent into phased, constrained, testable scope. Define requirements, priorities, non-goals, acceptance criteria, and delivery boundaries. Challenge anything vague, over-scoped, unprioritized, or disconnected from the product brief. This is the contract for all downstream design work.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full — this is the contract you are expanding
- `./resources/prd-completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

Per-section `stakes` in `prd-completion-criteria.yaml` sets elicitation depth. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing (e.g. `nfr` becomes consequential when regulated or when a hard threshold is named).

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. Pushback or hedging keeps the section here. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Session pacing:** After loading YAML, partition in-scope sections by effective stakes. **Diverge** on consequential sections first (`functional_requirements`, `user_journeys` when applicable, `scope_and_prioritization`). **Synthesize** medium sections (`nfr` when not elevated by `stakes_note`, `documentation_scope`) and low sections (`assumptions`, `ambiguity_disposition` when applicable). Run `coverage_check` during consequence-check, not as a separate elicitation walk. **Reopen** any synthesized section the user steers back to consequential pacing.

**Expert compression:** When the user demonstrably gives crisp, complete answers for a consequential section, I may replace one-question-at-a-time pacing with one confirmation synthesis. Keep consequential pacing for ambiguity, material trade-offs, or missing evidence.

## Global Directives

- **Discovery before invention**: Before accepting a greenfield premise, verify repository reality. Scan the codebase when the initiative may be brownfield or when artifacts claim behaviour that code may already implement. Do not invent greenfield solutions in a brownfield environment.
- **Diverge before converging.** Consequential sections from YAML first; medium and low sections synthesized for steering.
- **Naked assumptions are forbidden in artifacts.** Every documented assumption, deferral, and open question carries `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** `handoff.md` is for defects, cross-artifact conflicts, and promotion requests requiring another owner. Live elicitation stays in chat unless async continuity requires a governed handoff. Bounded assumptions only when low-risk and reversible.

## Semantic Memory

When product/domain meaning becomes stable during this session:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities. Follow the authoring rules in `assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when this initiative establishes or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Groundtruth — verify repository reality for any implementation relevant to the initiative.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 2: Probe backward — review `product-brief.md` for unresolved assumptions, handoff items, or scope edges needing promotion. Route cross-artifact/source issues through `handoff.md` before proceeding.
- [ ] Step 3: Elicit (diverge → synthesize → steer) — apply Stakes-based elicitation:
  - **Open with the PRD contour.** Name in-scope sections grouped by YAML `stakes` (respecting `stakes_note` overrides) and signal consequential depth vs synthesis for the rest.
  - **Diverge on consequential sections.** One question at a time through `functional_requirements`, `user_journeys` (when applicable), and `scope_and_prioritization` until each passes its YAML weak_signal check.
  - **Probe without scripting.** Alongside YAML weak-signal drivers, optionally use `solution-shaped`, `happy ears`, or `steelman the opposite` when they sharpen the question.
  - **Synthesize medium and low sections.** Draft `nfr` (when not elevated by `stakes_note`), `documentation_scope`, `assumptions`, and `ambiguity_disposition` in one block. Ask the user to redirect, accept, or escalate.
  - **Reopen only what the user steers.** Hedging or pushback promotes that section to consequential pacing.
  - **Governance routing.** Decide whether remaining ambiguity belongs in `handoff.md` or a bounded assumption.
- [ ] Step 4: Consequence-check — privately verify before writing:
  - Every Must Have traceable to a user need from `product-brief.md`
  - Phase 1 is the absolute minimum to validate the idea
  - Explicitly out-of-scope items are listed
  - Non-functional requirements have thresholds, not just categories
  - Documentation scope has a decision for each audience (per completion criteria)
  - Any remaining ambiguity has a governed outcome: `handoff.md`, bounded assumption, or explicit defer/reject/supersede
  - Every in-scope section in `prd-completion-criteria.yaml` passes falsifiable / good_signal / weak_signal
- [ ] Step 5: Pre-exit offer (declinable in one word) — *"Before I write the PRD — anything you want to take to roundtable or stress-test first? Otherwise I'll proceed."* Offer advanced facilitator skills per core Advanced Elicitation Triggers when trade-offs are still open.
- [ ] Step 6: Write — write `[plan_folder]/<initiative-name>/prd.md` using `assets/prd-template.md`. Substitute `[user_name]` from `.bmild.toml`.
  - **Initiative naming.** Initiative names are lowercase-kebab-case identifiers (e.g. `py-tokenizer`) — safe across filesystems, shells, and links. If the user supplies a kebab-case-compliant slug, use it directly. Otherwise confirm a kebab-case slug with the user before writing; never silently transform a proposed name.
- [ ] Step 7: Gate check — resolve any remaining product-domain ambiguity synchronously in chat, or route UX/architecture gaps through `handoff.md`. Do not leave durable question threads in `prd.md`.
- [ ] Step 8: Register — add `prd.md` to `## Live` in `registry.md`. Archive any superseded predecessor.
- [ ] Step 9: Semantic distillation gate — apply Semantic Memory rules when triggered.
- [ ] Step 10: Close — apply Exit and Handoff from the core skill. Downstream design handoff is allowed; `Next` may point to Katrina, Lance, or both.

## Definition of Done

- [ ] Functional requirements, user journeys, scope/prioritization, NFRs, documentation scope, and assumptions documented
- [ ] `prd-completion-criteria.yaml` verified for all in-scope sections
- [ ] Remaining ambiguity routed through `handoff.md` or bounded assumptions — not embedded question sections
- [ ] `prd.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `context.md` and/or `context-map.md` updated only if the semantic distillation gate fired
- [ ] `registry.md` updated with `prd.md` in `## Live`
- [ ] Close message: artifacts written, queued or deferred governance items, next owner
- [ ] Both `product-brief.md` and `prd.md` exist; downstream design handoff to Katrina and/or Lance is unblocked
