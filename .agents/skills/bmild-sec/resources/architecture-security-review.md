# Architecture-Security-Review

Review an architectural spec or system design for security design flaws. Focus on trust boundaries, auth model, data sensitivity, and attack surfaces introduced by the design — before implementation begins.

## Additional Context

Load in this order:

- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/context-map.md` if it is relevant
- `[plan_folder]/adr/` entries relevant to the review target
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/system-design.md` in full — the primary review target
- `[plan_folder]/<initiative-name>/prd.md` and `product-brief.md` for context on user trust model and data sensitivity
- `./resources/security-categories.yaml`

If no `system-design.md` exists, flag that high-level security assumptions could not be verified and proceed based on observed implementation context.

## Additional Norms

**Repository discovery.** Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method: symbol navigation for known entities, semantic search for behavioural or architectural concepts, AST-aware analysis for syntax-sensitive patterns.

Architecture-level findings are design gaps, not implementation bugs. Tag each finding with the appropriate owner: Lance if the architecture contract must change, Katrina if a UX flow enables the vulnerability.

## Tasks

Progress:

- [ ] Step 1: Identify the trust model — who the trusted actors are, what data is sensitive, where trust boundaries are crossed, what the authentication and authorization model is, and how sensitive data flows through the system.
- [ ] Step 2: Assess the architectural design against security categories in `security-categories.yaml`. Focus on: insecure design patterns, missing auth controls at boundary crossings, sensitive data exposure in the design, trust escalation paths, and insecure data flow design.
- [ ] Step 3: Run the Pre-exit Checkpoint from the core skill before writing findings.
- [ ] Step 4: Write `[plan_folder]/<initiative-name>/security-review-<slug>.md` using `assets/security-review-template.md` if design-level vulnerabilities are found. No artifact is written for a clean review.
- [ ] Step 5: If an artifact was written, open `[plan_folder]/<initiative-name>/registry.md` and add `security-review-<slug>.md` to `## Live`.
- [ ] Step 6: Close per Exit and Handoff. Architecture-level findings route to Lance or Katrina — not to Alex — since the contract must change before implementation can address the vulnerability.

## Definition of Done

- [ ] Trust model and data flow analyzed from the design spec
- [ ] `security-categories.yaml` applied for scope and false-positive filtering
- [ ] Only High or Medium severity design-level issues reported
- [ ] Findings correctly tagged as Lance or Katrina owned (architectural/UX design gaps, not implementation bugs)
- [ ] `security-review-<slug>.md` written if vulnerabilities found; no artifact for clean review
- [ ] `registry.md` updated if artifact written
- [ ] Close message: trust model assessed, design findings summary, next owner (Lance or Katrina for redesign)
