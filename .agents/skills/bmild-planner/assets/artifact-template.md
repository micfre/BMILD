## slices.md

```markdown
---
scope: <initiative-name> | _system
status: active | complete | archived
updated: YYYY-MM-DD
author: [user_name] + Sonia (Planner)
planning_method: plan-forward-verify-backward
verification_status: pass | pass_with_warning | fail | handback
approved_scope: MVP | named phase | full initiative
---

## Readiness

- Upstream artifacts present:
  - Result: pass / gap / handback
  - Detail: [one-line justification]
- Cross-artifact alignment:
  - Result: pass / gap / contradiction
  - Detail: [one-line per finding, or "all Must Haves covered"]
- Coverage verified:
  - Result: pass / pass-with-warning / fail
  - Detail: [one-line justification]
- Question closure:
  - Result: pass / gap / routed / deferred_by_user
  - Detail: [all Open and Handoff Questions resolved, explicitly deferred, or routed with target responder and documented action]

## Slice Registry

- Slice 1:
  - Intent: ...
  - Status: todo
  - Depends on: none
  - Verifiable end condition: ...
  - Slice type: groundwork
- Slice 2:
  - Intent: ...
  - Status: todo
  - Depends on: Slice 1
  - Verifiable end condition: ...
  - Slice type: mainline

## Roadmap / Deferred Phases
- [Future phase item]:
  - Phase: Growth / later named phase
  - Status: roadmap / blocked_placeholder
  - Reason not authored as Slice: [out of approved scope / missing UX / user did not request full-initiative planning]
  - Required future artifact or decision: ...

## Coverage Verification
- Goal being checked: ...
- Coverage result: ...
- Requirement traceability:
  - `prd.md` Must Have 1 -> Slice 1, Slice 2
  - `prd.md` Must Have 2 -> Slice 3
  - `prd.md` Must Have 3 -> uncovered
- Recut note: ... <!-- include only if a recut occurred -->
- Warning note: ... <!-- include only if verification passed with warning -->
```

## verification-matrix.md

```markdown
---
scope: <initiative-name> | _system
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: [user_name] + Sonia (Planner)
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

## Open Verification Questions
- ...
```

## slice-\<N\>.md

```markdown
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
Likely-required reads Sonia@bmild-planner used when sizing this Slice.
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
<!-- Sonia@bmild-planner-owned notes: why this is groundwork/mainline/cleanup, decomposition gotchas, Single-Slice Optimisation if applicable. -->
- Budget estimate: <estimated_total>/<target> tokens, WITHIN BUDGET | OVER BUDGET; skipped files: <none/list>.

## Implementation Notes
<!-- Alex@bmild-dev fills this in after implementation. Sonia@bmild-planner leaves this empty. -->

## QA / Security Follow-up
- Open QA items: ...
- Open security items: ...
- Resolution notes: ...
```

## _rollup.md

```markdown
---
owner: Sonia (Planner)
updated: YYYY-MM-DD
---

## Initiative Registry

- Initiative: <initiative-name>
  - Phase: MVP | Growth | full
  - Status: active | complete | archived
  - Lead: Faisal | Lance | Katrina | Sonia
  - Last updated: YYYY-MM-DD
```
