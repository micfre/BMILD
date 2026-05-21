# UX-Refinement

Extend or update an existing `ux-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

## Additional Context

Load in this order:
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/ux-design.md` in full — this is the design you are modifying
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` for current requirements
- `[plan_folder]/<initiative-name>/system-design.md` if it exists — technical constraints only; not a source of UX intent
- Confirm no `## Archived` entries or other initiative folders were loaded

## Additional Directives

- Read current `product-brief.md` and `prd.md` before asking refinement questions. Read `system-design.md` when present to understand fixed technical constraints. Treat explicit PM requirements as settled unless the refinement target exposes a conflict, stale requirement, UX infeasibility, or UX-owned trade-off. Do not infer user intent from architecture.
- If live `handoff.md` items target `ux-design.md` or `DESIGN.md`, resolve them in this refinement or explicitly defer, reject, supersede, or route them onward as appropriate.
- Durable global patterns (palette, typography, global component rules) → project-root `DESIGN.md`. Initiative-specific flows → `[plan_folder]/<initiative-name>/ux-design.md`.
- Before writing, re-check the sections being modified against `./resources/completion-criteria.yaml` privately.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows:
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method: symbol navigation for known entities, semantic search for behavioural or architectural concepts, AST-aware analysis for syntax-sensitive pattern matching.

Internal gap checklist — re-check privately for affected sections before the artifact:
- [ ] Information architecture: navigation model, page/view hierarchy, layout regions, data-where defined
- [ ] User flows: entry points, happy paths, error paths, exit conditions; edge cases (empty / loading / validation) called out
- [ ] Interaction model: UI elements, what they do, state they carry; modal/drawer/dialog lifecycles defined
- [ ] Visual language: palette, typography, spacing, motion (only when meaningful), component visual states (default / hover / active / disabled / focused / error)
- [ ] Empty states, error states, mobile layout, and accessibility considered
- [ ] Component library decision aligned with Lance's tech stack (or recommendation surfaced)

## Tasks

Progress:

- [ ] Step 1: Hydrate upstream inputs — read current PM artifacts and architecture constraints (see Additional Directives). Extract settled requirements, UX constraints, and what the change affects.
- [ ] Step 2: Identify refinement target — determine what has changed or is being challenged. If the user has not specified, ask one question. Surface any existing bounded assumptions, unresolved queue items, or stale promotion records before proceeding.
- [ ] Step 3: Brainstorm reconciliation — if a brainstorming session preceded this artifact, load it and cross-reference its ideas against the current `ux-design.md`. Identify ideas that were silently dropped — especially ideas about interaction feel, tone, personality, or "what should this feel like" that do not map cleanly to structural flows or screen layouts. Present findings to the user and ask whether any should be incorporated before proceeding.
- [ ] Step 4: Groundtruth — verify any new codebase reality relevant to the change. Check that existing patterns in `DESIGN.md` still constrain the refined design. Use code intelligence tools (see Additional Directives).
- [ ] Step 5: Probe — present what appears settled from PM artifacts, what technical constraints apply, what the change affects, which user-state hypotheses follow, and what UX decisions are newly required. Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count. Apply all Global Directives from the core skill. Elicit before modifying; write at a meaningful checkpoint. Do not silently absorb unresolved issues.
- [ ] Step 6: Write — re-check the modified sections against `completion-criteria.yaml` and the internal gap checklist (see Additional Directives) privately. Update `[plan_folder]/<initiative-name>/ux-design.md`. Update the `updated` frontmatter date. Preserve sections not being changed.
- [ ] Step 7: Distillation gate — do any refined decisions qualify for distillation to project-root `DESIGN.md`? Global interaction principles and visual language decisions only.
- [ ] Step 8: Register in context memory — confirm `ux-design.md` remains in `## Live` in `registry.md`. Move any superseded predecessor to `## Archived` if applicable.
- [ ] Step 9: Close — apply the Exit and Handoff format from the core skill.

## Definition of Done

- [ ] Brainstorming ideas reconciled (if applicable)
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not just preserved
- [ ] Relevant `handoff.md` items targeting UX-owned artifacts resolved, deferred, rejected, superseded, or routed onward appropriately
- [ ] Remaining user-owned ambiguity resolved in chat, escalated through `handoff.md` only when another owner must act, or handled as bounded assumptions when safe
- [ ] Updated `ux-design.md` written; `updated` date current
- [ ] `DESIGN.md` updated if distillation gate triggered
- [ ] `registry.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, queued or deferred governance items, next owner
