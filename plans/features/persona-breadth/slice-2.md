---
feature: persona-breadth
slice: 2
status: done
updated: 2026-03-27
---

## Intent
Standardize the primary personas so they load context first, narrate what they found, and name the next persona explicitly at handoff, while updating `Delivery Planner` to cover readiness, Slice flow, and rerouting.

## Scope
- In: update the primary persona skill instructions to enforce the shared activation and handoff contracts for PM, UX, Arch, Delivery Planner, Dev, and QA.
- In: expand `Delivery Planner` instructions so the persona handles implementation-readiness checks, Slice-plan sequencing, Slice-status visibility, and plan rerouting when execution uncovers blockers or gaps.
- In: preserve persona-specific voice and scope while making the context-loading and handoff behaviors mandatory.
- Out of scope for this Slice: reworking onboarding docs, rewriting `README.md`, or introducing helper personas.

## Design Contracts (must honour)
- `system-design.md §Persona Activation Contract` — primary personas must read live context and primary upstream artifacts before asking substantive questions.
- `system-design.md §Persona Opening Contract` — openings must state scope, loaded context, current stage/gap, and next action.
- `system-design.md §Persona Handoff Contract` — closings must state completion, artifact update, and the explicitly named next persona.
- `system-design.md §Rename Contract: \`planner\` -> \`Delivery Planner\` > Approved role statement` — `Delivery Planner` owns readiness, sequencing, status clarity, and rerouting around the Slice plan.
- `system-design.md §Decision: Standardize context-first behavior across personas` — wording may vary, but the behavior is mandatory.
- `ux-design.md §Interaction Model` — personas should present themselves as entering an ongoing effort and should reduce guesswork about next steps.
- `ux-design.md §User Flows` — support both fresh entry and mid-lifecycle entry without resetting the conversation unnecessarily.
- `spec.md §Requirements > Must Have` — the role must cover BMILD equivalents of readiness checking, Slice-plan creation, and Slice-progress routing/status visibility.

## Acceptance Criteria
- [x] Each primary persona's instructions explicitly require loading live context before substantive questioning or routing.
- [x] Each primary persona's opening instructions require a brief narration of loaded context and current stage/gap.
- [x] Each primary persona's closing or handoff instructions require naming the next persona explicitly when a handoff is appropriate.
- [x] `Delivery Planner` instructions explicitly cover implementation readiness, Slice sequencing, Slice progress visibility, and rerouting when implementation reveals gaps or blockers.
- [x] Persona-specific responsibilities and voice remain distinct after the standardization.

## Implementation Notes
<!-- Alex fills this in after implementation. Sonia leaves this empty. -->
- Standardized the activation and handoff contracts across `bmild-pm`, `bmild-ux`, `bmild-arch`, `bmild-planner`, `bmild-dev`, and `bmild-qa` without flattening their domain-specific language.
- Kept the folder name `bmild-planner` for compatibility while reinforcing the user-facing `Delivery Planner` role in the prompt text and handoff wording.
- Treated the missing `plans/platform/_context.md` in this repo as an allowed absence and updated affected skills to check for it explicitly.
