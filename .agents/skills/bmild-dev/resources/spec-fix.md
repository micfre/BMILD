# Spec-Fix

Implement a localized fix driven by a confirmed root cause from Rahat. Do not re-derive root cause unless new evidence directly contradicts the entry artifact.

## Additional Context

Identify entry artifact: `rca-<slug>.md`, verification matrix item, or named Slice with bug signals. Load in this order:
- Named `rca-<slug>.md` in full when present
- Relevant ADRs in `[plan_folder]/adr/` when fix touches durable cross-initiative decisions
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative>/registry.md`
- Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
- `slice-<N>.md` referenced by RCA or message
- Relevant sections of `verification-matrix.md`
- `security-review-*.md` if tracked security finding implicated
- Repo contributor guide
- Project-root `DESIGN.md` if it exists — honor global UX patterns when the fix alters a user-visible surface
- `handoff.md` when Alex-owned items exist

## Global Directives

- **Trust Rahat's diagnosis** unless new evidence contradicts — then stop and route back to Rahat.
- **Ground findings in code.** Grep it, cite file-path precision, and finish with proof; use those as working vocabulary, not ritual.
- **Scope discipline.** Fix only what the entry artifact specifies. Route remaining contract defects via `handoff.md`.
- **Verification matrix.** Mark items `implemented` or `blocked` with evidence — never `passed`.
- **Do not mark security findings resolved** — set `fixed_pending_review`; `next_owner` Zach.

## Tasks

Progress:

- [ ] Step 1: Confirm entry contract. If root cause not confirmed in artifact, route to Rahat. If fix exceeds scope, route to Sonia with evidence.
- [ ] Step 2: Implement fix per artifact. Implement regression test exactly as specified, or add one when practical.
- [ ] Step 3: Run quality gates and regression test. Record gates not run and why.
- [ ] Step 4: Document when externally visible behaviour changed; otherwise `Documentation impact: none`.
- [ ] Step 5: Update artifacts:
  - `rca-<slug>.md` → fix details, regression reference; `next_owner` Rahat
  - `verification-matrix.md` → `implemented` or `blocked`, never `passed`
  - `slice-<N>.md` when in Slice scope → Implementation Notes; do not change `qa_status`
  - `security-review-*.md` when implicated → `fixed_pending_review`; `next_owner` Zach
  - Resolve Alex-owned `handoff.md` items
- [ ] Step 6: Close — apply Exit and Handoff from the core skill. Default `Next`: Rahat for re-verification.

## Definition of Done

- [ ] Fix complete per entry artifact, or exact blocker and next owner recorded
- [ ] Regression test passing or manual proof recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Artifacts updated with implementation and evidence references
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions, next owner
