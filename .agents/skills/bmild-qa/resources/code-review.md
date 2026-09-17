# Code Review

Review the authorized outcome or change set for repository Standards and specification fidelity. Keep both axes distinct; review the actual integration effects rather than an advance file inventory.

## Additional Context

Read applicable repository standards, live source spec/UX/architecture contracts, the outcome record, actual changes and surrounding integration code, `resources/code-review-categories.yaml`, `resources/lens-edge-case-hunter.md`, `resources/lens-verification-gap.md`, and `resources/findings-triage.md`. A named legacy Slice supplies scope references. Without authoritative specifications, report the Spec limitation and review against the user request where available.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- Repository standards win; cite documented rule violations. Taxonomy smells are judgment calls, not rigid style mandates. Skip noise already enforced by tools.
- Inspect missing or partial requirements, incorrect behavior, and unauthorized additions directly against source contracts, including phase boundaries.
- Assess maintainability, cohesion, complexity, dependency fit, failure handling, operability, and relevant scaling behavior. A smaller diff is not automatically better.
- Findings need evidence, consequence, and remediation direction. Read adjacent code to understand effects; do not turn a bounded review into an unrelated project audit.
- Apply the Edge-Case Hunter lens over the changed surface (path trace before any author narrative; deletion and claims checks where applicable) and the Verification-Gap lens over changed behavior and its consumers. Both lenses report unhandled paths and gaps without severity; verdict every lens and reviewer finding through `resources/findings-triage.md` — verify each claim and its reachable consequence before assigning `high | medium | low | false | maybe-false`, group survivors by shared root cause, and warn on failed layers instead of issuing a clean result.
- Review-only requests do not authorize production edits. Return findings for already-authorized remediation without manufacturing a user relay.

<!-- outcome-assurance:start -->
### Independent acceptance

Resolve the authorized phase/outcome from the request, live source contracts, and `verification-matrix.md`; read those sources independently from disk. A named legacy Slice or explicit PR/diff/branch/commit/file set is also a valid target. For current changes include staged, unstaged, and untracked work. Ask only when scope remains genuinely ambiguous, not because multiple old Slices exist. If the matrix is absent, create its outcome record from Sonia's template using settled scope; no planner invocation is required. Direct changes without an initiative may keep evidence in the requested review output; do not invent an initiative or spec.

Independent acceptance requires a fresh reviewer context that did not implement the reviewed production changes and did not inherit the development transcript. A separate new window or an isolated reviewer worker qualifies; renaming a persona or forking full history does not. Read the original spec and actual code; the implementer's summary only helps navigation. If independence is unavailable, report useful advisory findings, leave acceptance pending, and prepare a fresh-window transition. A reviewer-authored production fix needs a different independent reviewer.

Record code/change identity, source-contract identity, and relevant environment with evidence. Changes make affected proof pending; preserve unaffected current evidence and historical results. A final pass checks current state still matches reviewed state. Do not clear findings or publish accepted status from stale evidence.

Rahat alone writes `qa_status: verified | failed | blocked`, `security_status: findings_open | cleared`, and `code_review_status: findings_open | cleared`. Explicit not-applicable dispositions require a scope-specific rationale from Rahat. `not_reviewed`, missing fields, unrun required proof, and an omitted axis are never terminal. Targeted review cannot stand in for other required axes.

Set outcome `status: done` only with established independence, current evidence for every required source obligation and review axis, no unresolved required finding, and verified phase scope. Otherwise preserve `ready_for_review` or the actual blocked state. The matrix remains live while any outcome needs it. When setting the final outstanding outcome to `done`, Rahat moves `verification-matrix.md` from registry `## Live` to `## Archived` only if every outcome is `done` and no open handoff, RCA, security-review, or continuation obligation depends on it; otherwise keep it live and record the reason. On archival, also sync the initiative's `[plan_folder]/rollup.md` registry entry (`Status: complete`, `Last updated`) as a mechanical scribe update. For a named legacy Slice, mirror only accepted scope covered by this review into `slices.md` and move `slice-<N>.md` to registry `## Archived` only after its own status is done. Never archive unrelated outcomes or reopen historical completed Slices merely to normalize fields. Reconcile closure in this pass; do not hand back to Rahat merely for closure.
<!-- outcome-assurance:end -->

## Tasks

Progress:

- [ ] Step 1: Establish scope, source/code identity, and review independence.
- [ ] Step 2: Review Standards and Spec separately against actual changed behavior and integration effects. Inspect tests and relevant quality evidence. Apply Edge-Case Hunter and Verification-Gap; verdict their findings through findings triage.
- [ ] Step 3: Report `## Standards` and `## Spec`, with evidence and consequences. Persist findings and code-review disposition in the outcome record; other axes remain unchanged.
- [ ] Step 4: Reconcile current independent acceptance under the embedded contract, including legacy status mirroring when applicable.
- [ ] Step 5: Close — report reviewed axes, limitations, and actual remaining remediation or proof.

## Definition of Done

- Standards and Spec reviewed independently, including relevant maintainability and scalability concerns.
- Current evidence and findings persisted; absent specifications and unperformed axes remain explicit.
