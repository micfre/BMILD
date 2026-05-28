# Refine-Brief

Revisit and improve an existing product brief. Probe what changed, challenge stale framing, and update `product-brief.md`. Existing content is a starting point to challenge, not a contract to preserve.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full
- `[plan_folder]/<initiative-name>/prd.md` in full if it exists (read for downstream impact assessment only)
- Confirm no `## Archived` entries or other initiative folders were loaded

Also load before writing:
- `./resources/brief-completion-criteria.yaml`

## Additional Directives

When refinement depends on existing behaviour, verify current codebase reality before accepting the old artifact as true. Discovery before invention: scan the codebase before accepting a greenfield premise in a brownfield project.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows:
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

## Tasks

Progress:

- [ ] Step 1: Determine what changed in product framing. If the user has not specified, ask one question. Typical triggers: changed user need, shifted success metric, revised scope boundary, updated competitive framing, or changed initiative vision.
- [ ] Step 2: If any brainstorming session preceded this artifact, load it and cross-reference ideas against the current `product-brief.md`. Identify silently dropped ideas (especially qualitative direction such as feel, tone, or coaching approach). Present findings and ask whether any should be incorporated before proceeding.
- [ ] Step 3: Groundtruth and challenge — treat existing brief content as a starting point. Probe what was assumed versus validated. Surface unresolved PM-owned handoff items. Apply all Principles and Global Directives from the core skill.
- [ ] Step 4: Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session.
- [ ] Step 5: Elicit refinements — probe only the brief sections requiring change with the same depth and rigor as initial authoring. Do not drift into PRD detail except to flag downstream implications.
- [ ] Step 6: Write — privately check `brief-completion-criteria.yaml` before writing. Update `[plan_folder]/<initiative-name>/product-brief.md` using `assets/product-brief-template.md` as the structural reference. Preserve sections not being changed. Update the `updated` frontmatter date.
- [ ] Step 7: Gate check — walk the user through any remaining product ambiguity that still needs live resolution. For each: explain the issue, present options, give a recommendation. Keep user-owned gaps in chat unless async owner-to-owner continuity truly requires a governed handoff.
- [ ] Step 8: Semantic distillation gate — update initiative `context.md` when refined product/domain meaning becomes stable and `context-map.md` when the refinement introduces or changes a cross-initiative semantic boundary.
- [ ] Step 9: Register in context memory — open `[plan_folder]/<initiative-name>/registry.md`. Confirm `product-brief.md` remains in `## Live`. Move any superseded predecessor to `## Archived` if applicable.
- [ ] Step 10: Determine downstream impact and offer next move:
- [ ] Step 10a: If brief changes force updates to `prd.md` only, offer `Refine-PRD` as the immediate next move in this same skill.
- [ ] Step 10b: If brief changes force updates to planning/design artifacts beyond PM ownership (`slices.md`, `slice-<N>.md`, `verification-matrix.md`, `ux-design.md`, `system-design.md`, or broader cross-artifact cascade), offer Sonia in `bmild-planner` Course-Correction mode as the immediate next move.
- [ ] Step 11: Close — apply the Exit and Handoff format from the core skill. Make the recommended next move explicit based on Step 10.

## Definition of Done

- [ ] Refinement target identified and relevant `product-brief.md` sections updated
- [ ] Existing brief content challenged, not merely preserved
- [ ] Relevant PM-owned `handoff.md` items resolved, deferred, rejected, superseded, or kept open with a clear next owner
- [ ] Remaining user-owned ambiguity resolved in chat or handled as bounded assumptions when safe
- [ ] `brief-completion-criteria.yaml` privately checked before writing
- [ ] `product-brief.md` written with current `updated` date
- [ ] `context.md` or `context-map.md` updated only if the semantic distillation gate fired
- [ ] `registry.md` reflects current brief state
- [ ] Close message includes the downstream next move: `Refine-PRD` for PM-only downstream changes, or Sonia Course-Correction for broader planned-artifact cascades
