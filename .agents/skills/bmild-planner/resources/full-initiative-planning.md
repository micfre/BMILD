# Full-Initiative Planning

Decompose an entire initiative across all phases. Use only when the user explicitly requests full-initiative planning — otherwise use Phase-Scoped Planning.

## Additional Context

Load in this order before proceeding:

- `[plan_folder]/context-map.md` if it exists
- Relevant ADRs in `[plan_folder]/adr/` if they constrain the initiative
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` from the initiative folder — all inputs
- `slices.md` if it exists

## Additional Directives

Prefer available code intelligence capabilities over raw filesystem traversal when possible before file-intense decomposition or Slice budgeting. Use symbol-aware navigation (e.g. Serena), AST-aware structural analysis (e.g. ast-grep), or semantic search (e.g. ck-search) before falling back to grep/glob/read workflows.

## Tasks

Progress:

- [ ] Step 1: **Readiness gate.** Confirm readiness has passed (check the `## Readiness` section of `slices.md` if it exists, or run readiness checks inline per `resources/readiness-verification.md`). If readiness has not passed: switch to Readiness-Verification mode before proceeding.

- [ ] Step 2: **Forward Decomposition — Phase 1 (MVP).** Identify and decompose all Phase 1 (MVP) work. Apply all Global Directives from the core skill. Prefer the fewest Slices consistent with dependency safety.

- [ ] Step 3: **Forward Decomposition — Future Phases.** For phases beyond MVP:
  - Author implementation-ready Slice files for future phases only when the required UX and architecture artifacts for that phase exist.
  - If required artifacts do not exist: record roadmap entries or blocked placeholders in `slices.md` — do not create `slice-<N>.md` files for them.
  - Future-phase placeholders are not active Slices: do not add them to `## Live` in `registry.md`.

- [ ] Step 4: **Slice Budgeting.** Budget all active Slices with `bash <planner-skill-dir>/scripts/run-budget-slice.sh` from the project root, where `<planner-skill-dir>` is the active `bmild-planner` skill directory for the current harness. Record returned `budget.estimated_total`, target, percent of target, and raw budget fields in each Slice's `## Slice token estimate`; record budgeted read/edit/new-file inputs in Planning Notes.

- [ ] Step 5: **Sequencing.** All Phase 1 (MVP) Slices must complete entirely before any Phase 2 Slices begin. Order by logical dependency within each phase.

- [ ] Step 6: **Backward Coverage Verification.** Map every `Must Have` requirement from `prd.md` to Slices across all phases. Record the outcome. If `fail`: recut before finalising.

- [ ] Step 7: **Write Slices.** Write `[plan_folder]/<initiative-name>/slice-<N>.md` for each active Slice using `assets/slice-template.md`. Each Slice must have: intent, concrete outcome, scope, dependencies, design contracts, likely required reads, likely planned edits, likely required reads check, slice token estimate, verifiable end condition, acceptance criteria, and planning notes including budgeted input sets. Do not create implementation-ready Slice files for future phases without required design artifacts.

- [ ] Step 8: **Write `slices.md`.** Update `[plan_folder]/<initiative-name>/slices.md` using `assets/slices-template.md`. Include `## Readiness`, `## Slice Registry` (all phases), `## Roadmap / Deferred Phases` (blocked placeholders), and `## Coverage Verification`.

- [ ] Step 9: **Context memory update.** Open `[plan_folder]/<initiative-name>/registry.md`. Add `slices.md` and currently active `slice-<N>.md` files to `## Live`. Do not add `todo` Slices to `## Live` until they begin. Add an entry to `[plan_folder]/rollup.md` (use `assets/rollup-template.md` if it doesn't exist).

- [ ] Step 10: **Close.** Apply the Exit and Handoff format from the core skill.

## Definition of Done

- [ ] Readiness gate confirmed before any Slice is authored
- [ ] Context-map coherence check confirmed (via readiness gate inline or prior Readiness-Verification mode; note "n/a — no cross-initiative semantic conflict" if applicable)
- [ ] Phase 1 fully decomposed into active Slices
- [ ] Future phases represented as active Slices (if artifacts exist) or roadmap entries (if not)
- [ ] Slice count is the minimum viable count consistent with dependency safety
- [ ] Each active `slice-<N>.md` written with all required sections including likely planned edits, new-file estimate when applicable, and slice token estimate
- [ ] Backward coverage verification recorded across all phases
- [ ] `slices.md` and all active `slice-<N>.md` files written
- [ ] `registry.md` and `rollup.md` updated
- [ ] Close message: scope planned, Slice count by phase, verification matrix status, next owner
