---
owner: Lance (Architect)
updated: YYYY-MM-DD
---

## Tech Stack

[Canonical languages, runtimes, frameworks, and infrastructure choices that all initiatives must build within. Changes here require explicit user decision — do not modify without surfacing the trade-off.]

## Auth Model

[Authentication and authorization architecture. Cross-initiative contracts that all implementations must not violate. State the auth pattern, session model, and any cross-service trust rules at the level of specificity that constrains future design.]

## Shared Schema

[Tables, types, enums, or data structures that cross initiative boundaries. Record at the column level: table, column, type, nullability, constraints, migration intent. Column-level decisions recorded here apply to all future initiatives.]

## Service Contracts

[Shared APIs, event contracts, queue shapes, or integration points that multiple initiatives depend on. Specify method/path, request/response shape, auth requirement, and error codes at the level Alex can implement without architectural decisions.]

## Cross-Initiative Decisions

[Any other architectural decisions — patterns, conventions, constraints — that future initiatives must build against. Examples: logging format, error handling convention, feature flag system, observability contract.]

## Distillation Log

Append-only. Add an entry each time this document is updated. Format: date | initiative-name | what was distilled.

- [YYYY-MM-DD] | [initiative-name] | [one-line description of what was distilled]
