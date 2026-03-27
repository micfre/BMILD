---
feature: persona-breadth
slice: 1
status: todo
updated: 2026-03-27
---

## Intent
Establish the canonical public persona roster and adopt `Delivery Planner` as the public-facing replacement for `Planner`.

## Scope
- In: rename public-facing `Planner` references to `Delivery Planner` in core skill metadata and any immediately adjacent user-facing copy; align the canonical lifecycle roster ordering across touched surfaces.
- In: preserve compatibility if the underlying `.agents/skills/bmild-planner/` path remains unchanged.
- Out of scope for this Slice: rewriting the full `README.md` information architecture, standardizing all persona opening/handoff wording, or adding migration guide content beyond references needed for naming consistency.

## Design Contracts (must honour)
- `system-design.md §Canonical Persona Registry Contract` — public docs and onboarding must present one ordered lifecycle roster.
- `system-design.md §Rename Contract: \`planner\` -> \`Delivery Planner\`` — apply the public role rename consistently while allowing the folder path to remain unchanged.
- `system-design.md §Decision: Adopt \`Delivery Planner\` as the public role name` — avoid Agile-derived labels and preserve BMILD's lighter-weight identity.
- `ux-design.md §Navigation & Information Architecture` — lifecycle-stage entry should be clearer than persona jargon.
- `ux-design.md §IL Session: Rename \`planner\` to \`Delivery Planner\` (2026-03-27)` — the rename decision and rationale are fixed inputs.

## Acceptance Criteria
- [ ] All user-facing references changed in this Slice use `Delivery Planner` instead of `Planner`.
- [ ] Any retained filesystem or trigger naming mismatch is not exposed as the primary user-facing label.
- [ ] The canonical lifecycle roster is internally consistent across all files touched in this Slice.
- [ ] No new workflow modes, personas, or installer/script behavior are introduced.

## Implementation Notes
<!-- Alex fills this in after implementation. Sonia leaves this empty. -->
