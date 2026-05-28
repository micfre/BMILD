# Direct-Fix

Investigate and fix a localized defect reported outside a tracked artifact. Reproduction and root-cause confirmation come before edits. If root cause remains uncertain after targeted investigation, switch to Diagnostic mode and stop before changing production code.

## Additional Context

Load in this order:
- Error output, stack trace, failing test, or reproduction details from the message
- Repo context relevant to the reported failure path
- Local implementation files along the suspected code path
- Repo contributor guide

Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — in that case re-evaluate against core Mode Lookup before proceeding.

## Global Directives

- **Evidence before action.** Confirm root cause with evidence before any edit.
- **Scope discipline.** Smallest fix resolving the confirmed root cause. No refactor of adjacent code. No scope expansion.
- **Initiative path rule.** When an initiative exists, place `rca-<slug>.md` under `[plan_folder]/<initiative-name>/` and register in `registry.md`.

## Routing heuristics

- *Root cause unclear after targeted investigation* → stop; switch to Diagnostic mode; record symptoms and next question.
- *Fix reveals product, UX, architecture, or security decision* → stop; route to owning persona with evidence.
- *Recurring, cross-system, initiative-tied, or non-trivial defect* → write `rca-<slug>.md` using `assets/rca-template.md` and register.

## Tasks

Progress:

- [ ] Step 1: Investigate before edit — reproduce or localize via test, stack trace, log, or code-path inspection. Confirm localized fix scope. Treat user signals as hypotheses.
- [ ] Step 2: Execute — minimal fix per Global Directives and Routing heuristics.
- [ ] Step 3: Prove — run quality gates per contributor guide. Add regression test when practical; otherwise record manual reproduction sequence.
- [ ] Step 4: Document — when externally visible behaviour, runbooks, setup, or user help changed; otherwise `Documentation impact: none`.
- [ ] Step 5: Persist when useful — RCA per Routing heuristics.
- [ ] Step 6: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Root cause confirmed with evidence before edit, or escalation recorded
- [ ] Fix scoped to confirmed root cause
- [ ] Regression test passing or manual proof recorded
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded
- [ ] RCA written and registered when cross-turn value exists
- [ ] Close message: files changed, root cause, gates, documentation impact, next owner
