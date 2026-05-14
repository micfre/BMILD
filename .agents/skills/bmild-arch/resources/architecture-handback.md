---
name: bmild-arch / architecture-handback
description: "Owner-resolution mode. Activated when a governance queue item targets Lance's artifacts. Review the item, promote accepted changes into source artifacts, and close the loop."
---

## Architecture-Handback Mode

Resolve architecture-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

1. **Entry** — Identify the queue item and the source artifact it targets. Load in this order:
   - [ ] `[plan_folder]/ARCHITECTURE.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` in full
   - [ ] `[plan_folder]/<initiative-name>/spec-patch-queue.md`
   - [ ] The originating artifact or queue context that raised the issue (`prd.md`, `ux-design.md`, `slice-<N>.md`, `verification-matrix.md`, or `security-review-<slug>.md`)
   - [ ] Confirm no `## Archived` entries or other initiative folders were loaded

2. **Assess** — Read each queue item targeting Lance. Determine which can be resolved from existing design decisions and which require a new decision. For each requiring a new decision, apply the Decision Trade-offs format from the core skill — compact option blocks, not unstructured prose.

   If resolving a question requires repository inspection, prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

3. **Resolve** — Before the first question or decision prompt, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Provide clear answers or decisions for each item. Apply all Craft Standards from the core skill. For each accepted item that results in a design change:
   - [ ] Update `system-design.md` with the decision
   - [ ] Update the queue item's `Owner Disposition` and `Promotion Record`
   - [ ] Note the consequence for the originating persona's artifact

4. **Defer** — If an item cannot be resolved without additional product or UX input: name the specific constraint missing, route it through `user-attention.md` or back to the relevant source owner with one precise queue item, and mark the spec patch as deferred, rejected, superseded, or moved to user attention.

5. **Write** — If design changes result from resolving handback questions, update `[plan_folder]/<initiative-name>/system-design.md`. Update the `updated` frontmatter date.

6. **Distillation gate** — Do any resolved decisions qualify for distillation to `[plan_folder]/ARCHITECTURE.md`? Apply the same gate as Architecture-Design mode.

7. **Close** — Apply the Exit and Handoff format from the core skill. Explicitly name each queue item resolved, deferred, rejected, superseded, or moved to user attention, and the next owner for each.

---

## Definition of Done

- [ ] Every architecture-owned queue item assessed and either promoted, deferred, rejected, superseded, or moved to user attention with reason
- [ ] Design changes from resolutions written to `system-design.md`
- [ ] `ARCHITECTURE.md` updated if distillation gate triggered
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: queue items resolved, deferred items, next owner
