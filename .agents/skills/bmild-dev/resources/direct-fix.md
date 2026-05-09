---
name: bmild-dev / direct-fix
description: "Ad hoc bug fix mode. Activated when broken behaviour is reported but no RCA, verification matrix item, or Slice is attached. Investigate before editing."
---

## Direct-Fix Mode

Investigate and fix a localized defect reported outside a tracked artifact. Reproduction comes before edits. If root cause remains uncertain after targeted investigation, stop and route to Rahat — do not continue coding.

1. **Entry** — Load in this order:
   - [ ] Error output, stack trace, failing test, or reproduction details from the message
   - [ ] Repo context relevant to the reported failure path
   - [ ] Local implementation files along the suspected code path
   - [ ] Repo contributor guide

   Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — in that case re-evaluate against the core mode detection lookup before proceeding.

2. **Pre-Edit** — Apply core Pre-Edit Discipline before writing any code.

3. **Investigate** — Before editing any file:
   - [ ] Reproduce the failure — via test, log, or code-path inspection
   - [ ] Identify root cause with evidence: failing assertion, stack trace line, logic error, incorrect assumption
   - [ ] Confirm the fix is localized — the change does not alter behaviour outside the reported failure

   If root cause is not clear after targeted investigation: stop. Route to Rahat with symptoms, hypotheses checked, evidence collected, and the next diagnostic question. Do not guess and do not edit.

4. **Execute** — Implement the smallest fix that resolves the confirmed root cause. Do not refactor adjacent code. Do not expand scope.

5. **Prove** — Run quality gates per the contributor guide. Add a regression test when practical. If not practical, record a manual reproduction and proof sequence that Rahat can re-run.

6. **Document** — Required when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`.

7. **Close** — Write a Dev note (`dev-note-<slug>.md`) when the fix changes externally visible behaviour, the root cause reveals something future specs or architecture should account for, or the fix creates follow-up work. A truly trivial local fix with no future relevance does not require a Dev note. When a Dev note is written: use `assets/dev-note-template.md`; place it under the relevant initiative folder, or `[plan_folder]/_system/` for genuinely global work; register it in the initiative's `_context.md` `## Live` section.

   No formal handoff is required unless a tracked QA or security artifact was implicated — in that case re-evaluate against Spec-Fix mode before closing. Apply the Exit and Handoff format from the core skill.

---

## Definition of Done
- [ ] Root cause confirmed with evidence before any edit, or escalation to Rahat recorded with full context
- [ ] Fix complete and scoped to confirmed root cause
- [ ] Regression test passing, or manual proof sequence recorded
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded (complete or `none`)
- [ ] Dev note written and registered when conditions above are met
- [ ] Close message: files changed, root cause summary, gates run, documentation impact, next owner if any
