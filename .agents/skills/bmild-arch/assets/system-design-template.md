---
type: System Design
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name> | _system"
author: "[user_name] + Lance (Arch)"
---

## 1. Architecture Scope & Context

- **Authorized outcome / phase:** <MVP | Growth | Vision | named outcome | initiative-wide>
- **Authorization source:** <request or authoritative scope link>
- **In-scope requirements:** <source links>
- **Deferred requirements:** <later outcomes/phases that provide context but no present implementation authority>
- **Initiative-wide invariants:** <constraints shared by every outcome>
- **Current system context:** <how this work fits the existing architecture and active runtime paths>

## Contract notation

Use the following fields for every architecture item in §§2–8. Omit an optional field only when it adds no information.

- **Applies to:** initiative-wide | <named outcome/phase>
- **Disposition:** committed | delegated | illustrative | observed
- **Constraint / observation:** <binding rule, delegated boundary, example, or implementation-confirmed fact>
- **Consequence:** <observable behavior, quality, evolution, or operational effect>
- **Revisit trigger:** <evidence or event that reopens the item; optional>

`committed` items constrain implementation. `delegated` items leave the choice to Alex within the stated boundary. `illustrative` items are non-binding examples. `observed` items record implementation-confirmed reality and do not become commitments without applying Lance's criteria and any required user decision.

## 2. Key Design Decisions

### Decision: <title>

- **Applies to:** ...
- **Disposition:** committed | delegated | illustrative | observed
- **Context:** Why a decision is needed.
- **Alternatives considered:**
  - **Option 1:** pros, cons, complexity, and relevant evidence
  - **Option 2:** pros, cons, complexity, and relevant evidence
- **Decision & rationale:** Why the selected path fits the named constraint.
- **Consequence:** Observable behavior, quality, evolution, or operational effect.
- **Revisit trigger:** ...

Use full alternatives only for a real trade-off. Delegate or mark illustrative when the difference is preference-level.

## 3. System Boundaries & Quality Attributes

### Boundary or quality attribute: <name>

- **Applies to:** ...
- **Disposition:** ...
- **Constraint / observation:** <component/context ownership, trust boundary, allowed dependency direction, or measurable quality target>
- **Consequence:** ...
- **Evidence / source:** ...
- **Revisit trigger:** ...

Cover only applicable load-bearing concerns: ownership boundaries, trust zones, latency/availability/capacity targets, privacy, compliance, scalability, or maintainability constraints.

## 4. Data Contracts & Persistence

### Data contract: <entity / stream / store>

- **Applies to:** ...
- **Disposition:** ...
- **Committed semantics:** <identity, ownership, lifecycle, retention, consistency, privacy, compatibility, invariants>
- **Delegated choices:** <physical representation or tuning Alex may choose>
- **Consequence:** ...

When a physical schema is committed, include only the precision it requires:

### Table: <table_name>

- Column: ...
  - Type: ...
  - Nullable: yes/no
  - Default: ...
  - Notes: ...

Indexes: ...
Constraints and enforcement layer: ...
Migration and compatibility intent: ...

## 5. API & Integration Contracts

### <METHOD> <path> | <event / integration name>

- **Applies to:** ...
- **Disposition:** ...
- **Compatibility / trust boundary:** ...
- **Auth:** required | public | admin only | <other>
- **Request / input:** <fields, types, required/optional status>
- **Response / output:** <success and distinguishable failure semantics>
- **Ordering, idempotency, pagination, filtering, or versioning:** <when applicable>
- **Delegated choices:** <transport/private adapter details not committed>
- **Consequence:** ...

## 6. Service Contracts & Delegated Choices

### <Service or boundary name>

- **Applies to:** ...
- **Disposition:** ...
- **Committed behavior:** <inputs, outputs, side effects, error semantics, security or compatibility obligations>
- **Required signature:** <only when interoperability or another committed constraint requires it>
- **Delegated choices:** <private methods, internal decomposition, algorithms, or data structures Alex may choose>
- **Consequence:** ...

## 7. Failure, Consistency & Recovery

### Scenario: <failure or concurrency condition>

- **Applies to:** ...
- **Disposition:** ...
- **Detection:** ...
- **Required behavior:** <atomicity, retry/idempotency, degradation, rollback, reconciliation, recovery objective>
- **Delegated choices:** ...
- **Consequence:** ...

## 8. Operability & Evolution

### Concern: <observability / deployment / migration / capacity / compatibility>

- **Applies to:** ...
- **Disposition:** ...
- **Required signal or invariant:** ...
- **Rollout / rollback / compatibility expectation:** ...
- **Delegated choices:** ...
- **Consequence:** ...
- **Revisit trigger:** ...

## 9. Bounded Assumptions

- **Assumption:** <low-risk, reversible assumption>
  - Applies to: initiative-wide | <named outcome/phase>
  - Confidence: Low | Med | High
  - Consequence if wrong: ...
  - Revisit trigger: ...

## 10. Implementation-Confirmed Observations

- **Observation:** <durable fact confirmed by implementation>
  - Applies to: initiative-wide | <named outcome/phase>
  - Disposition: observed
  - Source: <code/evidence reference>
  - Architectural consequence: none | <owner decision required>
  - Promotion record: <scribe provenance or Lance decision when promoted>

Observations are descriptive, not binding. Move one into a committed section only after applying Lance's criteria and any required user decision.

## 11. Archived Decisions

Preserve superseded commitments with their former applicability, disposition, replacement, and reason.
