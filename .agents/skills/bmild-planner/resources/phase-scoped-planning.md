# Phase-Scoped Planning

Decompose a named phase into implementation-ready Slices. The named phase is the explicit scope boundary — do not decompose beyond it.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/adr/` entries relevant to the planning target
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md`
- `slices.md` if it exists
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Readiness gate first.** Confirm readiness passed (`## Readiness` in `slices.md` or inline checks per `readiness-verification.md`) before authoring Slices.
- **Both `product-brief.md` and `prd.md` must exist** before decomposition. If either is missing, block and route to Faisal.
- **Decompose only the named phase.** Deferred phases are roadmap entries in `slices.md`, not implementation-ready Slice files.
- **Vertical Slices**, sequenced by logical dependency. Prefer the fewest Slices consistent with dependency safety and verifiable end conditions — not layer splits.
- **Single-Slice Optimisation:** one file, one localised component, or cohesive atomic update → exactly one Slice. Do not invent groundwork or cleanup Slices for trivial changes.
- **Phase 1 (MVP) Slices complete before Phase 2** begins. Document dependencies in `slices.md`.
- **Verification matrix items pass only after named proof is run** — implementation status alone is not proof.

## Routing heuristics (Slice budgeting)

Run `bash <planner-skill-dir>/scripts/run-budget-slice.sh --target [slice_target] --base [tokenizer_base] --multiplier [tokenizer_multiplier] --reads <read-files> --edits <edit-files> [--new <count> --src <dir>]` from the project root.

- *Budget OVER target* → split, recut, or hand back. Persist estimate fields in each Slice's `## Slice token estimate` and Planning Notes.
- *Reads/edits mixed or omitted, or new-file creation unestimated* → treat estimate as invalid; re-run with separate `--reads`, `--edits`, and when needed `--new` plus `--src`.
- *`--src` points at a broad mixed tree* → prefer the closest stable peer directory for the artifact type Alex will create.

## Tasks

Progress:

- [ ] Step 1: Readiness gate — confirm readiness passed; if not, switch to Readiness-Verification before proceeding.
- [ ] Step 2: Forward decomposition — decompose only the named phase per Global Directives.
- [ ] Step 3: Slice budgeting — budget each Slice per Routing heuristics and core Context Reads tokenizer passthrough.
- [ ] Step 4: Sequencing — order by dependency; Phase 1 before Phase 2.
- [ ] Step 5: Backward coverage verification — map every `Must Have` to Slices; record `pass`, `pass_with_warning`, `fail`, or `handback`. Recut if `fail`.
- [ ] Step 6: Pre-exit offer (declinable in one word) — *"Before I write the Slices — anything you want to take to roundtable or examine from another angle first? Otherwise I'll proceed."*
- [ ] Step 7: Write Slices — write `slice-<N>.md` using `assets/slice-template.md` with all required sections.
- [ ] Step 8: Write `slices.md` — update using `assets/slices-template.md` (`## Readiness`, `## Slice Registry`, `## Roadmap / Deferred Phases`, `## Coverage Verification`).
- [ ] Step 9: Register — add `slices.md` and active `slice-<N>.md` to `## Live` in `registry.md`. Do not add `todo` Slices until they begin. Update `rollup.md` if new initiative.
- [ ] Step 10: Close — apply Exit and Handoff from the core skill. Hand off one Slice at a time to Alex.

## Definition of Done

- [ ] Readiness gate confirmed
- [ ] Forward decomposition covers only the named phase
- [ ] Slice count minimum viable for dependency safety and context budget
- [ ] Backward coverage verification recorded
- [ ] Each active `slice-<N>.md` written with token estimate and budgeted inputs
- [ ] `slices.md`, `registry.md`, and `rollup.md` updated
- [ ] Close message: scope planned, Slice count, verification matrix status, next owner
