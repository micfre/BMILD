---
scope: "<initiative-name> | _system"
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: "[user_name] + Sonia (Planner)"
mode: nyquist-readiness
status: draft | active | partially_implemented | verified | blocked
---

## Test Infrastructure

- Commands: ...
- Tools: ...
- Required fixtures or mocks: ...

## Requirement Coverage Matrix

- Requirement: ...
  - Source: `prd.md §...` / `ux-design.md §...` / `system-design.md §...`
  - Covered by Slice: Slice <N>
  - Test case / verification action: ...
  - Type: unit / integration / e2e / manual
  - Status: draft / implemented / passed / failed / blocked
  - Created by: Sonia
  - Implementation consumer: Alex
  - Verification owner: Rahat
  - Evidence: [test file, command, manual check, or pending]
  - Next owner: Alex / Rahat / Lance / Katrina / none
  - Queue reference: none | `spec-patch-queue.md#...` | `user-attention.md#...`

## Open Verification Dependencies

- Use this section only for proof-owned dependencies, blocked evidence, or missing verification setup.
- Do not place source-artifact repair requests here. Route product, UX, architecture, and other source-truth defects through `spec-patch-queue.md`, route missing user input through `user-attention.md`, and reference the queue item ID here only when verification depends on it.
- ...
