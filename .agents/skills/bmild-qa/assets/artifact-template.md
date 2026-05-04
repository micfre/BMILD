## RCA Artifact (diagnostic mode)

Write `[plan_folder]/<initiative-name>/rca-<slug>.md` for every new bug arising from a documented Slice or initiative.

Use `_system/rca-<slug>.md` only for genuinely global defects with no initiative, Slice, or initiative `_context.md` owner. If a Slice, initiative folder, or initiative `_context.md` is known, do not write RCA under `_system`.

```markdown
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
```

**File rules:**

- New bug from a documented Slice → new `rca-<slug>.md`
- Pre-existing tracked bug → update the existing file; do not create a duplicate
- Minor cosmetic / typo bugs → note inline in `slice-<N>.md`; no RCA file required
- Initiative evidence wins over global context when choosing the RCA folder

## Verification Matrix (Nyquist mode)

Write `[plan_folder]/<initiative-name>/verification-matrix.md` mapping every requirement to a demonstrable test case.

```markdown
---
scope: <initiative-name> | _system
created: YYYY-MM-DD
author: [user_name] + Rahat (QA)
mode: nyquist
status: draft | active | partially_implemented | verified | blocked
---

## Test Infrastructure
Commands and tools used to run tests.

## Requirement Coverage Matrix
- Requirement: Must Have 1 ...
  - Spec ref: ...
  - Covered by Slice: ...
  - Test case / verification action: ...
  - Type: unit / integration / e2e / manual
  - Status: draft / implemented / passed / failed / blocked
  - Created by: Sonia / Rahat
  - Implementation consumer: Alex
  - Verification owner: Rahat
  - Evidence: [test file, command, manual check, or pending]
  - Next owner: Alex / Rahat / Lance / Katrina / none
- Requirement: Must Have 2 ...
  - Spec ref: ...
  - Covered by Slice: ...
  - Test case / verification action: ...
  - Type: unit / integration / e2e / manual
  - Status: draft / implemented / passed / failed / blocked
  - Created by: Sonia / Rahat
  - Implementation consumer: Alex
  - Verification owner: Rahat
  - Evidence: [test file, command, manual check, or pending]
  - Next owner: Alex / Rahat / Lance / Katrina / none

## Test Scaffolding
Files, mocks, fixture setups required.
```
