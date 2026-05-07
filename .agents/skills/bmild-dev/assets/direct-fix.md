---
name: bmild-dev / direct-fix
description: "Ad hoc bug fix mode. Activated when broken behaviour is reported but no RCA, verification matrix item, or Slice is attached. Investigate before editing."
---

## Direct-Fix Mode

Investigate and fix a localized defect reported outside a tracked artifact. Reproduction comes before edits. If root cause remains uncertain after targeted investigation, stop and route to Rahat — do not continue coding.

---

## 1. Entry

Load in this order:

1. The error output, stack trace, failing test, or reproduction details provided in the message
2. Repo context relevant to the reported failure path
3. Local implementation files along the suspected code path
4. The repo contributor guide

Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — in that case re-evaluate against the core mode detection lookup before proceeding.

---

## 2. Pre-Edit

Apply core Pre-Edit Discipline before writing any code.

---

## 3. Investigate

Before editing any file:

1. Reproduce the failure — via test, log, or code-path inspection.
2. Identify the root cause with evidence: failing assertion, stack trace line, logic error, incorrect assumption.
3. Confirm the fix is localized — the change does not alter behaviour outside the reported failure.

If root cause is not clear after targeted investigation: stop. Route to Rahat with symptoms, hypotheses checked, evidence collected, and the next diagnostic question. Do not guess and do not edit.

---

## 4. Execute

Implement the smallest fix that resolves the confirmed root cause. Do not refactor adjacent code. Do not expand scope.

---

## 5. Prove

Run quality gates defined in the contributor guide. Add a regression test when practical. If a regression test is not practical, record a manual reproduction and proof sequence that Rahat can re-run.

---

## 6. Document

Documentation is required when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`.

---

## 7. Close

Write a Dev note (`dev-note-<slug>.md`) when:

- The fix changes externally visible behaviour
- The root cause reveals something future specs or architecture should account for
- The fix creates follow-up work

A truly trivial local fix with no future relevance does not require a Dev note.

When a Dev note is written: use `assets/artifact-template.md` for structure; place it under the relevant initiative folder, or `[plan_folder]/_system/` for genuinely global work; register it in the initiative's `_context.md` `## Live` section.

No formal handoff is required unless a tracked QA or security artifact was implicated — in that case re-evaluate against the Spec-Fix mode before closing.

Apply the Close and Handoff format from the core skill.

---

## Definition of Done

- Root cause confirmed with evidence before any edit was made, or escalation to Rahat recorded with full context.
- Fix is complete and scoped to the confirmed root cause.
- Regression test passing, or manual proof sequence recorded.
- Quality gates run per contributor guide, or unrun gates recorded with reason.
- Documentation impact recorded (complete or `none`).
- Dev note written and registered when conditions above are met.
- Close message lists: files changed, root cause summary, gates run, documentation impact, next owner if any.
