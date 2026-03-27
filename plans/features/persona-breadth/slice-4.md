---
feature: persona-breadth
slice: 4
status: done
updated: 2026-03-27
---

## Intent
Add the supporting migration and onboarding guidance needed to reinforce the new lifecycle map after the primary skill and README changes land.

## Scope
- In: create or update the minimal supporting docs needed for BMAD migration and first-run onboarding, if the README alone is insufficient.
- In: align any new guidance with the canonical lifecycle roster, context-first persona behavior, and `Delivery Planner` naming.
- In: update `CHANGELOG.md` to reflect the user-facing changes shipped by this feature.
- Out of scope for this Slice: new workflow modes, scripts, installers, or non-Codex platform guidance.

## Design Contracts (must honour)
- `ux-design.md §Navigation & Information Architecture` — onboarding guidance should support stage-based entry and BMAD migration.
- `ux-design.md §Onboarding Decision Surface` — users should be able to join midstream and see short invocation examples.
- `ux-design.md §Flow: BMAD Migrant Looks For Equivalent Capability` — migration guidance should be intent-based and should explain what BMILD intentionally does not replicate.
- `system-design.md §Canonical Persona Registry Contract` — supporting docs must reinforce the same lifecycle roster and keep special modes separate.
- `system-design.md §Open Technical Questions` — use the minimal doc set needed; do not invent extra surfaces without evidence.

## Acceptance Criteria
- [x] Supporting onboarding or migration guidance exists if still needed after the README rewrite, and it does not duplicate the README without adding value.
- [x] Any added guidance includes short, stage-based invocation examples and reinforces mid-lifecycle entry.
- [x] BMAD migration guidance explains BMILD's intentional differences without implying missing capability.
- [x] `CHANGELOG.md` reflects the renamed role and the improved onboarding / handoff model.

## Implementation Notes
<!-- Alex fills this in after implementation. Sonia leaves this empty. -->
- Added a focused `ONBOARDING.md` rather than another broad docs surface so first-run and midstream entry guidance stays compact and distinct from the README.
- Kept the onboarding doc intent-based: stage routing, short invocation examples, and a BMAD migration branch that explains what BMILD intentionally does not replicate.
- Linked the onboarding guide from `README.md` and extended `CHANGELOG.md` so the user-facing onboarding and renamed-role changes are both visible.
