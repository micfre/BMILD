---
name: bmild-dev / direct-dev
description: "Ad hoc implementation mode. Activated when no Slice is named. Covers prototypes, experiments, small features, spikes, migration helpers, and exploratory work."
---

## Direct-Dev Mode

Implement bounded repo work outside a formal Slice. No spec, UX design, architecture design, or verification matrix is required.

---

## 1. Entry

If scope is not clear from the message, ask one question for the smallest concrete target before proceeding.

Classify the work before implementing:

- **Throwaway** — exploratory, disposable, not intended to persist after the session
- **Exploratory** — may inform a future spec; leaves reusable code or a documented finding
- **Durable** — changes production behaviour, leaves code that others will build on

Load repo context and the contributor guide. Load BMILD memory only when the request names an initiative, depends on documented behaviour, or might alter durable product or architecture understanding.

---

## 2. Pre-Edit

Apply core Pre-Edit Discipline before writing any code.

---

## 3. Execute

Implement the smallest coherent change that satisfies the request. Match existing repo patterns. Do not over-engineer toward a spec that does not yet exist.

---

## 4. Prove

Run quality gates defined in the contributor guide. Add or update tests only when they prove the prototype, protect durable behaviour, or the user explicitly asked for tests.

---

## 5. Document

Documentation is required only when durable behaviour changes or the user explicitly asks for it. Otherwise record `Documentation impact: none` in the Dev note when a note exists.

---

## 6. Close

Write a Dev note (`dev-note-<slug>.md`) when the work:

- Changes durable repo behaviour
- Leaves reusable code
- Reveals a fact that future specs should account for
- Creates follow-up work

If none of these apply and the work is throwaway with no future relevance, no Dev note is required.

When a Dev note is written: use `assets/dev-note-template.md` for structure; place it under the relevant initiative folder, or `[plan_folder]/_system/` for genuinely global work; register it in the initiative's `_context.md` `## Live` section.

No formal handoff is required unless the work reveals a decision that belongs upstream — see the core Escalation Routing table.

Apply the Close and Handoff format from the core skill.

---

## Definition of Done

- The implementation or prototype is complete, or the exact blocker and next owner are recorded.
- Quality gates run per contributor guide, or unrun gates recorded with reason.
- Documentation impact recorded (complete or `none`).
- Dev note written and registered when conditions above are met.
- Close message lists: files changed, gates run, documentation impact, next owner if any.
