# Architecture-Handback

Resolve architecture-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

## Additional Context

Identify the queue item and the source artifact it targets. Load in this order:

- Relevant ADRs in `[plan_folder]/adr/` if they exist
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/system-design.md` in full
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or handoff context that raised the issue (`prd.md`, `ux-design.md`, `slice-<N>.md`, `verification-matrix.md`, or `security-review-<slug>.md`)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Additional Directives

**Code intelligence.** When resolving a question that requires repository inspection, prefer available code intelligence capabilities over raw filesystem traversal, before falling back to grep/glob/read workflows:
- Symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Promotion Cascade Check.** After each accepted item that results in a design change:

1. Identify downstream consumers per `AGENTS.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`.
2. Count distinct `Target Owner` values for `stale` artifacts.
   - **0 stale owners** → no cascade action.
   - **1 stale owner** → auto-enqueue one follow-up `H-###` item per stale artifact (`Type: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Lance`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Requested Change: <pointer to source artifact section>`). The close message follows the verbatim-invocation rule for the single owner.
   - **≥2 stale owners** → do NOT enqueue individually; mark each artifact in `registry.md ## Stale` with the upstream handoff reference, and route the user to Sonia in Course-Correction mode in this turn's close. Append `Cascade: <summary>` to the handoff item being closed.
3. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this handoff.

## Tasks

Progress:

- [ ] Step 1: Assess — read each handoff item targeting Lance. Determine which can be resolved from existing design decisions and which require a new decision. For each requiring a new decision, use compact option blocks (option / pros / cons / complexity / conditional recommendation) — not unstructured prose.
- [ ] Step 2: Preview the handoff set — before the first question or decision prompt, name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session.
- [ ] Step 3: Resolve — provide clear answers or decisions for each item. For each accepted item that results in a design change: update `system-design.md`, update the handoff item's `Owner Disposition` and `Promotion Record`, run the Promotion Cascade Check (see Additional Directives), and note the consequence for the originating persona's artifact.
- [ ] Step 4: Defer — if an item cannot be resolved without additional product or UX input: name the specific constraint missing, keep user-owned resolution in chat unless async continuity truly requires a governed handoff, or route back to the relevant source owner with one precise handoff item.
- [ ] Step 5: Write — if design changes result from resolving handback questions, update `[plan_folder]/<initiative-name>/system-design.md`. Update the `updated` frontmatter date.
- [ ] Step 6: Distillation gate — do any resolved decisions qualify for distillation to `[plan_folder]/adr/`? Apply the same gate as Architecture-Design mode.
- [ ] Step 7: Close — apply the Exit and Handoff format from the core skill. Explicitly name each handoff item resolved, deferred, rejected, superseded, or kept open, and the next owner for each.

## Definition of Done

- [ ] Every architecture-owned handoff item assessed and either promoted, deferred, rejected, superseded, or kept open with reason
- [ ] Design changes from resolutions written to `system-design.md`
- [ ] ADRs updated if the distillation gate triggered
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: handoff items resolved, deferred items, next owner
