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
- Recut note: ...
- Warning note: ...
