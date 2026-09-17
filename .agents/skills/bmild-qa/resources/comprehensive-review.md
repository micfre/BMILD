# Comprehensive Review

Verify the whole authorized outcome against its source specification, security obligations, and code quality. This is the default for completed-outcome verification and build-and-verify engagements. Use one context load for shared evidence while preserving independent verdicts.

## Additional Context

Read live source requirements, UX states, architecture contracts, applicable ADRs, repository standards, the outcome evidence record, relevant findings, actual changed code, tests, and affected integration boundaries. Load `resources/security-categories.yaml`, `resources/code-review-categories.yaml`, `resources/lens-edge-case-hunter.md`, `resources/lens-verification-gap.md`, and `resources/findings-triage.md`. Legacy Slice scope is an input, not a required artifact. Without an authoritative spec for a direct change, review against the user's request and observed evidence; state the Spec limitation honestly.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- Verify from the source, not only the planner's matrix or implementer's tests. Find omitted requirements and integration effects; preserve MVP/Growth/Vision boundaries.
- Interpret UX authority before deriving checks: verify committed user-observable behavior, applicable states, accessibility, and consequential copy for the authorized outcome; do not convert delegated component mechanics, illustrative examples, observed brownfield behavior, or deferred-phase designs into acceptance requirements. For legacy UX designs, preserve explicit observable decisions and resolve only genuinely ambiguous authority through Katrina's criteria; require no bulk migration.
- Keep functionality/completeness, security, standards, and spec verdicts separate. A pass on one never offsets failure on another. Required documentation and user journeys count as outcome obligations.
- Assess relevant scalability from workload/resource assumptions, algorithmic/query behavior, and applicable performance proof. Review maintainability, cohesion, complexity, dependency fit, failure handling, and operability. A passing unit suite or smaller diff is not sufficient evidence for these claims.
- Complete the requested audit before coordinating repairs. Review-only requests do not authorize production changes. For an authorized build-and-verify engagement, return actionable findings to development, then independently re-verify affected proof without requiring another user relay.
- Apply security taxonomy and credible exploit tracing; retain the High/Medium confidence threshold for vulnerability findings. Missing required security proof is blocked evidence, not a fabricated vulnerability or a clean pass.
- Apply the Edge-Case Hunter lens over the changed surface and the Verification-Gap lens over changed behavior and its consumers. The lenses report unhandled paths and gaps without severity; verdict every lens and reviewer finding through `resources/findings-triage.md` — verify each claim and its reachable consequence before assigning `high | medium | low | false | maybe-false`, group survivors by shared root cause, and warn on failed layers instead of issuing a clean result.

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

- [ ] Step 1: Resolve scope and independence, then identify the source/code state being reviewed.
- [ ] Step 2: Verify functionality and completeness from all source obligations, including omitted matrix entries, error/edge cases, docs, journeys, NFRs, and integration effects. Run or independently inspect the applicable reproducible evidence; report unavailable proof as blocked. Trace changed behavior to real consumers and inspected tests with the Verification-Gap lens.
- [ ] Step 3: Establish security applicability, map trust boundaries and sensitive flows, and trace consequential exploit candidates. Record reasons for inapplicable areas.
- [ ] Step 4: Review repository Standards and Spec fidelity separately, including meaningful scalability and maintainability evidence. Taxonomy smells are judgment prompts; omit tool-owned noise. Flag unauthorized future-phase behavior. Walk the changed surface with the Edge-Case Hunter lens; verdict all lens findings through findings triage.
- [ ] Step 5: Report `## Verification`, `## Security`, `## Standards`, and `## Spec` with evidence and pass/fail/blocked dispositions. Persist actionable findings once in the outcome record; use a security-review artifact only for actual vulnerabilities. Preserve independent per-axis statuses.
- [ ] Step 6: Reconcile acceptance using the embedded contract. Continue authorized repairs through development and independent re-verification, or leave an actionable fresh-window transition. No fixed retry count substitutes for evidence of progress; stop an unchanged failing approach and identify the missing decision or capability.
- [ ] Step 7: Close — distinguish independently accepted outcomes from advisory checks, blocked proof, and pending review. Name only genuine remaining work.

## Definition of Done

- All requested axes evaluated against the whole authorized outcome and source requirements.
- Evidence current and independently established for acceptance; missing proof and independence remain visible.
- Findings, applicability, and lifecycle state accurately recorded without a closure-only handoff.
