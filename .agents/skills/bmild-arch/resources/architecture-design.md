---
name: bmild-arch / architecture-design
description: "New initiative mode. Groundtruth the codebase, elicit decisions conversationally, and write system-design.md for a new initiative."
---

## Architecture-Design Mode

Design the system for a new initiative. Produce concrete, implementable contracts — not high-level diagrams.

1. **Entry** — Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists — your design must extend it, never contradict it
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
   - [ ] Do not load `## Archived` entries or other initiative folders

   If no `product-brief.md` or `prd.md` exists: probe for key requirements before proceeding. Entry at the architecture stage is not permission to skip problem framing.

2. **Groundtruth** — Before proposing architecture, verify the current state of the codebase. Scan the file tree and read relevant implementation files. Identify any existing code, schemas, or API contracts that constrain or contradict the proposed design. Do not invent greenfield solutions in a brownfield environment.

3. **Synthesize** — Before writing anything, summarize: what appears settled, what conflicts, what needs a decision. Present findings to the user. Name any apparent gaps or contract mismatches. Ask the smallest useful question before committing to a design direction. Do not silently absorb an unresolved issue into `system-design.md`.

4. **Elicit** — Probe through each section of `assets/system-design-template.md` sequentially. Apply all Design Standards from the core skill. Use compact option blocks for trade-offs. Surface one open question per turn unless questions are inter-related. For each open technical question, explain it conversationally with options and a recommendation — do not log it silently.

   If a user pushes toward closure on an unresolved technical question, name the risk, note it as an open question in the design doc, and defer to their explicit decision.

5. **Write** — Load `./resources/completion-criteria.yaml` and privately check each section against its `good_signal`, `weak_signal`, and `falsifiable` field before writing. Could a developer execute against this contract without making an architectural decision? Resolve user-owned architecture gaps through elicitation. Route product or UX gaps as Handoff Questions. Write `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`.

6. **Distillation gate** — Does this initiative's `system-design.md` contain decisions — schema columns, auth patterns, service contracts, shared infrastructure — that future unrelated initiatives must build against? If yes, distill those specific decisions into `plans/ARCHITECTURE.md` using `assets/architecture-template.md`. Local endpoint shapes, initiative-specific data models, and implementation choices do not qualify.

7. **Register in context memory** — Open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `system-design.md` to `## Live`. Move any superseded predecessor to `## Archived`.

8. **Gate check** — Walk the user through any outstanding Open Technical Questions in the architecture domain: schema decisions, API contracts, service boundaries, tech stack choices. For each: explain the issue, present options, give a recommendation. Confirm every documented question has a target responder and status. User-owned questions must be resolved or explicitly deferred before handoff.

9. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Groundtruthing findings surfaced before artifact authoring
- [ ] All architecture decisions have observable implementation consequences
- [ ] `completion-criteria.yaml` privately checked before writing
- [ ] `system-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `ARCHITECTURE.md` updated if distillation gate triggered
- [ ] `_context.md` updated with `system-design.md` in `## Live`
- [ ] All Open Technical Questions resolved or explicitly deferred by user
- [ ] Close message: key decisions, trade-offs accepted, deferred risks, next owner
