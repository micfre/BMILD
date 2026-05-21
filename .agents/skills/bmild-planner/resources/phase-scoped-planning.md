# Phase-Scoped Planning

Decompose a named phase into implementation-ready Slices. The named phase is the explicit scope boundary — do not decompose beyond it.

## Additional Context

Load in this order before proceeding:

- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/adr/` entries relevant to the planning target
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` from the initiative folder — primary inputs
- `slices.md` if it exists — you may be adding to an existing plan

## Additional Directives

Prefer available code intelligence capabilities over raw filesystem traversal when possible before file-intense decomposition or Slice budgeting. Use symbol-aware navigation (e.g. Serena), AST-aware structural analysis (e.g. ast-grep), or semantic search (e.g. ck-search) before falling back to grep/glob/read workflows.

## Tasks

Progress:

- [ ] Step 1: **Readiness gate.** Confirm readiness has passed (check the `## Readiness` section of `slices.md` if it exists, or run readiness checks inline per `resources/readiness-verification.md`). If readiness has not passed: switch to Readiness-Verification mode before proceeding. Do not decompose a phase that has not passed the readiness gate.

- [ ] Step 2: **Forward Decomposition.** Identify all discrete units of implementation work implied by the named phase. Decompose only that phase. Apply all Global Directives from the core skill:
  - Prefer the fewest Slices consistent with dependency safety and verifiable end conditions.
  - Apply Single-Slice Optimisation where applicable.
  - Decompose vertically — not by layer.
  - For deferred phases, record roadmap entries in `slices.md` rather than implementation-ready Slice files.

- [ ] Step 3: **Slice Budgeting.** For each Slice, build `Likely Required Reads`, `Likely Planned Edits`, and when new files are expected, estimate how many Alex is likely to create and choose the closest stable source directory whose existing files are the same kind of artifact Alex is likely to add. Avoid broad mixed directories when a narrower peer directory exists. Then run `bash <planner-skill-dir>/scripts/run-budget-slice.sh --target [slice_target] --base [tokenizer_base] --multiplier [tokenizer_multiplier] --reads <read-files> --edits <edit-files> [--new <count> --src <dir>]` from the project root, where `<planner-skill-dir>` is the active `bmild-planner` skill directory for the current harness. If OVER BUDGET, split or recut. Record the returned `budget.estimated_total`, target, percent of target, and raw budget fields in the Slice's `## Slice token estimate`; record the exact read/edit file sets and any new-file estimate inputs in Planning Notes.

- [ ] Step 4: **Sequencing.** Order Slices by logical dependency. All Phase 1 (MVP) Slices must complete before any Phase 2 Slices begin. Document dependencies explicitly.

- [ ] Step 5: **Backward Coverage Verification.** Map every `Must Have` requirement from `prd.md` to one or more Slices. Record the outcome: `pass`, `pass_with_warning`, `fail`, or `handback`. If `fail`: recut before finalising. If `handback`: name the blocking question and route upstream. Do not record `pass` if any `Must Have` is uncovered.

- [ ] Step 6: **Write Slices.** Write `[plan_folder]/<initiative-name>/slice-<N>.md` for each active Slice using `assets/slice-template.md`. Each Slice must have: intent, concrete outcome, scope, dependencies, design contracts, likely required reads, likely planned edits, likely required reads check, slice token estimate, verifiable end condition, acceptance criteria, and planning notes including budgeted input sets.

- [ ] Step 7: **Write `slices.md`.** Update `[plan_folder]/<initiative-name>/slices.md` using `assets/slices-template.md`. The `## Readiness` section must be written before any Slice entries. Update `## Slice Registry` with all Slices. Add `## Roadmap / Deferred Phases` for any out-of-scope work. Record coverage verification in `## Coverage Verification`.

- [ ] Step 8: **Context memory update.** Open `[plan_folder]/<initiative-name>/registry.md`. Add `slices.md` and the active `slice-<N>.md` files to `## Live`. Do not add `todo` Slices to `## Live` until they begin. Move any superseded predecessor to `## Archived`. Add or update an entry in `[plan_folder]/rollup.md` if this is a new initiative (use `assets/rollup-template.md` if it doesn't exist).

- [ ] Step 9: **Close.** Apply the Exit and Handoff format from the core skill. Hand off one Slice at a time. Alex works Slice N, marks it ready-for-review, then picks up Slice N+1. Sonia does not need to be re-invoked per Slice unless the plan changes or a blocker surfaces.

## Definition of Done

- [ ] Readiness gate confirmed before any Slice is authored
- [ ] Cross-initiative semantic context checked via `context-map.md` when relevant
- [ ] Forward decomposition covers only the named phase
- [ ] Slice count is the minimum viable count consistent with dependency safety, proof boundaries, and context budget
- [ ] Backward coverage verification recorded with outcome
- [ ] Each active `slice-<N>.md` written with all required sections including likely planned edits, new-file estimate when applicable, and slice token estimate
- [ ] `slices.md` written with Readiness, Slice Registry, Roadmap, and Coverage Verification sections
- [ ] `registry.md` and `rollup.md` updated
- [ ] Close message: scope planned, Slice count, verification matrix status, next owner
