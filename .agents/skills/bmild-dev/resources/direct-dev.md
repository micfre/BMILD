# Direct-Dev

Implement bounded repo work outside a formal Slice. No Slice, spec, UX design, architecture design, or verification matrix is required.

## Additional Context

- Load repo context and the contributor guide.
- Load BMILD memory only when the request names an initiative, depends on documented behaviour, or might alter durable product or architecture understanding.
- If scope is not clear from the message, ask one question for the smallest concrete target before proceeding.

## Additional Norms

**Repository discovery.** Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.

- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Work classification.** Before implementing, classify the work:
- *Throwaway* — exploratory, disposable, not intended to persist after the session
- *Exploratory* — may inform a future spec; leaves reusable code or a documented finding
- *Durable* — changes production behaviour, leaves code that others will build on

Do not over-engineer toward a spec that does not yet exist.

## Tasks

Progress:

- [ ] Step 1: Apply core Craft Standards (Global Norms craft principles) before writing any code.
- [ ] Step 2: Implement the smallest coherent change that satisfies the request. Match existing repo patterns.
- [ ] Step 3: Run quality gates per the contributor guide. Add or update tests only when they prove the prototype, protect durable behaviour, or the user explicitly asked for tests.
- [ ] Step 4: Document only when durable behaviour changes or the user explicitly asks. Otherwise record `Documentation impact: none`.
- [ ] Step 5: Promote durable technical truth instead of writing a sidecar. When the work changes durable repo behaviour, leaves reusable code, reveals a fact that future specs should account for, or creates follow-up work: update the most appropriate governing artifact directly. For initiative-local technical truth, use `system-design.md`. If another owner must act, create or update `handoff.md`. If none apply and the work is throwaway with no future relevance, no BMILD memory artifact is required.
- [ ] Step 6: No formal handoff is required unless the work reveals a decision that belongs upstream — see the core Trigger-Condition Rules. Apply the Exit and Handoff format from the core skill.

## Definition of Done

- [ ] Implementation or prototype complete, or exact blocker and next owner recorded
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded (complete or `none`)
- [ ] Durable technical truth promoted into a governing artifact, or no BMILD memory artifact written because none was warranted
- [ ] Close message: files changed, gates run, documentation impact, next owner if any
