---
name: bmild-ux / ux-design
description: "New initiative mode. Groundtruth existing patterns, elicit user flows and interaction model, and write ux-design.md for a new initiative."
---

## UX-Design Mode

Design the frontend experience for a new initiative. Produce observable, testable UX decisions — not visual preferences.

1. **Entry** — Load in this order:
   - [ ] Project-root `DESIGN.md` if it exists — your design must be consistent with established global UX patterns
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
   - [ ] Do not load `## Archived` entries or other initiative folders

   If no `product-brief.md` or `prd.md` exists: probe for key user needs and requirements before proceeding. Entry at the UX stage is not permission to skip problem framing.

2. **Groundtruth** — Verify the current state of the codebase and any existing global design system. Identify patterns that constrain or shape the new design. Do not invent patterns that contradict established global UX.

3. **Synthesize** — Before designing, summarize: what appears settled from the spec, what user-state decisions are missing, what conflicts exist. Ask the smallest useful question before committing to an interaction model. Do not silently absorb unresolved issues into the artifact.

4. **Elicit** — Probe through each section of `assets/ux-design-template.md` sequentially. Apply all Design Standards from the core skill. Surface one open question per turn unless questions are inter-related. For each open UX issue, explain it conversationally with options and a recommendation — do not log it silently. Elicit before producing final designs; write at a meaningful checkpoint.

   Probe backward on: empty states, error states, loading states, mobile layout, and accessibility — before closing.

5. **Write** — Load `./criteria/completion-criteria.yaml` and privately check each section against its `good_signal`, `weak_signal`, and `falsifiable` field. Is there an observable user behavior or testable screen state confirming each section is complete? Resolve user-owned UX gaps through elicitation. Route product or architecture gaps as Handoff Questions. Write `[plan_folder]/<initiative-name>/ux-design.md` using `assets/ux-design-template.md`.

6. **Distillation gate** — Do this initiative's decisions establish interaction principles, visual language decisions, or UX patterns that all future initiatives must conform to? If yes, distill those specific elements into project-root `DESIGN.md` using `assets/design-md-template.md` for creation, or preserve its existing structure for updates. Initiative-local flows, screen-specific states, and scoped interaction decisions do not qualify.

7. **Register in context memory** — Open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `ux-design.md` (and `DESIGN.md` if updated) to `## Live`. Move any superseded predecessor to `## Archived`.

8. **Gate check** — Walk the user through any outstanding Open UX Questions. For each: explain the issue, present options, give a recommendation. Do not probe on architecture or product-scope questions — route those via Handoff Questions. Confirm every documented question has a target responder and status.

9. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done
- [ ] Groundtruthing findings surfaced before artifact authoring
- [ ] All UX decisions are observable or testable — preferences are labelled as such
- [ ] Empty, error, loading, mobile, and accessibility states considered
- [ ] `completion-criteria.yaml` privately checked before writing
- [ ] `ux-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `DESIGN.md` updated if distillation gate triggered
- [ ] `_context.md` updated with artifacts in `## Live`
- [ ] All Open UX Questions resolved or explicitly deferred by user
- [ ] Close message: key decisions, trade-offs accepted, deferred risks, next owner
