---
name: bmild-sec / architecture-security-review
description: "Architecture review mode. Reviews a system design or architectural spec for security design flaws and trust boundary gaps."
---

## Architecture-Security-Review Mode

Review an architectural spec or system design for security design flaws. Focus on trust boundaries, auth model, data sensitivity, and attack surfaces introduced by the design — before implementation begins.

1. **Entry** — Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` in full — the primary review target
   - [ ] `[plan_folder]/<initiative-name>/prd.md` and `product-brief.md` for context on user trust model and data sensitivity
   - [ ] `./resources/security-categories.yaml`

   If no `system-design.md` exists, flag that high-level security assumptions could not be verified and proceed based on observed implementation context.

2. **Trust model analysis** — Identify: who the trusted actors are, what data is sensitive, where trust boundaries are crossed, what the authentication and authorization model is, and how sensitive data flows through the system.

3. **Vulnerability assessment** — Assess the architectural design against security categories in `security-categories.yaml`. Focus on: insecure design patterns (not just implementation errors), missing auth controls at boundary crossings, sensitive data exposure in the design, trust escalation paths, and insecure data flow design.

   Note: architecture-level findings are design gaps, not implementation bugs. Tag each finding with the appropriate owner: Lance if the architecture contract must change, Katrina if a UX flow enables the vulnerability.

4. **Write** — If design-level vulnerabilities are found: write `[plan_folder]/<initiative-name>/security-review-<slug>.md` using `assets/security-review-template.md`. No artifact is written for a clean review.

5. **Register in context memory** — If an artifact was written: open `[plan_folder]/<initiative-name>/_context.md`. Add `security-review-<slug>.md` to `## Live`.

6. **Close** — Apply the Exit and Handoff format from the core skill. Architecture-level findings route to Lance or Katrina — not to Alex — since the contract must change before implementation can address the vulnerability.

---

## Definition of Done

- [ ] Trust model and data flow analyzed from the design spec
- [ ] `security-categories.yaml` applied for scope and false-positive filtering
- [ ] Only High or Medium severity design-level issues reported
- [ ] Findings correctly tagged as Lance or Katrina owned (architectural/UX design gaps, not implementation bugs)
- [ ] `security-review-<slug>.md` written if vulnerabilities found; no artifact for clean review
- [ ] `_context.md` updated if artifact written
- [ ] Close message: trust model assessed, design findings summary, next owner (Lance or Katrina for redesign)
