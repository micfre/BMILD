---
scope: <initiative-name> | _system
slice: <N>
status: todo | active | ready-for-review | done | blocked
updated: YYYY-MM-DD
qa_status: not_started | blocked | ready_for_verification | verified | failed
security_status: not_reviewed | not_applicable | review_requested | findings_open | cleared
---

## Intent

One sentence: what this Slice accomplishes.

## Concrete Outcome

One concrete outcome advanced by this Slice.

## Scope

- In: ...
- Out of scope for this Slice: ...

## Dependencies

- Slice <N> ...
- Upstream constraint ...

## Design Contracts (must honour)

- `system-design.md §<section>` — <one-line summary of the contract>
- `ux-design.md §<section>` — <one-line summary>

## Likely Required Reads

- Slice-local contracts:
  - path/to/file
- Existing implementation boundary:
  - path/to/file
- Upstream domain truth:
  - path/to/file
- Closest prior art:
  - path/to/file
- Quality and proof boundaries:
  - path/to/file

## Likely Required Reads Check

- Existing contract file considered: yes / no / not applicable — [path or reason]
- Existing runner/orchestrator/route/entrypoint considered: yes / no / not applicable — [path or reason]
- Canonical schema/config/manifest/registry considered: yes / no / not applicable — [path or reason]
- Closest prior implementation/prototype/test considered: yes / no / not applicable — [path or reason]
- Verification/comparator/artifact-writer boundary considered: yes / no / not applicable — [path or reason]

## Verifiable End Condition

Specific enough to reuse during backward coverage checking.

## Acceptance Criteria

- [ ] ...

## Planning Notes

- Budget estimate: <estimated_total>/<target> tokens, WITHIN BUDGET | OVER BUDGET; skipped files: <none/list>.

## Implementation Notes

## QA / Security Follow-up

- Open QA items: ...
- Open security items: ...
- Resolution notes: ...
