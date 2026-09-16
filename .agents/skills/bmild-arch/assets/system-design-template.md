---
type: System Design
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name> | _system"
author: "[user_name] + Lance (Arch)"
---

## 1. Architecture Vision & Context

How this initiative fits into the broader system architecture and current codebase reality.

## 2. Key Design Decisions

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

## 5. Service Contracts and Delegated Choices

### <ServiceName>.<methodName>(params): ReturnType

Describe binding boundary behavior, side effects, and errors. Specify signatures when interoperability or another committed constraint requires them. Mark private method sketches as illustrative.

- Committed constraints: ...
- Delegated implementation choices: ...

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
