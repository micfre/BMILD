---
name: bmild-qa / direct-fix
description: "Ad hoc QA repair mode. Activated when broken behaviour is reported and Rahat is expected to continue through a localized fix without a named RCA, verification matrix item, or Slice."
---

## Direct-Fix Mode

Investigate and fix a localized defect reported outside a tracked artifact. Reproduction and root-cause confirmation come before edits. If root cause remains uncertain after targeted investigation, switch to Diagnostic mode and stop before changing production code.

1. **Entry** — Load in this order:
   - [ ] Error output, stack trace, failing test, or reproduction details from the message
   - [ ] Repo context relevant to the reported failure path
   - [ ] Local implementation files along the suspected code path
   - [ ] Repo contributor guide

   Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — in that case re-evaluate against the core mode detection lookup before proceeding.

2. **Repository discovery** — Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

3. **Investigate before edit** — Before editing any file:
   - [ ] Reproduce or localize the failure through a test, stack trace, log, or code-path inspection
   - [ ] Identify root cause with evidence: failing assertion, stack trace line, logic error, contract drift, or incorrect assumption
   - [ ] Confirm the fix is localized and does not alter behaviour outside the reported failure
   - [ ] Treat user-provided signals as hypotheses, not evidence

   If root cause is not clear after targeted investigation: stop. Record symptoms, hypotheses checked, evidence collected, and the next diagnostic question.

4. **Execute** — Implement the smallest fix that resolves the confirmed root cause. Do not refactor adjacent code. Do not expand scope. If the fix reveals a product, UX, architecture, or security decision, stop and route to the owning persona with evidence.

5. **Prove** — Run quality gates per the contributor guide. Add a regression test when practical. If not practical, record a manual reproduction and proof sequence that another agent can re-run.

6. **Document** — Required when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`.

7. **Persist when useful** — Write or update `rca-<slug>.md` when the defect is recurring, cross-system, tied to an initiative, required for future verification, or non-trivial enough that chat memory would lose important context. A truly trivial local fix with no future relevance does not require a new RCA. If an RCA is written: use `assets/rca-template.md`; place it under the relevant initiative folder, or `[plan_folder]/_system/` for genuinely global work; register it in the relevant `_context.md` `## Live` section.

8. **Close** — Apply the Exit and Handoff format from the core skill. Close with root cause, files changed, proof run, artifact updates, documentation impact, and next owner if any.

---

## Definition of Done

- [ ] Root cause confirmed with evidence before any edit, or escalation recorded with full context
- [ ] Fix complete and scoped to confirmed root cause
- [ ] Regression test passing, or manual proof sequence recorded
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded (complete or `none`)
- [ ] RCA written and registered when cross-turn value exists
- [ ] Close message: files changed, root cause summary, gates run, documentation impact, next owner if any
