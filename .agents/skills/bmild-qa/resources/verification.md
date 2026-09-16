# Verification

Perform an explicitly targeted functionality/completeness review. General requests to verify a completed outcome use Comprehensive Review; this mode never implies security or code review ran.

## Additional Context

Read the authorized phase/outcome, original live product/UX/architecture requirements, relevant outcome evidence and findings, repository guidance, actual code and tests, and integration boundaries. A Slice is optional legacy context.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- Check source requirements directly, including omissions from the matrix, error/edge behavior, relevant NFRs, documentation, and user journeys. Required proof must run or have independently inspectable current evidence; implementation status alone is not proof.
- Persist actionable findings in the outcome record before returning them to development. Diagnose consequential failures with evidence; a simple missing requirement does not need an RCA ceremony.
- Preserve other review-axis statuses. Missing security or code evidence prevents overall acceptance even if this targeted axis passes.

<!-- outcome-assurance:start -->
### Independent acceptance

Resolve the authorized phase/outcome from the request, live source contracts, and `verification-matrix.md`; read those sources independently from disk. A named legacy Slice or explicit PR/diff/branch/commit/file set is also a valid target. For current changes include staged, unstaged, and untracked work. Ask only when scope remains genuinely ambiguous, not because multiple old Slices exist. If the matrix is absent, create its outcome record from Sonia's template using settled scope; no planner invocation is required. Direct changes without an initiative may keep evidence in the requested review output; do not invent an initiative or spec.

Independent acceptance requires a fresh reviewer context that did not implement the reviewed production changes and did not inherit the development transcript. A separate new window or an isolated reviewer worker qualifies; renaming a persona or forking full history does not. Read the original spec and actual code; the implementer's summary only helps navigation. If independence is unavailable, report useful advisory findings, leave acceptance pending, and prepare a fresh-window transition. A reviewer-authored production fix needs a different independent reviewer.

Record code/change identity, source-contract identity, and relevant environment with evidence. Changes make affected proof pending; preserve unaffected current evidence and historical results. A final pass checks current state still matches reviewed state. Do not clear findings or publish accepted status from stale evidence.

Rahat alone writes `qa_status: verified | failed | blocked`, `security_status: findings_open | cleared`, and `code_review_status: findings_open | cleared`. Explicit not-applicable dispositions require a scope-specific rationale from Rahat. `not_reviewed`, missing fields, unrun required proof, and an omitted axis are never terminal. Targeted review cannot stand in for other required axes.

Set outcome `status: done` only with established independence, current evidence for every required source obligation and review axis, no unresolved required finding, and verified phase scope. Otherwise preserve `ready-for-review` or the actual blocked state. The matrix remains live while any outcome needs it. For a named legacy Slice, mirror only accepted scope covered by this review into `slices.md` and move `slice-<N>.md` to registry `## Archived` only after its own status is done. Never archive unrelated outcomes or reopen historical completed Slices merely to normalize fields. Reconcile closure in this pass; do not hand back to Rahat merely for closure.
<!-- outcome-assurance:end -->

## Tasks

Progress:

- [ ] Step 1: Establish authorized scope, source/code identity, and review independence.
- [ ] Step 2: Trace source requirements to observable tests and manual checks; repair incomplete coverage in place. Inspect relevant integration and performance evidence; name unverified limits.
- [ ] Step 3: Run applicable gates and proofs, recording failures and unavailable checks. Persist actionable findings, current evidence, and QA verdicts without changing unrelated axes.
- [ ] Step 4: Reconcile closure under the embedded acceptance contract, including any legacy status mirroring.
- [ ] Step 5: Close — state this axis's verdict and any remaining required review or remediation, without implying an unperformed axis passed.

## Definition of Done

- Targeted functionality/completeness evidence and findings recorded against source obligations.
- Current independent proof required for accepted verdicts; unresolved proof and other required axes remain pending.
