# QA-Handback

Resolve QA-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory. Use this mode when the queue item targets `verification-matrix.md` or an existing `rca-<slug>.md`. For new diagnostic work use Diagnostic mode; for repairs use Spec-Fix or Direct-Fix.

## Additional Context

Identify the queue item and the source artifact it targets. Load in this order:
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/verification-matrix.md` in full (if it exists)
- Any referenced `[plan_folder]/<initiative-name>/rca-<slug>.md` files
- `[plan_folder]/<initiative-name>/handoff.md`
- The originating artifact or queue context that raised the issue (`slice-<N>.md`, `system-design.md`, `security-review-<slug>.md`, or upstream design artifacts when proof-boundary defects implicate them)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Additional Norms

**Evidence and queue discipline.** Apply all Global Norms from the core skill: evidence before action, root cause before fix recommendation, lightest persistent artifact preserving next action. Queue items are coordination artifacts, not proof — treat `accepted` as pending until the target owner promotes the change into the governed source artifact.

**Repository discovery (when needed).** If resolving a question requires repository inspection, prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

**Promotion Cascade Check.** Run after each accepted item that results in a QA artifact change. Identify downstream consumers per `CLAUDE.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts:
- **0 stale owners** → no cascade action.
- **1 stale owner** → auto-enqueue one follow-up handoff item per stale artifact (`Type: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Rahat`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Requested Change: <pointer to source artifact section>`). The close message follows the verbatim-invocation rule for the single owner.
- **≥2 stale owners** → do NOT enqueue individually; mark each artifact in `registry.md ## Stale` with the upstream handoff reference, and route the user to Sonia in Course-Correction mode in this turn's close. Append `Downstream Cascade: <summary>` to the handoff item being closed.
- Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this SP.

## Tasks

Progress:

- [ ] Step 1: Assess — read each queue item targeting Rahat. Determine which can be resolved from existing evidence and which require new verification work.
- [ ] Step 2: Resolve — for each item that can be resolved, provide a clear answer or repair. For each accepted item that results in a QA artifact change: update `verification-matrix.md` and/or the relevant `rca-<slug>.md`; re-run or review the named proof if evidence is required; update the queue item's `Owner Disposition` and `Promotion Record`; run the Promotion Cascade Check (see Additional Norms); note the consequence for the originating persona's artifact.
- [ ] Step 3: Defer — if an item cannot be resolved without additional design or implementation input: name the specific constraint missing, resolve user-owned gaps in chat, or route it back to the relevant source owner with one precise handoff item, and mark the handoff as deferred, rejected, or superseded.
- [ ] Step 4: Write — persist all QA changes to the relevant artifacts. Update the `updated` frontmatter date.
- [ ] Step 5: Close — apply the Exit and Handoff format from the core skill. Explicitly name each handoff item resolved, deferred, rejected, or superseded, and the next owner for each. Update Slice `qa_status` if verification outcomes changed.

## Definition of Done

- [ ] Every QA-owned handoff item assessed and either resolved, deferred, rejected, or superseded with reason
- [ ] Verification or RCA changes written to `verification-matrix.md` or `rca-<slug>.md` with evidence
- [ ] Slice `qa_status` updated if verification outcomes changed
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: queue items resolved, deferred items, next owner
