# Slice-Security-Review

Review a completed Slice implementation for security vulnerabilities. Focus ONLY on security implications newly added by this Slice's code changes.

## Additional Context

Load in this order:

- `[plan_folder]/adr/` entries relevant to the Slice's security model
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/system-design.md` if it exists
- `[plan_folder]/<initiative-name>/prd.md` and `product-brief.md` if they exist
- `[plan_folder]/<initiative-name>/slice-<N>.md` — the Slice being reviewed
- `./resources/security-categories.yaml` — governs review scope, false-positive filtering, and validation patterns

## Additional Directives

**Repository context.** Identify existing security frameworks, secure coding patterns, sanitization methods, and the project's threat model. Do not flag deviations from patterns that don't exist in this codebase.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method: symbol navigation for known entities, semantic search for behavioural or architectural concepts, AST-aware analysis for syntax-sensitive patterns.

When reviewing a fix for an existing `security-review-<slug>.md`, update the existing artifact rather than creating a duplicate.

## Tasks

Progress:

- [ ] Step 1: Research repository security context (existing frameworks, secure patterns, sanitization methods, threat model).
- [ ] Step 2: Compare the Slice's new code against established secure patterns. Flag deviations and new attack surfaces. Do not review pre-existing code outside the Slice scope.
- [ ] Step 3: Examine the Slice's implementation files. Trace data flow from user inputs to sensitive operations. Identify: security boundaries, trusted/untrusted inputs, authn/authz paths, data sensitivity, and new attack surfaces.
- [ ] Step 4: Run the Pre-exit Checkpoint from the core skill before writing findings.
- [ ] Step 5: Write `[plan_folder]/<initiative-name>/security-review-<slug>.md` using `assets/security-review-template.md` if vulnerabilities are found. If the finding is a source-artifact defect or a security requirement mismatch, reference the needed `handoff.md` item or source-promotion path. No artifact is written for a clean review.
- [ ] Step 6: If an artifact was written, open `[plan_folder]/<initiative-name>/registry.md` and add `security-review-<slug>.md` to `## Live`.
- [ ] Step 7: Close per Exit and Handoff. Offer to hand back to Alex for implementation fixes, or to Lance if architectural redesign is needed.

## Definition of Done

- [ ] Repository security context researched before flagging deviations
- [ ] `security-categories.yaml` applied for scope and false-positive filtering
- [ ] Only High or Medium severity issues with credible exploitability reported
- [ ] `security-review-<slug>.md` written if vulnerabilities found; no artifact for clean review
- [ ] `registry.md` updated if artifact written
- [ ] Close message: scope and categories checked, findings summary, next owner
