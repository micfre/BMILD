# Planning-Handback

Resolve planning-owned governance items raised by other personas. Promote accepted changes into source artifacts so the handoff does not become shadow memory.

For requested execution strategy revisions use Delivery Strategy; internal plan changes belong to Alex. Resolve independent owner consequences through separate ladder episodes; use Course-Correction only for user-approved coupled choices.

## Additional Context

Load in this order:
- `[plan_folder]/<initiative-name>/registry.md`
- Named legacy registry entries only if relevant to the queued item
- Named legacy Slice records only when the queued item depends on them
- `[plan_folder]/<initiative-name>/verification-matrix.md` (if it exists)
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or context (`prd.md`, `ux-design.md`, `system-design.md`, `rca-<slug>.md`, or `security-review-<slug>.md`)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Accepted handoff items are not truth until promoted** in the source artifact.
- **Classify before resolving:**
  - *Bounded-to-planning* → resolve here (readiness, coverage, dependencies, and outcome evidence; legacy Slice records only when implicated).
  - *Design-change-driven* → update affected outcome readiness and proof boundaries.
  - *Cross-artifact impact* → separate independent owner episodes; offer Course-Correction only when the choices are coupled and materially change scope, sequencing, or proof.

## Tasks

Progress:

- [ ] Step 1: Assess each handoff item targeting Sonia — classify per Global Directives.
- [ ] Step 2: Preview the handoff set — name categories and approximate question count before the first prompt.
- [ ] Step 3: Resolve bounded items — for each accepted planning change:
  - Update the affected outcome in `verification-matrix.md`; mirror legacy records only when applicable
  - Update `Owner Disposition` and `Promotion Record`
  - Run the **Promotion Cascade Check** from `references/gap-resolution.md`: classify consumers `unaffected | mechanical | owner-decision | stale`; scribe mechanical propagation; resolve independent owner decisions through separate ladder episodes; offer Course-Correction only for coupled choices and wait for user confirmation. Mark only unresolved consumers stale and append `Downstream Cascade: <summary>`; do not replace an in-session resolution with a new handoff.
- [ ] Step 4: Defer items needing design input — name missing constraint; route with one precise handoff item when another owner must act.
- [ ] Step 5: Write — persist planning changes; update `timestamp` frontmatter.
- [ ] Step 6: Register — after successful promotion, remove repaired planning artifacts from registry `## Stale` and add them to `## Live`; leave only unresolved artifacts stale with their governing handoff/proposal reference. Move terminal artifacts to `## Archived` only under their explicit owner/trigger rule.
- [ ] Step 7: Close — apply Exit and Handoff from the core skill. Name each item resolved, deferred, rejected, or superseded.

## Definition of Done

- [ ] Every planning-owned handoff item assessed and routed or resolved with reason
- [ ] Planning changes written to outcome records; affected proof marked pending when source contracts shifted
- [ ] `registry.md` updated
- [ ] Close message: items resolved, deferred items, next action or owner
