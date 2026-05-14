---
name: bmild-dev / spec-fix
description: "Planned bug fix mode. Activated when a fix is attached to a named RCA, verification matrix item, or Slice. Rahat's confirmed diagnosis is the entry artifact."
---

## Spec-Fix Mode

Implement a localized fix driven by a confirmed root cause from Rahat. Do not re-derive root cause — trust the diagnosis unless new evidence directly contradicts it. If contradicting evidence appears, stop and route back to Rahat rather than continuing.

1. **Entry** — Identify the entry artifact: `rca-<slug>.md` named in the message, a verification matrix item referenced, or a named Slice with bug signals. Load in this order:
   - [ ] The named `rca-<slug>.md` in full (primary entry artifact when present)
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative>/_context.md`
   - [ ] Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
   - [ ] `slice-<N>.md` referenced by the RCA or message
   - [ ] Relevant sections of `verification-matrix.md`
   - [ ] `security-review-*.md` if a tracked security finding is implicated
   - [ ] Repo contributor guide

2. **Repository discovery** — Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

3. **Pre-Edit** — Apply core Craft Standards (Pre-Edit principles) before writing any code.

4. **Execute** — Implement the fix described in the RCA. Rahat's confirmed root cause, evidence, and regression-proof spec drive the implementation — do not expand scope beyond what the RCA specifies. If the RCA specifies a regression test, implement it exactly as described. If it does not and a regression test is practical, add one and reference it in artifact updates.

5. **Prove** — Run quality gates per the contributor guide. Run the regression test. Record any gate that could not be run and the reason.

6. **Document** — Required when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`.

   If the fix reveals a remaining contract defect or unanswered question outside Alex's authority, route it through `spec-patch-queue.md` or `user-attention.md` rather than a chat-only handoff.

7. **Close** — Update artifacts in this order:
   - [ ] `rca-<slug>.md` → add fix details and regression-test reference; set `next_owner` to Rahat
   - [ ] `verification-matrix.md` → relevant items `implemented` or `blocked`, never `passed`
   - [ ] `slice-<N>.md` (when fix is inside Slice scope) → append to Implementation Notes; do not change `qa_status`
   - [ ] `security-review-*.md` (when a tracked finding is implicated) → set to `fixed_pending_review`; set `next_owner` to Zach

   Default handoff: **Rahat** for re-verification. Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] Fix complete per RCA specification, or exact blocker and next owner recorded
- [ ] Regression test implemented and passing, or manual proof recorded with reproduction steps
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded (complete or `none`)
- [ ] All artifacts updated with implementation status and evidence references
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions, next owner
