---
type: Slice
title: "Slice <N> — <title>"
description: "A bounded development and acceptance unit within an authorized outcome"
timestamp: YYYY-MM-DD
scope: "<initiative-name>"
slice: <N>
outcome: O-###
status: todo
qa_status: not_reviewed
security_status: not_reviewed
code_review_status: not_reviewed
---

## Parent and sources

- Parent: [O-### — <outcome title>](verification-matrix.md#o-###--<outcome-title>)
- Phase and authorization: <parent scope; planning does not authorize execution>
- Sources: <links to governing requirement, UX, architecture, and documentation sections>

## Acceptance boundary

- Observable result: <behavior and failure states; cite source IDs rather than copying specifications>
- Exclusions: <adjacent and deferred work>
- Required proof: <checks and applicable review axes; evidence lives in the parent matrix>
- Dependencies: <links to prerequisite Slices or explicit none; required accepted behavior>

## Implementation guidance

<Only constraints or integration guidance another context needs. Private structure, task order, and files stay with Alex.>

## Continuation

- Evidence: [Parent outcome and Slice evidence](verification-matrix.md#o-###--<outcome-title>)
- Implementation notes / next action: <actual progress, blockers, or review transition>
- Related work: [Slice registry](slices.md); <dependency and successor links>

Statuses project matrix evidence: `todo | in_progress | blocked | ready_for_review | done`. Only Rahat accepts `done` and archives this Slice. Use the parent's review-axis vocabulary; missing or stale evidence never implies acceptance. Sonia resolves boundary/dependency changes; Alex controls implementation details. The final Slice review includes whole-outcome source coverage and integrated verification.
