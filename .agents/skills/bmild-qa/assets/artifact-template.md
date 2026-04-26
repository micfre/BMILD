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
author: bmild-qa
mode: nyquist
---

## Test Infrastructure
Commands and tools used to run tests.

## Requirement Coverage Matrix
| Requirement (spec ref) | Test Case | Type (unit/integration/e2e) | Status |
|---|---|---|---|
| Must Have 1: ... | ... | ... | draft |
| Must Have 2: ... | ... | ... | draft |

## Test Scaffolding
Files, mocks, fixture setups required.
```
