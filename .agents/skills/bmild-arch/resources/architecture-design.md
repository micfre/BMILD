---
name: bmild-arch / architecture-design
description: "New initiative mode. Groundtruth the codebase, elicit decisions conversationally, and write system-design.md for a new initiative."
---

## Architecture-Design Mode

Design the system for a new initiative. Produce concrete, implementable contracts — not high-level diagrams.

1. **Entry** — Resolve the initiative path by checking `[plan_folder]/<initiative-name>/` directly when an initiative is named. Load in this order:
   - [ ] `plans/ARCHITECTURE.md` if it exists — your design must extend it, never contradict it
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
   - [ ] `[plan_folder]/<initiative-name>/ux-design.md` if it exists — interaction, user-state, and screen contract inputs
   - [ ] Do not load `## Archived` entries or other initiative folders

   If no `product-brief.md` or `prd.md` exists: probe for key requirements before proceeding. Entry at the architecture stage is not permission to skip problem framing.

2. **Hydrate upstream inputs** — Read `product-brief.md`, `prd.md`, and `ux-design.md` when present before asking architecture questions. Extract settled requirements, constraints, non-functional requirements, documentation obligations, user-state contracts, information timing, permissions, and UX proof states. Do not reopen these as user choices unless the artifacts conflict, contradict the codebase, or require an architecture trade-off the upstream artifacts did not decide.

3. **Groundtruth** — Before proposing architecture, verify the current state of the codebase. Scan the file tree and read relevant implementation files. Identify any existing code, schemas, or API contracts that constrain or contradict the proposed design. Do not invent greenfield solutions in a brownfield environment.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

4. **Synthesize** — Before writing anything, summarize: what appears settled from PM and UX artifacts, what UX states imply for API/data/service boundaries, what architecture hypotheses follow, what conflicts, and what needs a decision. Present findings to the user. Name any apparent gaps or contract mismatches. Ask the smallest useful architecture question before committing to a design direction. Do not silently absorb an unresolved issue into `system-design.md`.

5. **Elicit** — Before the first question, preview the queue: name the architecture categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Then probe through each section of `assets/system-design-template.md` sequentially. Apply all Craft Standards from the core skill. Use compact option blocks only for genuine technical trade-offs. Surface one ambiguity per turn unless questions are inter-related.

   If user input is still required after the session, create or update `[plan_folder]/<initiative-name>/user-attention.md` using `.agents/skills/bmild-pm/assets/user-attention-template.md`. If the issue belongs to another owned artifact or reflects a source defect/conflict, create or update `[plan_folder]/<initiative-name>/spec-patch-queue.md` using `.agents/skills/bmild-pm/assets/spec-patch-queue-template.md`. Record only low-risk, reversible bounded assumptions inside `system-design.md`.

6. **Write** — Load `./resources/completion-criteria.yaml` and privately check each section against its `good_signal`, `weak_signal`, and `falsifiable` field before writing. Could a developer execute against this contract without making an architectural decision? Resolve user-owned architecture gaps through elicitation or `user-attention.md`. Route product or UX source issues through `spec-patch-queue.md`. Write `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`.

7. **Distillation gate** — Does this initiative's `system-design.md` contain decisions — schema columns, auth patterns, service contracts, shared infrastructure — that future unrelated initiatives must build against? If yes, distill those specific decisions into `plans/ARCHITECTURE.md` using `assets/architecture-template.md`. Local endpoint shapes, initiative-specific data models, and implementation choices do not qualify.

8. **Register in context memory** — Open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `system-design.md` to `## Live`. Move any superseded predecessor to `## Archived`.

9. **Gate check** — Walk the user through any remaining architecture-domain ambiguity that still needs synchronous resolution. For each: explain the issue, present options, give a recommendation. If user input still remains, queue it in `user-attention.md`. If the issue belongs to product or UX ownership, route it through `spec-patch-queue.md`. Do not preserve durable question sections in `system-design.md`.

10. **Close** — Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Groundtruthing findings surfaced before artifact authoring
- [ ] All architecture decisions have observable implementation consequences
- [ ] `completion-criteria.yaml` privately checked before writing
- [ ] `system-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `ARCHITECTURE.md` updated if distillation gate triggered
- [ ] `_context.md` updated with `system-design.md` in `## Live`
- [ ] Remaining ambiguity routed through `user-attention.md`, `spec-patch-queue.md`, or bounded assumptions instead of embedded question sections
- [ ] Close message: key decisions, trade-offs accepted, queued or deferred governance items, next owner
