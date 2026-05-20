# Verification

Check test coverage and run quality gates on completed code. Lean workflow applies — switch to Diagnostic mode if a failure is found during verification.

## Additional Context

Load in this order:
- `[plan_folder]/CHARTER.md` if it exists
- `[plan_folder]/ARCHITECTURE.md` if it exists
- `[plan_folder]/_system/_rollup.md` if it exists
- `[plan_folder]/<initiative-name>/_context.md`
- The completed `slice-<N>.md` in full
- `prd.md` as the execution contract for verifying requirement coverage
- Relevant `verification-matrix.md`, `rca-*.md`, and `security-review-*.md` tied to the Slice
- Repo contributor guide (`AGENTS.md`, `CONTRIBUTING.md`) for testing conventions and commands

## Additional Norms

**Repository discovery.** Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Quality gate format.** Check the contributor guide for exact commands. Report clearly: which passed, which failed, and the failure output. If a gate failure reveals a bug, switch to Diagnostic mode.

```sh
<typecheck command>    # zero errors
<lint command>         # pass
<format check command> # pass
<test command>         # all affected tests pass
```

## Tasks

Progress:

- [ ] Step 1: Test coverage review — evaluate the completed Slice's acceptance criteria against existing tests. Identify untested happy paths, untested error paths, and untested edge cases. Write or recommend tests for identified gaps. Test observable behaviour, not internal implementation details. Verify required documentation against observable implementation behaviour when documentation was part of the spec. Check whether Alex changed any relevant matrix, RCA, or security statuses; verify the evidence before closing them.
- [ ] Step 2: Quality gate verification — run each gate per the contributor guide (see Additional Norms for format). Report which passed, which failed, and the failure output. If a gate failure reveals a bug, switch to Diagnostic mode.
- [ ] Step 3: Document verification findings — for any gap or failure that matters to the Slice's acceptance criteria or verification matrix: update `verification-matrix.md` when expected proof is missing, blocked, failed, or newly satisfied; update `slice-<N>.md` Implementation Notes when the issue is local to the Slice; write or update `rca-<slug>.md` when a root cause investigation is needed. If verification reveals a design-contract defect or still-unpromoted user answer, route it through `spec-patch-queue.md` or `user-attention.md`. Do not treat queue status alone as verification closure. Do not hand off a failure-path issue, missing integration coverage, or failed gate only in chat.
- [ ] Step 4: Update Slice status — when the Slice passes verification: update `slice-<N>.md` `qa_status` to `verified`. When verification fails or is blocked: update `qa_status` to `failed` or `blocked` and record the next owner.
- [ ] Step 5: Register in context memory — if any QA artifacts were written or updated, confirm they are in `## Live` in `_context.md`.
- [ ] Step 6: Close — apply the Exit and Handoff format from the core skill. If root cause requires a design change, hand off to Lance or Katrina with the confirmed root cause and a precise question.

## Definition of Done

- [ ] Test coverage reviewed against acceptance criteria; gaps identified and addressed or recorded
- [ ] Quality gates run and results reported; gate failures diagnosed
- [ ] Verification matrix and Slice status updated with evidence
- [ ] Any issue important enough to affect Alex's next action persisted before handoff
- [ ] Required documentation checked against implementation, or gap recorded with next owner Alex
- [ ] Close message: what passed, what failed, what is blocked, artifacts updated, next owner
