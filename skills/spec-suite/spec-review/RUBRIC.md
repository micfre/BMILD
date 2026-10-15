# Rubric

Checks for a spec, grouped by section. A spec from `to-spec` carries Problem Statement, Solution, User Stories, Implementation Decisions, Testing Decisions, Out of Scope, and Further Notes. A spec from `spec-dev` may add Success Signal, User Journeys, Quality Requirements, Interaction and States, and Assumptions.

Apply a check only where its **trigger** holds. An absent section is a finding only when its trigger holds and nothing else in the spec covers it.

Each check reads _what good looks like_ → _the weak signal_.

## Problem and solution

- **Problem Statement**: names who has the problem and what it costs them, from their perspective. → Weak: a restated solution ("users need a dashboard"), or a problem that belongs to no one in particular.
- **Solution**: describes what changes for the user. → Weak: module names and implementation steps.
- **Success signal** (trigger: a metric or target matters to the outcome): observable, and paired with a counter-signal naming how the number could improve while the outcome gets worse. → Weak: "users love it"; a metric with no counter-signal.

## User stories and journeys

- **User Stories**: numbered, each `As an <actor>, I want <feature>, so that <benefit>`, covering failure and edge paths as well as the happy path. The numbers are the requirement IDs that tickets and reviews cite. → Weak: happy path only; a story that is really an implementation task; numbering that skips or repeats.
- **User Journeys** (trigger: the change has a multi-step, user-facing flow): each names a protagonist with context, the ordered path, the moment value should land, and the failure path, and is labelled **Firsthand** or **Illustrative**. A Firsthand journey cites where the account came from; an Illustrative one records the missing evidence. → Weak: a Firsthand label with no source; invented detail presented as observed.

## Quality requirements

Trigger: performance, scale, availability, security, privacy, accessibility, or compliance would bend a design decision.

- Each requirement has a threshold and a way to observe it, and rules something out. → Weak: "fast", "secure", or "scalable" with no number; a requirement no design choice would change for.

## Interaction and states

Trigger: the change has a user-facing surface.

- Each surface accounts for its empty, loading, error, offline, and permission-denied states, or marks a state not applicable with a reason. Consequential copy (destructive confirmations, errors the user must act on) and accessibility obligations are stated. → Weak: happy-state screens only; "show an error" with no behaviour behind it.

## Implementation decisions

- **Committed only**: every stated decision binds the build and has an observable consequence in behaviour, data, compatibility, quality, or operations. Anything unstated is the implementer's choice, and the section says so. → Weak: a choice between options with the same observable outcome (that choice belongs to the implementer); private structure specified to remove judgement.
- **Code agrees**: claims about current behaviour match the repo, and a decision that contradicts an ADR names it and says why. → Weak: a greenfield design for something the code already does; a silent ADR conflict.
- **Durable form**: interfaces, types, and behavioural contracts rather than file paths or code. The one exception is a prototype snippet that encodes a decision more precisely than prose, marked as coming from a prototype.
- **Dimensions swept**: each applicable dimension is decided, or deferred with a reason: boundaries and ownership, data and schema, APIs and integration, failure and consistency, security and trust, operations and observability, compatibility and migration. → Weak: an applicable dimension left silent. The operational envelope is the one most often missed.

## Testing decisions

- **Seams**: named, existing seams preferred, the highest and fewest possible, each with a note on what it catches and what it misses. → Weak: a bare list of seam names; a new seam where an existing one already reaches the behaviour.
- **Proof map**: every user story and quality requirement maps to a seam and to the observable assertion that would fail if it regressed, failure paths included. → Weak: a requirement with no proof; an assertion on internals rather than behaviour; "add tests".

A `to-spec` spec carries no proof map and no closing _implementer's choice_ line, because its template does not ask for them. Their absence alone is a judgement call. It becomes blocking only when the _Done-ness_ check finds a specific story whose completion is unclear, and that finding names the story.

## Scope and assumptions

- **Out of Scope**: names what a reasonable reader would otherwise assume is included. → Weak: empty, or listing only the obviously absent.
- **Assumptions**: each states its confidence and the consequence if wrong. → Weak: an assumption doing structural work with no consequence attached.

## Whole spec

- **Vocabulary**: domain terms match `GLOSSARY.md`. → Weak: a synonym the glossary lists under _Avoid_; a new term where the glossary already has one.
- **Done-ness**: a fresh implementer can tell when each story is done. → Weak: "gracefully", "reasonable", "user-friendly", "as appropriate".
- **Weight**: every section changes a downstream decision. → Weak: furniture, such as boilerplate quality requirements, a vision that fits any project, or a section filled in to look complete.
