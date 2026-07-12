# Architecture-Refinement

Extend or update an existing `system-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

## Additional Context

Load in this order:
- Relevant ADRs in `[plan_folder]/adr/` if they exist
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/system-design.md` in full
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md`
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists
- `./resources/completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

Per-section `stakes` in `completion-criteria.yaml` sets elicitation depth for **changed** sections. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Refinement pacing:** Map each section being changed to its YAML `stakes`. Preview the queue grouped by stakes. Apply consequential pacing only to changed consequential sections; synthesize changed medium/low sections unless the user steers back. Run `fr_coverage` during consequence-check when FRs or contracts change.

## Global Directives

- **Discovery before invention**: Before accepting a greenfield architecture premise, groundtruth the codebase. Distinguish active runtime paths from abandoned prior art.
- **Challenge, do not preserve.** Treat existing architecture content as hypotheses until revalidated.
- **Trade-off vocabulary.** At decision and pressure-test moments, use `one-way-door`, `reversible`, `contract drift`, or `load-bearing` when they clarify the trade-off, not as a required frame.
- **Hydrate before eliciting.** Read current PM and UX artifacts; do not reopen settled upstream truth unless the refinement target exposes conflict or stale content.
- **Schema changes flow through code-first migration workflow.** Never hand-written SQL.
- **Naked assumptions are forbidden in artifacts.** Format: `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** Live elicitation in chat; route product/UX gaps through `handoff.md`.

## Distillation gates

**Drift-protection ADR gate.** When a refined Key Decision in `system-design.md` §2 passes the triple-axis test (hard to reverse, surprising without context, real trade-off), extract a terse drift-protection ADR into `[plan_folder]/adr/` per the gate in `assets/adr-template.md`. Apply the same gate as Architecture-Design mode.

**Semantic Memory.** When refined initiative-local meaning becomes stable:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities. Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when the refinement introduces or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Hydrate — read current PM and UX artifacts; identify what the change affects.
- [ ] Step 2: Identify refinement target — if unspecified, ask one question. Surface bounded assumptions and unresolved handoff items.
- [ ] Step 3: Brainstorm reconciliation — if a brainstorming session preceded this artifact, cross-reference against `system-design.md`; surface silently dropped ideas; ask whether any should be reconsidered.
- [ ] Step 4: Groundtruth — verify codebase reality per Global Directives when relevant to the change.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 5: Preview the queue — name changed sections grouped by YAML `stakes` and approximate question count.
- [ ] Step 6: Elicit refinements — apply Stakes-based elicitation to changed sections only.
- [ ] Step 7: Consequence-check — verify changed sections, traceability to `prd.md`, and in-scope YAML sections.
- [ ] Step 8: Pre-exit offer (conditional, declinable in one word) — when any **consequential** section is being materially changed, offer once: *"Before I update the system design — anything you want to stress-test or take to roundtable? Otherwise I'll proceed."* Skip when only medium/low sections change or the session is a single-field alignment.
- [ ] Step 9: Write — update `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`. Preserve unchanged sections. Update `timestamp` frontmatter.
- [ ] Step 10: Distillation gates — apply the Drift-protection ADR gate and Semantic Memory rules when triggered.
- [ ] Step 11: Register — confirm `system-design.md` in `## Live`; archive superseded predecessors if applicable.
- [ ] Step 12: Close — apply Exit and Handoff from the core skill. Default `Next` to Sonia; route to Katrina if `ux-design.md` is still missing.

## Definition of Done

- [ ] Brainstorming ideas reconciled when applicable
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not merely preserved
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Relevant `handoff.md` items resolved, deferred, rejected, superseded, or kept open with clear next owner
- [ ] `system-design.md` written with current `timestamp` date
- [ ] Drift-protection ADR extracted into `[plan_folder]/adr/` only if the triple-axis gate fired
- [ ] `context.md` and/or `context-map.md` updated only if the semantic gate fired
- [ ] `registry.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, queued or deferred governance items, next owner
