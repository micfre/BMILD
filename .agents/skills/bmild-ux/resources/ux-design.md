---
name: bmild-ux / ux-design
description: "New initiative mode. Groundtruth existing patterns, elicit user flows and interaction model, and write ux-design.md for a new initiative."
---

## UX-Design Mode

Design the frontend experience for a new initiative. Produce observable, testable UX decisions — not visual preferences.

1. **Entry** — Resolve the initiative path by checking `[plan_folder]/<initiative-name>/` directly when an initiative is named. Load in this order:
   - [ ] Project-root `DESIGN.md` if it exists — your design must be consistent with established global UX patterns
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` if it exists — technical constraints only; not a source of UX intent
   - [ ] Do not load `## Archived` entries or other initiative folders

   If no `product-brief.md` or `prd.md` exists: probe for key user needs and requirements before proceeding. Entry at the UX stage is not permission to skip problem framing.

2. **Hydrate upstream inputs** — Read `product-brief.md` and `prd.md` before asking UX questions, and read `system-design.md` when present to understand fixed technical constraints. Extract settled requirements, user journeys, priority boundaries, non-functional requirements, documentation obligations, fixed component/library constraints, auth boundaries, data availability, and latency/platform limits. Do not reopen PM requirements as user choices unless the artifacts conflict, contradict existing UX patterns, or require a UX trade-off the PM artifacts did not decide. Do not infer user intent from architecture.

3. **Groundtruth** — Verify the current state of the codebase and any existing global design system. Identify patterns that constrain or shape the new design. Do not invent patterns that contradict established global UX.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

4. **Synthesize** — Before designing, summarize: what appears settled from PM artifacts, what technical constraints from architecture apply, what user-state hypotheses follow, what user-state decisions are missing, and what conflicts exist. Ask the smallest useful UX question before committing to an interaction model. Do not silently absorb unresolved issues into the artifact.

5. **Elicit** — Before the first question, preview the queue: name the UX categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Then probe through each section of `assets/ux-design-template.md` sequentially. Apply all Craft Standards from the core skill. Surface one ambiguity per turn unless questions are inter-related. Elicit before producing final designs; write at a meaningful checkpoint.

   Probe backward on: empty states, error states, loading states, mobile layout, and accessibility — before closing.

6. **Write** — Load `./resources/completion-criteria.yaml` and privately check each section against its `good_signal`, `weak_signal`, and `falsifiable` field. Is there an observable user behavior or testable screen state confirming each section is complete? Resolve user-owned UX gaps through elicitation or `user-attention.md`. Route product or architecture source issues through `spec-patch-queue.md`. Write `[plan_folder]/<initiative-name>/ux-design.md` using `assets/ux-design-template.md`.

7. **Distillation gate** — Do this initiative's decisions establish interaction principles, visual language decisions, or UX patterns that all future initiatives must conform to? If yes, distill those specific elements into project-root `DESIGN.md` using `assets/design-md-template.md` for creation, or preserve its existing structure for updates. Initiative-local flows, screen-specific states, and scoped interaction decisions do not qualify.

8. **Register in context memory** — Open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `ux-design.md` (and `DESIGN.md` if updated) to `## Live`. Move any superseded predecessor to `## Archived`.

9. **Gate check** — Walk the user through any remaining UX-domain ambiguity that still needs synchronous resolution. For each: explain the issue, present options, give a recommendation. If user input still remains, queue it in `user-attention.md`. If the issue belongs to architecture or product ownership, route it through `spec-patch-queue.md`. Do not preserve durable question sections in `ux-design.md`.

10. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Groundtruthing findings surfaced before artifact authoring
- [ ] All UX decisions are observable or testable — preferences are labelled as such
- [ ] Empty, error, loading, mobile, and accessibility states considered
- [ ] `completion-criteria.yaml` privately checked before writing
- [ ] `ux-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `DESIGN.md` updated if distillation gate triggered
- [ ] `_context.md` updated with artifacts in `## Live`
- [ ] Remaining ambiguity routed through `user-attention.md`, `spec-patch-queue.md`, or bounded assumptions instead of embedded question sections
- [ ] Close message: key decisions, trade-offs accepted, queued or deferred governance items, next owner
