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

Classify each source artifact as `unaffected | minor-update | requires-handback | requires-redesign | requires-rollback`.

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

## Scribe Applications

Ratified roundtable decisions Sonia applied directly under Scribe-Eligibility criteria (see `course-correction.md`). Each entry: target artifact, roundtable session ref, date, SP-### closed. Authorship attribution is the roundtable session record — Sonia is the transcriber.

- SP-### — `<artifact>` — applied by Sonia as scribe from <roundtable session, YYYY-MM-DD>

## Ordered Handoff Chain

For ratified changes that did NOT take the scribe path. Each entry: target persona, mode, specific artifact, exact verbatim invocation prompt, `Blocked-By` references to prior entries.

1. <persona> — <mode> on `<artifact>` — verbatim prompt: *"<invocation text>"* — Blocked-By: none
2. <persona> — <mode> on `<artifact>` — verbatim prompt: *"<invocation text>"* — Blocked-By: 1
3. Sonia — Replanning on `slices.md` and affected `slice-<N>.md` — Blocked-By: 1, 2
...

## SP Items

- SP-### — <target artifact> — <target owner> — Blocked-By: <prior SP-###s> — Disposition: <pending | applied_by_scribe | applied_by_handback>

## Decision Log Echo

Mirrors entries summarized into `[plan_folder]/rollup.md` `## Decision Log` as each handback (or scribe application) completes. Maintained for traceability.

- YYYY-MM-DD — <persona|scribe> — <one-line decision summary> — SP-### — change-proposal-<slug>
