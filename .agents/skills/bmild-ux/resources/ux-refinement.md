---
name: bmild-ux / ux-refinement
description: "Refinement mode. Activated when ux-design.md already exists. Extends or updates the existing UX design for new requirements or changed constraints."
---

## UX-Refinement Mode

Extend or update an existing `ux-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

1. **Entry** — Load in this order:
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/ux-design.md` in full — this is the design you are modifying
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` for current requirements
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Identify refinement target** — Determine what has changed or what is being challenged. If the user has not specified, ask one question. Surface any existing Open UX Questions in `ux-design.md` before proceeding.

   If live product or architecture artifacts contain UX Handoff Questions targeted to Katrina, resolve them in this refinement or explicitly defer them with user consent.

3. **Brainstorm reconciliation** — If any brainstorming session preceded this artifact, load it and cross-reference its ideas against the current `ux-design.md`. Identify ideas that were silently dropped — especially ideas about interaction feel, tone, personality, or "what should this feel like" that don't map cleanly to structural flows or screen layouts. Present findings to the user and ask whether any should be incorporated before proceeding.

4. **Groundtruth** — Verify any new codebase reality relevant to the change. Check that existing patterns in `DESIGN.md` still constrain the refined design.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

5. **Probe** — Present what appears settled, what the change affects, and what decisions are newly required. Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Apply all Craft Standards from the core skill. Elicit before modifying; write at a meaningful checkpoint. Do not silently absorb unresolved issues.

6. **Write** — Load `./resources/completion-criteria.yaml` and privately re-check the sections being modified. Update `[plan_folder]/<initiative-name>/ux-design.md`. Update the `updated` frontmatter date. Preserve sections not being changed.

7. **Distillation gate** — Do any refined decisions qualify for distillation to project-root `DESIGN.md`? Apply the same gate as UX-Design mode: global interaction principles and visual language decisions only.

8. **Register in context memory** — Confirm `ux-design.md` remains in `## Live` in `_context.md`. Move any superseded predecessor to `## Archived` if applicable.

9. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Brainstorming ideas reconciled (if applicable)
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not just preserved
- [ ] Handoff Questions from Faisal or Lance resolved in the design or explicitly deferred
- [ ] All Open UX Questions resolved or explicitly deferred by user
- [ ] Updated `ux-design.md` written; `updated` date current
- [ ] `DESIGN.md` updated if distillation gate triggered
- [ ] `_context.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, deferred risks, next owner
