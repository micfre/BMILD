---
feature: persona-breadth
updated: 2026-03-27
author: bmild-pm
---

## Problem Statement
BMILD needs clearer end-to-end persona coverage and smoother lifecycle transitions so new users, current users, and BMAD migrants can move from ideation to shipped feature without feeling that a needed perspective is missing.

## Context
BMILD's promise is a narrower, milder BMAD: simpler, less formal, and more adaptable. The risk is that users, especially BMAD migrants familiar with a larger persona roster, may interpret the smaller BMILD cast as incomplete, unclear, or incapable. The first-contact surfaces that matter most are `README.md`, onboarding, and persona handoff behavior.

## Users / Stakeholders
- New users evaluating BMILD for the first time and trying to decide where to start.
- Existing BMAD users migrating workflows and looking for equivalent capability coverage.
- Current BMILD users who need reliable guidance through the next lifecycle stage.
- Maintainers responsible for preserving BMILD's "mild" philosophy while improving clarity and coverage.

## Requirements
### Must Have
- BMILD must visibly cover the full intended lifecycle: ideation, product framing with PRD documentation, UX design, architecture, slice planning, development, and QA for both test augmentation and debugging.
- The `Delivery Planner` role must cover the BMILD equivalents of implementation-readiness checking, Slice-plan creation, and Slice-progress routing/status visibility.
- The `Delivery Planner` role must be responsible for ensuring a feature is ready to enter Slice-based implementation and for helping users understand what Slice should happen next during execution.
- Users must be able to enter at any lifecycle stage conversationally, without needing to study the full docs first.
- Personas must situate themselves by reading existing feature or platform context before asking discovery questions.
- Personas must avoid signaling that they are encountering the platform or feature for the first time when relevant context already exists.
- Persona handoffs must reduce user guesswork about who to engage next.
- `README.md` and onboarding must make the BMILD persona system feel complete, simple, and intentional rather than reduced or underpowered.
- BMAD migrants must have a clear way to map familiar intents to BMILD personas without requiring BMAD persona-for-persona parity.
- The solution must preserve BMILD's mild philosophy: fewer primary interaction personas, less process overhead, and more adaptable behavior.
- Any additional personas introduced must be helper personas only, not new primary interaction personas.
- Interactive Leads must remain constrained to the current four primary interaction personas for the next several releases.
- The feature must target Codex CLI only through `v0.5`; other supported skill platforms are out of scope for this work.

### Should Have
- Evaluate whether current persona names, especially `planner`, create unnecessary ambiguity and should be renamed.
- Provide migration-oriented documentation that specifically addresses BMAD converts.
- Clarify the "mild" product philosophy where needed if it improves user comprehension without changing the core promise.

### Out of Scope
- Recreating BMAD's full persona roster or pursuing persona-count parity.
- Introducing Scrum ceremonies, sprint ritual management, or people-process facilitation under a BMILD label.
- Adding new workflow modes beyond brainstorming, advanced elicitation, and interactive leads.
- Introducing installers, automation scripts, or scripted onboarding.
- Expanding Interactive Leads beyond the current primary-persona set in the near term.
- Supporting non-Codex target platforms before `v0.5`.
- Publishing git Releases before `v0.4`.
- Changing the core BMILD philosophy away from being simpler and milder than BMAD.

## Success Criteria
- A new user can identify a sensible starting persona from the primary onboarding surfaces without external help.
- A BMAD migrant can map their intent to a BMILD persona or path without concluding that BMILD lacks a necessary capability.
- A user can move from one lifecycle stage to the next without guessing which persona should take over.
- Users can begin work at any lifecycle stage and encounter personas that first situate themselves from existing context before asking only unresolved questions.
- No major intended lifecycle stage feels uncovered by BMILD's persona system.
- Maintainers observe reduced cases of users bouncing to GitHub Issues or Discord because they cannot identify the right persona or next step.

## Open Questions
- What exact public-facing persona roster should BMILD present as canonical, given the distinction between the broader working set and the four personas hardcoded into Interactive Leads?
- What specific handoff language or protocol changes should be standardized across all primary personas?
- What threshold of observed confusion is sufficient to justify adding a helper persona instead of solving the issue through naming, onboarding, or handoff improvements?
- What BMAD concepts or persona expectations most need explicit migration guidance in `README.md` or onboarding?
- What exact user-facing verbs should describe `Delivery Planner` so users understand that it checks readiness, creates Slices, tracks Slice progress, and reroutes work when implementation uncovers change?

## Assumptions
- The current risk is primarily one of clarity, perceived coverage, and lifecycle navigation rather than a proven need for many additional personas.
- Documentation is important for onboarding, but normal-course lifecycle movement should be guided mostly by persona behavior and handoffs.
- Keeping the primary interaction model compact is more important than maximizing persona specialization.
- BMAD distributes planning and in-flight coordination across the Scrum Master persona and separate readiness / sprint-status workflows; BMILD can consolidate the equivalent user need into `Delivery Planner` without inheriting Scrum framing.
- Helper personas may be acceptable if evidence shows that real users are leaving the product flow to ask for orientation externally.

## IL Session: Rename `planner` to `Delivery Planner` (2026-03-27)

### Non-negotiable
- `planner` is too vague as a user-facing name.
- The replacement should help users understand the stage transition from completed design into ordered implementation work.
- The name must preserve BMILD's mild philosophy and avoid reintroducing Agile ceremony.
- `Scrum Master` is not appropriate because it imports process expectations BMILD explicitly rejects.
- The role remains focused on decomposing work into development Slices, not on managing people, ceremonies, or release operations.

### Preference
| Option | Who favoured it | Why | Cost |
|--------|------------------|-----|------|
| Delivery Planner | Faisal, Katrina, Rahat, user | Plain-language, stage-clear, avoids Agile baggage, understandable to new users and BMAD migrants | Slightly less BMILD-specific than a Slice-based label |
| Slice Planner | Katrina (partial) | Strongly expresses BMILD's distinct method | Requires prior understanding of BMILD terminology |
| Release Planner | Lance (initially) | Familiar and concrete | Risks implying operational release ownership the role does not have |

### Open (deferred)
- Apply `Delivery Planner` consistently across public docs, onboarding prompts, skill descriptions, and handoff language.

## Approved Role Statement: Delivery Planner (2026-03-27)
`Delivery Planner` is BMILD's implementation-orchestration persona. It ensures a feature is ready to enter Slice-based delivery, decomposes approved design into ordered Slices, maintains visibility into Slice progress, and helps route the next Slice or planning adjustment when execution reveals blockers, gaps, or change pressure. It owns readiness, sequencing, status clarity, and rerouting around the Slice plan. It does not own Scrum ceremonies, people-process management, stakeholder facilitation, deployment coordination, or generic project management.
