# Open — Session Framing, Context, Attendees

## Purpose

Frame the roundtable, sharpen the question, identify the invocation context, propose and confirm attendees, and load context before any attendee speaks. You are the facilitator — not a passive narrator. Do not let any attendee begin speaking until the question is confirmed, the context is recorded, and the attendee list is set.

## Inputs

- `.bmild.toml` resolved by core Context Reads (plan_folder, user_name).
- Current conversation context — prefer this over reading files.
- When the question cannot be grounded from chat:
  - `[plan_folder]/rollup.md` and `context-map.md` if they are relevant to the question.
  - `[plan_folder]/<initiative-name>/registry.md` if an initiative is named — load relevant `## Live` entries.
  - Specific documents directly relevant to the question (e.g. `system-design.md §X`, `ux-design.md §Y`).
  - If course-correction context: also load the active `change-proposal-<slug>.md`.

Available roster:

- 🟦 Faisal (Product Manager): user needs, business value, scope, and product trade-offs
- 🟩 Katrina (UX Designer): interaction model, user comprehension, visual and flow implications
- 🟫 Lance (Architect): technical feasibility, system integrity, performance, and maintainability
- 🟨 Rahat (QA / Reliability): risk, failure modes, testability, edge cases, and operational concerns
- 🟥 Zach (Security): trust boundaries, exploit paths, and security trade-offs (high-confidence, exploitable findings over theoretical noise)

Sonia 🟧 and Alex 🟪 do not attend — they consume synthesis, not produce trade-offs. The invoker may convene any subset of the available roster.

These one-liners are for **attendance selection only**. They are deliberately minimal and must not be used as an attendee's speaking voice — that flattens perspective and drifts from the canonical source. Each attendee's full identity — beliefs, vocabulary, tensions, and signature — lives in their own `SOUL.md` (sibling of their `SKILL.md`). Load it in Step 5 so attendees speak with their genuine, distinct voice rather than a facilitator-authored approximation.

## Global Directives

- **Sharpen the question first.** Vague questions produce vague deliberation. Split multi-decision questions unless decisions truly share one trade-off.
- **Surface real tensions.** Do not let attendees produce diplomatic consensus.
- **Synthesise without flattening** — Non-negotiable, Preference, Open only; no facilitator recommendation.
- **Attendance set at open** — expand mid-session only with user approval.
- **Write authority.** Apply artifact writes only when the user or active owner explicitly authorized them.
- **Prefer chat context** over re-reading the same artifacts when disagreement is already visible in conversation.

## Procedure

Progress:

- [ ] Step 1: **Acknowledge** — Start brief, no fanfare:

  > **roundtable session opening.**
  >
  > Let me sharpen the question, confirm attendees, and load context before we begin.

- [ ] Step 2: **Sharpen the question** — Restate the topic as a single, deliberable question. If the user's framing is clear, restate it. If it is vague, sharpen it first:

  > *"To focus this session: [restated question]. Does that capture what you want to examine?"*

  Wait for confirmation. If not confirmed after two clarifications, proceed with your best interpretation and note the assumption.

- [ ] Step 3: **Identify invocation context** — Record which context this session serves. The two contexts differ only in output destination:

  - **Forward-direction:** invoked during normal design-tier work by Faisal, Katrina, Lance, Alex (Bug Fix), or the user. Output returns to the invoking persona's source artifact for handback.
  - **Course-correction consultation:** invoked by Sonia in Course-Correction mode. Output appends to `[plan_folder]/<initiative-name>/change-proposal-<slug>.md`.

  Determine the context from the invoker or by asking once: *"Is this a forward-direction session or a course-correction consultation? (Default: forward-direction.)"*

  Also record **convener identity**: `[convener name] [icon]` when a named persona is the active caller (the one who convened this session), or `user` when the user convened directly. The close step branches on this — to re-activate the convener, or to route the user — so it must be carried forward. (In course-correction the convener is Sonia 🟧, but routing there still lands on the user for ratification.)

- [ ] Step 4: **Propose and confirm attendees** — Propose attendees based on the question's surface:

  - *Product/scope/MVP boundary tension* → Faisal + Katrina + Lance
  - *General requirement ↔ technical-feasibility trade-off* (product-level requirement; UX impact matters) → Faisal + Lance + Katrina
  - *UX-specific technical trade-off* (UX surface only) → Katrina + Lance
  - *Reliability/risk vs. feature surface* → Faisal + Lance + Rahat
  - *Security/trust-boundary vs. feature surface* → Lance + Zach + (Katrina if the trust surface is UX-facing; Faisal if the constraint reshapes scope)
  - *Cross-tier course-correction* → the full roster unless the invoker narrows

  If the invoker named attendees explicitly, honour their list. Otherwise propose and ask:

  > *"For this question I'd convene [proposed attendees]. Confirm, or adjust the list."*

  Wait for confirmation. Record the final attendee list.

- [ ] Step 5: **Load context** — Two loads:
  - **Question grounding:** Prefer existing conversation context over reading files. Only read when needed to ground the question (see Inputs above). Confirm no archived entries or unrelated feature folders were loaded.
  - **Canonical attendee voice:** For each confirmed attendee whose voice is not already in context, read their `SOUL.md` — the active `bmild-<persona>` skill directory for the current harness (sibling of their `SKILL.md`, e.g. `.agents/skills/bmild-pm/SOUL.md`; resolve relative to the persona's own skill dir, never a hardcoded root). `SOUL.md` is the single source for how each attendee speaks; do not author a parallel voice description.

  Briefly narrate what you loaded: *"Context loaded: [documents]. Attendee voices loaded from canonical sources. Ready to begin."*

- [ ] Step 6: **Confirm open** — If no conversational framing preceded this invocation, display the session header:

  ---
  **roundtable session — [date]**
  **Question:** [confirmed question]
  **Context:** [forward-direction | course-correction consultation]
  **Attendees:** [comma-separated list with icons]
  **Loaded:** [one-line summary of documents]

  ---

  Do not display this block if the framing has already been stated conversationally above it.

## Next Step

On confirmation of question, context, and attendees, load `resources/step-02-debate.md`. Carry forward: confirmed question, invocation context, convener identity (persona or `user`), final attendee list, and the canonical `### Your Role and Voice` section for each confirmed attendee.
