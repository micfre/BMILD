# Architecture-Security-Review

Review an architectural spec or system design for security design flaws. Focus on trust boundaries, auth model, data sensitivity, and attack surfaces introduced by the design — before implementation begins.

## Additional Context

Load in this order:

- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/context-map.md` if it is relevant
- `[plan_folder]/adr/` entries relevant to the review target
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/system-design.md` in full — primary review target
- `[plan_folder]/<initiative-name>/prd.md` and `product-brief.md` for user trust model and data sensitivity
- `./resources/security-categories.yaml`

If no `system-design.md` exists, flag that high-level security assumptions could not be verified and proceed based on observed implementation context.

## Stakes-based elicitation

Per-category `stakes` in YAML governs design-review depth:

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | Map trust boundaries, authn/authz paths, and sensitive data flows for the design element. Document attack scenario and required contract change before flagging. Offer roundtable when remediation paths diverge (e.g., centralize vs distribute auth). |
| **medium** | Assess design against category checklist; full boundary trace only when the design introduces new sensitive data handling or exposure surface. Apply `data_exposure` `stakes_note` when PII or credentials are in scope. |
| **low** | Apply filtering threshold only. |

**Review pacing:** Trust model first, then consequential categories, then medium. Architecture findings are design gaps — tag Lance (contract change) or Katrina (UX trust-boundary issue), not Alex.

**Expert compression:** When the user demonstrably gives crisp, complete answers for a consequential review section, I may replace one-question-at-a-time pacing with one confirmation synthesis. Keep consequential pacing for ambiguity, material trade-offs, or missing evidence.

## Global Directives

- **Design gaps, not implementation bugs.** Tag each finding with appropriate owner before handoff.
- **Confidence threshold.** Report only high-confidence findings: >80% exploitability or a clear insecure-by-design pattern, with a credible exploit path from trust boundary to impact.

## Routing heuristics

- *Design-level vulnerability* → `security-review-<slug>.md`; next owner Lance or Katrina.
- *Clean review* → state trust model assessed and categories checked explicitly.
- *Hard exclusions* → do NOT report per YAML filtering.

## Semantic Memory

When trust-model or security terminology becomes stable during this review (and an initiative is named/inferable):
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms (e.g. principal, trust boundary, sensitive-data class). Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when a security boundary establishes or changes a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Identify trust model — trusted actors, sensitive data, boundary crossings, authn/authz model, sensitive data flows.
- [ ] Step 2: Assess design against YAML categories per Stakes-based elicitation — insecure design patterns, missing auth at boundaries, trust escalation, insecure data flow.
- [ ] Step 3: Pre-exit offer (declinable in one word) — *"Before I finalise these findings — anything you want to stress-test first? Otherwise I'll write up the review."* Omit when no findings to write.
- [ ] Step 4: Write `security-review-<slug>.md` if design-level vulnerabilities found; no artifact for clean review.
- [ ] Step 5: Register — add to `## Live` in `registry.md` when written.
- [ ] Step 6: Semantic distillation gate — apply Semantic Memory rules when triggered (skip when no initiative is named).
- [ ] Step 7: Close — apply Exit and Handoff from the core skill. Architecture findings route to Lance or Katrina.

## Definition of Done

- [ ] Trust model and data flow analyzed from design spec
- [ ] `security-categories.yaml` applied for stakes pacing and filtering
- [ ] Only High or Medium design-level issues reported
- [ ] Findings tagged Lance or Katrina owned where applicable
- [ ] Artifact written only when findings exist; `registry.md` updated when applicable
- [ ] `context.md` and/or `context-map.md` updated only if the semantic distillation gate fired and an initiative is in scope
- [ ] Close message: trust model assessed, design findings summary, next owner
