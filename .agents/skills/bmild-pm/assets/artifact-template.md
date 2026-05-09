## product-brief.md

```markdown
---
initiative: <initiative-name>
updated: YYYY-MM-DD
author: [user_name] + Faisal (PM)
---

## Problem

[What specific pain exists. Who feels it. How they cope today. What the cost of the status quo is. Real scenarios, not abstractions.]

## Solution

[What we are building and how it solves the problem. Focus on the experience and outcome, not the implementation.]

## Target Users

[Primary users — who they are, what they need, what success looks like for them. Secondary users or non-user stakeholders if relevant.]

[B2B: name buyer and user separately if they are different people.]

## Competitive Context

[What alternatives exist. Why this approach over them. What the differentiating bet is. Be honest — if the moat is execution speed, say so rather than fabricating a technical moat.]

## Success Criteria

[Vision-level outcomes that should hold across multiple initiatives. At least one must be measurable.]

## Scope

[What is in for the first initiative. What is explicitly out. Tight — this is a boundary document, not a feature list.]

## 2-3 Year Vision

[Where this goes if the first initiative succeeds. What it becomes. Inspiring but grounded.]

## Open Product Questions

Vision or market-level questions. If resolved differently, these would change the vision, user model, or competitive positioning.

- Question: ...
  - Target responder: User
  - Status: unresolved | resolved | deferred_by_user
  - Recommendation: ...
  - Consequence if deferred: ...
```

## prd.md

```markdown
---
initiative: <initiative-name>
updated: YYYY-MM-DD
author: [user_name] + Faisal (PM)
---

## Functional Requirements

### [Capability Area Name]

- FR1: [Actor] can [capability]
- FR2: [Actor] can [capability]

### [Capability Area Name]

- FR3: [Actor] can [capability]

## User Journeys

- Journey: [Named trigger and user type]
  - Steps: [ordered sequence]
  - Success exit: [what done looks like]
  - Edge or failure paths: [acknowledged paths]

### Journey Requirements Summary

[Which capability areas each journey reveals. Connects journey coverage to FRs above.]

## Scope & Prioritization

- **Phase 1 (MVP):** Absolute minimum to validate the idea.
- **Phase 2 (Growth):** Fast follows and competitive enhancements.
- **Explicitly Out of Scope:** What we are actively choosing not to do.

## Non-Functional Requirements

- **[Category]:** [Threshold and the scenario that triggers it]

## Documentation Scope

- User docs: [required | not required | deferred_by_user] — [what or reason] — [verifiable claim if required]
- Operator docs: [required | not required | deferred_by_user] — [what or reason] — [verifiable claim if required]
- Contributor docs: [required | not required | deferred_by_user] — [what or reason] — [verifiable claim if required]

## Consequence-Driven Assumptions

- **Assumption:** [Description]
  - Confidence: [Low/Med/High]
  - Consequence if wrong: [Impact]

## Open Product Questions

User-owned product questions. Must be resolved or explicitly deferred by the user before handoff.

- Question: ...
  - Target responder: User
  - Status: unresolved | resolved | deferred_by_user
  - Recommendation: ...
  - Consequence if deferred: ...

## UX Handoff Questions

Questions outside PM scope that Katrina must resolve.

- Question: ...
  - Target responder: Katrina
  - Status: unresolved | resolved | deferred_by_user
  - Context or recommendation: ...
  - Consequence if deferred: ...

## Architecture Handoff Questions

Questions outside PM scope that Lance must resolve.

- Question: ...
  - Target responder: Lance
  - Status: unresolved | resolved | deferred_by_user
  - Context or recommendation: ...
  - Consequence if deferred: ...
```
