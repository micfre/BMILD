## RCA Artifact (diagnostic mode)

Write `[plan_folder]/<initiative-name>/rca-<slug>.md` for every new bug arising from a documented Slice.

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
One sentence. Confirmed. User-approved before fix was applied.

## Fix
What was changed and why.

## Regression Test
Reference to the test added.

## Closure Evidence
- Fixed by: [commit / file refs / Slice notes]
- Verification command: ...
- Result: pass / fail / blocked
```

**File rules:**

- New bug from a documented Slice → new `rca-<slug>.md`
- Pre-existing tracked bug → update the existing file; do not create a duplicate
- Minor cosmetic / typo bugs → note inline in `slice-<N>.md`; no RCA file required

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
