---
name: bmild-sec / slice-security-review
description: "Slice review mode. Reviews a completed Slice implementation for security vulnerabilities introduced by the change."
---

## Slice-Security-Review Mode

Review a completed Slice implementation for security vulnerabilities. Focus ONLY on security implications newly added by this Slice's code changes.

1. **Entry** — Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists — primary source for platform-level security constraints and auth model decisions
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/prd.md` and `product-brief.md` if they exist
   - [ ] `[plan_folder]/<initiative-name>/slice-<N>.md` — the Slice being reviewed
   - [ ] `./resources/security-categories.yaml` — governs review scope, false-positive filtering, and validation patterns

2. **Repository context research** — Identify existing security frameworks, secure coding patterns, sanitization methods, and the project's threat model. Do not flag deviations from patterns that don't exist in this codebase.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

3. **Comparative analysis** — Compare the Slice's new code against established secure patterns. Flag deviations and new attack surfaces. Do not review pre-existing code outside the Slice scope.

4. **Vulnerability assessment** — Examine the Slice's implementation files. Trace data flow from user inputs to sensitive operations. Identify: security boundaries, trusted/untrusted inputs, authn/authz paths, data sensitivity, and new attack surfaces. Apply all Craft Standards from the core skill.

5. **Write** — If vulnerabilities are found: write `[plan_folder]/<initiative-name>/security-review-<slug>.md` using `assets/security-review-template.md`. If the finding is a source-artifact defect or a security requirement mismatch, reference the needed `spec-patch-queue.md` item or source-promotion path. No artifact is written for a clean review. When reviewing a fix for an existing `security-review-<slug>.md`, update the existing artifact rather than creating a duplicate.

6. **Register in context memory** — If an artifact was written: open `[plan_folder]/<initiative-name>/_context.md`. Add `security-review-<slug>.md` to `## Live`.

7. **Close** — Apply the Exit and Handoff format from the core skill. Offer to hand back to Alex for implementation fixes, or to Lance if architectural redesign is needed.

---

## Definition of Done

- [ ] Repository security context researched before flagging deviations
- [ ] `security-categories.yaml` applied for scope and false-positive filtering
- [ ] Only High or Medium severity issues with credible exploitability reported
- [ ] `security-review-<slug>.md` written if vulnerabilities found; no artifact for clean review
- [ ] `_context.md` updated if artifact written
- [ ] Close message: scope and categories checked, findings summary, next owner
