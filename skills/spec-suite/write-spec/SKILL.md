---
name: spec-dev
description: "Develop a spec by guided interview across product, UX, architecture, and testing, review it, and publish it to the issue tracker."
disable-model-invocation: true
---

Develop a spec with the user by interview, then review it and publish it. Where `to-spec` synthesizes a conversation that already happened, this skill drives the conversation: it seeds the design tree from the lenses, draws out what the user knows but hasn't said, and doesn't publish until `spec-review` finds nothing blocking.

The issue tracker and triage label vocabulary should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

## Process

### 1. Explore

Explore the repo to understand the current state of the code in the area the spec touches. Use the project's domain glossary vocabulary throughout, and respect any ADRs in the area.

If the user passed an existing spec (an issue reference or a path), fetch it with its comments. What it settles counts as decided; the session deepens it.

### 2. Grill

Call the Skill tool twice, for "grilling" and "domain-modeling". Seed the design tree from [LENSES.md](LENSES.md): every branch of each lens whose trigger holds.

A **one-way door** (scope, committed implementation decisions, seams) is where the two references below apply; a **two-way door** rides in whichever round is open.

- **[ARTICULATE.md](ARTICULATE.md)**: when the user plainly knows more than they have said, ask the branch's next question through an articulation method.
- **[DELIBERATE.md](DELIBERATE.md)**: when a one-way door has several defensible options and the user is torn, have each option argued in parallel before putting the question.

When a branch needs a runnable answer (a state model you have to watch change, a UI you have to see), pause and offer the user a prototype detour: `/handoff` out, `/prototype` in a fresh session, `/handoff` back. Fold its verdict back in as the answer.

#### What only the user knows

Some questions ask for knowledge only the user holds: a real session, an incident, a stakeholder's constraint, a value. A recommended answer there would put words in the user's mouth, so these questions carry a marker in place of the recommendation:

```
❓ **Q3** - **Evidence for the onboarding journey**: Describe a real session where someone tried to onboard and it went wrong: who, what they did, where value should have landed, what broke.

🔒 Only you know this. If you have no real account, say so and I'll record the journey as Illustrative with the evidence gap noted.
```

Decisions, and facts you could look up, keep grilling's recommended answer.

### 3. Draft

Write the spec using the template below. Include a conditional section only when its [LENSES.md](LENSES.md) trigger holds.

The finished draft carries everything the session settled, so it is the safe point to compact if the session nears the smart zone.

### 4. Review

Call the Skill tool with "spec-review", handing it the draft text rather than an issue reference, so it reviews the draft and not the published version.

- Fix each finding the conversation or the code already answers, and state each fix in one line.
- Put the blocking findings that need a user decision to the user as the next grilling round; batch the remaining judgement calls into one round with your recommended answers.
- When the user dismisses a finding, record the decision and its reason in the spec (Assumptions or Out of Scope), so the next reviewer, who never sees this conversation, sees the reasoning.

Revise the draft and review again. The spec is done when `spec-review` reports no blocking finding the user has not dismissed, on either axis, and the user confirms you have reached a shared understanding.

### 5. Publish

Publish the spec to the issue tracker and apply the `ready-for-agent` triage label. When the session started from an existing spec, update that issue in place: the new body absorbs its amending comments, and one new comment says the body supersedes every comment before it.

<spec-template>

## Problem Statement

Who has the problem and what it costs them, from their perspective.

## Solution

What changes for the user, from their perspective.

## Success Signal

_Conditional._ The observable signal, and the counter-signal that would show the number improving while the outcome gets worse.

## User Stories

A LONG, numbered list covering every aspect of the feature, failure and edge paths included. The numbers are the requirement IDs that tickets and reviews cite.

1. As an <actor>, I want a <feature>, so that <benefit>

## User Journeys

_Conditional._ Per journey: the protagonist and their context, the ordered path, the moment value should land, and the failure path. Label each **Firsthand** (with its source: who told it, when) or **Illustrative** (with the missing evidence).

## Quality Requirements

_Conditional._ Each with a threshold and how it is observed.

## Interaction and States

_Conditional._ Per surface: the empty, loading, error, offline, and permission-denied states (or why one does not apply), consequential copy, and accessibility obligations.

## Implementation Decisions

The decisions that bind the build, each with its observable consequence: modules and their interfaces, schema changes, API contracts, failure behaviour, and the like. Close with one line: everything not stated here is the implementer's choice.

Describe interfaces, types, and behavioural contracts rather than file paths or code: those go stale fast. Exception: a prototype snippet that encodes a decision more precisely than prose (state machine, reducer, schema, type shape), trimmed to the decision-rich parts and marked as coming from a prototype.

## Testing Decisions

- **Proof map, grouped by seam**: for each seam under test, what it catches and what it misses, then every user story and quality requirement it proves, each with the observable assertion that fails if it regresses. A story no seam proves is listed under its own heading with the reason.

  ```
  - Checkout interface: catches payment and cart outcomes; misses rendering.
    - Story 4: an expired card returns a declined result and the cart is left intact.
  ```

- **Prior art**: similar tests already in the codebase.

## Out of Scope

What a reasonable reader would otherwise assume is included.

## Assumptions

Each assumption with its confidence and the consequence if wrong. Every unanswered _What only the user knows_ question, deferred decision, and Illustrative journey becomes one.

## Further Notes

Anything else a fresh implementer needs.

</spec-template>
