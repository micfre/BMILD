# Architecture-Design

Design the system for a new initiative. Produce concrete, implementable contracts — not high-level diagrams.

## Additional Context

Load in this order before beginning:

- `[plan_folder]/ARCHITECTURE.md` if it exists — your design must extend it, never contradict it
- `[plan_folder]/_system/_rollup.md` if it exists
- `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` — primary design inputs
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists — interaction, user-state, and screen contract inputs
- Confirm no `## Archived` entries or other initiative folders were loaded

If no `product-brief.md` or `prd.md` exists: probe for key requirements before proceeding. Entry at the architecture stage is not permission to skip problem framing.

## Additional Norms

**Code intelligence.** Before proposing architecture, prefer available code intelligence capabilities over raw filesystem traversal, before falling back to grep/glob/read workflows:
- Symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Completion criteria check.** Load `./resources/completion-criteria.yaml` and privately check each section against its `good_signal`, `weak_signal`, and `falsifiable` field before writing `system-design.md`. Do not present this file to the user. Route discrete user input to `user-attention.md`, source defects or cross-artifact conflicts to `spec-patch-queue.md`, and use bounded assumptions only when low-risk and reversible.

**Internal gap checklist.** Before writing the artifact, privately verify:

- [ ] Tech stack specified (or confirmed unchanged); UI component library named
- [ ] Database schema column-level: table, columns, types, nullability, defaults, PKs/FKs, indexes, constraints, migration intent
- [ ] API contracts: method, path, request (path/query/body), response (status codes + bodies), error codes, authn/authz
- [ ] Service & component contracts: signatures, parameters, return types, thrown errors; queue/event shapes; third-party integration contracts
- [ ] Deployment topology and environment parity considered
- [ ] Observability: logs, metrics, traces, alerting hooks
- [ ] Failure modes and degradation behaviour
- [ ] Data migration safety and rollback path
- [ ] Rate or cost ceilings on new external dependencies or infrastructure

## Tasks

Progress:

- [ ] Step 1: Hydrate upstream inputs — read `product-brief.md`, `prd.md`, and `ux-design.md` when present. Extract settled requirements, constraints, NFRs, documentation obligations, user-state contracts, information timing, permissions, and UX proof states. Do not reopen these as user choices unless the artifacts conflict, contradict the codebase, or require an architecture trade-off the upstream artifacts did not decide.
- [ ] Step 2: Groundtruth — before proposing architecture, scan the file tree and read relevant implementation files. Identify any existing code, schemas, or API contracts that constrain or contradict the proposed design. Do not invent greenfield solutions in a brownfield environment.
- [ ] Step 3: Synthesize — before writing anything, summarize: what appears settled from PM and UX artifacts, what UX states imply for API/data/service boundaries, what architecture hypotheses follow, what conflicts, and what needs a decision. Present findings to the user. Name any apparent gaps or contract mismatches. Ask the smallest useful architecture question before committing to a design direction. Do not silently absorb an unresolved issue into `system-design.md`.
- [ ] Step 4: Elicit — before the first question, preview the queue: name the architecture categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Then probe through each section of `assets/system-design-template.md` sequentially. Use compact option blocks only for genuine technical trade-offs. Surface one ambiguity per turn unless questions are inter-related.

  If user input is still required after the session, create or update `[plan_folder]/<initiative-name>/user-attention.md` using `.agents/skills/bmild-pm/assets/user-attention-template.md`. If the issue belongs to another owned artifact or reflects a source defect/conflict, create or update `[plan_folder]/<initiative-name>/spec-patch-queue.md` using `.agents/skills/bmild-pm/assets/spec-patch-queue-template.md`. Record only low-risk, reversible bounded assumptions inside `system-design.md`.

- [ ] Step 5: Run the Pre-exit Checkpoint from the core skill before writing the system design.
- [ ] Step 6: Write — check the internal gap checklist and `completion-criteria.yaml` privately. Write `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`.
- [ ] Step 7: Distillation gate — does this initiative's `system-design.md` contain decisions — schema columns, auth patterns, service contracts, shared infrastructure — that future unrelated initiatives must build against? If yes, distill those specific decisions into `[plan_folder]/ARCHITECTURE.md` using `assets/architecture-template.md`. Local endpoint shapes, initiative-specific data models, and implementation choices do not qualify.
- [ ] Step 8: Register in context memory — open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `system-design.md` to `## Live`. Move any superseded predecessor to `## Archived`.
- [ ] Step 9: Gate check — walk the user through any remaining architecture-domain ambiguity that still needs synchronous resolution. For each: explain the issue, present options, give a recommendation. If user input still remains, queue in `user-attention.md`. If the issue belongs to product or UX ownership, route through `spec-patch-queue.md`. Do not preserve durable question sections in `system-design.md`.
- [ ] Step 10: Close — apply the Exit and Handoff format from the core skill. Default `Next` to Sonia. If this is a named initiative and `ux-design.md` still does not exist, route to Katrina instead so UX is not skipped before planning.

## Definition of Done

- [ ] Groundtruthing findings surfaced before artifact authoring
- [ ] All architecture decisions have observable implementation consequences
- [ ] Schema, API, service, dependency, and platform decisions are specific enough for Alex to implement without making architectural choices
- [ ] `completion-criteria.yaml` privately checked before writing
- [ ] `system-design.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `ARCHITECTURE.md` updated if distillation gate triggered
- [ ] `_context.md` updated with `system-design.md` in `## Live`
- [ ] Remaining ambiguity routed through `user-attention.md`, `spec-patch-queue.md`, or bounded assumptions instead of embedded question sections
- [ ] Close message: key decisions, trade-offs accepted, queued or deferred governance items, next owner
