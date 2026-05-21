# Planning-Handback

Resolve planning-owned governance items raised by other personas. Promote accepted changes into source artifacts so the handoff does not become shadow memory. Use this mode when the handoff item targets `slices.md`, `slice-<N>.md`, or `verification-matrix.md` and the change is bounded to those artifacts. For design-change-driven plan revisions use Replanning; for ≥2-owner cascades use Course-Correction.

## Additional Context

Identify the queue item and the source artifact it targets. Load in this order:

- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/slices.md` in full (if it exists)
- All active `slice-<N>.md` files under `## Live`
- `[plan_folder]/<initiative-name>/verification-matrix.md` (if it exists)
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or queue context that raised the issue (`prd.md`, `ux-design.md`, `system-design.md`, `system-design.md` implementation updates, `rca-<slug>.md`, or `security-review-<slug>.md`)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Additional Directives

Accepted handoff items are not authoritative until promotion is recorded in the source artifact. The handoff is coordination state, not truth.

## Tasks

Progress:

- [ ] Step 1: **Assess.** Read each handoff item targeting Sonia. Determine which can be answered from existing plan state and which require revision. Classify each:
  - **Bounded-to-planning** — affects only `slices.md`, `slice-<N>.md`, or `verification-matrix.md` and does not require design re-decision → resolve in this mode.
  - **Design-change-driven** — the originating finding implies a design contract has shifted → exit this mode and route to Replanning.
  - **Multi-artifact cascade** — resolution requires ≥2 design-tier owners to patch their artifacts → exit this mode and route to Course-Correction.

- [ ] Step 2: **Resolve.** For each bounded-to-planning item, provide a clear answer or planning revision. Apply all Global Directives from the core skill. For each accepted item that results in a planning change:
  - Update `slices.md`, the affected `slice-<N>.md`, or `verification-matrix.md` as appropriate.
  - Re-run slice budgeting if reads, edits, or new-file estimates changed.
  - Update the handoff item's `Owner Disposition` and `Promotion Record`.
  - Run the **Promotion Cascade Check**: identify downstream consumers per `CLAUDE.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts.
    - (a) **0 stale owners** → no cascade action.
    - (b) **1 stale owner** → auto-enqueue one follow-up handoff item per stale artifact (`Type: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Sonia`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Requested Change: <pointer to source artifact section>`). The close message follows the verbatim-invocation rule for the single owner.
    - (c) **≥2 stale owners** → do NOT enqueue individually; mark each artifact in `registry.md ## Stale` with the upstream handoff reference, and route the user to Course-Correction mode in this turn's close (which Sonia herself runs). Append `Downstream Cascade: <summary>` to the handoff item being closed. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this handoff item.
  - Note the consequence for the originating persona's artifact.

- [ ] Step 3: **Defer.** If an item cannot be resolved without additional design input: name the specific constraint missing, resolve user-owned gaps in chat, or route it back to the relevant source owner with one precise handoff item, and mark the handoff as deferred, rejected, or superseded.

- [ ] Step 4: **Write.** Persist all planning changes to the relevant artifacts. Update the `updated` frontmatter date.

- [ ] Step 5: **Context memory update.** Move any newly active `slice-<N>.md` files to `## Live` in `registry.md`. Move superseded Slice files to `## Archived`.

- [ ] Step 6: **Close.** Apply the Exit and Handoff format from the core skill. Explicitly name each handoff item resolved, deferred, rejected, or superseded, and the next owner for each. If completed work re-routes Alex, name the next Slice explicitly.

## Definition of Done

- [ ] Every planning-owned handoff item assessed and either resolved, deferred, rejected, superseded, or routed to Replanning/Course-Correction with reason
- [ ] Planning changes written to `slices.md`, `slice-<N>.md`, or `verification-matrix.md`
- [ ] Slice budget re-run when input volumes shifted
- [ ] `registry.md` updated to reflect revised plan state
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: queue items resolved, deferred items, next Slice or next owner
