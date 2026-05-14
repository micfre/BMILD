---
name: bmild-ux / ux-refinement
description: "Refinement mode. Activated when ux-design.md already exists. Extends or updates the existing UX design for new requirements or changed constraints."
---

## UX-Refinement Mode

Extend or update an existing `ux-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

1. **Entry** — Resolve the initiative path by checking `[plan_folder]/<initiative-name>/` directly when an initiative is named. Load in this order:
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/ux-design.md` in full — this is the design you are modifying
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` for current requirements
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` if it exists — technical constraints only; not a source of UX intent
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Hydrate upstream inputs** — Read current `product-brief.md` and `prd.md` before asking refinement questions, and read `system-design.md` when present to understand fixed technical constraints. Treat explicit PM requirements as settled unless the refinement target exposes a conflict, stale requirement, UX infeasibility, or UX-owned trade-off. Do not infer user intent from architecture.

3. **Identify refinement target** — Determine what has changed or what is being challenged. If the user has not specified, ask one question. Surface any existing bounded assumptions, unresolved queue items, or stale promotion records before proceeding.

   If live `spec-patch-queue.md` items target `ux-design.md` or `DESIGN.md`, resolve them in this refinement or explicitly defer, reject, supersede, or move them to `user-attention.md` as appropriate.

4. **Brainstorm reconciliation** — If any brainstorming session preceded this artifact, load it and cross-reference its ideas against the current `ux-design.md`. Identify ideas that were silently dropped — especially ideas about interaction feel, tone, personality, or "what should this feel like" that don't map cleanly to structural flows or screen layouts. Present findings to the user and ask whether any should be incorporated before proceeding.

5. **Groundtruth** — Verify any new codebase reality relevant to the change. Check that existing patterns in `DESIGN.md` still constrain the refined design.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

6. **Probe** — Present what appears settled from PM artifacts, what technical constraints from architecture apply, what the change affects, which user-state hypotheses follow, and what UX decisions are newly required. Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Apply all Craft Standards from the core skill. Elicit before modifying; write at a meaningful checkpoint. Do not silently absorb unresolved issues.

7. **Write** — Load `./resources/completion-criteria.yaml` and privately re-check the sections being modified. Update `[plan_folder]/<initiative-name>/ux-design.md`. Update the `updated` frontmatter date. Preserve sections not being changed.

8. **Distillation gate** — Do any refined decisions qualify for distillation to project-root `DESIGN.md`? Apply the same gate as UX-Design mode: global interaction principles and visual language decisions only.

9. **Register in context memory** — Confirm `ux-design.md` remains in `## Live` in `_context.md`. Move any superseded predecessor to `## Archived` if applicable.

10. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Brainstorming ideas reconciled (if applicable)
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not just preserved
- [ ] Relevant `spec-patch-queue.md` items targeting UX-owned artifacts resolved, deferred, rejected, superseded, or moved to `user-attention.md`
- [ ] Remaining user-owned ambiguity resolved, queued in `user-attention.md`, or handled as bounded assumptions when safe
- [ ] Updated `ux-design.md` written; `updated` date current
- [ ] `DESIGN.md` updated if distillation gate triggered
- [ ] `_context.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, queued or deferred governance items, next owner
