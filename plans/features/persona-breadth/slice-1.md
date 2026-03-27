---
feature: persona-breadth
slice: 1
status: todo
updated: 2026-03-27
---

## Intent
Establish the canonical public persona roster and adopt `Delivery Planner` as the public-facing implementation-orchestration replacement for `Planner`.

## Scope
- In: rename public-facing `Planner` references to `Delivery Planner` in core skill metadata and any immediately adjacent user-facing copy.
- In: reflect the approved role definition in core user-facing surfaces so `Delivery Planner` clearly owns readiness, Slice planning, status visibility, and rerouting.
- In: align the canonical lifecycle roster ordering across touched surfaces.
- In: preserve compatibility if the underlying `.agents/skills/bmild-planner/` path remains unchanged.
- Out of scope for this Slice: rewriting the full `README.md` information architecture, standardizing all persona opening/handoff wording, or adding migration guide content beyond references needed for naming consistency.

## Design Contracts (must honour)
- `system-design.md §Canonical Persona Registry Contract` — public docs and onboarding must present one ordered lifecycle roster.
- `system-design.md §Rename Contract: \`planner\` -> \`Delivery Planner\`` — apply the public role rename consistently while allowing the folder path to remain unchanged.
- `system-design.md §Rename Contract: \`planner\` -> \`Delivery Planner\` > Approved role statement` — the role must be described as implementation orchestration rather than generic planning.
- `system-design.md §Decision: Adopt \`Delivery Planner\` as the public role name` — avoid Agile-derived labels and preserve BMILD's lighter-weight identity.
- `ux-design.md §Navigation & Information Architecture` — lifecycle-stage entry should be clearer than persona jargon.
- `ux-design.md §IL Session: Rename \`planner\` to \`Delivery Planner\` (2026-03-27)` — the rename decision and rationale are fixed inputs.
- `spec.md §Approved Role Statement: Delivery Planner (2026-03-27)` — public-facing wording must cover readiness, sequencing, status clarity, and rerouting while excluding Scrum/process ownership.

## Acceptance Criteria
- [ ] All user-facing references changed in this Slice use `Delivery Planner` instead of `Planner`.
- [ ] Touched user-facing references describe `Delivery Planner` as more than a rename-only role and include the approved implementation-orchestration scope where appropriate.
- [ ] Any retained filesystem or trigger naming mismatch is not exposed as the primary user-facing label.
- [ ] The canonical lifecycle roster is internally consistent across all files touched in this Slice.
- [ ] No new workflow modes, personas, or installer/script behavior are introduced.

## Implementation Notes
<!-- Alex fills this in after implementation. Sonia leaves this empty. -->
