# Direct-Fix

Investigate and fix a localized defect reported outside a tracked artifact. Reproduction comes before edits. If root cause remains uncertain after targeted investigation, stop and route to Rahat — do not continue coding.

## Additional Context

- Load in this order:
  - Error output, stack trace, failing test, or reproduction details from the message
  - Repo context relevant to the reported failure path
  - Local implementation files along the suspected code path
  - Repo contributor guide
- Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — in that case re-evaluate against the core Mode Lookup before proceeding.

## Additional Directives

**Repository discovery.** Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.

- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Reproduction discipline.** Reproduce the failure before editing. If root cause is not clear after targeted investigation: stop. Route to Rahat with symptoms, hypotheses checked, evidence collected, and the next diagnostic question. Do not guess and do not edit.

## Tasks

Progress:

- [ ] Step 1: Apply core Global Directives before writing any code.
- [ ] Step 2: Investigate before editing any file — reproduce the failure via test, log, or code-path inspection; identify root cause with evidence (failing assertion, stack trace line, logic error, incorrect assumption); confirm the fix is localized and does not alter behaviour outside the reported failure. If root cause is not clear after targeted investigation, stop and route to Rahat.
- [ ] Step 3: Implement the smallest fix that resolves the confirmed root cause. Do not refactor adjacent code. Do not expand scope.
- [ ] Step 4: Run quality gates per the contributor guide. Add a regression test when practical. If not practical, record a manual reproduction and proof sequence that Rahat can re-run.
- [ ] Step 5: Document when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`.
- [ ] Step 6: Promote durable technical truth instead of writing a sidecar. When the fix changes externally visible behaviour, the root cause reveals something future specs or architecture should account for, or the fix creates follow-up work: update the most appropriate governing artifact directly. For initiative-local technical truth, use `system-design.md`. If another owner must act, create or update `handoff.md`. A truly trivial local fix with no future relevance does not require a BMILD memory artifact.
- [ ] Step 7: No formal handoff is required unless a tracked QA or security artifact was implicated — in that case re-evaluate against Spec-Fix mode before closing. Apply the Exit and Handoff format from the core skill.

## Definition of Done

- [ ] Root cause confirmed with evidence before any edit, or escalation to Rahat recorded with full context
- [ ] Fix complete and scoped to confirmed root cause
- [ ] Regression test passing, or manual proof sequence recorded
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded (complete or `none`)
- [ ] Durable technical truth promoted into a governing artifact, or no BMILD memory artifact written because none was warranted
- [ ] Close message: files changed, root cause summary, gates run, documentation impact, next owner if any
