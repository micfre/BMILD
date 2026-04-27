```markdown
---
scope: <initiative-name> | _system
updated: YYYY-MM-DD
author: bmild-arch
---

## 1. Architecture Vision & Context
- How this initiative fits into the broader system architecture and current codebase reality.

## 2. Architectural Decisions (ADRs)
### Decision: <title>
- **Context:** Why we need to decide.
- **Alternatives Considered:** (Structured evaluation)
  - Option A | Pros | Cons | Complexity (Impact + Risk)
  - Option B | Pros | Cons | Complexity (Impact + Risk)
- **Decision & Rationale:** Why we chose the path.

## 3. Data Model & Schema Changes
### Table: <table_name>
| Column | Type | Nullable | Default | Notes |
|--------|------|----------|---------|-------|
| ...

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

## 6. Open Technical Questions
Questions to resolve before or during implementation.

## 7. Consequence-Driven Technical Assumptions
- **Assumption:** [Description] | **Confidence:** [Low/Med/High] | **Consequence if wrong:** [Impact]

## Archived Decisions
<!-- Decisions superseded by later work -->
```
