# PR-Security-Review

Review a pull request or diff for security vulnerabilities. Focus ONLY on security implications of the newly introduced or materially changed code in this PR.

## Additional Context

Load in this order:

- `[plan_folder]/ARCHITECTURE.md` if it exists
- `[plan_folder]/_system/_rollup.md` if it exists
- `[plan_folder]/<initiative-name>/_context.md` if an initiative is named or inferable
- The PR diff or changed files provided in the message
- `./resources/security-categories.yaml`

## Additional Norms

**Repository context.** Identify existing security frameworks, secure coding patterns, and the project's threat model as needed to contextualize the PR changes.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method: symbol navigation for known entities, semantic search for behavioural or architectural concepts, AST-aware analysis for syntax-sensitive patterns.

Do not review pre-existing code outside the PR diff.

## Tasks

Progress:

- [ ] Step 1: Confirm the PR scope — which files changed, what behaviour was added or modified.
- [ ] Step 2: Research repository security context as needed (existing frameworks, secure patterns, threat model).
- [ ] Step 3: Examine only the changed code in the PR. Trace data flow from user inputs to sensitive operations. Focus on: security boundaries crossed, trusted/untrusted inputs introduced, authn/authz paths affected, sensitive data newly handled, and new attack surfaces created.
- [ ] Step 4: Run the Pre-exit Checkpoint from the core skill before writing findings.
- [ ] Step 5: Write `[plan_folder]/<initiative-name>/security-review-<slug>.md` using `assets/security-review-template.md` if vulnerabilities are found. If the finding is a source-artifact defect or a security requirement mismatch, reference the needed `spec-patch-queue.md` item or source-promotion path. Use `_system/security-review-<slug>.md` when no initiative is identifiable. No artifact is written for a clean review.
- [ ] Step 6: If an artifact was written and an initiative is known, open `[plan_folder]/<initiative-name>/_context.md` and add `security-review-<slug>.md` to `## Live`.
- [ ] Step 7: Close per Exit and Handoff. Offer to hand back to Alex for implementation fixes, or to Lance if architectural redesign is needed.

## Definition of Done

- [ ] Scope confirmed to PR diff only — pre-existing code not reviewed
- [ ] `security-categories.yaml` applied for scope and false-positive filtering
- [ ] Only High or Medium severity issues with credible exploitability reported
- [ ] `security-review-<slug>.md` written if vulnerabilities found; no artifact for clean review
- [ ] `_context.md` updated if artifact written and initiative is known
- [ ] Close message: scope and categories checked, findings summary, next owner
