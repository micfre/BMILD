# Refine-Brief

Revisit and improve an existing product brief. Probe what changed, challenge stale framing, and update `product-brief.md`. Existing content is a starting point to challenge, not a contract to preserve.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full
- `[plan_folder]/<initiative-name>/prd.md` in full if it exists (downstream impact assessment only)
- `./resources/brief-completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

Per-section `stakes` in `brief-completion-criteria.yaml` sets elicitation depth for changed sections. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Refinement pacing:** Map each section being changed to its YAML `stakes`. Preview the queue grouped by stakes. Apply consequential pacing only to changed consequential sections; synthesize changed medium/low sections unless the user steers back.

**Expert compression:** When the user demonstrably gives crisp, complete answers for a consequential section, I may replace one-question-at-a-time pacing with one confirmation synthesis. Keep consequential pacing for ambiguity, material trade-offs, or missing evidence.

## Global Directives

- **Discovery before invention**: Before accepting a greenfield premise, verify repository reality. Scan the codebase when the initiative may be brownfield or when artifacts claim behaviour that code may already implement. Do not invent greenfield solutions in a brownfield environment.
- **Challenge, do not preserve.** Treat existing brief content as hypotheses until revalidated.
- **Problem framing precedes features.** Do not drift into PRD detail except to flag downstream implications.
- **Artifact-authority discipline.** Live elicitation in chat; `handoff.md` only when async continuity or another owner must act. Bounded assumptions only when low-risk and reversible.

## Semantic Memory

When refined product/domain meaning becomes stable:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local semantics.
- Update `[plan_folder]/context-map.md` when the refinement introduces or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Determine what changed. If unspecified, ask one question. Typical triggers: changed user need, shifted success metric, revised scope boundary, updated competitive framing, or changed initiative vision.
- [ ] Step 2: If a brainstorming session preceded this artifact, cross-reference it against `product-brief.md`. Surface silently dropped ideas; ask whether any should be incorporated.
- [ ] Step 3: Groundtruth and challenge — verify repository reality per Global Directives when refinement depends on existing behaviour. Surface unresolved PM-owned handoff items.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 4: Preview the queue — name changed sections grouped by YAML `stakes` and approximate question count before the first probe.
- [ ] Step 5: Elicit refinements — apply Stakes-based elicitation to changed sections only; unchanged sections skip elicitation.
- [ ] Step 6: Consequence-check — privately verify changed sections and any cross-section impacts before writing; run `brief-completion-criteria.yaml` for all in-scope sections.
- [ ] Step 7: Pre-exit offer (conditional, declinable in one word) — when any **consequential** section (per YAML `stakes`, respecting `stakes_note`) is being materially changed, offer once: *"Before I update the brief — anything you want to stress-test or take to roundtable? Otherwise I'll proceed."* Offer advanced facilitator skills per core Advanced Elicitation Triggers when trade-offs are still open. Skip when only medium/low sections change or the session is a single-field alignment.
- [ ] Step 8: Write — update `[plan_folder]/<initiative-name>/product-brief.md` using `assets/product-brief-template.md`. Preserve unchanged sections. Update `timestamp` frontmatter.
- [ ] Step 9: Gate check — resolve remaining product ambiguity in chat or route through `handoff.md` when another owner must act.
- [ ] Step 10: Semantic distillation gate — apply Semantic Memory rules when triggered.
- [ ] Step 11: Register — confirm `product-brief.md` in `## Live`; archive superseded predecessors if applicable.
- [ ] Step 12: Downstream impact — if brief changes force `prd.md` updates only, offer Refine-PRD as `Next`; if changes cascade to planning/design artifacts beyond PM ownership, offer Sonia in `bmild-planner` Course-Correction mode.
- [ ] Step 13: Close — apply Exit and Handoff from the core skill with the recommended next move from Step 12.

## Definition of Done

- [ ] Refinement target identified and relevant `product-brief.md` sections updated
- [ ] Existing brief content challenged, not merely preserved
- [ ] `brief-completion-criteria.yaml` verified for all in-scope sections
- [ ] Relevant PM-owned `handoff.md` items resolved, deferred, rejected, superseded, or kept open with a clear next owner
- [ ] `product-brief.md` written with current `timestamp` date
- [ ] `context.md` or `context-map.md` updated only if the semantic distillation gate fired
- [ ] `registry.md` reflects current brief state
- [ ] Close message includes downstream next move when impact extends beyond the brief
