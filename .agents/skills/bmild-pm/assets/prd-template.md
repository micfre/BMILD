---
type: PRD
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name>"
author: "[user_name] + Faisal (PM)"
---

## Functional Requirements

### [Capability Area Name 1]

- FR1: [Actor] can [capability]
- FR2: [Actor] can [capability]

### [Capability Area Name 2]

- FR3: [Actor] can [capability]

## User Journeys

Optional: include only when requirements involve user-facing behavior or workflow change; otherwise record why no journey applies.

- J1 — Journey: [Named trigger and protagonist — a specific named person or precisely identified role, not "the user"]
  - Trigger and context: [what starts the journey and the protagonist's relevant context at that moment, inline]
  - Steps: [ordered sequence, carrying persona context at the steps where it matters]
  - Climax and success exit: [the moment value lands, and what done looks like]
  - Failure path: [the specific way this journey fails, and what recovery looks like]
  - Evidence: Firsthand — [confirmed account source] | Illustrative — evidence gap: [the specific firsthand account not yet supplied]
  - Reveals: [capability areas / FR IDs this journey exercises]

### Journey Requirements Summary

[Which capability areas each journey reveals. Connects journey coverage to FRs above.]

## Success Measures & Counter-Metrics

Optional: include when the PRD records success metrics; omit the section rather than padding it with empty pairs.

- **[Metric name]:** [What it measures and its threshold]
  - **Counter-metric:** [The signal that fires when the primary metric is improved in a harmful way, and what that harmful way is]

## Scope & Prioritization

- **Phase 1 (MVP) outcome:** [Observable product outcome this phase establishes]
  - Includes: [FR and journey IDs]
- **Phase 2 (Growth) outcome:** [Post-MVP outcome]
  - Includes: [FR and journey IDs]
- **Vision:** [Longer-horizon outcome, when useful]
  - Includes: [FR and journey IDs, or omitted when not yet specified]
- **Explicitly Out of Scope:** What we are actively choosing not to do.

Defining a phase does not authorize its implementation. The active user request or an
authoritative outcome record supplies execution authority.

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
