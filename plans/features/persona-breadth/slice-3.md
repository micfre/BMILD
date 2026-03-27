---
feature: persona-breadth
slice: 3
status: done
updated: 2026-03-27
---

## Intent
Turn `README.md` into a stage-based discovery and onboarding surface that helps new users and BMAD migrants know where to start, who comes next, and what `Delivery Planner` actually owns.

## Scope
- In: restructure `README.md` around promise, start-here routing, canonical lifecycle roster, handoff explanation, BMAD migration guidance, modes, and memory model.
- In: explain `Delivery Planner` in plain language as the role for readiness, Slice planning, progress visibility, and rerouting, without importing Scrum ceremony expectations.
- In: add concise invocation examples and make BMILD's "mild" positioning clearer without turning the README into a manifesto.
- Out of scope for this Slice: editing individual persona skill files beyond references necessary for README alignment, or adding non-README docs except those explicitly required by Slice 4.

## Design Contracts (must honour)
- `ux-design.md §Navigation & Information Architecture` — `README.md` should act as the primary discovery and decision surface.
- `ux-design.md §Screens / Views > README Discovery Surface` — the README must be scannable, stage-based, and migration-aware.
- `ux-design.md §Interaction Model` — the first visible routing should be action-oriented rather than "meet the personas."
- `system-design.md §Canonical Persona Registry Contract` — present the ordered lifecycle roster and keep special modes separate.
- `system-design.md §Rename Contract: \`planner\` -> \`Delivery Planner\`` — public-facing naming must be consistent.
- `spec.md §Approved Role Statement: Delivery Planner (2026-03-27)` — README wording must reflect the approved scope without drifting into generic project-management language.

## Acceptance Criteria
- [x] `README.md` contains a stage-based "Start Here" section that helps users identify a sensible first persona.
- [x] `README.md` presents the canonical lifecycle roster in a consistent order, with `Delivery Planner` in place.
- [x] `README.md` explains `Delivery Planner` strongly enough that users understand it covers readiness, Slice planning, status visibility, and rerouting.
- [x] `README.md` explains persona handoffs and context-first behavior clearly enough that users know how BMILD moves from stage to stage.
- [x] `README.md` includes BMAD migration guidance based on user intent rather than persona parity.
- [x] The README remains concise enough to scan, with philosophy moved below the initial routing decision.

## Implementation Notes
<!-- Alex fills this in after implementation. Sonia leaves this empty. -->
- Rewrote `README.md` around lifecycle-stage entry so the first meaningful choice is where to start, not how BMILD compares to BMAD.
- Added explicit sections for the canonical lifecycle roster, `Delivery Planner`, handoff behavior, and BMAD intent mapping while keeping special modes separate from the main working set.
- Preserved the existing install path, memory model, roadmap, and acknowledgements sections, but moved the philosophy/comparison material below the primary routing content.
