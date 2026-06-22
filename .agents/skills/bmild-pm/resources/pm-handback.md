# PM-Handback

Resolve PM-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full (if it exists)
- `[plan_folder]/<initiative-name>/prd.md` in full (if it exists)
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or handoff context that raised the issue (`ux-design.md`, `system-design.md`, `slices.md`, `slice-<N>.md`, `verification-matrix.md`, `rca-<slug>.md`, or `security-review-<slug>.md`)
- `./resources/brief-completion-criteria.yaml` and/or `./resources/prd-completion-criteria.yaml` when updating the corresponding artifact(s)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

For handoff items requiring new product decisions, map each item to its target section in the loaded completion criteria YAML and use that section's `stakes` value. When `stakes_note` is present, it overrides `stakes` for pacing. Items that do not map to a YAML section default to **consequential**.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

## Global Directives

- **Artifact-authority discipline.** Promote accepted decisions into `product-brief.md` and/or `prd.md`; `handoff.md` records coordination until the target artifact is updated. Live user elicitation in chat unless async continuity requires a governed handoff.
- **Naked assumptions are forbidden in artifacts.** Document promoted assumptions with `Assumption` → `Confidence` → `Consequence if wrong`.

## Semantic Memory

When resolved decisions stabilize product/domain meaning:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local semantics.
- Update `[plan_folder]/context-map.md` when a decision establishes, modifies, or conflicts with a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Identify each handoff item and its target artifact from context reads above.
- [ ] Step 2: Assess items targeting Faisal — which can be answered from existing product decisions vs which need new decisions (apply Stakes-based elicitation for the latter, mapped to YAML section `stakes`).
- [ ] Step 3: Preview the handoff set — name items grouped by effective stakes and approximate question count before the first prompt.
- [ ] Step 4: Resolve — for each item, provide a clear answer or decision. For each accepted item that changes product truth:
  - Update `product-brief.md` and/or `prd.md` as appropriate
  - Update the handoff item's `Owner Disposition` and `Promotion Record`
  - Run the **Promotion Cascade Check**: identify downstream consumers per `AGENTS.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts. (a) **0 stale owners** → no cascade action. (b) **1 stale owner** → auto-enqueue one follow-up `H-###` per stale artifact (`Type: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Faisal`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Requested Change: <pointer to source artifact section>`). Close follows the verbatim-invocation rule. (c) **≥2 stale owners** → mark each artifact in `registry.md ## Stale` with the upstream handoff reference; route the user to Sonia in Course-Correction mode. Append `Cascade: <summary>` to the handoff item being closed. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this handoff.
  - Note the consequence for the originating persona's artifact
- [ ] Step 5: Defer items that need UX or architecture input — name the missing constraint; route back with one precise handoff item when another owner must act.
- [ ] Step 6: Consequence-check — verify updated PM artifact(s) against the loaded completion criteria YAML for all in-scope sections.
- [ ] Step 7: Write — update PM artifact(s) and `timestamp` frontmatter when product changes result.
- [ ] Step 8: Semantic distillation gate — apply Semantic Memory rules when triggered.
- [ ] Step 9: Close — apply Exit and Handoff from the core skill. Name each item resolved, deferred, rejected, superseded, or kept open, and the next owner.

## Definition of Done

- [ ] Every PM-owned handoff item assessed and either promoted, deferred, rejected, superseded, or kept open with reason
- [ ] Product changes written to `product-brief.md` and/or `prd.md` with completion criteria verified for updated sections
- [ ] `context.md` or `context-map.md` updated only if the semantic distillation gate fired
- [ ] Originating persona informed via close message and any new `handoff.md` items
- [ ] Close message: handoff items resolved, deferred items, next owner
