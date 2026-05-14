---
name: bmild-arch / architecture-refinement
description: "Refinement mode. Activated when system-design.md already exists. Extends or updates the existing design for new requirements or changed constraints."
---

## Architecture-Refinement Mode

Extend or update an existing `system-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

1. **Entry** — Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` in full — this is the contract you are modifying
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` for current requirements
   - [ ] Do not load `## Archived` entries or other initiative folders

2. **Identify refinement target** — Determine what has changed or what is being challenged. If the user has not specified, ask one question. Surface any existing bounded assumptions, unresolved queue items, or stale promotion records before proceeding.

3. **Brainstorm reconciliation** — If any brainstorming session preceded this artifact, load it and cross-reference its ideas against the current `system-design.md`. Identify ideas that were silently dropped — especially non-obvious technical approaches, cross-cutting concerns, or alternative architectures that were explored but not adopted. Present findings to the user and ask whether any should be reconsidered before proceeding.

4. **Groundtruth** — Verify any new codebase reality relevant to the change. Check that the existing design still reflects the active runtime path — not deprecated or bypassed code.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

5. **Synthesize and probe** — Present what appears settled, what the change affects, and what decisions are newly required. Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Apply all Craft Standards from the core skill. Use compact option blocks for trade-offs. Do not silently absorb unresolved issues into the updated design.

   If live `spec-patch-queue.md` items target `system-design.md` or `plans/ARCHITECTURE.md`, resolve them in this refinement or explicitly defer, reject, supersede, or move them to `user-attention.md` as appropriate.

6. **Write** — Load `./resources/completion-criteria.yaml` and privately re-check the sections being modified. Update `[plan_folder]/<initiative-name>/system-design.md`. Update the `updated` frontmatter date. Use `assets/system-design-template.md` as a structural reference; preserve sections not being changed.

7. **Distillation gate** — Do any refined decisions qualify for distillation to `plans/ARCHITECTURE.md`? Apply the same gate as Architecture-Design mode: cross-initiative schema patterns, auth contracts, or shared infrastructure decisions only.

8. **Register in context memory** — Confirm `system-design.md` remains in `## Live` in `_context.md`. Move any superseded predecessor to `## Archived` if a new version was created.

9. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Brainstorming ideas reconciled (if applicable)
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not just preserved
- [ ] Relevant `spec-patch-queue.md` items targeting architecture-owned artifacts resolved, deferred, rejected, superseded, or moved to `user-attention.md`
- [ ] Remaining user-owned ambiguity resolved, queued in `user-attention.md`, or handled as bounded assumptions when safe
- [ ] Updated `system-design.md` written; `updated` date current
- [ ] `ARCHITECTURE.md` updated if distillation gate triggered
- [ ] `_context.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, queued or deferred governance items, next owner
