---
scope: <initiative-name> | _system
slug: <slug>
slice: <N>
severity: low | medium | high | critical
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: open | resolved
owner: Rahat
next_owner: Alex | Lance | Katrina | none
---

## Symptom

What was observed.

## Reproduction Steps

Exact steps to trigger the symptom.

## Hypotheses (breadth-first)

1. [Cause] — [why it produces this symptom] — Layer: [DB/Service/API/Frontend]
2. ...

**Ranked most likely:** [1–2 candidates and ranking rationale]

## Evidence

- Hypothesis N: [confirmed | rejected] — [instrumentation used and result]

## Root Cause

One sentence. Confirmed by evidence before handoff or QA-owned repair.

## Handoff / QA-Owned Repair

- Production fix needed: yes / no
- Next owner: Alex / Rahat / Lance / Katrina / none
- Required action: what must change and why
- QA-owned work completed: tests, matrix updates, RCA evidence, or none

## Regression Proof

Reference to the test added by Rahat, or the regression proof Alex must add or run.

## Closure Evidence

- Closed by: [commit / file refs / Slice notes / handoff target]
- Verification command: ...
- Result: pass / fail / blocked

## Governance Follow-Up

- Source-artifact update required: yes | no
- Queue path: none | `spec-patch-queue.md` | `user-attention.md`
- Notes: what must still be promoted by the owning persona, if applicable
