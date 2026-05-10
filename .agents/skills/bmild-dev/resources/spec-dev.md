---
name: bmild-dev / spec-dev
description: "Planned implementation mode. Activated when a named Slice exists and its file is present. Implements acceptance criteria against a full design contract."
---

## Spec-Dev Mode

Implement a well-defined Slice inside a documented initiative.

1. **Entry** — Confirm `slice-<N>.md` is present at `[plan_folder]/<initiative>/slice-<N>.md`. If missing, flag it and operate at reduced fidelity: work from available contracts, note what you are inferring, and flag what is missing. Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative>/_context.md`
   - [ ] Every `## Live` entry relevant to the Slice — skip `## Archived` and unrelated initiative folders
   - [ ] `slice-<N>.md` in full
   - [ ] Relevant sections of `verification-matrix.md` when present
   - [ ] Design contracts referenced by the Slice
   - [ ] Repo contributor guide (`AGENTS.md`, `CONTRIBUTING.md`, or equivalent)

2. **Pre-Edit** — Apply core Craft Standards (Pre-Edit principles) before writing any code.

3. **Execute** — Work through acceptance criteria one by one; check each off as you complete it. Honor every design contract referenced by the Slice. Do not resolve a contract gap by inference — route to Sonia with one precise question if a genuine contract is missing or ambiguous. When `verification-matrix.md` is present, treat it as a binding QA contract: mark relevant items `implemented` with evidence references; never mark them `passed` — that belongs to Rahat.

4. **Prove** — Run quality gates per the contributor guide. Record any gate that could not be run and the reason.

5. **Document** — Write or update documentation required by the spec, Slice, or contributor guide — including README, AGENTS/CONTRIBUTING, runbooks, release notes, and user-facing help. Name any deferred doc item with the change required and next owner.

6. **Close** — Update artifacts in this order:
   - [ ] `slice-<N>.md` → status `ready-for-review`, AC checked off, Implementation Notes appended, QA/Security Follow-up updated
   - [ ] `slices.md` → Slice status `ready-for-review`
   - [ ] `verification-matrix.md` → relevant items `implemented` or `blocked`, never `passed`
   - [ ] `_context.md` → move `slice-<N>.md` to `## Archived`; add new live docs to `## Live`
   - [ ] `rca-<slug>.md` if implementing fixes → add fix details and regression-test reference; set `next_owner` to Rahat
   - [ ] `security-review-*.md` if implementing fixes → set to `fixed_pending_review`; set `next_owner` to Zach

   Default handoff: **Rahat** for verification. Apply the Exit and Handoff format from the core skill.

---

## Definition of Done

- [ ] All acceptance criteria checked, implemented, or explicitly deferred with reason
- [ ] Verification matrix items `implemented` or `blocked` — never `passed`
- [ ] Quality gates run, or unrun gates recorded with reason
- [ ] Documentation complete or deferred item named with owner
- [ ] All artifacts above updated
- [ ] Close message: files changed, gates run, artifact updates, documentation impact, user verification actions with pass criteria, next owner
