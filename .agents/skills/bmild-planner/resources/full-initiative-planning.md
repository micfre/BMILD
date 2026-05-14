---
name: bmild-planner / full-initiative-planning
description: "Full-initiative planning mode. Activated only when the user explicitly requests planning across all phases. Decomposes the full initiative including future phases."
---

## Full-Initiative Planning Mode

Decompose an entire initiative across all phases. Use only when the user explicitly requests full-initiative planning — otherwise use Phase-Scoped Planning.

1. **Entry** — Load in this order:
   - [ ] `[plan_folder]/CHARTER.md` if it exists
   - [ ] `[plan_folder]/ARCHITECTURE.md` if it exists
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `[plan_folder]/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` from the initiative folder — all inputs
   - [ ] `slices.md` if it exists

2. **Readiness gate** — Confirm readiness has passed (check the `## Readiness` section of `slices.md` if it exists, or run readiness checks inline). If readiness has not passed: switch to Readiness-Verification mode before proceeding.

3. **Repository discovery** — Before file-intense decomposition or Slice budgeting, prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

4. **Forward Decomposition — Phase 1 (MVP)** — Identify and decompose all Phase 1 (MVP) work. Apply all Craft Standards from the core skill. Prefer the fewest Slices consistent with dependency safety.

5. **Forward Decomposition — Future Phases** — For phases beyond MVP:
   - Author implementation-ready Slice files for future phases only when the required UX and architecture artifacts for that phase exist
   - If required artifacts do not exist: record roadmap entries or blocked placeholders in `slices.md` — do not create `slice-<N>.md` files for them
   - Future-phase placeholders are not active Slices: do not add them to `## Live` in `_context.md`

6. **Slice Budgeting** — Budget all active Slices with `bash .agents/skills/bmild-planner/scripts/budget-slice.sh` from the project root. Record returned `budget.estimated_total`, target, percent of target, and raw budget fields in each Slice's `## Slice token estimate`; record budgeted read/edit/new-file inputs in Planning Notes.

7. **Sequencing** — All Phase 1 (MVP) Slices must complete entirely before any Phase 2 Slices begin. Order by logical dependency within each phase.

8. **Backward Coverage Verification** — Map every `Must Have` requirement from `prd.md` to Slices across all phases. Record the outcome. If `fail`: recut before finalising.

9. **Write Slices** — Write `[plan_folder]/<initiative-name>/slice-<N>.md` for each active Slice using `assets/slice-template.md`. Do not create implementation-ready Slice files for future phases without required design artifacts.

10. **Write `slices.md`** — Update `[plan_folder]/<initiative-name>/slices.md` using `assets/slices-template.md`. Include `## Readiness`, `## Slice Registry` (all phases), `## Roadmap / Deferred Phases` (blocked placeholders), and `## Coverage Verification`.

11. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Add `slices.md` and currently active `slice-<N>.md` files to `## Live`. Do not add `todo` Slices to `## Live` until they begin. Add an entry to `[plan_folder]/_system/_rollup.md` (use `assets/rollup-template.md` if it doesn't exist).

12. **Close** — Apply the Exit and Handoff format from the core skill.

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
