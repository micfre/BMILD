---
name: bmild-planner / phase-scoped-planning
description: "Phase-scoped planning mode. Activated when the user names a specific phase (MVP, Phase 1). Decomposes only that phase into implementation-ready Slices."
---

## Phase-Scoped Planning Mode

Decompose a named phase into implementation-ready Slices. The named phase is the explicit scope boundary — do not decompose beyond it.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` from the initiative folder — primary inputs
   - [ ] `slices.md` if it exists — you may be adding to an existing plan

2. **Readiness gate** — Confirm readiness has passed (check the `## Readiness` section of `slices.md` if it exists, or run readiness checks inline). If readiness has not passed: switch to Readiness-Verification mode before proceeding. Do not decompose a phase that has not passed the readiness gate.

3. **Forward Decomposition** — Identify all discrete units of implementation work implied by the named phase. Decompose only that phase. Apply all Craft Standards from the core skill:
   - Prefer the fewest Slices consistent with dependency safety and verifiable end conditions
   - Apply Single-Slice Optimisation where applicable
   - Decompose vertically — not by layer
   - For deferred phases, record roadmap entries in `slices.md` rather than implementation-ready Slice files

4. **Slice Budgeting** — For each Slice, build `Likely Required Reads`, `Likely Planned Edits`, and when new files are expected, estimate how many Alex is likely to create and choose the closest stable source directory whose existing files are the same kind of artifact Alex is likely to add. Avoid broad mixed directories when a narrower peer directory exists. Then run `scripts/budget-slice.sh --target [slice_target] --base [tokenizer_base] --multiplier [tokenizer_multiplier] --reads <read-files> --edits <edit-files> [--new <count> --src <dir>]`. If OVER BUDGET, split or recut. Record the estimate plus the exact read/edit file sets and any new-file estimate inputs in the Slice's Planning Notes.

5. **Sequencing** — Order Slices by logical dependency. All Phase 1 (MVP) Slices must complete before any Phase 2 Slices begin. Document dependencies explicitly.

6. **Backward Coverage Verification** — Map every `Must Have` requirement from `prd.md` to one or more Slices. Record the outcome: `pass`, `pass_with_warning`, `fail`, or `handback`. If `fail`: recut before finalising. If `handback`: name the blocking question and route upstream. Do not record `pass` if any `Must Have` is uncovered.

7. **Write Slices** — Write `[plan_folder]/<initiative-name>/slice-<N>.md` for each active Slice using `assets/slice-template.md`. Each Slice must have: intent, concrete outcome, scope, dependencies, design contracts, likely required reads, likely planned edits, verifiable end condition, acceptance criteria, and planning notes including budget estimate.

8. **Write `slices.md`** — Update `[plan_folder]/<initiative-name>/slices.md` using `assets/slices-template.md`. The `## Readiness` section must be written before any Slice entries. Update `## Slice Registry` with all Slices. Add `## Roadmap / Deferred Phases` for any out-of-scope work. Record coverage verification in `## Coverage Verification`.

9. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Add `slices.md` and the active `slice-<N>.md` files to `## Live`. Do not add `todo` Slices to `## Live` until they begin. Move any superseded predecessor to `## Archived`. Add an entry to `plans/_system/_rollup.md` if this is a new initiative (use `assets/rollup-template.md` if it doesn't exist).

10. **Close** — Apply the Exit and Handoff format from the core skill. Hand off one Slice at a time. Alex works Slice N, marks it ready-for-review, then picks up Slice N+1. Sonia does not need to be re-invoked per Slice unless the plan changes or a blocker surfaces.

---

## Definition of Done

- [ ] Readiness gate confirmed before any Slice is authored
- [ ] Forward decomposition covers only the named phase
- [ ] Slice count is the minimum viable count consistent with dependency safety, proof boundaries, and context budget
- [ ] Backward coverage verification recorded with outcome
- [ ] Each active `slice-<N>.md` written with all required sections including likely planned edits, new-file estimate when applicable, and budget estimate
- [ ] `slices.md` written with Readiness, Slice Registry, Roadmap, and Coverage Verification sections
- [ ] `_context.md` and `_rollup.md` updated
- [ ] Close message: scope planned, Slice count, verification matrix status, next owner
