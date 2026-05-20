# PM-Handback

Resolve PM-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

## Additional Context

Load in this order:
- `[plan_folder]/CHARTER.md` if it exists
- `[plan_folder]/<initiative-name>/_context.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full (if it exists)
- `[plan_folder]/<initiative-name>/prd.md` in full (if it exists)
- `[plan_folder]/<initiative-name>/spec-patch-queue.md`
- The originating artifact or queue context that raised the issue (`ux-design.md`, `system-design.md`, `slices.md`, `slice-<N>.md`, `verification-matrix.md`, `rca-<slug>.md`, or `security-review-<slug>.md`)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Additional Norms

When resolving a queue item requires repository inspection, prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows:
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

## Tasks

Progress:

- [ ] Step 1: Identify the queue item and the source artifact it targets (from context reads above).
- [ ] Step 2: Assess each queue item targeting Faisal. Determine which can be answered from existing product decisions and which require new decisions. For those requiring new decisions, apply the elicitation pacing and decision option format from the core skill.
- [ ] Step 3: Before the first question or decision prompt, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session.
- [ ] Step 4: Resolve — provide clear answers or decisions for each item. Apply all Principles and Global Norms from the core skill. For each accepted item that results in a product change:
  - Update `product-brief.md` or `prd.md` as appropriate
  - Update the queue item's `Owner Disposition` and `Promotion Record`
  - Run the **Promotion Cascade Check**: identify downstream consumers per `CLAUDE.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts. (a) **0 stale owners** → no cascade action. (b) **1 stale owner** → auto-enqueue one follow-up SP item per stale artifact (`Classification: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Faisal`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Exact Proposed Change: <pointer to source artifact section>`). The close message follows the verbatim-invocation rule for the single owner. (c) **≥2 stale owners** → do NOT enqueue individually; mark each artifact in `_context.md ## Stale` with the upstream SP reference, and route the user to Sonia in Course-Correction mode in this turn's close. Append `Downstream Cascade: <summary>` to the SP item being closed. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this SP.
  - Note the consequence for the originating persona's artifact
- [ ] Step 5: Defer any item that cannot be resolved without additional UX or architecture input. Name the specific constraint missing, route it through `user-attention.md` or back to the relevant source owner with one precise queue item, and mark the spec patch as deferred, rejected, superseded, or moved to user attention.
- [ ] Step 6: Write — if product changes result from resolving handback questions, update the relevant PM artifact(s). Update the `updated` frontmatter date.
- [ ] Step 7: Distillation gate — do any resolved decisions establish or modify a project-level invariant (vision, target users, competitive positioning) that future unrelated initiatives must align with, or conflict with a sibling initiative's `product-brief.md`? If yes, seed or update `[plan_folder]/CHARTER.md`. Otherwise skip.
- [ ] Step 8: Close — apply the Exit and Handoff format from the core skill. Explicitly name each queue item resolved, deferred, rejected, superseded, or moved to user attention, and the next owner for each.

## Definition of Done

- [ ] Every PM-owned queue item assessed and either promoted, deferred, rejected, superseded, or moved to user attention with reason
- [ ] Product changes from resolutions written to `product-brief.md` and/or `prd.md`
- [ ] `CHARTER.md` updated if distillation gate triggered
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: queue items resolved, deferred items, next owner
