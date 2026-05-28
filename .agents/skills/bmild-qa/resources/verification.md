# Verification

Check test coverage and run quality gates on completed code. Lean workflow applies — switch to Diagnostic mode if a failure is found during verification.

## Additional Context

Load in this order:
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/context-map.md` if it is relevant
- `[plan_folder]/adr/` entries relevant to the verification target
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- The completed `slice-<N>.md` in full
- `prd.md` as the execution contract for verifying requirement coverage
- Relevant `verification-matrix.md`, `rca-*.md`, and `security-review-*.md` tied to the Slice
- Repo contributor guide (`AGENTS.md`, `CONTRIBUTING.md`) for testing conventions and commands

## Global Directives

- **Evidence before action.** Never recommend production changes until root cause is confirmed.
- **Proof discipline.** Verification matrix items pass only after you have run or reviewed the named proof. Implementation status alone is not proof.
- **Persist before handoff.** Any issue important enough to influence Alex's next action must be persisted before handoff. Chat-only defects do not exist for Alex's next fresh window.
- **Planning-artifact discipline.** Sonia-authored matrices are planning artifacts, not QA conclusions. Validate and revise them rather than treating them as already proven.
- **Handoff-artifact discipline.** `accepted` is pending until the target owner promotes the change into the governed source artifact.

## Routing heuristics

- *Expected proof missing / blocked / failed / newly satisfied* → update `verification-matrix.md`.
- *Issue local to the Slice, no RCA needed* → update `slice-<N>.md` Implementation Notes.
- *Root cause investigation needed, or documented Slice produced a new bug* → write or update `rca-<slug>.md` in the initiative folder.
- *Documentation missing, stale, or behaviour-inaccurate* → record verification finding with next owner Alex.
- *Regression evidence passes for an RCA* → mark RCA `resolved`. Not before.
- *Gate failure reveals a bug* → switch to Diagnostic mode.
- *Design-contract defect or another owner must promote a fix* → route through `handoff.md`.

**Quality gate format.** Check the contributor guide for exact commands:

```sh
<typecheck command>    # zero errors
<lint command>         # pass
<format check command> # pass
<test command>         # all affected tests pass
```

## Tasks

Progress:

- [ ] Step 1: Test coverage review — evaluate acceptance criteria against existing tests. Identify untested happy paths, error paths, and edge cases. Test observable behaviour, not internals. Verify documentation against implementation when docs were part of the spec. Check whether Alex changed matrix, RCA, or security statuses; verify evidence before closing them.
- [ ] Step 2: Quality gate verification — run each gate per contributor guide. Report which passed, which failed, and failure output. Apply Routing heuristics on failure.
- [ ] Step 3: Document verification findings — persist gaps per Routing heuristics. Do not hand off failure-path issues, missing integration coverage, or failed gates only in chat.
- [ ] Step 4: Update Slice status — `qa_status` → `verified` when passing; `failed` or `blocked` with next owner when not.
- [ ] Step 5: Register — confirm QA artifacts are in `## Live` in `registry.md`.
- [ ] Step 6: Close — apply Exit and Handoff from the core skill. If root cause requires design change, hand off to Lance or Katrina with confirmed root cause and a precise question.

## Definition of Done

- [ ] Test coverage reviewed against acceptance criteria; gaps identified and addressed or recorded
- [ ] Quality gates run and results reported; gate failures diagnosed
- [ ] Verification matrix and Slice status updated with evidence
- [ ] Issues affecting Alex's next action persisted before handoff
- [ ] Required documentation checked against implementation, or gap recorded with next owner Alex
- [ ] Close message: what passed, what failed, what is blocked, artifacts updated, next owner
