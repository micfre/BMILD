---
name: bmild-planner / full-initiative-planning
description: "Full-initiative planning mode. Activated only when the user explicitly requests planning across all phases. Decomposes the full initiative including future phases."
---

## Full-Initiative Planning Mode

Decompose an entire initiative across all phases. Use only when the user explicitly requests full-initiative planning — otherwise use Phase-Scoped Planning.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` from the initiative folder — all inputs
   - [ ] `slices.md` if it exists

2. **Readiness gate** — Confirm readiness has passed (check the `## Readiness` section of `slices.md` if it exists, or run readiness checks inline). If readiness has not passed: switch to Readiness-Verification mode before proceeding.

3. **Forward Decomposition — Phase 1 (MVP)** — Identify and decompose all Phase 1 (MVP) work. Apply all Planning Standards from the core skill. Prefer the fewest Slices consistent with dependency safety.

4. **Forward Decomposition — Future Phases** — For phases beyond MVP:
   - Author implementation-ready Slice files for future phases only when the required UX and architecture artifacts for that phase exist
   - If required artifacts do not exist: record roadmap entries or blocked placeholders in `slices.md` — do not create `slice-<N>.md` files for them
   - Future-phase placeholders are not active Slices: do not add them to `## Live` in `_context.md`

5. **Slice Budgeting** — Budget all active Slices. Record budget estimates in each Slice's Planning Notes.

6. **Sequencing** — All Phase 1 (MVP) Slices must complete entirely before any Phase 2 Slices begin. Order by logical dependency within each phase.

7. **Backward Coverage Verification** — Map every `Must Have` requirement from `prd.md` to Slices across all phases. Record the outcome. If `fail`: recut before finalising.

8. **Write Slices** — Write `[plan_folder]/<initiative-name>/slice-<N>.md` for each active Slice using `assets/slice-template.md`. Do not create implementation-ready Slice files for future phases without required design artifacts.

9. **Write `slices.md`** — Update `[plan_folder]/<initiative-name>/slices.md` using `assets/slices-template.md`. Include `## Readiness`, `## Slice Registry` (all phases), `## Roadmap / Deferred Phases` (blocked placeholders), and `## Coverage Verification`.

10. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Add `slices.md` and currently active `slice-<N>.md` files to `## Live`. Do not add `todo` Slices to `## Live` until they begin. Add an entry to `plans/_rollup.md` (use `assets/rollup-template.md` if it doesn't exist).

11. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Readiness gate confirmed before any Slice is authored
- [ ] Phase 1 fully decomposed into active Slices
- [ ] Future phases represented as active Slices (if artifacts exist) or roadmap entries (if not)
- [ ] Slice count is the minimum viable count consistent with dependency safety
- [ ] Backward coverage verification recorded across all phases
- [ ] `slices.md` and all active `slice-<N>.md` files written
- [ ] `_context.md` and `_rollup.md` updated
- [ ] Close message: scope planned, Slice count by phase, verification matrix status, next owner
