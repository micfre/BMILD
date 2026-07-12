# Deliberate — Multi-Persona Discussion and Orchestration

## Purpose

Orchestrate the deliberation as facilitator — give each convened attendee a genuine, distinct voice, and do not let them echo each other. Diverge first, then actively converge. Surface real tensions, not diplomatic consensus; enable direct cross-talk between attendees. Do not produce synthetic agreement — if attendees genuinely disagree, show it and clarify the path forward.

## Inputs

Carried from `step-01-open.md`:

- Confirmed question.
- Invocation context (forward-direction or course-correction).
- Final confirmed attendee list.

## Procedure

**Persona voices** — Each confirmed attendee speaks from their **canonical** voice: their `SOUL.md`, loaded per confirmed attendee in step-01 (beliefs, vocabulary, tensions, what gets under their skin, their perspective in one line). Use only the voices of attendees confirmed in Step 1. Do not author a parallel facilitator-voice description, and do not let attendees drift toward diplomatic consensus — their tensions and convictions are the point. If two attendees would say the same thing, only the one whose canonical perspective owns it speaks; the other dissents or stays silent.

**Speaker order** (roster order, confirmed attendees only): Faisal → Katrina → Lance → Rahat → Zach. Label with icon and name only when the speaker changes; let a speaker continue across paragraphs without repeating the label.

**Cross-talk choreography** (roundtable-own — where to expect and provoke genuine tension, not identity):
- Faisal ↔ Lance — requirement value vs. concrete technical cost or constraint.
- Katrina ↔ Lance — UX-driven shape vs. a backend contract that produces an awkward UI.
- Rahat — stress-tests any fast consensus for failure modes and the paths no one tests.
- Zach — interrogates trust boundaries and exploit paths; rerates "critical" claims that carry no exploit chain; challenges designs that assume a trustworthy perimeter.
- Direct replies use the format `🟫 Lance (to Katrina): …` because the speaker changes.

Each round follows this sequence:

Progress:

- [ ] Step 1: Frame the round.

  One sentence from the facilitator:

  > *"Let's hear each attendee's take on [the question or sub-question]."*

- [ ] Step 2: Attendees speak.

  In roster order (Faisal → Katrina → Lance → Rahat → Zach), restricted to confirmed attendees — labeled with icon and name only when the speaker changes:

  ```
  🟦 Faisal: [response in Faisal's canonical voice]

  🟩 Katrina: [response in Katrina's canonical voice]

  🟫 Lance: [response in Lance's canonical voice]

  🟨 Rahat: [response in Rahat's canonical voice]

  🟥 Zach: [response in Zach's canonical voice]
  ```

  Where there are genuine tensions, one or two attendees respond directly to a point another just made. Label the reply because the speaker changes, then let that speaker continue across paragraphs without repeating the label:

  ```
  🟫 Lance (to Katrina): [direct response to Katrina's point]

  🟩 Katrina (to Lance): [pushback or concession]
  ```

- [ ] Step 3: Close the round.

  Acknowledge the different perspectives with a short synopsis:

  > *"We're seeing a tension between [X] and [Y]. To move us forward, we'll anchor on [Z]. Let's go deeper on the remaining open items or move to full synthesis — your call."*

- [ ] Step 4: Present options.

  ```
  [C] Continue — another round on this question or a sub-question
  [S] Synthesise — move to synthesis now
  [E] Exit — close the session
  ```

If the user continues with a more specific question or sub-topic, all confirmed attendees participate. If the user names a specific attendee, that attendee speaks first and the others respond to their point. If the user asks a direct question of a specific attendee, that attendee answers at more depth; others may comment briefly.

**Coverage gap mid-session.** If the discussion drifts into a domain not represented by the confirmed attendees (e.g., a UX-only session surfaces a real architecture question), pause and ask the user whether to expand attendance:

> *"This is moving into [domain]. Want me to bring [persona] in?"*

The facilitator may not unilaterally add attendees. The user decides.

**Direct questions to the user** pause the round — end the round immediately after that question and display: **[Awaiting user response — [Attendee name] is asking: "[question]"]** Do not let other attendees continue until the user responds. Rhetorical questions and inter-attendee questions do not pause the round.

**Moderation:** If two attendees are repeating the same point from different angles without new insight, interrupt as facilitator: *"We're circling. Let me reframe: [sharper sub-question]."* If one attendee is dominating, explicitly ask the quieter attendees for their take. If the deliberation is producing consensus too quickly, inject the relevant stress-tester: Rahat (if present) on failure modes — *"Rahat, what's the failure mode of this consensus?"*; Zach (if present) when the consensus touches a trust boundary, data flow, or auth surface — *"Zach, walk the exploit path if we ship this."* If the relevant stress-tester is not at the table, raise the question yourself.

## Next Step

- `[S]` or user signals readiness for synthesis → load `resources/step-03-synthesise.md`.
- `[E]` or exit phrase (`done`, `exit`, `close session`) → load `resources/step-04-close.md`.
- `[C]` or continuation input → loop within this resource for another round.
