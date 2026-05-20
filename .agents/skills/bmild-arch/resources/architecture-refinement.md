# Architecture-Refinement

Extend or update an existing `system-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

## Additional Context

Load in this order before beginning:

- Relevant ADRs in `[plan_folder]/adr/` if they exist
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/system-design.md` in full — this is the contract you are modifying
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md` for current requirements
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists — interaction, user-state, and screen contract inputs
- Confirm no `## Archived` entries or other initiative folders were loaded

## Additional Norms

**Code intelligence.** When verifying codebase reality, prefer available code intelligence capabilities over raw filesystem traversal, before falling back to grep/glob/read workflows:
- Symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Completion criteria check.** Load `./resources/completion-criteria.yaml` and privately re-check the sections being modified before updating `system-design.md`. Do not present this file to the user.

**Internal gap checklist.** Before writing the updated artifact, privately verify:

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

- [ ] Step 1: Hydrate upstream inputs — read current `product-brief.md`, `prd.md`, and `ux-design.md` when present. Treat explicit PM requirements and UX interaction/state contracts as settled unless the refinement target exposes a conflict, stale requirement, implementation impossibility, or architecture-owned trade-off.
- [ ] Step 2: Identify refinement target — determine what has changed or what is being challenged. If the user has not specified, ask one question. Surface any existing bounded assumptions, unresolved handoff items, or stale promotion records before proceeding.
- [ ] Step 3: Brainstorm reconciliation — if any brainstorming session preceded this artifact, load it and cross-reference its ideas against the current `system-design.md`. Identify ideas that were silently dropped — especially non-obvious technical approaches, cross-cutting concerns, or alternative architectures explored but not adopted. Present findings to the user and ask whether any should be reconsidered before proceeding.
- [ ] Step 4: Groundtruth — verify any new codebase reality relevant to the change. Check that the existing design still reflects the active runtime path — not deprecated or bypassed code.
- [ ] Step 5: Synthesize and probe — present what appears settled from PM and UX artifacts, what the change affects, what UX states imply for API/data/service boundaries, which architecture hypotheses follow, and what architecture decisions are newly required. Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Use compact option blocks only for genuine technical trade-offs. Do not silently absorb unresolved issues into the updated design.

  If live `handoff.md` items target `system-design.md` or an ADR-backed decision, resolve them in this refinement or explicitly defer, reject, supersede, or keep them open with a clear next owner as appropriate.

- [ ] Step 6: Write — check the internal gap checklist and `completion-criteria.yaml` privately on sections being modified. Update `[plan_folder]/<initiative-name>/system-design.md`. Update the `updated` frontmatter date. Use `assets/system-design-template.md` as a structural reference; preserve sections not being changed.
- [ ] Step 7: Distillation gate — do any refined decisions qualify for distillation to `[plan_folder]/adr/`? Apply the same gate as Architecture-Design mode: cross-initiative schema patterns, auth contracts, or shared infrastructure decisions only.
- [ ] Step 8: Register in context memory — confirm `system-design.md` remains in `## Live` in `registry.md`. Move any superseded predecessor to `## Archived` if a new version was created.
- [ ] Step 9: Close — apply the Exit and Handoff format from the core skill. Default `Next` to Sonia. If this refinement is for a named initiative that still lacks `ux-design.md`, route to Katrina instead so UX is not skipped before planning.

## Definition of Done

- [ ] Brainstorming ideas reconciled (if applicable)
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not just preserved
- [ ] All architecture decisions have observable implementation consequences
- [ ] Schema, API, service, dependency, and platform decisions are specific enough for Alex to implement without making architectural choices
- [ ] Relevant `handoff.md` items targeting architecture-owned artifacts resolved, deferred, rejected, superseded, or kept open with a clear next owner
- [ ] Remaining user-owned ambiguity resolved in chat or handled as bounded assumptions when safe
- [ ] Updated `system-design.md` written; `updated` date current
- [ ] ADRs updated if the distillation gate triggered
- [ ] `registry.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, queued or deferred governance items, next owner
