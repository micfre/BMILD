# Spec-Fix

Implement a localized fix driven by a confirmed root cause from Rahat. Do not re-derive root cause — trust the diagnosis unless new evidence directly contradicts it. If contradicting evidence appears, stop and route back to Rahat rather than continuing.

## Additional Context

- Identify the entry artifact: `rca-<slug>.md` named in the message, a verification matrix item referenced, or a named Slice with bug signals.
- Load in this order:
  - The named `rca-<slug>.md` in full (primary entry artifact when present)
  - Relevant ADRs in `[plan_folder]/adr/` when the fix touches a durable cross-initiative technical decision
  - `[plan_folder]/rollup.md` if it exists
  - `[plan_folder]/<initiative>/registry.md`
  - Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
  - `slice-<N>.md` referenced by the RCA or message
  - Relevant sections of `verification-matrix.md`
  - `security-review-*.md` if a tracked security finding is implicated
  - Repo contributor guide

## Additional Norms

**Repository discovery.** Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.

- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Scope discipline.** Do not expand scope beyond what the RCA specifies. Rahat's confirmed root cause, evidence, and regression-proof spec drive the implementation. If the fix reveals a remaining contract defect or unanswered question outside Alex's authority, route it through `handoff.md` rather than a chat-only handoff.

## Tasks

Progress:

- [ ] Step 1: Apply core Craft Standards (Global Norms craft principles) before writing any code.
- [ ] Step 2: Implement the fix described in the RCA. If the RCA specifies a regression test, implement it exactly as described. If it does not and a regression test is practical, add one and reference it in artifact updates.
- [ ] Step 3: Run quality gates per the contributor guide. Run the regression test. Record any gate that could not be run and the reason.
- [ ] Step 4: Document when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`.
- [ ] Step 5: Update artifacts in this order:
  - `rca-<slug>.md` → add fix details and regression-test reference; set `next_owner` to Rahat
  - `verification-matrix.md` → relevant items `implemented` or `blocked`, never `passed`
  - `slice-<N>.md` (when fix is inside Slice scope) → append to Implementation Notes; do not change `qa_status`
  - `security-review-*.md` (when a tracked finding is implicated) → set to `fixed_pending_review`; set `next_owner` to Zach
- [ ] Step 6: Default handoff is Rahat for re-verification. Apply the Exit and Handoff format from the core skill.

## Definition of Done

- [ ] Fix complete per RCA specification, or exact blocker and next owner recorded
- [ ] Regression test implemented and passing, or manual proof recorded with reproduction steps
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded (complete or `none`)
- [ ] All artifacts updated with implementation status and evidence references
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions, next owner
