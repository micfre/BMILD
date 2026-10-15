# Lenses

The branches a spec's design tree must visit, grouped by lens. Product and Testing apply to every spec; UX and Architecture apply when their trigger holds. A branch the code or the conversation already settles is a fact to state, not a question to ask.

## Product

- **Problem**: who has it, and what it costs them today.
- **Solution**: what changes for them, and how they would know it worked.
- **Success signal** (when a metric matters): the number, and how it could be gamed while the outcome gets worse.
- **Stories**: every actor; the happy path, then the failure and edge paths.
- **Journeys** (multi-step, user-facing flow): first ask for a real session (a _What only the user knows_ question). Shape only what the user supplied; with no real account, the journey is Illustrative and the gap is recorded.
- **Scope**: what a reader would assume is included but isn't, and what is deliberately later.

## UX

Trigger: the change has a user-facing surface.

- **States**: for each surface, empty, loading, error, offline, and permission-denied.
- **Copy**: the words that carry consequence (destructive confirmations, errors the user must act on).
- **Accessibility**: the obligations this surface carries.
- **Commitment**: what the user must see and be able to do is committed; component mechanics stay with the implementer.

## Architecture

Trigger: the change crosses a module boundary, touches data or schema, adds or changes an API or integration, or carries a quality requirement.

- **Dimensions**: boundaries and ownership, data and schema, APIs and integration, failure and consistency, security and trust, operations and observability, compatibility and migration. Each applicable one is decided or deferred with a reason. The operational envelope is the one most often left silent.
- **Consequence**: before asking about a decision, name its observable consequence. When the options would behave the same, the choice belongs to the implementer: leave it out of the spec.
- **Quality requirements**: a threshold and a way to observe it, for each one that bends a decision.

## Testing

- **Seams**: existing seams before new ones, the highest and fewest possible, each with what it catches and what it misses. Confirm them with the user. When where a seam belongs is itself in question, call the Skill tool with "codebase-design".
- **Proof**: for each story and quality requirement, grouped under the seam that proves it, the assertion that would fail if it regressed, failure paths included. Expected values come from the spec or a worked example, never recomputed the way the code computes them.
