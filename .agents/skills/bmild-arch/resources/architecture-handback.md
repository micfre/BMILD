# Architecture-Handback

Resolve architecture-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

## Additional Context

Load in this order:
- Relevant ADRs in `[plan_folder]/adr/` if they exist
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/system-design.md` in full
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or handoff context (`prd.md`, `ux-design.md`, `slice-<N>.md`, `verification-matrix.md`, or `security-review-<slug>.md`)
- `./resources/completion-criteria.yaml` when updating `system-design.md`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

For handoff items requiring new architecture decisions, map each item to its target section in `completion-criteria.yaml` and use that section's `stakes` value. When `stakes_note` is present, it overrides `stakes`. Items that do not map to a YAML section default to **consequential**.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/costs and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

## Global Directives

- **Artifact-authority discipline.** Promote accepted decisions into `system-design.md`; unpromoted handoff items are not resolved by conversation alone.
- **Every architecture decision has an observable implementation consequence.**
- **Naked assumptions are forbidden in artifacts.** Format: `Assumption` → `Confidence` → `Consequence if wrong`.

## ADR distillation gate

When resolved decisions qualify for `[plan_folder]/adr/`, apply the same gate as Architecture-Design mode.

## Tasks

Progress:

- [ ] Step 1: Identify each handoff item and its target artifact.
- [ ] Step 2: Assess items targeting Lance — which can be answered from existing design decisions vs which need new decisions (apply Stakes-based elicitation for the latter).
- [ ] Step 3: Preview the handoff set — name items grouped by effective stakes and approximate question count.
- [ ] Step 4: Resolve — for each accepted item that changes design truth:
  - Update `system-design.md`
  - Update the handoff item's `Owner Disposition` and `Promotion Record`
  - Run the **Promotion Cascade Check**: identify downstream consumers per `AGENTS.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts. (a) **0 stale owners** → no cascade action. (b) **1 stale owner** → auto-enqueue one follow-up `H-###` per stale artifact (`Type: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Lance`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Requested Change: <pointer to source artifact section>`). Close follows the verbatim-invocation rule. (c) **≥2 stale owners** → mark each artifact in `registry.md ## Stale` with the upstream handoff reference; route the user to Sonia in Course-Correction mode. Append `Cascade: <summary>` to the handoff item being closed. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this handoff.
  - Note the consequence for the originating persona's artifact
- [ ] Step 5: Defer items needing product or UX input — name the missing constraint; route back with one precise handoff item when another owner must act.
- [ ] Step 6: Consequence-check — verify updated sections against `completion-criteria.yaml` for all in-scope sections.
- [ ] Step 7: Write — update `system-design.md` and `updated` frontmatter when design changes result.
- [ ] Step 8: ADR distillation gate — apply ADR distillation rules when triggered.
- [ ] Step 9: Close — apply Exit and Handoff from the core skill. Name each item resolved, deferred, rejected, superseded, or kept open, and the next owner.

## Definition of Done

- [ ] Every architecture-owned handoff item assessed and either promoted, deferred, rejected, superseded, or kept open with reason
- [ ] Design changes written to `system-design.md` with completion criteria verified for updated sections
- [ ] ADRs updated only if distillation gate fired
- [ ] Close message: handoff items resolved, deferred items, next owner
