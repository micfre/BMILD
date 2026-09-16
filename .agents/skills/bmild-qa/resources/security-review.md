# Security Review

Review an architecture contract, approved phase/outcome, or bounded change set for high-confidence security vulnerabilities. Focus on credible exploit paths and security implications introduced or materially changed by the resolved scope.

## Additional Context

Resolve the target through BMILD context before reading broad code:

- Named `system-design.md` or architecture review → architecture target.
- Completed implementation or feature review → authorized outcome target; a named legacy Slice supplies scope references.
- Explicit PR, diff, branch, commit range, worktree, or file set → bounded change-set target.
- Initiative without an explicit target → read `registry.md`, live source scope, and outcome evidence; ask only if the authorized phase/outcome remains ambiguous.

Load the applicable subset in this order:

- Relevant `[plan_folder]/adr/` entries
- `[plan_folder]/rollup.md` and relevant `[plan_folder]/context-map.md` when they exist
- Initiative `registry.md` and `context.md`
- `product-brief.md` and `prd.md` for actors, data sensitivity, and user trust assumptions
- `system-design.md` for architecture or outcome targets; `ux-design.md` when the trust surface is user-facing
- The outcome record or named legacy Slice, relevant verification-matrix entries, resolved changed files, and nearby secure-pattern examples for implementation targets
- Existing `security-review-<slug>.md` when re-verifying a finding
- `resources/security-categories.yaml`

If an architecture target has no `system-design.md`, state that design assumptions cannot be fully verified and continue only from observed evidence.

## Stakes-based elicitation

- **Consequential categories:** trace untrusted input through each boundary to the sensitive sink or impact. Document attacker, preconditions, exploit path, and remediation before reporting.
- **Medium categories:** compare against established secure patterns; perform a full trace when PII, credentials, or sensitive-record exposure is implicated.
- **Filtering:** apply hard exclusions and require confidence of at least 0.8 throughout. Low-confidence or defense-in-depth ideas are omitted from vulnerability findings.
- **Expert compression:** crisp, complete evidence may be confirmed in one synthesis. Ambiguous consequential boundaries still receive full tracing.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.
- **Identify context before flagging.** Map existing security frameworks, sanitization patterns, principals, and threat model before treating a deviation as vulnerable.
- **Scope discipline.** Architecture review covers the named design; code review covers only newly introduced or materially changed attack surfaces. Read outside scope only to establish reachability and secure precedent.
- **Confidence threshold.** Persist only High or Medium findings with confidence at least 0.8 and a credible path from untrusted entry to impact.
- **Update, do not duplicate.** A review of an existing security finding updates its artifact and closure evidence.
- **Review is not implementation.** Route implementation errors to Alex and design-contract gaps to Lance or Katrina.
- **Code investigation.** Choose suitable available tools for the relevant implementation and integration boundary, honoring repository guidance.

## Routing heuristics

- *Design-level vulnerability* → persist `security-review-<slug>.md`; next owner Lance or Katrina.
- *Implementation vulnerability* → persist `security-review-<slug>.md`; next owner Alex.
- *Clean review* → explicitly state scope and categories checked; create no security-review artifact.
- *Stable initiative-local security term* → update `context.md` using the canonical context template discipline.
- *Cross-initiative semantic boundary* → route the proposed `context-map.md` change through the gap-resolution ladder; when the owner-authorized edit needs a new file, create it from `.agents/skills/bmild-pm/assets/context-map-template.md`.

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

- [ ] Step 1: Resolve and state the architecture, outcome, or change-set scope. For implementation review, query available code-intelligence capabilities and identify changed behavior/files without requiring a user-pinned Git baseline.
- [ ] Step 2: Map trusted actors, untrusted inputs, sensitive data, boundary crossings, authentication/authorization, and sensitive sinks that the scope introduces or changes.
- [ ] Step 3: Assess the scope against `security-categories.yaml` using stakes pacing and filtering. Trace consequential candidates end to end before assigning confidence or severity.
- [ ] Step 4: Pre-exit offer, only when findings will be persisted: *"Before I finalise these findings — anything you want to stress-test first? Otherwise I'll write up the review."* A decline or proceed signal continues to Step 5 in the same turn.
- [ ] Step 5: Record outcome. Findings path: write or update `security-review-<slug>.md` from `assets/security-review-template.md`; register it in `registry.md`; for an outcome set `security_status: findings_open` and update matrix security evidence. Clean path: create no security-review artifact; for an outcome set `security_status: cleared` and update matrix evidence. When all applicable persisted findings become `resolved`, map that result to matrix `cleared` while preserving the finding history; never treat matrix `cleared` as permission to erase the review artifact.
- [ ] Step 6: Apply the initiative-local semantic-memory update when triggered; route cross-initiative changes per Routing heuristics.
- [ ] Step 7: Reconcile independent outcome acceptance under the embedded contract; mirror a named legacy Slice only when its own scope is accepted. Architecture-only security review cannot certify production implementation.
- [ ] Step 8: Close — apply Exit and Handoff from the core skill. `Next:` names the remediation owner when findings remain; a clean terminal review uses `none`.

## Definition of Done

- [ ] Review scope and trust model stated
- [ ] Security taxonomy applied with confidence filtering and credible exploit paths
- [ ] Only High or Medium findings persisted; clean scope explicitly reported
- [ ] Security artifact, registry, matrix, and outcome status updated when applicable
- [ ] Independent outcome closure reconciled in the same pass with no self-handoff
- [ ] Next owner is the actual remediation owner or none
