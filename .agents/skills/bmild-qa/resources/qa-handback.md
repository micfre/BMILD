---
name: bmild-qa / qa-handback
description: "Owner-resolution mode. Activated when a governance queue item targets Rahat's verification or RCA artifacts. Review the item, promote accepted changes into source artifacts, and close the loop."
---

## QA-Handback Mode

Resolve QA-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory. Use this mode when the queue item targets `verification-matrix.md` or an existing `rca-<slug>.md`. For new diagnostic work use the Diagnostic mode; for repairs use Spec-Fix or Direct-Fix.

1. **Entry** — Identify the queue item and the source artifact it targets. Load in this order:
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/verification-matrix.md` in full (if it exists)
   - [ ] Any referenced `[plan_folder]/<initiative-name>/rca-<slug>.md` files
   - [ ] `[plan_folder]/<initiative-name>/spec-patch-queue.md`
   - [ ] The originating artifact or queue context that raised the issue (`slice-<N>.md`, `dev-note-<slug>.md`, `security-review-<slug>.md`, or upstream design artifacts when proof-boundary defects implicate them)
   - [ ] Confirm no `## Archived` entries or other initiative folders were loaded

2. **Assess** — Read each queue item targeting Rahat. Determine which can be resolved from existing evidence and which require new verification work. Apply all Craft Standards from the core skill: evidence before action, root cause before fix recommendation, lightest persistent artifact preserving next action.

   If resolving a question requires repository inspection, prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

3. **Resolve** — Provide a clear answer or repair for each item. For each accepted item that results in a QA artifact change:
   - [ ] Update `verification-matrix.md` and/or the relevant `rca-<slug>.md`
   - [ ] Re-run or review the named proof if evidence is required
   - [ ] Update the queue item's `Owner Disposition` and `Promotion Record`
   - [ ] Run the **Promotion Cascade Check**: identify downstream consumers per `CLAUDE.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts. (a) **0 stale owners** → no cascade action. (b) **1 stale owner** → auto-enqueue one follow-up SP item per stale artifact (`Classification: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Rahat`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Exact Proposed Change: <pointer to source artifact section>`). The close message follows the verbatim-invocation rule for the single owner. (c) **≥2 stale owners** → do NOT enqueue individually; mark each artifact in `_context.md ## Stale` with the upstream SP reference, and route the user to Sonia in Course-Correction mode in this turn's close. Append `Downstream Cascade: <summary>` to the SP item being closed. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this SP.
   - [ ] Note the consequence for the originating persona's artifact

4. **Defer** — If an item cannot be resolved without additional design or implementation input: name the specific constraint missing, route it through `user-attention.md` or back to the relevant source owner with one precise queue item, and mark the spec patch as deferred, rejected, superseded, or moved to user attention.

5. **Write** — Persist all QA changes to the relevant artifacts. Update the `updated` frontmatter date.

6. **Close** — Apply the Exit and Handoff format from the core skill. Explicitly name each queue item resolved, deferred, rejected, superseded, or moved to user attention, and the next owner for each. Update Slice `qa_status` if verification outcomes changed.

---

## Definition of Done

- [ ] Every QA-owned queue item assessed and either resolved, deferred, rejected, superseded, or moved to user attention with reason
- [ ] Verification or RCA changes written to `verification-matrix.md` or `rca-<slug>.md` with evidence
- [ ] Slice `qa_status` updated if verification outcomes changed
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: queue items resolved, deferred items, next owner
