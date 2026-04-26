```markdown
---
scope: <initiative-name> | _system
updated: YYYY-MM-DD
author: bmild-arch
---

## Tech Stack
| Layer | Choice | Notes |
|-------|--------|-------|
| Runtime | ... | |
| Framework | ... | |
| UI Components | ... | |
| ORM | ... | |
| ...

## Database Schema Changes
### Table: <table_name>
| Column | Type | Nullable | Default | Notes |
|--------|------|----------|---------|-------|
| ...

Indexes: ...
Constraints: ...
Migration intent: ...

## API Contracts
### <METHOD> <path>
**Auth:** required | public | admin only

**Request:**
- Path params: ...
- Query params: ...
- Body: `{ field: type, ... }`

**Response:**
- `200`: `{ ... }`
- `400`: `{ error: string }` — when ...
- `404`: — when ...

## Service Contracts
### <ServiceName>.<methodName>(params): ReturnType
Description. Throws: ...

## Architectural Decisions
### Decision: <title>
- **Decided:** ...
- **Rationale:** ...
- **Alternatives considered:** ...
- **Implementation discretion:** ...

## Open Technical Questions
Questions to resolve before or during implementation.

## Archived Decisions
<!-- Decisions superseded by later work -->
```
