---
name: bmild-planner / replanning
description: "Replanning mode. Activated when an existing plan has a blocker, design change, or re-sequencing need discovered during execution."
---

## Replanning Mode

Revise an existing plan when a blocker surfaces, design changes, or a re-sequencing need arises during execution. Completed Slices are fixed history — only unstarted and active Slices are in scope for revision.

1. **Entry** — Load in this order:
   - [ ] `[plan_folder]/CHARTER.md` if it exists
   - [ ] `[plan_folder]/ARCHITECTURE.md` if it exists
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `[plan_folder]/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `slices.md` in full — read the current plan state before making any changes
   - [ ] All active `slice-<N>.md` files under `## Live`
   - [ ] Updated design artifacts that triggered the replan if named

2. **Identify the trigger** — Determine precisely what changed: a blocked implementation, a design update, a discovered dependency, or a scope change. If not specified, ask one question. Do not re-plan speculatively.

3. **Repository discovery** — Before file-intense impact assessment or recutting, prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

4. **Assess impact** — Identify which Slices are affected:
   - **Completed Slices** are fixed history — do not revise
   - **Active Slices** are temporarily frozen — revise only if fundamentally invalid
   - **Unstarted (todo) Slices** are fully in scope for revision or resequencing

5. **Recut** — Run at most one recut pass on affected unstarted Slices, then one final backward coverage verification pass. If coverage still fails after one recut, hand back with a precise blocking question rather than looping.

6. **Backward Coverage Verification** — Re-run coverage verification across the revised plan. Record the updated outcome in `slices.md ## Coverage Verification`. If any `Must Have` becomes uncovered by the recut, escalate before finalising.

7. **Write updated Slices** — Update affected `slice-<N>.md` files. When likely reads, planned edits, or new-file estimates change, re-run `bash .agents/skills/bmild-planner/scripts/run-budget-slice.sh` from the project root and refresh the Slice's `## Slice token estimate` plus Planning Notes. Update `slices.md` with revised Slice Registry entries, recut note (if applicable), and updated coverage verification. Do not modify completed Slice files.

8. **Update context memory** — Add any newly active `slice-<N>.md` files to `## Live` in `_context.md`. Move superseded Slice files to `## Archived`.

9. **Close** — Apply the Exit and Handoff format from the core skill. Re-route Alex to the next viable Slice, or hand back upstream with a precise question if the blocker requires a design decision.

---

## Definition of Done

- [ ] Trigger identified and impact scoped to affected Slices only
- [ ] Completed Slices not modified
- [ ] At most one recut pass applied to unstarted Slices
- [ ] Backward coverage verification re-run and recorded
- [ ] Updated `slices.md` and affected `slice-<N>.md` files written
- [ ] `_context.md` updated to reflect revised plan state
- [ ] Close message: what changed, revised plan state, next Slice for Alex or blocking question
