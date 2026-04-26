## slices.md

```markdown
---
scope: <initiative-name> | _system
status: active | complete | archived
updated: YYYY-MM-DD
author: bmild-planner
planning_method: plan-forward-verify-backward
verification_status: pass | pass_with_warning | fail | handback
---

## Readiness

| Check | Result | Detail |
|-------|--------|--------|
| Upstream artifacts present | pass / gap / handback | [one-line justification] |
| Cross-artifact alignment | pass / gap / contradiction | [one-line per finding, or "all Must Haves covered"] |
| Coverage verified | pass / pass-with-warning / fail | [one-line justification] |

| # | Intent | Status | Depends On | Verifiable End Condition | Slice Type |
|---|--------|--------|------------|--------------------------|------------|
| 1 | ... | todo | — | ... | groundwork |
| 2 | ... | todo | 1 | ... | mainline |

## Coverage Verification
- Goal being checked: ...
- Coverage result: ...
- Requirement traceability:
  - `spec.md` Must Have 1 -> Slice 1, Slice 2
  - `spec.md` Must Have 2 -> Slice 3
  - `spec.md` Must Have 3 -> uncovered
- Recut note: ... <!-- include only if a recut occurred -->
- Warning note: ... <!-- include only if verification passed with warning -->
```

## slice-\<N\>.md

```markdown
---
scope: <initiative-name> | _system
slice: <N>
status: todo | active | ready-for-review | done | blocked
updated: YYYY-MM-DD
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
- path/to/file

## Verifiable End Condition
Specific enough to reuse during backward coverage checking.

## Acceptance Criteria
- [ ] ...

## Planning Notes
<!-- Sonia@bmild-planner-owned notes: why this is groundwork/mainline/cleanup, decomposition gotchas, Single-Slice Optimisation if applicable. -->

## Implementation Notes
<!-- Alex@bmild-dev fills this in after implementation. Sonia@bmild-planner leaves this empty. -->
```
