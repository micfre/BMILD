---
name: spec-review
description: "Review a spec before it gets built, along two axes run as parallel sub-agents: Rubric (does each section hold what a fresh implementer needs?) and Red team (where does the spec break under attack?). Use when the user wants a spec, PRD, or plan reviewed, asks whether a spec is ready for tickets or implementation, or wants a written spec attacked before it is built."
---

Two-axis review of a spec before it is built:

- **Rubric**: does each section hold what a fresh implementer needs to build the right thing and know when it is done?
- **Red team**: where does the spec break when someone attacks it?

Both axes run as **parallel sub-agents** that see the spec and the repo, never the conversation that produced the spec: a reviewer who has read the reasoning finds it convincing. This skill then aggregates their findings.

## Process

### 1. Pin the spec

Find the spec, in this order:

1. A reference passed as an argument: an issue number or URL (fetch the body and every comment via the tracker doc), or a file path.
2. A draft handed over by the calling skill, such as `spec-dev` reviewing its draft before publishing.
3. Otherwise, ask the user where the spec is.

A spec on the issue tracker needs the tracker doc. The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

Comments that amend a spec are part of it, so the spec text is the body plus its amending comments. Earlier review reports are not amendments, and a comment saying the body supersedes earlier comments retires every comment before it.

Record the spec's **version**: the issue's last-updated time, the file's latest commit, or `draft`. A review describes that version only; after any edit, review again.

### 2. Gather context pointers

Note where the sub-agents can check the spec against the project: `GLOSSARY.md` (or `GLOSSARY-MAP.md`), ADRs in `docs/adr/` that touch the area, and the repo root. Pass pointers rather than copies, so each sub-agent reads only what it needs.

### 3. Spawn both sub-agents in parallel

Issue both sub-agent calls together, in the foreground. A sub-agent has no access to this skill's files, so paste each reference it needs in full.

If you cannot spawn sub-agents, walk both axes yourself, one after the other, and label the report and its verdict **not independent**: you have seen the reasoning the review is meant to be blind to.

**Rubric sub-agent prompt** should include:

- The spec text and its version.
- The context pointers.
- [RUBRIC.md](RUBRIC.md) and the _Blocking vs judgement call_ section below, pasted in full.
- The brief: "Walk every applicable check in the rubric against the spec. For each finding, quote the spec passage it concerns (or name the absent section), say what a fresh implementer would get wrong, and give the fix direction. Mark each finding **blocking** or **judgement call**. Read the code, glossary, or ADR before reporting anything about it. Under 500 words."

**Red team sub-agent prompt** should include:

- The spec text and its version.
- The context pointers.
- [RED-TEAM.md](RED-TEAM.md) and the _Blocking vs judgement call_ section below, pasted in full.
- The brief: "Attack the spec through the red-team lenses. For each finding, quote the passage, state the attack, and say what goes wrong for whoever relies on it. Mark each finding **blocking** or **judgement call**. Quote the passage for every finding; for a gap, quote the passage it follows from. An empty report is a valid result. Under 400 words."

### 4. Aggregate

Present the two reports under `## Rubric` and `## Red team` headings, below a line naming the spec version reviewed. Pass them on verbatim when returning to a calling skill, which is usually the spec's author; otherwise verbatim or lightly cleaned. Keep the axes separate: merging or reranking across them lets a clean axis hide a failing one.

End with a one-line summary: blocking findings per axis, the worst issue _within each axis_, and whether the spec is **ready to build**.

### 5. Deliver

- **Draft from a calling skill**: return the report to the caller.
- **Otherwise**: report in the conversation. For a spec on the issue tracker, offer to post the report as a comment on the spec issue; post it only when the user asks.

The spec's author decides what changes. Every finding is input to that decision, so the spec itself stays as it is.

## Blocking vs judgement call

- **Blocking**: a fresh implementer, holding only this spec and the repo, would build the wrong thing or could not tell when they are done.
- **Judgement call**: the spec is buildable as written, but weaker than it should be.

A spec is **ready to build** when neither axis reports a blocking finding.

## Why two axes

The rubric measures the spec against what a spec should hold, so it finds what is missing or thin. The red team attacks what is there, so it finds what is present but wrong. A spec can pass one and fail the other:

- Every section filled in, but two of them quietly contradict each other → **Rubric pass, Red team fail.**
- Internally sharp, but ships a UI with no Interaction and States section → **Red team pass, Rubric fail.**
