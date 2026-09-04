# Comprehensive Review

Perform all three Rahat review axes in one session and one context load: completed-Slice FR/NFR verification, security review, and two-axis code review. Preserve separate findings and evidence; consolidate only lifecycle reconciliation and the final handoff.

## Additional Context

Resolve scope through BMILD context:

- Honor a named initiative and Slice directly.
- If only an initiative is named, read its `registry.md` and `slices.md`; infer only when exactly one Slice is `ready-for-review`, otherwise ask which Slice or bounded change set to review.
- Honor an explicit PR, diff, branch, commit range, worktree, or file set. For "current changes," include staged, unstaged, and untracked work. No user-pinned fixed point is required.
- If no bounded target can be resolved, ask one scope question before review.

Load once, in authority order:

- Relevant `[plan_folder]/adr/` entries and `[plan_folder]/context-map.md`
- `[plan_folder]/rollup.md` when present
- Initiative `registry.md`, `context.md`, named Slice, and `slices.md`
- Live `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` sections governing the scope
- Relevant `verification-matrix.md`, `rca-*.md`, and `security-review-*.md`
- Repository guidance and coding standards applicable to changed files
- The resolved change set, tests, and nearby implementation needed to understand it
- `resources/security-categories.yaml` and `resources/code-review-categories.yaml`

For a direct change with no authoritative specification, run the available functional/gate evidence, security, and Standards axes; report the Spec sub-axis as unavailable rather than blocking the entire review.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.
- **One context load, three independent verdicts.** Reuse shared evidence, but do not let a pass on one axis offset a failure on another.
- **Complete the audit before routing.** A discovered defect becomes a persisted finding; do not abandon the remaining review axes by switching into a fix mode mid-review.
- **Changed-scope discipline.** Functional verification follows the named Slice/contracts; security and code findings must arise from newly introduced or materially changed behavior in the resolved scope.
- **Proof discipline.** Matrix items pass only after the named proof runs. Implementation status is not evidence.
- **Security threshold.** Apply `security-categories.yaml`; only High or Medium issues at confidence 0.8 or greater with a credible exploit path become vulnerabilities.
- **Code-review separation.** Keep Standards and Spec findings distinct; repository rules override taxonomy smells, smells remain judgment calls, and tool-enforced noise is skipped.
- **Review is not implementation.** Persist and route findings; production fixes require the appropriate Fix mode and authority.
- **Code intelligence first.** Prefer available symbol-aware, AST-aware, semantic, hybrid-search, or code-graph capabilities before broad text/file scans when repository guidance permits.

## Tasks

Progress:

- [ ] Step 1: Query available code-intelligence capabilities, then state the single BMILD-resolved scope, changed files/behavior, authoritative contracts, and any reduced-fidelity limitation.
- [ ] Step 2: Run Slice FR/NFR verification — map Acceptance Criteria and NFRs to tests/manual proof, inspect happy/error/edge paths, verify required documentation, run repository quality gates, and update verification-matrix evidence.
- [ ] Step 3: Run security review — map trust boundaries and sensitive flows, apply every relevant security category, and trace consequential candidates from untrusted entry to impact.
- [ ] Step 4: Run code review Standards axis — check applicable repository rules, then judgment-call taxonomy smells; cite the rule or changed hunk for each finding.
- [ ] Step 5: Run code review Spec axis — report missing/partial requirements, unrequested behavior, and incorrectly implemented requirements with source-contract citations. If no authoritative spec exists, state that and skip only this sub-axis.
- [ ] Step 6: Present four clearly separated sections: `## Verification`, `## Security`, `## Standards`, and `## Spec`. Each records pass/fail/blocked, evidence, findings count, and worst finding where one exists. Do not collapse them into one score.
- [ ] Step 7: Persist findings and statuses once. Update `qa_status: verified | failed | blocked`; set `security_status: findings_open | cleared`; set `code_review_status: findings_open | cleared`. Write/update `security-review-<slug>.md` only for security findings. Put actionable functional and code-review items in Slice `## Review Follow-up`, update linked matrix governance evidence, and register any new artifact.
- [ ] Step 8: Reconcile Slice closure once. Set `status: done`, update `slices.md`, and move `slice-<N>.md` from registry `## Live` to `## Archived` only when `qa_status: verified`, `security_status: cleared`, `code_review_status: cleared`, and no review finding remains open. Otherwise keep `ready-for-review`; never hand back to Rahat for a second closure pass.
- [ ] Step 9: Close — apply Exit and Handoff from the core skill. `Next:` lists only actual remediation owners in dependency order; use `none` when all axes pass and closure is complete.

## Definition of Done

- [ ] FR/NFR verification, security review, Standards review, and Spec review all completed for one shared scope
- [ ] Each axis reported independently with evidence and findings count
- [ ] Applicable gates and named proofs run, or blockers recorded
- [ ] Security taxonomy and code-review taxonomy applied under their distinct thresholds
- [ ] Slice artifacts and all three review statuses updated in one pass when applicable
- [ ] Slice closed and archived when every axis is terminal, otherwise the true remediation owner is named
