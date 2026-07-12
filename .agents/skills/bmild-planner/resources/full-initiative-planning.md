# Full-Initiative Planning

Decompose an entire initiative across all phases. Use only when the user explicitly requests full-initiative planning — otherwise use Phase-Scoped Planning.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- Relevant ADRs in `[plan_folder]/adr/` if they constrain the initiative
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md`
- `slices.md` if it exists
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Readiness sequencing.** Name the blocking thing and its readiness chain when ordering dependencies; this is reasoning vocabulary, not a required turn shape.
- **Readiness gate first.** Confirm readiness passed before authoring Slices.
- **Both `product-brief.md` and `prd.md` must exist** before decomposition. If either is missing, block and route to Faisal.
- **Vertical Slices**, sequenced by logical dependency. Prefer the fewest Slices consistent with dependency safety.
- **Single-Slice Optimisation** where applicable.
- **Phase 1 (MVP) Slices complete before Phase 2** begins.
- **Future-phase Slice files** only when required UX and architecture artifacts for that phase exist; otherwise roadmap entries only — not `## Live`.
- **Verification matrix items pass only after named proof is run.**

## Routing heuristics (Slice budgeting)

Same as Phase-Scoped Planning — run `bash <planner-skill-dir>/scripts/run-budget-slice.sh` with separate `--reads`, `--edits`, and when needed `--new` plus `--src`. OVER target → split, recut, or hand back.

## Tasks

Progress:

- [ ] Step 1: Readiness gate — confirm readiness passed; if not, switch to Readiness-Verification.
- [ ] Step 2: Forward decomposition — Phase 1 (MVP) in full per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 3: Future phases — active Slice files only when design artifacts exist; otherwise roadmap placeholders (not `## Live`).
- [ ] Step 4: Slice budgeting — budget all active Slices per Routing heuristics.
- [ ] Step 5: Sequencing — Phase 1 completes before Phase 2; dependency order within each phase.
- [ ] Step 6: Backward coverage verification — map every `Must Have` across phases; recut if `fail`.
- [ ] Step 7: Pre-exit offer (declinable in one word) — *"Before I write the Slices — anything you want to take to roundtable or examine from another angle first? Otherwise I'll proceed."*
- [ ] Step 8: Write Slices — `slice-<N>.md` for each active Slice using `assets/slice-template.md`.
- [ ] Step 9: Write `slices.md` — `## Readiness`, `## Slice Registry`, `## Roadmap / Deferred Phases`, `## Coverage Verification`.
- [ ] Step 10: Register — update `registry.md` and `rollup.md` (`assets/rollup-template.md` if new).
- [ ] Step 11: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Readiness gate confirmed
- [ ] Phase 1 fully decomposed; future phases as active Slices or roadmap entries
- [ ] Slice count minimum viable for dependency safety
- [ ] Backward coverage verification recorded
- [ ] Each active `slice-<N>.md` and `slices.md` written
- [ ] `registry.md` and `rollup.md` updated
- [ ] Close message: scope planned, Slice count by phase, verification matrix status, next owner
