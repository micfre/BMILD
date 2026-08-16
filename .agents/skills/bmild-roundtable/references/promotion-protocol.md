# Artifact Promotion Protocol

> Shared definition for advanced facilitators (`bmild-{roundtable,elicit,brainstorming}`). Each facilitator ships an identical local copy. This protocol returns durable consequences to the standard persona gap-resolution ladder; it does not create a facilitator-owned orchestration layer.

## Trigger

Run the promotion gate before close only when the user ratified a decision, the decision changes a durable contract, and at least one source artifact is now incomplete or stale. Otherwise use the facilitator's normal close.

## Impact inventory

List each affected artifact, owner, consequence, and one action class:

- `mechanical-scribe` — settled reversible propagation with no judgment.
- `owner-episode` — one causally bounded decision and all same-owner consequences, including canonical-tier artifacts owned by that persona.
- `coupled-course-correction` — choices across owners are causally coupled and materially alter scope, sequencing, or proof boundaries.
- `planner-deferred` — delivery artifacts are excluded unless the user included them or Sonia was the convener.

Group all same-owner consequences from one decision into one episode, even when several owned artifacts change. Separate independent owners into separate episodes. Multiple owners alone never imply Course-Correction.

## Ask once

Name the impact and ask once for promotion authority:

> “I found [N] affected artifacts: [M] mechanical updates, [O] independent owner episode(s), [C] coupled Course-Correction decision(s), and [P] deferred delivery artifact(s). Promote the mechanical items and return the owner episodes through BMILD's resolution ladder now?”

- Authorization allows only `mechanical-scribe` writes by the facilitator. It returns `owner-episode` lines to the presiding standard persona's ladder.
- If `coupled-course-correction` exists, offer Sonia once with the named coupled choices and wait for explicit consent. Promotion authority does not imply Course-Correction consent.
- “Not now” closes `ratified_pending_authorization`; explicit documentation deferral closes `ratified_with_documentation_deferred`.

## Apply

For authorized `mechanical-scribe` lines, do not load an owner's `SOUL.md`. Verify the source is already authoritative and the edit is reversible, no-judgment propagation. Write:

`Resolution: applied_by_scribe — owner: <owner>; scribe: Facilitator (<skill>); source: <ratified decision>; <date>`

Record provenance beside the authoritative edit. Do not create a closed-on-write handoff for history. If an existing handoff is resolved, close it and point its Promotion Record at the edit.

Return every `owner-episode` to the presiding standard persona, which loads its own `references/gap-resolution.md` and runs capability-gated guest voice or owner consult. Owner consult may author canonical-tier artifacts. If the session was user-convened, activate the first owner as presiding persona and carry the full inventory; each independent consequence remains a separate episode.

After each resolution, re-read changed contracts, scribe mechanical fallout, classify remaining impact, and resume the suspended work. Mark only unresolved artifacts stale.

**Elicit / Brainstorming boundary:** these facilitators still require explicit authorization for direct mechanical writes. Without it, return the inventory to the convener.

**Course-Correction consultation:** append synthesis to the active change proposal and return to Sonia. Sonia owns the standard ladder episodes. Do not run a second promotion ask.

## Close states

When the gate fired, close with exactly one state:

- `ratified_and_promoted` — all authorized mechanical writes and in-session owner episodes completed; only explicitly deferred delivery remains.
- `ratified_and_routed` — unresolved work genuinely left the session or user-approved Course-Correction owns the coupled fallout.
- `ratified_pending_authorization` — promotion or Course-Correction authority was not granted.
- `ratified_with_documentation_deferred` — the user explicitly deferred artifact updates.

Never claim `ratified_and_promoted` while an owner episode remains unresolved or an artifact is stale from the ratification.

## Durable backlog

Create a handoff only when work genuinely leaves the session because required capability is unavailable or rejected, user input/authority is missing or declined, or ownership remains asynchronous. Reuse an existing matching item. Persist the inventory, exact blocked episode, owner, artifact, and resumption condition. Do not create handoffs for completed in-session promotion.

## RCA and delivery

Historical `rca-<slug>.md` files receive dated addenda; do not rewrite evidence retrospectively. Delivery artifacts remain excluded unless explicitly authorized or Sonia is already presiding.
