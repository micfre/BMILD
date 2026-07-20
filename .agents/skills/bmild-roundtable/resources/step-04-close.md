# Close — Session Conclusion

## Purpose

Close the session briefly — the synthesis already did the heavy work. Each confirmed attendee who was most engaged makes a short in-character closing remark. Do not produce a long wrap-up.

## Inputs

Carried from prior steps:

- Invocation context (forward-direction or course-correction).
- Convener identity (a named persona, or `user`), carried from step-01.
- Suspended session state for a persona convener: persona, mode/resource, initiative, artifact section in progress, and pending work.
- Final attendee list and which attendees were most engaged.
- Key outcome established in synthesis.

Natural close phrases that route here: `done`, `exit`, `close session`, `that's enough`, `wrap up`. The `[E]` option at the end of each round also routes here.

## Procedure

Progress:

- [ ] Step 1: **Session outcome** — Facilitator states in one sentence what the session produced, and when the promotion gate fired, names the close state:

  > *"This session established [key outcome — e.g. the API contract trade-offs, the deferred UX question, the confirmed non-negotiable]. Close state: [ratified_and_promoted | ratified_and_routed | ratified_pending_authorization | ratified_with_documentation_deferred | n/a]."*

  Load `references/promotion-protocol.md` only when carrying a promotion close state from step-03; otherwise use `n/a`.

- [ ] Step 2: **Attendee sign-offs** — Two or three attendees who were most engaged in the session make brief, two-sentence maximum closing remarks derived from their loaded `SOUL.md` (beliefs, tensions, and perspective in one line). Do not substitute facilitator-authored role hints:

  ```
  🟦 Faisal: [brief closing — pragmatic, user-focused]

  🟩 Katrina: [brief closing — interaction or design-focused]

  🟫 Lance: [brief closing — concrete, constraint-aware]

  🟨 Rahat: [brief closing — risk or edge-case-aware]

  🟥 Zach: [brief closing — exploit-path or trust-boundary-aware]
  ```

  Mine the loaded SOUL rather than reusing generic example beats; the close should sound like the attendees who actually participated.

- [ ] Step 3: **Return handoff — branch on convener identity.** Your turn ends at sign-off: you cannot resume another persona on the user's behalf, so the close must make the next move unambiguous. Use the convener identity carried from step-01 to pick **exactly one** branch. Never use *"I will turn this back to [persona]"* — it is a promise you cannot keep.

  **A — Persona convened (default; the convener resumes).** Yield the floor with this copy-ready invocation so the next turn continues at the recorded suspended point with the synthesis as input:

  > *"Facilitator 🌀 closing. Synthesis is ready. Resume **[convener name] [icon]** with the message \"continue `[initiative-name]` [mode/resource] from [artifact section in progress] with the [facilitator output] above.\" [Only if a real user action remains:] For you, [user_name]: [ratify/answer the unresolved Open item]."*

  **B — User convened (no invoking persona to return to).** Emit the core-style routing block so the user has a clear next step:

  > *"Facilitator 🌀 closing. For you, [user_name]: [only a real step-completion action — omit this line if there is none]. Next: invoke the persona who owns the next artifact when ready, or tell me what's next."*

  **C — Course-correction consultation.** Synthesis was appended to `change-proposal-<slug>.md` in the synthesis step; route to ratification, then Sonia:

  > *"Facilitator 🌀 closing. For you, [user_name]: ratify the open items in `change-proposal-<slug>.md`. Next: Sonia 🟧 picks up routing once you've ratified."*

  `For you` is only for a genuine user-facing step-completion action; omit the entire line when there is none, in any branch. Keep `For you` and `Next` separate. Sign off as `— Facilitator 🌀`.

## Definition of Done

- Session outcome stated in one sentence; promotion close state named when the gate fired (`ratified_and_promoted` | `ratified_and_routed` | `ratified_pending_authorization` | `ratified_with_documentation_deferred`).
- Most-engaged attendees made in-character closing remarks.
- Facilitator signed off as `— Facilitator 🌀` with a branch-aware close selected by convener identity (persona re-activation, user `For you`/`Next` routing, or course-correction routing).
- No *"I will turn this back to [persona]"* phrasing remains; the convener either resumes with the synthesis as input or the user has a clear `For you`/`Next` step.
- The invoking persona or user has what they need to resume without re-running the roundtable.
- Context B did not double-gate promotion apply (Sonia owns post-ratification scribe/handback).
