# UX-Design

Design the frontend experience for a new initiative. Produce observable, testable UX decisions — not visual preferences.

## Additional Context

Load in this order:
- Project-root `DESIGN.md` if it exists — your design must be consistent with established global UX patterns
- `[plan_folder]/_system/_rollup.md` if it exists
- `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
- `[plan_folder]/<initiative-name>/system-design.md` if it exists — technical constraints only; not a source of UX intent
- Confirm no `## Archived` entries or other initiative folders were loaded

If no `product-brief.md` or `prd.md` exists: probe for key user needs and requirements before proceeding. Entry at the UX stage is not permission to skip problem framing.

## Additional Norms

- Read `product-brief.md` and `prd.md` before asking UX questions. Read `system-design.md` when present to understand fixed technical constraints. Extract settled requirements, user journeys, priority boundaries, NFRs, documentation obligations, fixed component/library constraints, auth boundaries, data availability, and latency/platform limits. Do not reopen PM requirements as user choices unless the artifacts conflict, contradict existing UX patterns, or require a UX trade-off the PM artifacts did not decide. Do not infer user goals, flow priority, content hierarchy, or screen intent from backend shape.
- After reading PM artifacts, formulate a concise UX synthesis: what is settled, what user-state hypotheses follow, and which UX-only decisions remain. Ask only those remaining questions; do not invent alternatives merely to satisfy an option-presenting pattern.
- Durable global patterns (palette, typography, global component rules) → project-root `DESIGN.md`. Initiative-specific flows and screens → `[plan_folder]/<initiative-name>/ux-design.md`.
- If Lance has fixed a UI component library, design within its constraints. If unfixed, a recommendation here carries weight — Lance owns the final tech stack decision.
- Before writing, load `./resources/completion-criteria.yaml` and privately check each section against its `good_signal`, `weak_signal`, and `falsifiable` field.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows:
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method: symbol navigation for known entities, semantic search for behavioural or architectural concepts, AST-aware analysis for syntax-sensitive pattern matching.

Internal gap checklist — check privately before the artifact:
- [ ] Information architecture: navigation model, page/view hierarchy, layout regions, data-where defined
- [ ] User flows: entry points, happy paths, error paths, exit conditions; edge cases (empty / loading / validation) called out
- [ ] Interaction model: UI elements, what they do, state they carry; modal/drawer/dialog lifecycles defined
- [ ] Visual language: palette, typography, spacing, motion (only when meaningful), component visual states (default / hover / active / disabled / focused / error)
- [ ] Empty states, error states, mobile layout, and accessibility considered
- [ ] Component library decision aligned with Lance's tech stack (or recommendation surfaced)

## Tasks

Progress:

- [ ] Step 1: Hydrate upstream inputs — read PM artifacts and architecture constraints (see Additional Norms). Extract settled requirements, UX constraints, documentation obligations, and open UX decisions.
- [ ] Step 2: Groundtruth — verify the current state of the codebase and any existing global design system. Identify patterns that constrain or shape the new design. Use code intelligence tools (see Additional Norms) before falling back to grep/glob/read. Do not invent patterns that contradict established global UX.
- [ ] Step 3: Synthesize — summarize: what appears settled from PM artifacts, what technical constraints from architecture apply, what user-state hypotheses follow, what user-state decisions are missing, and what conflicts exist. Ask the smallest useful UX question before committing to an interaction model. Do not silently absorb unresolved issues into the artifact.
- [ ] Step 4: Elicit — before the first question, preview the queue: name the UX categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Then probe through each section of `assets/ux-design-template.md` sequentially. Apply all Global Norms from the core skill. Surface one ambiguity per turn unless questions are inter-related. Elicit before producing final designs; write at a meaningful checkpoint. Probe backward on: empty states, error states, loading states, mobile layout, and accessibility before closing.
- [ ] Step 5: Run the Pre-exit Checkpoint from the core skill — one offer, declinable in one word.
- [ ] Step 6: Write — check the internal gap checklist and `completion-criteria.yaml` privately. Resolve user-owned UX gaps through elicitation or `user-attention.md`. Route product or architecture source issues through `spec-patch-queue.md`. Write `[plan_folder]/<initiative-name>/ux-design.md` using `assets/ux-design-template.md`.
- [ ] Step 7: Distillation gate — do this initiative's decisions establish interaction principles, visual language decisions, or UX patterns that all future initiatives must conform to? If yes, distill those specific elements into project-root `DESIGN.md` using `assets/design-md-template.md` for creation, or preserve its existing structure for updates. Initiative-local flows, screen-specific states, and scoped interaction decisions do not qualify.
- [ ] Step 8: Register in context memory — open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `ux-design.md` (and `DESIGN.md` if updated) to `## Live`. Move any superseded predecessor to `## Archived`.
- [ ] Step 9: Gate check — walk the user through any remaining UX-domain ambiguity that still needs synchronous resolution. For each: explain the issue, present options, give a recommendation. If user input still remains, queue it in `user-attention.md`. If the issue belongs to architecture or product ownership, route it through `spec-patch-queue.md`. Do not preserve durable question sections in `ux-design.md`.
- [ ] Step 10: Close — apply the Exit and Handoff format from the core skill.

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
