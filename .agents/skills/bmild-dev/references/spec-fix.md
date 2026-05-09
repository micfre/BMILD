---
name: bmild-dev / spec-fix
description: "Planned bug fix mode. Activated when a fix is attached to a named RCA, verification matrix item, or Slice. Rahat's confirmed diagnosis is the entry artifact."
---

## Spec-Fix Mode

Implement a localized fix driven by a confirmed root cause from Rahat. Do not re-derive root cause — trust the diagnosis unless new evidence directly contradicts it. If new contradicting evidence appears, stop and route back to Rahat rather than continuing.

---

## 1. Entry

Identify the entry artifact — one of:

- `rca-<slug>.md` named in the message
- A verification matrix item referenced in the message
- A named Slice with bug signals

Load in this order:

1. The named `rca-<slug>.md` in full (primary entry artifact when present)
2. `plans/ARCHITECTURE.md` if it exists
3. `plans/_rollup.md` if it exists
4. `[plan_folder]/<initiative>/_context.md`
5. Every `## Live` entry relevant to the named Slice or initiative — do not load `## Archived` entries
6. `slice-<N>.md` referenced by the RCA or message
7. Relevant sections of `verification-matrix.md`
8. `security-review-*.md` if a tracked security finding is implicated
9. The repo contributor guide

---

## 2. Pre-Edit

Apply core Pre-Edit Discipline before writing any code.

---

## 3. Execute

Implement the fix described in the RCA. Rahat's confirmed root cause, evidence, and regression-proof spec drive the implementation — do not expand scope beyond what the RCA specifies.

If the RCA specifies a regression test, implement it exactly as described. If it does not specify one and a regression test is practical, add one and reference it in the artifact updates below.

---

## 4. Prove

Run quality gates defined in the contributor guide. Run the regression test. Record any gate that could not be run and the reason.

---

## 5. Document

Documentation is required when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`.

---

## 6. Close

Update artifacts in this order:

- `rca-<slug>.md` — add fix details and regression-test reference; set `next_owner` to Rahat
- `verification-matrix.md` — set relevant items to `implemented` or `blocked`, never `passed`
- `slice-<N>.md` (when the fix is inside a Slice's scope) — append to Implementation Notes; do not change `qa_status`, Rahat owns that on re-verification
- `security-review-*.md` (when a tracked finding is implicated) — set relevant findings to `fixed_pending_review`, never `resolved`; set `next_owner` to Zach

Default handoff: **Rahat** for re-verification.

Apply the Close and Handoff format from the core skill.

---

## Definition of Done

- Fix is complete per the RCA specification, or the exact blocker and next owner are recorded.
- Regression test implemented and passing, or manual proof recorded with reproduction steps.
- Quality gates run per contributor guide, or unrun gates recorded with reason.
- Documentation impact recorded (complete or `none`).
- All artifacts above updated with implementation status and evidence references.
- Close message lists: files changed, gates run, artifact updates, documentation impact, user verification actions with pass criteria, next owner.
