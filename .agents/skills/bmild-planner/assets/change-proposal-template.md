---
type: Change Proposal
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name>"
slug: <kebab-case-slug>
status: open | in-progress | applied | abandoned
---

## Trigger

<one paragraph: what changed, why, and what triggered the recognition>

## Evidence

- <pointer to chat, artifact, finding, or RCA that raised the change>

## Impact Map

Classify each source artifact as `unaffected | mechanical | owner-decision | coupled-change | stale`.

- product-brief.md: <classification>
- prd.md: <classification>
- ux-design.md: <classification>
- system-design.md: <classification>
- slices.md: <classification>
- slice-<N>.md (each affected): <classification>
- verification-matrix.md: <classification>
- (other affected artifacts)

## Bounded Questions (ordered by leverage)

Each question: one trade-off, scoped to artifacts that share that trade-off, answerable in one roundtable session. Order by leverage — answer the question whose result most reshapes the downstream questions first.

1. <question 1>
2. <question 2>
...

## Roundtable Synthesis Records

Append a record per ratified roundtable session. Synthesis is the facilitator's output (Non-negotiable / Preference / Open); the user ratifies which option becomes the plan of record.

### Q1: <question 1 short title> (YYYY-MM-DD)

- Attendees: <list>
- Non-negotiable: <points>
- Preference: <option blocks>
- Open (deferred): <items>
- Ratified option: <user's choice, dated>

### Q2: ...

## Resolution Record

Record each bounded episode after the ratified decision: causal episode, owner, affected owned artifacts, resolution method, provenance location, and downstream impact. Same-owner consequences are one entry even when multiple artifacts change.

- R-### — <episode> — <owner> — `<artifacts>` — `applied_by_scribe | authored_by_guest | authored_by_consult` — <provenance pointer, YYYY-MM-DD>

## Ordered Handoff Chain

Only work that genuinely left the session because capability or authority was unavailable/rejected, user input was unavailable, or ownership remained asynchronous. Each entry: target persona, mode, artifact, exact invocation, `Blocked-By`, and resume condition. Completed in-session episodes never appear here.

1. <persona> — <mode> on `<artifact>` — verbatim prompt: *"<invocation text>"* — Blocked-By: none
2. <persona> — <mode> on `<artifact>` — verbatim prompt: *"<invocation text>"* — Blocked-By: 1
3. Sonia — Replanning on `slices.md` and affected `slice-<N>.md` — Blocked-By: 1, 2
...

## SP Items

- SP-### — <target artifact> — <target owner> — Blocked-By: <prior SP-###s> — Disposition: <pending | applied_by_handback> — Resume condition: <exact condition>

## Decision Log Echo

Mirrors entries summarized into `[plan_folder]/rollup.md` `## Decision Log` as each owner episode or asynchronous handback completes. Maintained for traceability.

- YYYY-MM-DD — <persona|scribe> — <one-line decision summary> — SP-### — change-proposal-<slug>
