---
name: bmild-sec / pr-security-review
description: "PR review mode. Reviews a pull request or diff for security vulnerabilities introduced by the change."
---

## PR-Security-Review Mode

Review a pull request or diff for security vulnerabilities. Focus ONLY on security implications of the newly introduced or materially changed code in this PR.

1. **Entry** — Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if an initiative is named or inferable
   - [ ] The PR diff or changed files provided in the message
   - [ ] `./resources/security-categories.yaml`

2. **Scope confirmation** — Confirm the PR scope: which files changed, what behaviour was added or modified. Do not review pre-existing code outside the PR diff.

3. **Repository context research** — Identify existing security frameworks, secure coding patterns, and the project's threat model as needed to contextualize the PR changes.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

4. **Vulnerability assessment** — Examine only the changed code in the PR. Trace data flow from user inputs to sensitive operations. Apply all Craft Standards from the core skill. Focus on: security boundaries crossed by the PR, trusted/untrusted inputs introduced, authn/authz paths affected, sensitive data newly handled, and new attack surfaces created.

5. **Write** — If vulnerabilities are found: write `[plan_folder]/<initiative-name>/security-review-<slug>.md` using `assets/security-review-template.md`. Use `_system/security-review-<slug>.md` when no initiative is identifiable. No artifact is written for a clean review.

6. **Register in context memory** — If an artifact was written and an initiative is known: open `[plan_folder]/<initiative-name>/_context.md`. Add `security-review-<slug>.md` to `## Live`.

7. **Close** — Apply the Exit and Handoff format from the core skill. Offer to hand back to Alex for implementation fixes, or to Lance if architectural redesign is needed.

---

## Definition of Done

- [ ] Scope confirmed to PR diff only — pre-existing code not reviewed
- [ ] `security-categories.yaml` applied for scope and false-positive filtering
- [ ] Only High or Medium severity issues with credible exploitability reported
- [ ] `security-review-<slug>.md` written if vulnerabilities found; no artifact for clean review
- [ ] `_context.md` updated if artifact written and initiative is known
- [ ] Close message: scope and categories checked, findings summary, next owner
