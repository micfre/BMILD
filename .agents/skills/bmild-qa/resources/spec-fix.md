# Spec-Fix

Implement a localized fix driven by a confirmed root cause from an RCA, verification matrix item, or named Slice. Do not re-derive root cause unless new evidence directly contradicts the entry artifact.

## Additional Context

Identify the entry artifact: `rca-<slug>.md`, a verification matrix item, or a named Slice with bug signals. Load in this order:
- The named `rca-<slug>.md` in full when present
- `[plan_folder]/adr/` entries relevant to the fix if they exist
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative>/registry.md`
- `[plan_folder]/<initiative>/context.md` if it exists
- Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
- `slice-<N>.md` referenced by the RCA or message
- Relevant sections of `verification-matrix.md`
- `security-review-*.md` if a tracked security finding is implicated
- Repo contributor guide

## Global Directives

- **Evidence before action.** Trust the entry artifact unless new evidence contradicts it; if contradicted, stop and update diagnosis.
- **Scope discipline.** Do not expand beyond what the entry artifact specifies. If fix would exceed scope, route to Sonia or Alex with evidence and stop.
- **Proof discipline.** Matrix items → `implemented` or `passed` only after named proof is run.

## Routing heuristics

- *Root cause not actually confirmed in entry artifact* → switch to Diagnostic mode.
- *Fix exceeds RCA or Slice scope* → route to Sonia or Alex; stop.
- *Remaining contract defect or another owner must promote* → route through `handoff.md`.
- *Tracked security finding implicated* → do not mark resolved; set next owner Zach.

## Tasks

Progress:

- [ ] Step 1: Confirm entry contract per Global Directives and Routing heuristics.
- [ ] Step 2: Execute — minimal fix per artifact. Implement regression test exactly as specified, or add one when practical.
- [ ] Step 3: Prove — quality gates and regression test; record any gate not run and why.
- [ ] Step 4: Document — when externally visible behaviour changed; otherwise `Documentation impact: none`.
- [ ] Step 5: Update artifacts in order:
  - `rca-<slug>.md` → fix details and regression reference; `next_owner` Rahat if independent verification needed, else `none`
  - `verification-matrix.md` → status updates only with proof evidence
  - `slice-<N>.md` → Implementation Notes; `qa_status` only when evidence supports
  - `security-review-*.md` → do not mark resolved; next owner Zach
- [ ] Step 6: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Fix complete per entry artifact, or exact blocker and next owner recorded
- [ ] Regression test passing or manual proof recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Artifacts updated with implementation and verification references
- [ ] Close message: files changed, gates, artifact updates, documentation impact, next owner
