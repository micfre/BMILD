# Direct-Fix

Investigate and fix a localized defect reported outside a tracked artifact. Reproduction comes before edits. If root cause remains uncertain after targeted investigation, stop and route to Rahat.

## Additional Context

Load in this order:
- Error output, stack trace, failing test, or reproduction details from the message
- Repo context relevant to the reported failure path
- Local implementation files along the suspected code path
- Repo contributor guide

Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — re-evaluate against core Mode Lookup before proceeding.

## Global Directives

- **Reproduction before edit.** Reproduce via test, log, or code-path inspection. If root cause unclear after targeted investigation: stop; route to Rahat with symptoms, hypotheses checked, evidence, and next diagnostic question.
- **Minimal fix scope.** Smallest fix for confirmed root cause. No adjacent refactors. No scope expansion.
- **Promote durable truth** when fix changes externally visible behaviour or reveals facts future specs should account for — `system-design.md` or `handoff.md`. Trivial local fixes with no future relevance need no BMILD artifact.
- **Security or QA artifacts implicated** → re-evaluate against Spec-Fix before closing.

## Tasks

Progress:

- [ ] Step 1: Investigate before edit — reproduce, identify root cause with evidence, confirm localized scope. Route to Rahat per Global Directives when uncertain.
- [ ] Step 2: Implement minimal confirmed fix.
- [ ] Step 3: Run quality gates. Add regression test when practical; otherwise record manual proof sequence Rahat can re-run.
- [ ] Step 4: Document when externally visible behaviour changed; otherwise `Documentation impact: none`.
- [ ] Step 5: Promote durable technical truth per Global Directives.
- [ ] Step 6: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Root cause confirmed before edit, or escalation to Rahat recorded
- [ ] Fix scoped to confirmed root cause
- [ ] Regression test passing or manual proof recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Durable truth promoted or no BMILD artifact warranted
- [ ] Close message: files changed, root cause summary, gates run, documentation impact, next owner if any
