# UX-Refinement

Extend or update an existing `ux-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

## Additional Context

Load in this order:
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/ux-design.md` in full
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md`
- `[plan_folder]/<initiative-name>/system-design.md` if it exists — technical constraints only
- `./resources/completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

Per-section `stakes` in `completion-criteria.yaml` sets elicitation depth for **changed** sections. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Refinement pacing:** Map each section being changed to its YAML `stakes`. Preview the queue grouped by stakes. Apply consequential pacing only to changed consequential sections; synthesize changed medium/low sections unless the user steers back.

## Global Directives

- **Discovery before invention**: Before accepting a greenfield UX premise, verify repository reality and any existing global design system. Do not invent patterns that contradict established global UX.
- **Challenge, do not preserve.** Treat existing UX content as hypotheses until revalidated.
- **Hydrate before eliciting.** Read current PM artifacts; do not reopen settled requirements unless the refinement target exposes conflict or stale content.
- **Observable decisions only.** Label preferences as preferences.
- **Artifact-authority discipline.** Live elicitation in chat; `handoff.md` when another owner must act. Bounded assumptions only when low-risk and reversible.

## Global pattern distillation

When refined decisions qualify for project-root `DESIGN.md` (global interaction principles and visual language only), apply the same distillation gate as UX-Design mode.

## Semantic Memory

When refined initiative-local meaning becomes stable:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities. Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when the refinement introduces or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Hydrate — read current PM artifacts and architecture constraints; identify what the change affects.
- [ ] Step 2: Identify refinement target — if unspecified, ask one question. Surface bounded assumptions and unresolved handoff items; use `friction map`, error/empty-state probing, or `show the work` where they clarify the flow, not as a script.
- [ ] Step 3: Brainstorm reconciliation — if a brainstorming session preceded this artifact, cross-reference against `ux-design.md`; surface silently dropped ideas; ask whether any should be incorporated.
- [ ] Step 4: Groundtruth — verify codebase/design-system reality per Global Directives when relevant to the change.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 5: Preview the queue — name changed sections grouped by YAML `stakes` and approximate question count.
- [ ] Step 6: Elicit refinements — apply Stakes-based elicitation to changed sections only.
- [ ] Step 7: Consequence-check — verify changed sections and cross-section impacts; run `completion-criteria.yaml` for all in-scope sections.
- [ ] Step 8: Pre-exit offer (conditional, declinable in one word) — when any **consequential** section is being materially changed, offer once: *"Before I update the UX design — anything you want to stress-test or take to roundtable? Otherwise I'll proceed."* Skip when only medium/low sections change or the session is a single-field alignment.
- [ ] Step 9: Write — update `[plan_folder]/<initiative-name>/ux-design.md` using `assets/ux-design-template.md`. Preserve unchanged sections. Update `timestamp` frontmatter.
- [ ] Step 10: Distillation gates — apply Global pattern distillation (DESIGN.md) and Semantic Memory (`context.md` / `context-map.md`) rules when triggered.
- [ ] Step 11: Register — confirm `ux-design.md` in `## Live`; archive superseded predecessors if applicable.
- [ ] Step 12: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Brainstorming ideas reconciled when applicable
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not merely preserved
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Relevant `handoff.md` items resolved, deferred, rejected, superseded, or routed with clear next owner
- [ ] `ux-design.md` written with current `timestamp` date
- [ ] `DESIGN.md` updated only if global pattern distillation gate fired
- [ ] `context.md` and/or `context-map.md` updated only if the semantic gate fired
- [ ] `registry.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, queued or deferred governance items, next owner
