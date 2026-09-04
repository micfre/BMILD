# Code Review

Review a BMILD-resolved change scope along two independent axes: repository Standards and specification fidelity. Do not require the user to invent or pin a Git fixed point before useful review can begin.

## Additional Context

Resolve scope from BMILD context in this order:

- Honor an explicitly named initiative and `slice-<N>.md`; the Slice Scope, Acceptance Criteria, Design Contracts, Likely Planned Edits, and Implementation Notes define the review boundary.
- If only an initiative is named, read its `registry.md` and `slices.md`; infer the scope only when exactly one Slice is `ready-for-review`, otherwise ask which Slice or change set to review.
- Honor a user-provided PR, diff, branch, commit range, or file set as the change evidence. It is a target, not a mandatory pinned-baseline protocol.
- For "current changes" or equivalent, inspect the worktree's tracked and untracked changes. Include staged and unstaged changes; never silently omit one class.
- If none of those yields one bounded target, ask one scope question.

Then load, in authority order:

- Relevant `[plan_folder]/adr/` entries and `[plan_folder]/context-map.md` when the change crosses initiative boundaries
- `[plan_folder]/rollup.md` if it exists
- The initiative `registry.md` and `context.md` when present
- The named Slice and its live `product-brief.md`, `prd.md`, `ux-design.md`, `system-design.md`, and `verification-matrix.md` sections relevant to the change
- Repository standards (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, coding standards, and equivalent nested guidance applicable to changed files)
- The resolved change set and nearby implementation needed to understand each changed hunk
- `resources/code-review-categories.yaml`

When no specification exists for a direct change, run the Standards axis and report `Spec: no authoritative specification available`; do not block the whole review.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.
- **Two independent axes.** Keep Standards and Spec findings separate. Do not merge, average, or rerank them into one verdict.
- **Repository standards win.** Cite file and rule for a documented-standard breach. The taxonomy smell baseline is always a judgment call and is suppressed when repository guidance endorses the pattern.
- **Skip tool-owned noise.** Do not report formatting, lint, or generated-file issues already deterministically enforced by the repository's normal tooling unless the enforcement itself is broken.
- **Changed-scope discipline.** Findings must arise from changed behavior or changed code in the resolved scope. Read adjacent code for understanding but do not report unrelated pre-existing defects.
- **Evidence over adjectives.** Every finding names severity, file/line or contract location, evidence, consequence, and remediation direction. A code excerpt supports the finding; it does not replace the explanation.
- **Review is not implementation.** Persist actionable findings and route them; do not edit production code in this mode.
- **Code intelligence first.** Prefer available symbol-aware, AST-aware, semantic, hybrid-search, or code-graph capabilities before broad text/file scans when repository guidance permits.

## Tasks

Progress:

- [ ] Step 1: Resolve and state scope using BMILD Scope, registry, and Slice context. Query available code-intelligence capabilities, then record the concrete changed files/hunks and any reduced-fidelity limitation.
- [ ] Step 2: Run the Standards axis against applicable repository guidance, then the code-smell taxonomy. Separate hard documented-standard breaches from judgment-call smells.
- [ ] Step 3: Run the Spec axis against the Slice Acceptance Criteria and live product/UX/system contracts. Report missing or partial requirements, unrequested behavior, and behavior implemented incorrectly; cite the source contract for every finding. If no authoritative spec exists, record that and skip only this axis.
- [ ] Step 4: Present results under `## Standards` and `## Spec`. Within each axis order findings by consequence, then evidence location. End with counts and the worst finding within each axis; never choose one winner across axes.
- [ ] Step 5: When a Slice is in scope, persist actionable findings in `slice-<N>.md` `## Review Follow-up` with next owner Alex or the relevant design owner. Set `code_review_status: findings_open` when findings exist; otherwise set `code_review_status: cleared`. Update linked matrix governance evidence where present.
- [ ] Step 6: Reconcile Slice closure. Set `status: done`, update `slices.md`, and move `slice-<N>.md` from registry `## Live` to `## Archived` only when `qa_status: verified`, `security_status` is terminal (`cleared`, `not_applicable`, or `not_reviewed`), `code_review_status: cleared`, and no review finding remains open. Otherwise keep `ready-for-review`; do not hand back to Rahat merely for closure.
- [ ] Step 7: Close — apply Exit and Handoff from the core skill. `Next:` names the actual owner of an open remediation; when no work remains, use `none`.

## Definition of Done

- [ ] One bounded review scope resolved through BMILD context rather than a mandatory pinned fixed point
- [ ] Applicable repository standards and the smell taxonomy checked
- [ ] Specification fidelity checked or absence of authoritative specification stated
- [ ] Standards and Spec findings reported separately with evidence and counts
- [ ] Slice evidence and `code_review_status` updated when a Slice is in scope
- [ ] Slice closure reconciled in the same pass with no self-handoff
