---
name: bmild-qa / verification
description: "Verification mode. Activated when checking a completed Slice or running quality gates. Lean workflow — switch to Diagnostic mode if a failure is found."
---

## Verification Mode

Check test coverage and run quality gates on completed code. Lean workflow applies — switch to Diagnostic mode if a failure is found during verification.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] The completed `slice-<N>.md` in full
   - [ ] `prd.md` as the execution contract for verifying requirement coverage
   - [ ] Relevant `verification-matrix.md`, `rca-*.md`, and `security-review-*.md` tied to the Slice
   - [ ] Repo contributor guide (`AGENTS.md`, `CONTRIBUTING.md`) for testing conventions and commands

2. **Test coverage review** — Evaluate the completed Slice's acceptance criteria against existing tests:
   - [ ] Identify untested happy paths, untested error paths, and untested edge cases
   - [ ] Write or recommend tests for identified gaps
   - [ ] Test observable behaviour, not internal implementation details
   - [ ] Verify required documentation against observable implementation behaviour when documentation was part of the spec

   Check whether Alex changed any relevant matrix, RCA, or security statuses; verify the evidence before closing them.

3. **Quality gate verification** — Check the contributor guide for exact commands. Run and report on each:

   ```sh
   <typecheck command>    # zero errors
   <lint command>         # pass
   <format check command> # pass
   <test command>         # all affected tests pass
   ```

   Report clearly: which passed, which failed, and the failure output. If a gate failure reveals a bug, switch to Diagnostic mode.

4. **Document verification findings** — For any gap or failure that matters to the Slice's acceptance criteria or verification matrix:
   - [ ] Update `verification-matrix.md` when expected proof is missing, blocked, failed, or newly satisfied
   - [ ] Update `slice-<N>.md` Implementation Notes when the issue is local to the Slice
   - [ ] Write or update `rca-<slug>.md` when a root cause investigation is needed

   Do not hand off a failure-path issue, missing integration coverage, or failed gate only in chat.

5. **Update Slice status** — When the Slice passes verification: update `slice-<N>.md` `qa_status` to `verified`. When verification fails or is blocked: update `qa_status` to `failed` or `blocked` and record the next owner.

6. **Register in context memory** — If any QA artifacts were written or updated, confirm they are in `## Live` in `_context.md`.

7. **Close** — Apply the Exit and Handoff format from the core skill. If root cause requires a design change, hand off to Lance or Katrina with the confirmed root cause and a precise question.

---

## Definition of Done

- [ ] Test coverage reviewed against acceptance criteria; gaps identified and addressed or recorded
- [ ] Quality gates run and results reported; gate failures diagnosed
- [ ] Verification matrix and Slice status updated with evidence
- [ ] Any issue important enough to affect Alex's next action persisted before handoff
- [ ] Required documentation checked against implementation, or gap recorded with next owner Alex
- [ ] Close message: what passed, what failed, what is blocked, artifacts updated, next owner
