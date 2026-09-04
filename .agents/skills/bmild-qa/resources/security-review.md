# Security Review

Review an architecture contract, completed Slice, or bounded change set for high-confidence security vulnerabilities. Focus on credible exploit paths and security implications introduced or materially changed by the resolved scope.

## Additional Context

Resolve the target through BMILD context before reading broad code:

- Named `system-design.md` or architecture review → architecture target.
- Named `slice-<N>.md`, completed implementation, or feature review → Slice target.
- Explicit PR, diff, branch, commit range, worktree, or file set → bounded change-set target.
- Initiative without an explicit target → read `registry.md` and `slices.md`; infer only when exactly one Slice is `ready-for-review`, otherwise ask one scope question.

Load the applicable subset in this order:

- Relevant `[plan_folder]/adr/` entries
- `[plan_folder]/rollup.md` and relevant `[plan_folder]/context-map.md` when they exist
- Initiative `registry.md` and `context.md`
- `product-brief.md` and `prd.md` for actors, data sensitivity, and user trust assumptions
- `system-design.md` for architecture or Slice targets; `ux-design.md` when the trust surface is user-facing
- The named Slice, relevant verification-matrix entries, resolved changed files, and nearby secure-pattern examples for implementation targets
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
- **Code intelligence first.** For implementation targets, prefer available symbol-aware, AST-aware, semantic, hybrid-search, or code-graph capabilities before broad text/file scans when repository guidance permits.

## Routing heuristics

- *Design-level vulnerability* → persist `security-review-<slug>.md`; next owner Lance or Katrina.
- *Implementation vulnerability* → persist `security-review-<slug>.md`; next owner Alex.
- *Clean review* → explicitly state scope and categories checked; create no security-review artifact.
- *Stable initiative-local security term* → update `context.md` using the canonical context template discipline.
- *Cross-initiative semantic boundary* → route the proposed `context-map.md` change through the gap-resolution ladder.

## Tasks

Progress:

- [ ] Step 1: Resolve and state the architecture, Slice, or change-set scope. For implementation review, query available code-intelligence capabilities and identify changed behavior/files without requiring a user-pinned Git baseline.
- [ ] Step 2: Map trusted actors, untrusted inputs, sensitive data, boundary crossings, authentication/authorization, and sensitive sinks that the scope introduces or changes.
- [ ] Step 3: Assess the scope against `security-categories.yaml` using stakes pacing and filtering. Trace consequential candidates end to end before assigning confidence or severity.
- [ ] Step 4: Pre-exit offer, only when findings will be persisted: *"Before I finalise these findings — anything you want to stress-test first? Otherwise I'll write up the review."* A decline or proceed signal continues to Step 5 in the same turn.
- [ ] Step 5: Record outcome. Findings path: write or update `security-review-<slug>.md` from `assets/security-review-template.md`; register it in `registry.md`; for a Slice set `security_status: findings_open` and update matrix security evidence. Clean path: create no artifact; for a Slice set `security_status: cleared` and update matrix evidence.
- [ ] Step 6: Apply the initiative-local semantic-memory update when triggered; route cross-initiative changes per Routing heuristics.
- [ ] Step 7: Reconcile Slice closure. Set `status: done`, update `slices.md`, and move `slice-<N>.md` from registry `## Live` to `## Archived` only when `qa_status: verified`, `security_status: cleared`, `code_review_status` is terminal (`cleared` or `not_applicable`), and no review finding remains open. Otherwise keep `ready-for-review`; do not hand back to Rahat merely for closure.
- [ ] Step 8: Close — apply Exit and Handoff from the core skill. `Next:` names the remediation owner when findings remain; a clean terminal review uses `none`.

## Definition of Done

- [ ] Review scope and trust model stated
- [ ] Security taxonomy applied with confidence filtering and credible exploit paths
- [ ] Only High or Medium findings persisted; clean scope explicitly reported
- [ ] Security artifact, registry, matrix, and Slice status updated when applicable
- [ ] Slice closure reconciled in the same pass with no self-handoff
- [ ] Next owner is the actual remediation owner or none
