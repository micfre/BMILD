# Synthesise — Consolidate Trade-offs (No Recommendation)

## Purpose

Synthesise the deliberation as facilitator — not as any attendee. Name tensions honestly; do not flatten them. Use three categories only: Non-negotiable, Preference, Open. Surface trade-offs and let the user decide — **do not recommend a decision in either invocation context.** Preserve artifact ownership: return patch-ready implications to the invoking persona unless the user explicitly authorized this facilitator to write the target artifact.

## Inputs

Carried from `step-02-debate.md`:

- Confirmed question and invocation context.
- Final attendee list and their positions.
- If course-correction context: active `change-proposal-<slug>.md` loaded in step-01.

## Procedure

Progress:

- [ ] Step 1: **Present the synthesis** under this structure:

  ---

  **Non-negotiable** — what all confirmed attendees agree on, or what is constrained by existing platform decisions:
  - [Point 1]
  - [Point 2]

  **Preference** — where attendees differed, but the trade-off is low-stakes or reversible:
  - Option 1:
    - Favoured by: Katrina, Faisal
    - Why: [reason]
    - Cost: [cost]
  - Option 2:
    - Favoured by: Lance
    - Why: [reason]
    - Cost: [cost]

  **Open** — genuinely unresolved; requires a decision before downstream work can proceed:
  - [Open question 1] — implication if unresolved: [impact]
  - [Open question 2] — implication if unresolved: [impact]

  ---

- [ ] Step 2: **Elicit open items** — If there are open items, run targeted elicitation immediately — do not let the synthesis stall:

  > *"There are [N] unresolved items. Let me ask them directly:*
  >
  > 1. [Question 1 — tightest possible phrasing]
  > 2. [Question 2]"*

  After the user answers: update the synthesis (move items from Open to Non-negotiable or Preference) or trigger another deliberation round if answers reveal new tensions (load `resources/step-02-debate.md`).

- [ ] Step 3: **Return artifact implications — branch on invocation context.**

  **Context A — Forward-direction** (default). Prepare a handoff note for the invoking persona:
  - [ ] Non-negotiables to apply to the appropriate spec/design document
  - [ ] Resolved open items and where matching handoff items or source-local ambiguity records should be removed, promoted, or closed
  - [ ] Deferred open items to resolve in chat, route through `handoff.md`, or record as bounded assumptions — with target owner, status, and consequence
  - [ ] Synthesis record to append to the most relevant spec document:

  ```markdown
  ## roundtable session: <question summary> (<YYYY-MM-DD>)

  ### Attendees
  <list>

  ### Non-negotiable
  ...

  ### Preference
  ...

  ### Open (deferred)
  ...
  ```

  - [ ] Target owner and artifact for each change

  If the user explicitly authorized facilitator writes, apply the changes and update `registry.md` if the document was newly created or significantly changed. Otherwise do not write artifacts directly.

  **Ratification→Promotion gate (Context A only).** After the user ratifies a decision (not merely a preference), load this skill's `references/promotion-protocol.md` and evaluate the trigger triad. When all three conditions hold:

  1. Build the compact impact inventory with owner + action class (`scribe` | `owner-handback` | `canonical-route` | `planner-deferred`).
  2. If ≥2 distinct design-tier owners need non-trivial updates → recommend Course-Correction; do not batch-scribe; persist backlog when permitted; close path uses `ratified_and_routed` (or pending/deferred).
  3. Otherwise ask **once** for promote authority using the protocol's phrasing (design artifacts vs slices).
  4. On authorization: apply only scribe-eligible lines as presiding scribe (SOUL load, settlement-verify, dual attribution, cascade check). Route canonical-tier, high-stakes, and failed-gate lines. Never write `context-map.md`, `[plan_folder]/adr/`, or project-root `DESIGN.md`.
  5. Record the close state for step-04: `ratified_and_promoted` | `ratified_and_routed` | `ratified_pending_authorization` | `ratified_with_documentation_deferred`.

  If the triad does not hold, skip the gate and use the normal handoff note.

  **Context B — Course-correction consultation.** Output destination is `[plan_folder]/<initiative-name>/change-proposal-<slug>.md` (already loaded in Step 1). Append a synthesis record to the `## Roundtable Synthesis Records` section:

  ```markdown
  ### Q<N>: <question short title> (<YYYY-MM-DD>)
  - Attendees: <list>
  - Non-negotiable: <points>
  - Preference: <option blocks>
  - Open (deferred): <items>
  - Ratified option: <pending user ratification, or user's choice + date once ratified>
  ```

  After appending, present the synthesis in chat for the user's ratification. Sonia (the invoker) does not select among Preference options; the user does. Once the user ratifies, Sonia evaluates Scribe-Eligibility (per `bmild-planner/resources/course-correction.md`) and either applies as scribe or routes through the owning persona's Handback. The facilitator does not make this routing decision — Sonia does. **Do not run the forward-direction Ratification→Promotion apply path here** (no double-gate).

- [ ] Step 4: **Report** — State what was done, in context-appropriate phrasing:

  *Forward-direction:* > *"Roundtable synthesis ready. I prepared changes for [owner/artifact] — [brief list of implications]. [If authorized: I updated the document(s). If not authorized: The handoff note is ready for [persona] to apply within their workflow.]"*

  *Course-correction:* > *"Roundtable synthesis appended to `change-proposal-<slug>.md`. Synthesis is in chat for your ratification."*

- [ ] Step 5: **Continue or close** — Ask: *"Do you want to keep the session open for another question, or shall we close?"*

## Next Step

- Another question → load `resources/step-01-open.md` (new question, same context — re-confirm attendees if the new question's surface differs).
- New tensions from user answers → load `resources/step-02-debate.md`.
- Done → load `resources/step-04-close.md`.
