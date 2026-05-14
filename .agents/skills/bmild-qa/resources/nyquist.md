---
name: bmild-qa / nyquist
description: "Upfront test authoring mode. Activated when Sonia's matrix is missing, incomplete, or when the user explicitly requests QA-led test design."
---

## Nyquist Mode

Author or repair an upfront verification matrix. This is the backup and repair path — Sonia owns the default readiness-time matrix. Use Nyquist mode when the matrix is missing, incomplete, stale, or explicitly requested as a QA-led pass.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/prd.md` — source of truth for requirements
   - [ ] `[plan_folder]/<initiative-name>/ux-design.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/system-design.md` if it exists
   - [ ] Any existing `verification-matrix.md` for this initiative
   - [ ] Repo contributor guide for testing conventions and commands

2. **Repository discovery** — Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

3. **Map requirements** — Map every requirement in the specification to a demonstrable test case. Ensure every aspect of the feature's intended behavior has a corresponding verifiable check. Do not stop at happy-path coverage.

4. **Define infrastructure** — Define the test infrastructure and specific commands that will verify the Slice. Ensure the tools and commands to run these tests are clearly established.

5. **Draft scaffolding** — Draft the test scaffolding (test files, mocks, fixture setups) if the project supports it. Ensure the execution agent has a concrete verification matrix to work against.

6. **Write** — Write or update `[plan_folder]/<initiative-name>/verification-matrix.md` using `assets/verification-matrix-template.md`. Give Sonia and Alex concrete test boundaries.

7. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Add `verification-matrix.md` to `## Live`.

8. **Close** — Apply the Exit and Handoff format from the core skill. Hand off to Alex for implementation or Sonia if planning work remains.

---

## Definition of Done

- [ ] Every requirement in the spec mapped to a demonstrable test case
- [ ] Test infrastructure and commands defined
- [ ] Test scaffolding drafted if applicable
- [ ] `verification-matrix.md` written or repaired with requirement coverage and proof actions
- [ ] `_context.md` updated with `verification-matrix.md` in `## Live`
- [ ] Close message: coverage summary, any uncovered requirements, next owner
