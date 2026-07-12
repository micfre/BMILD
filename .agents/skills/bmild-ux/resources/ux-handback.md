# UX-Handback

Resolve UX-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

## Additional Context

Load in this order:
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/ux-design.md` in full (if it exists)
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or handoff context (`prd.md`, `system-design.md`, `slice-<N>.md`, `verification-matrix.md`, or `security-review-<slug>.md`)
- `./resources/completion-criteria.yaml` when updating `ux-design.md`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

For handoff items requiring new UX decisions, map each item to its target section in `completion-criteria.yaml` and use that section's `stakes` value. When `stakes_note` is present, it overrides `stakes`. Items that do not map to a YAML section default to **consequential**.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Expert compression:** When the user demonstrably gives crisp, complete answers for a consequential section, I may replace one-question-at-a-time pacing with one confirmation synthesis. Keep consequential pacing for ambiguity, material trade-offs, or missing evidence.

## Global Directives

- **Artifact-authority discipline.** Promote accepted decisions into `ux-design.md`; `handoff.md` records coordination until the target artifact is updated.
- **Observable decisions only.** Label preferences as preferences.
- **Naked assumptions are forbidden in artifacts.** Document promoted assumptions with `Assumption` → `Confidence` → `Consequence if wrong`.

## Global pattern distillation

When resolved decisions qualify for project-root `DESIGN.md`, apply the same distillation gate as UX-Design mode.

## Semantic Memory

When resolved decisions stabilize initiative-local meaning:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities. Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when a decision establishes, modifies, or conflicts with a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Identify each handoff item and its target artifact.
- [ ] Step 2: Assess items targeting Katrina — which can be answered from existing design decisions vs which need new decisions (apply Stakes-based elicitation for the latter).
- [ ] Step 3: Preview the handoff set — name items grouped by effective stakes and approximate question count.
- [ ] Step 4: Resolve — for each accepted item that changes design truth:
  - Update `ux-design.md` (or create if needed)
  - Update the handoff item's `Owner Disposition` and `Promotion Record`
  - Run the **Promotion Cascade Check**: identify downstream consumers per `AGENTS.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts. (a) **0 stale owners** → no cascade action. (b) **1 stale owner** → auto-enqueue one follow-up `H-###` per stale artifact (`Type: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Katrina`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Requested Change: <pointer to source artifact section>`). Close follows the verbatim-invocation rule. (c) **≥2 stale owners** → mark each artifact in `registry.md ## Stale` with the upstream handoff reference; route the user to Sonia in Course-Correction mode. Append `Cascade: <summary>` to the handoff item being closed. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this handoff.
  - Note the consequence for the originating persona's artifact
- [ ] Step 5: Defer items needing product or architecture input — name the missing constraint; route back with one precise handoff item when another owner must act.
- [ ] Step 6: Consequence-check — verify updated sections against `completion-criteria.yaml` for all in-scope sections.
- [ ] Step 7: Write — update `ux-design.md` and `timestamp` frontmatter when design changes result.
- [ ] Step 8: Distillation gates — apply Global pattern distillation (DESIGN.md) and Semantic Memory (`context.md` / `context-map.md`) rules when triggered.
- [ ] Step 9: Close — apply Exit and Handoff from the core skill. Name each item resolved, deferred, rejected, superseded, or kept open, and the next owner.

## Definition of Done

- [ ] Every UX-owned handoff item assessed and either promoted, deferred, rejected, superseded, or kept open with reason
- [ ] Promotion Cascade Check completed for all accepted changes
- [ ] Design changes written to `ux-design.md` with completion criteria verified for updated sections
- [ ] `DESIGN.md` updated only if global pattern distillation gate fired
- [ ] `context.md` and/or `context-map.md` updated only if the semantic gate fired
- [ ] Close message: handoff items resolved, deferred items, next owner
