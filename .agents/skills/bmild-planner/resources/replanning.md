# Replanning

Revise an existing plan when a blocker surfaces, design changes, or a re-sequencing need arises during execution. Completed Slices are fixed history — only unstarted and active Slices are in scope for revision.

## Additional Context

Load in this order before proceeding:

- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/adr/` entries relevant to the planning target
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `slices.md` in full — read the current plan state before making any changes
- All active `slice-<N>.md` files under `## Live`
- Updated design artifacts that triggered the replan if named

## Additional Directives

Prefer available code intelligence capabilities over raw filesystem traversal when possible before file-intense impact assessment or recutting. Use symbol-aware navigation (e.g. Serena), AST-aware structural analysis (e.g. ast-grep), or semantic search (e.g. ck-search) before falling back to grep/glob/read workflows.

**Recovery-scope split rule.** When adding recovery scope to an active or in-progress Slice, evaluate whether the addition materially shifts the Slice's acceptance criteria (new AC, new design contract, new files touched beyond the planned reads/edits). If yes, the recut produces a **new** Slice file (next `slice-<N>.md`) rather than expanding the existing Slice. The original active Slice's AC remains unchanged; recovery work is sequenced as a new Slice via `slices.md` Slice Registry dependency notes. Single-Slice Optimisation does not apply to mixed recovery + original scope.

## Tasks

Progress:

- [ ] Step 1: **Identify the trigger.** Determine precisely what changed: a blocked implementation, a design update, a discovered dependency, or a scope change. If not specified, ask one question. Do not re-plan speculatively.

- [ ] Step 2: **Assess impact.** Identify which Slices are affected:
  - **Completed Slices** are fixed history — do not revise.
  - **Active Slices** are temporarily frozen — revise only if fundamentally invalid.
  - **Unstarted (todo) Slices** are fully in scope for revision or resequencing.

- [ ] Step 3: **Recut.** Run at most one recut pass on affected unstarted Slices, then one final backward coverage verification pass. If coverage still fails after one recut, hand back with a precise blocking question rather than looping. Apply the recovery-scope split rule (see Additional Directives) when recovery work touches an active Slice.

- [ ] Step 4: **Backward Coverage Verification.** Re-run coverage verification across the revised plan. Record the updated outcome in `slices.md ## Coverage Verification`. If any `Must Have` becomes uncovered by the recut, escalate before finalising.

- [ ] Step 5: **Write updated Slices.** Update affected `slice-<N>.md` files. When likely reads, planned edits, or new-file estimates change, re-run `bash <planner-skill-dir>/scripts/run-budget-slice.sh` from the project root (where `<planner-skill-dir>` is the active `bmild-planner` skill directory for the current harness) and refresh the Slice's `## Slice token estimate` plus Planning Notes. Update `slices.md` with revised Slice Registry entries, recut note (if applicable), and updated coverage verification. Do not modify completed Slice files.

- [ ] Step 6: **Context memory update.** Add any newly active `slice-<N>.md` files to `## Live` in `registry.md`. Move superseded Slice files to `## Archived`.

- [ ] Step 7: **Close.** Apply the Exit and Handoff format from the core skill. Re-route Alex to the next viable Slice, or hand back upstream with a precise question if the blocker requires a design decision.

## Definition of Done

- [ ] Trigger identified and impact scoped to affected Slices only
- [ ] Completed Slices not modified
- [ ] At most one recut pass applied to unstarted Slices
- [ ] Backward coverage verification re-run and recorded
- [ ] Updated `slices.md` and affected `slice-<N>.md` files written
- [ ] `registry.md` updated to reflect revised plan state
- [ ] Close message: what changed, revised plan state, next Slice for Alex or blocking question
