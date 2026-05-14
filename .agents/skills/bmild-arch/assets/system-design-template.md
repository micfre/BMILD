---
scope: "<initiative-name> | _system"
updated: YYYY-MM-DD
author: "[user_name] + Lance (Arch)"
---

## 1. Architecture Vision & Context

How this initiative fits into the broader system architecture and current codebase reality.

## 2. Architectural Decisions (ADRs)

### Decision: <title>

- **Context:** Why we need to decide.
- **Alternatives Considered:**
  - **Option 1:** ...
    - Pros: ...
    - Cons: ...
    - Complexity: impact + risk
    - Conditional recommendation: ...
  - **Option 2:** ...
    - Pros: ...
    - Cons: ...
    - Complexity: impact + risk
    - Conditional recommendation: ...
- **Decision & Rationale:** Why we chose the path.

## 3. Data Model & Schema Changes

### Table: <table_name>

- Column: ...
  - Type: ...
  - Nullable: yes/no
  - Default: ...
  - Notes: ...

Indexes: ...
Constraints: ...
Migration intent: ...

## 4. API & Integration Contracts

### <METHOD> <path>

**Auth:** required | public | admin only

**Request:**
- Path params: ...
- Query params: ...
- Body: `{ field: type, ... }`

**Response:**
- `200`: `{ ... }`
- `400`: `{ error: string }` — when ...

## 5. Service Contracts

### <ServiceName>.<methodName>(params): ReturnType

Description. Throws: ...

## 6. Bounded Assumptions

- **Assumption:** [Low-risk, reversible assumption recorded in the consuming artifact]
  - Confidence: [Low/Med/High]
  - Consequence if wrong: [Impact]
  - Revisit trigger: [What evidence or event should force re-evaluation]

## 7. Consequence-Driven Technical Assumptions

- **Assumption:** [Description]
  - Confidence: [Low/Med/High]
  - Consequence if wrong: [Impact]

## 8. Archived Decisions
