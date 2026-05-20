# Spec-Fix

Implement a localized fix driven by a confirmed root cause from an RCA, verification matrix item, or named Slice. Do not re-derive root cause unless new evidence directly contradicts the entry artifact. If contradicting evidence appears, stop and update the diagnosis rather than coding through it.

## Additional Context

Identify the entry artifact: `rca-<slug>.md` named in the message, a verification matrix item referenced, or a named Slice with bug signals. Load in this order:
- The named `rca-<slug>.md` in full (primary entry artifact when present)
- `[plan_folder]/adr/` entries relevant to the fix if they exist
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative>/registry.md`
- `[plan_folder]/<initiative>/context.md` if it exists
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

**Scope constraint.** Do not expand scope beyond what the entry artifact specifies. If the specified fix would exceed the RCA or Slice scope, route to Sonia or Alex with the evidence and stop.

## Tasks

Progress:

- [ ] Step 1: Confirm entry contract — confirm the diagnosis is supported by evidence in the entry artifact. If the root cause is not actually confirmed, switch to Diagnostic mode. If the specified fix would exceed the RCA or Slice scope, route to Sonia or Alex with the evidence and stop.
- [ ] Step 2: Execute — implement the minimal fix described by the RCA or verification finding. The confirmed root cause, evidence, and regression-proof spec drive the implementation. Do not expand scope beyond what the artifact specifies. If the RCA specifies a regression test, implement it exactly as described. If it does not and a regression test is practical, add one and reference it in artifact updates.
- [ ] Step 3: Prove — run quality gates per the contributor guide. Run the regression test. Record any gate that could not be run and the reason.
- [ ] Step 4: Document — required when externally visible behaviour, operational runbooks, setup instructions, or user help changed. Otherwise record `Documentation impact: none`. If the fix leaves a remaining contract defect or requires another owner to promote a resolution, route it through `handoff.md` rather than a chat-only note.
- [ ] Step 5: Update artifacts in this order:
  - `rca-<slug>.md` → add fix details and regression-test reference; set `next_owner` to Rahat for verification if additional independent verification is needed, otherwise `none`
  - `verification-matrix.md` → relevant items `implemented` or `passed` only when Rahat has run the named proof
  - `slice-<N>.md` (when fix is inside Slice scope) → append to Implementation Notes; update `qa_status` only when verification evidence supports it
  - `security-review-*.md` (when a tracked finding is implicated) → do not mark resolved; set next owner to Zach
- [ ] Step 6: Close — apply the Exit and Handoff format from the core skill. Include: files changed, gates run, artifact updates, documentation impact, user verification actions, and next owner.

## Definition of Done

- [ ] Fix complete per RCA or verification finding, or exact blocker and next owner recorded
- [ ] Regression test implemented and passing, or manual proof recorded with reproduction steps
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation impact recorded (complete or `none`)
- [ ] All artifacts updated with implementation and verification evidence references
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions, next owner
