---
name: bmild-dev / spec-dev
description: "Planned implementation mode. Activated when a named Slice exists and its file is present. Implements acceptance criteria against a full design contract."
---

## Spec-Dev Mode

Implement a well-defined, self-contained Slice inside a documented initiative.

---

## 1. Entry

Confirm the Slice file is present at `[plan_folder]/<initiative>/slice-<N>.md`. If it is missing, flag this to the user and operate at reduced fidelity: work from whatever design contracts and the contributor guide make available, note what you are inferring, and flag what is missing.

Load in this order:

1. `plans/CHARTER.md` if it exists
2. `plans/ARCHITECTURE.md` if it exists
3. `plans/_rollup.md` if it exists
4. `[plan_folder]/<initiative>/_context.md`
5. Every `## Live` entry relevant to the target Slice — do not load `## Archived` entries or unrelated initiative folders
6. `slice-<N>.md` in full
7. Relevant sections of `verification-matrix.md` when present
8. Design contracts referenced by the Slice
9. The repo contributor guide (`AGENTS.md`, `CONTRIBUTING.md`, or equivalent)

---

## 2. Pre-Edit

Apply core Pre-Edit Discipline before writing any code.

---

## 3. Execute

Work through acceptance criteria one by one. Check each off as you complete it.

Honor every design contract referenced by the Slice. Do not resolve a contract gap by inference — route to Sonia with one precise question if a genuine contract is missing or ambiguous.

Treat `verification-matrix.md` as a binding QA contract when present. Acceptance criteria define what to build; the verification matrix defines how the Slice must be proven. Mark relevant items `implemented` with evidence references. Never mark them `passed` — that belongs to Rahat.

---

## 4. Prove

Run the quality gates defined in the contributor guide. Record any gate that could not be run and the reason.

---

## 5. Document

Write or update documentation explicitly required by the spec, Slice, or contributor guide — including README, AGENTS/CONTRIBUTING, runbooks, release notes, onboarding notes, and user-facing help. If a doc update is required but cannot be completed, name the doc, the change required, and the next owner.

---

## 6. Close

Update artifacts in this order:

- `slice-<N>.md` — status → `ready-for-review`, completed AC checked off (`[ ]` → `[x]`), append **Implementation Notes**, update **QA / Security Follow-up**
- `slices.md` — change this Slice's status to `ready-for-review`
- `verification-matrix.md` — set relevant items to `implemented` or `blocked`, never `passed`
- `_context.md` (initiative scope) — move `slice-<N>.md` from `## Live` to `## Archived`; add any new live documents to `## Live`
- `rca-<slug>.md` (if implementing fixes) — add fix details and regression-test reference; set `next_owner` to Rahat unless Lance or Katrina must act first
- `security-review-*.md` (if implementing fixes) — set relevant findings to `fixed_pending_review`, never `resolved`; set `next_owner` to Zach

Default handoff: **Rahat** for verification.

Apply the Close and Handoff format from the core skill.

---

## Definition of Done

- All acceptance criteria are checked, implemented, updated, or explicitly deferred with reason.
- All verification-matrix items assigned to the Slice are set to `implemented` or `blocked` — never `passed`.
- Quality gates run per contributor guide, or unrun gates recorded with reason.
- Documentation requirements complete, or deferred item named with owner.
- All artifacts above updated.
- QA and security open items referenced and resolved or handed back with a concrete blocker.
- Close message lists: files changed, gates run, artifact updates, documentation impact, user verification actions with pass criteria, next owner.
