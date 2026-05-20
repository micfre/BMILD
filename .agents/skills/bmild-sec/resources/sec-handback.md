# Sec-Handback

Resolve security-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory. Use this mode when the queue item targets an existing `security-review-<slug>.md`. For new security reviews use one of the standard review modes (Architecture-Security-Review, PR-Security-Review, Slice-Security-Review).

## Additional Context

Load in this order:

- `[plan_folder]/<initiative-name>/_context.md`
- The referenced `[plan_folder]/<initiative-name>/security-review-<slug>.md` in full
- `[plan_folder]/<initiative-name>/spec-patch-queue.md`
- The originating artifact or queue context that raised the issue (typically a fix applied by Alex against an open finding, or a design change by Lance/Katrina that resolves a design-level finding)
- Upstream design artifacts (`system-design.md`, `ux-design.md`) when needed to re-verify a design-level finding
- Confirm no `## Archived` entries or other initiative folders were loaded

## Additional Norms

Apply all Global Norms from the core skill: scope discipline, evidence-driven confidence threshold (>80% exploitability), no theoretical noise.

Queue artifacts are coordination state, not security closure. An item is closed only when the finding is confirmed resolved in the governed source artifact and Zach has re-verified it.

## Tasks

Progress:

- [ ] Step 1: Identify the queue item and the source artifact it targets (from context reads above).
- [ ] Step 2: Read each queue item targeting Zach. Most items will be re-verification requests for previously open findings.
- [ ] Step 3: For each finding targeted by a queue item, re-run the security assessment on the affected boundary.
- [ ] Step 4: For each finding now resolved by the upstream change: update the `security-review-<slug>.md` finding entry with closure evidence (what was checked, what changed, why the finding is now closed); update the queue item's `Owner Disposition` and `Promotion Record`.
- [ ] Step 5: Run the **Promotion Cascade Check**: identify downstream consumers per `CLAUDE.md` cross-artifact flow; classify each as `unaffected | minor-update | stale`. Count distinct `Target Owner` values for `stale` artifacts. (a) **0 stale owners** → no cascade action. (b) **1 stale owner** → auto-enqueue one follow-up SP item per stale artifact (`Classification: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: Zach`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Exact Proposed Change: <pointer to source artifact section>`). The close message follows the verbatim-invocation rule for the single owner. (c) **≥2 stale owners** → do NOT enqueue individually; mark each artifact in `_context.md ## Stale` with the upstream SP reference, and route the user to Sonia in Course-Correction mode in this turn's close. Append `Downstream Cascade: <summary>` to the SP item being closed. Cycle prevention: do not enqueue an item whose `Supersedes` chain already includes this SP.
- [ ] Step 6: Note any residual or newly-introduced findings.
- [ ] Step 7: If a finding remains open after re-verification, keep it open in `security-review-<slug>.md` with updated next owner (Alex for implementation fixes, Lance/Katrina for design changes), and route a new queue item targeting that owner. Mark the original spec patch as deferred, rejected, superseded, or moved to user attention as appropriate.
- [ ] Step 8: Persist all security review changes. Update the `updated` frontmatter date.
- [ ] Step 9: Close per Exit and Handoff. Explicitly name each finding closed, each finding still open, and the next owner for each. Zach remains a terminal node by default — do not auto-handoff unless an open finding clearly routes to a named owner.

## Definition of Done

- [ ] Every security-owned queue item assessed and either re-verified-closed, deferred, rejected, superseded, or moved to user attention with reason
- [ ] Closure evidence recorded in `security-review-<slug>.md` for resolved findings
- [ ] Residual or newly-introduced findings recorded with next owner
- [ ] Originating persona informed of decisions and any remaining open items
- [ ] Close message: findings closed, findings still open, next owner
