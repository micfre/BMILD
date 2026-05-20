# Spec-Dev

Implement a well-defined Slice inside a documented initiative against a complete design contract.

## Additional Context

- Confirm `slice-<N>.md` is present at `[plan_folder]/<initiative>/slice-<N>.md`. If missing, flag it and operate at reduced fidelity: work from available contracts, note what you are inferring, and flag what is missing.
- Load in this order:
  - `[plan_folder]/CHARTER.md` if it exists
  - `[plan_folder]/ARCHITECTURE.md` if it exists
  - `[plan_folder]/_system/_rollup.md` if it exists
  - `[plan_folder]/<initiative>/_context.md`
  - Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
  - `slice-<N>.md` in full
  - Relevant sections of `verification-matrix.md` when present
  - Design contracts referenced by the Slice
  - Repo contributor guide (`AGENTS.md`, `CONTRIBUTING.md`, or equivalent)

## Additional Norms

**Repository discovery.** Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.

- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Contract discipline.** Do not resolve a contract gap by inference. If a genuine contract is missing or ambiguous, route to Sonia with one precise question. When `verification-matrix.md` is present, treat it as a binding QA contract: mark relevant items `implemented` with evidence references; never mark them `passed` — that belongs to Rahat.

## Tasks

Progress:

- [ ] Step 1: Apply core Craft Standards (Global Norms craft principles) before writing any code.
- [ ] Step 2: Work through acceptance criteria one by one, checking each off as you complete it. Honor every design contract referenced by the Slice. If execution exposes a contract defect or missing answer outside Alex's authority, create or update `[plan_folder]/<initiative>/spec-patch-queue.md` or `[plan_folder]/<initiative>/user-attention.md` instead of leaving durable guidance only in `slice-<N>.md`.
- [ ] Step 3: Run quality gates per the contributor guide. Record any gate that could not be run and the reason.
- [ ] Step 4: Write or update documentation required by the spec, Slice, or contributor guide — including README, AGENTS/CONTRIBUTING, runbooks, release notes, and user-facing help. Name any deferred doc item with the change required and next owner.
- [ ] Step 5: Update artifacts in this order:
  - `slice-<N>.md` → status `ready-for-review`, AC checked off, Implementation Notes appended, QA/Security Follow-up updated
  - `slices.md` → Slice status `ready-for-review`
  - `verification-matrix.md` → relevant items `implemented` or `blocked`, never `passed`
  - `_context.md` → move `slice-<N>.md` to `## Archived`; add new live docs to `## Live`
  - `rca-<slug>.md` if implementing fixes → add fix details and regression-test reference; set `next_owner` to Rahat
  - `security-review-*.md` if implementing fixes → set to `fixed_pending_review`; set `next_owner` to Zach
- [ ] Step 6: Default handoff is Rahat for verification. Apply the Exit and Handoff format from the core skill.

## Definition of Done

- [ ] All acceptance criteria checked, implemented, or explicitly deferred with reason
- [ ] Verification matrix items `implemented` or `blocked` — never `passed`
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation complete or deferred item named with owner
- [ ] All artifacts above updated
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions with pass criteria, next owner
