# Replanning

Revise an existing plan when a blocker surfaces, design changes, or a re-sequencing need arises during execution. Completed Slices are fixed history — only unstarted and active Slices are in scope for revision.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/adr/` entries relevant to the planning target
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `slices.md` in full
- All active `slice-<N>.md` files under `## Live`
- Updated design artifacts that triggered the replan if named
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Completed Slices are fixed history** — do not revise.
- **At most one recut pass** on affected unstarted Slices, then one coverage verification pass. If coverage still fails, hand back with one precise question.
- **Multi-artifact cascades** → exit to Course-Correction mode, not this mode.

## Recovery-scope split rule

When recovery scope would materially shift an active Slice's acceptance criteria (new AC, new design contract, new files beyond planned reads/edits), produce a **new** `slice-<N>.md` rather than expanding the existing Slice. Single-Slice Optimisation does not apply to mixed recovery + original scope.

## Routing heuristics (Slice budgeting)

When reads, edits, or new-file estimates change, re-run `bash <planner-skill-dir>/scripts/run-budget-slice.sh` and refresh `## Slice token estimate` and Planning Notes. Same invalid-input rules as phase-scoped planning.

## Tasks

Progress:

- [ ] Step 1: Identify the trigger — if unspecified, ask one question. Do not re-plan speculatively.
- [ ] Step 2: Assess impact — completed fixed; active frozen unless fundamentally invalid; todo fully in scope.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 3: Recut — one pass on affected unstarted Slices; apply Recovery-scope split rule when needed.
- [ ] Step 4: Backward coverage verification — re-run; record in `slices.md ## Coverage Verification`.
- [ ] Step 5: Write — update affected `slice-<N>.md` and `slices.md`; re-budget when inputs changed. Do not modify completed Slices.
- [ ] Step 6: Register — update `registry.md` (`## Live` / `## Archived`).
- [ ] Step 7: Close — apply Exit and Handoff from the core skill. Re-route Alex to next viable Slice or hand back upstream.

## Definition of Done

- [ ] Trigger identified; completed Slices untouched
- [ ] At most one recut pass on unstarted Slices
- [ ] Backward coverage verification re-run and recorded
- [ ] Updated `slices.md` and affected `slice-<N>.md` files written
- [ ] `registry.md` updated
- [ ] Close message: what changed, revised plan state, next Slice or blocking question
