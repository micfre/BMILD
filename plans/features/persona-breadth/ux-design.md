---
feature: persona-breadth
updated: 2026-03-27
author: bmild-ux
---

## Navigation & Information Architecture
This feature designs BMILD's user-facing navigation across three linked surfaces:

1. `README.md` as the primary discovery and decision surface.
2. Onboarding guidance as the first-run orientation surface.
3. Persona handoffs as the in-flow navigation surface once the user is already engaged.

The core UX decision is to organize BMILD around **lifecycle stage entry** rather than around a long persona catalog. Users should be able to answer three questions quickly:

- Where do I start?
- Who should I talk to next?
- If I came from BMAD, what is the BMILD equivalent for the job I am trying to do?

Recommended information architecture for `README.md`:

1. **Promise / Positioning**
   Short statement of what BMILD is and why it exists: simpler, milder, still lifecycle-complete.
2. **Start Here**
   A small decision section that routes users by intent:
   - "I have an idea"
   - "I need to design a feature"
   - "I need to break work into slices"
   - "I need to build"
   - "I need to debug or improve test coverage"
   - "I know BMAD and want the BMILD equivalent"
3. **Primary Persona Roster**
   Present the canonical working set with one-line job statements in lifecycle order.
4. **How Handoffs Work**
   Explain that personas read context first, then either continue the current stage or route the user to the next one.
5. **BMAD Migration Guide**
   Intent-based mapping, not one-to-one persona parity.
6. **Modes**
   Brainstorming, Advanced Elicitation, Interactive Leads.
7. **Memory Model**
   Keep the existing `plans/` explanation, but position it as the reason BMILD personas can situate themselves.

Recommended onboarding structure:

- **Entry question:** "What stage are you at?"
- **Secondary reassurance:** "You do not need to start at the beginning. BMILD can join midstream."
- **Suggested invocation examples:** one short example per lifecycle stage.
- **Migration branch for BMAD users:** "If you would have used X intent in BMAD, start with Y here."

Recommended persona-navigation model:

- Personas should present themselves as entering an ongoing effort, not opening a blank slate.
- Each persona should briefly narrate what context was loaded and what territory it is taking ownership of.
- When a stage is complete enough for transfer, the persona should recommend the next persona explicitly rather than relying on the user to infer it.

## User Flows
### Flow: New User Starts From Scratch
Entry point: `README.md`.

1. User lands on the repo and reads the promise statement.
2. User reaches a "Start Here" section that routes by intent, not by jargon.
3. User sees the recommended first persona for their current stage.
4. User invokes that persona with a plain-language request.
5. Persona reads available context.
6. Persona states what it loaded, what it understands, and asks only the next necessary question.
Exit condition: user is active in the correct lifecycle stage without external clarification.

Error paths and edge cases:
- If the user is unfamiliar with lifecycle stages, the route labels must use plain language and examples.
- If no context exists yet, the persona may say it is starting fresh, but should still frame the stage confidently.

### Flow: BMAD Migrant Looks For Equivalent Capability
Entry point: `README.md`.

1. User recognizes BMILD as BMAD-adjacent and scans for differences.
2. User enters a migration-oriented section labeled for BMAD users.
3. User finds an intent-based mapping table:
   - "Need product framing" -> PM
   - "Need UX" -> UX
   - "Need architecture" -> Arch
   - "Need release planning / slice decomposition" -> Planner or renamed equivalent
   - "Need implementation" -> Dev
   - "Need debugging or test augmentation" -> QA
4. User also sees what BMILD intentionally does not replicate: many personas, workflow proliferation, and process heaviness.
5. User starts with the mapped BMILD persona and experiences a context-aware handoff model.
Exit condition: user feels BMILD is intentionally narrower, not missing capability.

Error paths and edge cases:
- If the user expects persona-count parity, the migration copy must directly explain why BMILD does not pursue that.
- If the user is looking for a non-existent helper role, the docs should route them to the nearest primary persona or supported mode.

### Flow: User Enters Mid-Lifecycle
Entry point: direct persona invocation from chat.

1. User invokes a persona for the stage they are in, such as UX, Arch, Planner, Dev, or QA.
2. Persona reads `_context.md` and relevant live documents before questioning the user.
3. Persona briefly states what context it loaded and what appears to be current.
4. Persona asks only for missing information required to proceed in that stage.
5. When its work reaches a natural boundary, it recommends the next persona explicitly.
Exit condition: the user remains in-flow without needing docs or community help to determine next steps.

Error paths and edge cases:
- If context is partial or stale, the persona should identify the gap precisely rather than resetting the conversation.
- If required upstream artifacts are missing, the persona should route back to the correct predecessor persona with a short explanation.

### Flow: Handoff Between Personas
Entry point: current persona finishes a meaningful checkpoint.

1. Persona completes its document or decision checkpoint.
2. Persona states that the work is ready enough for the next stage.
3. Persona names the next persona and why that handoff is appropriate now.
4. If another design-layer artifact is still required, the persona says so plainly rather than implying readiness.
Exit condition: the user can continue by invoking the named next persona without ambiguity.

Error paths and edge cases:
- If the next step depends on both UX and architecture, the handoff must say that both are needed before planning.
- If a blocker belongs to an earlier stage, the handoff should point backward explicitly rather than letting the user guess.

## Screens / Views
### README Discovery Surface
- Layout: positioning section, start-here routing section, persona roster, migration guide, modes, memory model.
- Data displayed: BMILD promise, lifecycle map, canonical persona roster, BMAD migration mapping, invocation examples.
- User actions available: identify starting stage, select a persona, understand the next stage, understand BMILD-vs-BMAD tradeoffs.
- States:
  - Populated: all sections present and scannable.
  - Error equivalent: if the copy is too comparative or too abstract, users leave without knowing where to begin.

### Onboarding Decision Surface
- Layout: short orientation, stage-based choices, example prompts, reassurance for midstream entry.
- Data displayed: stage labels, recommended persona, one-sentence role definition, example invocation.
- User actions available: pick a stage, invoke a persona, branch into BMAD migration guidance.
- States:
  - Empty: no prior context exists.
  - Contextual: existing `plans/` docs exist, so onboarding emphasizes "jump in where you are."

### Persona Handoff Surface
- Layout: compact closing statement at the end of a persona checkpoint.
- Data displayed: what was completed, what remains, who should engage next, and any dependency caveat.
- User actions available: continue to the named persona, pause for review, or loop back if a dependency is missing.
- States:
  - Ready-for-next-stage
  - Blocked-on-missing-upstream-context
  - Needs-parallel-design-input

## Interaction Model
- `README.md` should function as a routing interface, not a manifesto. Dense philosophy belongs below the first routing decision.
- The first visible CTA should be stage-based and action-oriented, not "meet the personas."
- Canonical persona presentation should follow lifecycle order because users mentally model process before identity.
- BMAD migration guidance should map intents and outcomes, not attempt persona-by-persona imitation.
- Persona openings should follow a shared pattern:
  - State engagement mode and feature/platform scope.
  - State which context files were read.
  - State what seems to be the current stage or gap.
  - Ask the next question only if needed.
- Persona closings should follow a shared pattern:
  - State what is now complete.
  - State what artifact was written or updated.
  - Recommend the next persona or explain why the current stage is still blocked.
- If a persona enters without any prior context, it may say so once, but should immediately orient around the user's current stage rather than around its own lack of history.
- The planner role needs UX clarification because "planner" is generic and process-heavy. The user-facing label should emphasize release planning and Slice decomposition. A rename is likely warranted if product confirms it.

## Visual Design Language
### Colour
This feature is primarily documentation and conversational UX. Preserve the existing BMILD repo visual style, but make the persona and stage navigation more scannable.

| Role | Value |
|------|-------|
| Primary | Existing BMILD blue |
| Secondary | Existing BMILD neutral dark |
| Success | Green for "ready for next stage" cues |
| Warning | Amber for "blocked / missing upstream artifact" cues |
| Info | Blue for migration and onboarding notes |

### Typography
Use the existing repo typography. Improve hierarchy through section naming and list structure rather than by introducing a new visual system.

| Role | Family | Weight | Size |
|------|--------|--------|------|
| README section heading | Existing markdown rendering | Bold | Existing |
| Persona/stage labels | Existing markdown rendering | Bold | Existing |
| Example prompt text | Existing markdown rendering | Regular | Existing |

### Spacing
Base unit: existing markdown spacing conventions.
Scale: use short sections, compact bullets, and tables only where scanning benefits materially.

### Motion
No motion requirement. This is static documentation plus conversational behavior.

## Component Notes
- Recommended documentation components:
  - Lifecycle stage table or ordered list
  - Intent-to-persona mapping table for BMAD migrants
  - "Start here" cards or clearly separated subsections
  - Short example prompt blocks
- Recommended conversational components across personas:
  - Standardized "context loaded" opening
  - Standardized "next persona" closing
- If a helper persona is ever introduced, it should be framed as a navigator or bridge, not as a new primary lane in the lifecycle map.

## Open UX Questions
- Should the canonical public roster include Dev and Planner in the same prominence tier as PM, Arch, UX, and QA, or should the README visually distinguish design-layer personas from execution-layer personas?
- What user-facing name best replaces `planner`, if renaming proceeds?
- Should BMAD migration guidance live inline in `README.md`, or split between `README.md` and a dedicated migration doc linked near the top?
- How explicit should the handoff language be in persona outputs before it starts to feel repetitive?

## debate session: Rename `planner` to `Delivery Planner` (2026-03-27)

### Non-negotiable
- `planner` is too vague as a public-facing label.
- The replacement must clearly signal the stage after design and before implementation.
- The label must preserve BMILD's lighter-weight identity and avoid importing Agile ceremony.
- `Scrum Master` is out of bounds because it implies process ownership BMILD does not want.
- The role still owns Slice decomposition and sequencing, not delivery management or release operations.

### Preference
| Option | Who favoured it | Why | Cost |
|--------|------------------|-----|------|
| Delivery Planner | Faisal, Katrina, Rahat, user | Clear in the lifecycle flow, legible to new users, migration-friendly, low ceremony | Less explicitly BMILD-branded than a Slice-based label |
| Slice Planner | Katrina (partial) | Highlights BMILD's distinctive Slice model | Depends on users already understanding BMILD vocabulary |
| Release Planner | Lance (initially) | Familiar and concrete | Suggests operational release accountability the persona does not actually own |

### Open (deferred)
- Reflect `Delivery Planner` consistently in README lifecycle maps, onboarding examples, and persona handoff copy.

## Approved Role Statement: Delivery Planner (2026-03-27)
`Delivery Planner` is BMILD's implementation-orchestration persona. It ensures a feature is ready to enter Slice-based delivery, decomposes approved design into ordered Slices, maintains visibility into Slice progress, and helps route the next Slice or planning adjustment when execution reveals blockers, gaps, or change pressure. It owns readiness, sequencing, status clarity, and rerouting around the Slice plan. It does not own Scrum ceremonies, people-process management, stakeholder facilitation, deployment coordination, or generic project management.
