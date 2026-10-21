# Persona-run articulation

## Purpose

Let a standard persona (Faisal, Katrina, Lance, Sonia, Alex, Rahat) draw out what the user already knows, in the persona's own voice, while the section is still live. There is no facilitator, opening, close, or suspension notice.

Why this exists: users often know more than they have said, and a section's tacit knowledge is easiest to draw out while that section is live. Offered only at the end of a session, articulation lands when the user is tired and ready to move on, so its value is lost. A persona that already owns the content and its criteria can ask the sharpening question at the right moment, at almost no cost.

## Inputs

- The trigger: the persona's inline-articulation signal, an accepted articulation offer (possibly with a shortlist method pre-selected), or the harness loading this skill mid-session.
- The working content of the live section, from the current conversation.
- The method catalog, served by `sh <articulate-dir>/scripts/methods.sh` (POSIX) or `powershell -File <articulate-dir>\scripts\methods.ps1` (Windows-native), where `<articulate-dir>` is the sibling `../bmild-articulate` resolved from the persona's skill directory.

## Global Directives

- **The user supplies the answer.** The method's job is to draw it out. Ask the question the method produces; don't answer it on the user's behalf.
- **One method, then read the room.** Apply a single method and fold in the result. Continue only when the user engages.
- **Catalog only.** Never name a method from memory; unknown names are reported by the script, not substituted.
- **Ownership is unchanged.** Edits inside the persona's own artifact apply directly. Anything touching another owner's contract runs through the persona's `references/gap-resolution.md`.

## Procedure

Progress:

- [ ] Step 1: **Target** — In one sentence, name the section or decision and what looks thin, hedged, or untested.
- [ ] Step 2: **Select** — When a shortlist method was offered and accepted, use it. Otherwise run `categories`, then `list --category` for at most two categories matching the content (see the content-type and weakness map in `resources/step-01-select.md`), then `show` the one method you will apply.
- [ ] Step 3: **Apply in voice** — Pose the one or two questions the method produces, or show what it surfaces in the current content, phrased as the persona would ask them. Do not announce a mode change; naming the method in passing is enough (e.g., "Let me pre-mortem this: …").
- [ ] Step 4: **Fold in** — Update the working content with what the user said and state the change in one line.
- [ ] Step 5: **Continue or resume** — If the result opened a further angle, suggest one next method in a sentence. The user can take it, name another, or move on.

Example:

- *Before (facilitator hand-off at session end):* "Before I write the brief — I could run Pre-mortem Analysis in a separate articulation session. Otherwise I'll proceed." The user, forty minutes in, says "proceed", and the fragile success metric ships untested.
- *After (persona-run, in-flow):* Faisal, the moment the success criterion settles: "Let me pre-mortem that metric. It's six months out and activation hit 40% but retention fell. What happened?" The user names the gaming path in one sentence, and it becomes the counter-metric.

## Next Step

On any move-on signal, resume the persona's suspended step in the same turn, per its Same-Session Resumption contract. Do not emit an Opening Stance or a close, and do not re-elicit settled content.
