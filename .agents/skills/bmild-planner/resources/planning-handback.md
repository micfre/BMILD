# Planning-Handback

Resolve planning-owned governance items raised by other personas. Promote accepted changes into source artifacts so the handoff does not become shadow memory.

For design-change-driven plan revisions use Replanning; for ≥2-owner cascades use Course-Correction.

## Additional Context

Load in this order:
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/slices.md` in full (if it exists)
- All active `slice-<N>.md` files under `## Live`
- `[plan_folder]/<initiative-name>/verification-matrix.md` (if it exists)
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or context (`prd.md`, `ux-design.md`, `system-design.md`, `rca-<slug>.md`, or `security-review-<slug>.md`)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Accepted handoff items are not truth until promoted** in the source artifact.
- **Classify before resolving:**
  - *Bounded-to-planning* → resolve here (`slices.md`, `slice-<N>.md`, `verification-matrix.md` only).
  - *Design-change-driven* → exit to Replanning.
  - *Multi-artifact cascade (≥2 design-tier owners)* → exit to Course-Correction.

## Tasks

Progress:

- [ ] Step 1: Assess each handoff item targeting Sonia — classify per Global Directives.
- [ ] Step 2: Preview the handoff set — name categories and approximate question count before the first prompt.
- [ ] Step 3: Resolve bounded items — for each accepted planning change:
  - Update `slices.md`, affected `slice-<N>.md`, or `verification-matrix.md`
  - Re-run slice budgeting if reads, edits, or new-file estimates changed
  - Update `Owner Disposition` and `Promotion Record`
  - Run **Promotion Cascade Check**: classify downstream consumers as `unaffected | minor-update | stale`. (a) **0 stale** → no action. (b) **1 stale owner** → auto-enqueue one `H-###` per stale artifact; close follows verbatim-invocation rule. (c) **≥2 stale owners** → mark artifacts in `registry.md ## Stale`; route to Course-Correction; append `Downstream Cascade: <summary>`. Cycle prevention: do not enqueue if `Supersedes` chain includes this handoff.
- [ ] Step 4: Defer items needing design input — name missing constraint; route with one precise handoff item when another owner must act.
- [ ] Step 5: Write — persist planning changes; update `timestamp` frontmatter.
- [ ] Step 6: Register — update `registry.md` (`## Live` / `## Archived`).
- [ ] Step 7: Close — apply Exit and Handoff from the core skill. Name each item resolved, deferred, rejected, or superseded.

## Definition of Done

- [ ] Every planning-owned handoff item assessed and routed or resolved with reason
- [ ] Planning changes written to planning artifacts; slice budget re-run when inputs shifted
- [ ] `registry.md` updated
- [ ] Close message: items resolved, deferred items, next Slice or next owner
