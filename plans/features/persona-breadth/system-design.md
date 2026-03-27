---
feature: persona-breadth
updated: 2026-03-27
author: bmild-arch
---

## Tech Stack
| Layer | Choice | Notes |
|-------|--------|-------|
| Runtime | N/A | Documentation and skill-contract feature; no runtime change |
| Framework | Agent Skills (`SKILL.md` + `steps/`) | Existing BMILD skill structure remains authoritative |
| UI Components | Markdown docs + conversational outputs | No component-library decision required |
| Storage | `plans/` markdown memory model | Existing context-file pattern remains unchanged |
| Dependencies | None added | No installer, scripting, or new tool dependency is in scope |

## Database Schema Changes
No database changes. This feature operates entirely within repository documentation and skill prompt contracts.

## API Contracts
No network or HTTP API changes. The relevant contracts are skill-behavior contracts inside the repository.

## Service Contracts
### Persona Activation Contract
All primary personas must follow the same activation sequence at the contract level:

1. Resolve engagement mode and scope.
2. Read `plans/platform/_context.md` if present.
3. In feature mode, read `plans/features/<feature-name>/_context.md` if present.
4. Load all `live` entries from the relevant `_context.md`.
5. Read the persona's primary upstream artifact before asking substantive questions:
   - PM -> existing context only
   - UX -> `spec.md`
   - Arch -> `spec.md`
   - Delivery Planner -> `ux-design.md` and `system-design.md`
   - Dev -> active `slice-<N>.md` plus referenced design docs
   - QA -> relevant `slice-<N>.md`, `AGENTS.md`, and other live context as needed
6. Narrate loaded context briefly before the next elicitation or execution step.

**Contract rule:** a persona must not open with questions that are already answerable from live context.

### Persona Opening Contract
Each primary persona opening should contain four elements in order:

1. Scope statement: feature / platform / greenfield mode.
2. Context statement: which files were loaded.
3. Situation statement: what stage appears current or what gap exists.
4. Next action: one precise question or one precise execution statement.

**Example shape:**
- "I loaded `spec.md` and `ux-design.md` for `persona-breadth`."
- "The feature already has product framing and UX guidance; I'm entering at the design-decomposition stage."

### Persona Handoff Contract
Each primary persona closing should contain three elements:

1. Completion statement: what is now complete enough.
2. Artifact statement: which document was written or updated.
3. Routing statement: who should engage next and why.

**Contract rule:** handoffs must name the next persona explicitly. "Ready for the next step" without naming the next role is insufficient.

### Canonical Persona Registry Contract
BMILD should present a canonical ordered lifecycle roster in public docs and onboarding:

1. PM
2. UX
3. Arch
4. Delivery Planner
5. Dev
6. QA

Supporting modes remain separate from the lifecycle roster:
- Brainstorming
- Advanced Elicitation
- Interactive Leads

**Contract rule:** helper personas, if ever added, must be documented as navigational or bridging aids, never as additional primary lifecycle lanes.

### Rename Contract: `planner` -> `Delivery Planner`
The user-facing role label changes from `Planner` to `Delivery Planner`.

Approved role statement:
`Delivery Planner` is BMILD's implementation-orchestration persona. It ensures a feature is ready to enter Slice-based delivery, decomposes approved design into ordered Slices, maintains visibility into Slice progress, and helps route the next Slice or planning adjustment when execution reveals blockers, gaps, or change pressure. It owns readiness, sequencing, status clarity, and rerouting around the Slice plan. It does not own Scrum ceremonies, people-process management, stakeholder facilitation, deployment coordination, or generic project management.

Apply consistently in:
- `README.md`
- skill descriptions and output wording
- onboarding examples
- handoff phrasing
- migration guidance

Internal file-system path may remain `bmild-planner` for compatibility unless a separate compatibility decision is made later.

**Compatibility note:** if the folder path remains `bmild-planner`, user-facing copy must avoid exposing the mismatch except where installation layout makes the folder name unavoidable.

## Architectural Decisions
### Decision: Treat persona breadth as a contract problem, not a persona-count problem
- **Decided:** Improve lifecycle coverage perception through clearer contracts, naming, onboarding, and handoffs before introducing any new helper personas.
- **Rationale:** The spec identifies the main failure mode as confusion and perceived incompleteness, not proven absence of capability.
- **Alternatives considered:** Add more personas to mirror BMAD more closely.
- **Implementation discretion:** A helper persona can still be proposed later if evidence shows users are leaving the normal flow to seek orientation externally.

### Decision: Standardize context-first behavior across personas
- **Decided:** All primary personas must read live context first and acknowledge it before questioning or routing.
- **Rationale:** This directly addresses the observed anti-pattern of personas acting like they are seeing the project for the first time.
- **Alternatives considered:** Solve the issue through docs alone.
- **Implementation discretion:** Wording can vary by persona, but the loading and narration steps are mandatory.

### Decision: Keep the primary lifecycle compact and explicit
- **Decided:** Present one canonical lifecycle roster and distinguish it from special modes.
- **Rationale:** Users need a clear "who next" model more than a large catalog.
- **Alternatives considered:** Flat presentation of all personas and modes together.
- **Implementation discretion:** README and onboarding may visually group design-layer and execution-layer roles if UX decides it improves scanning.

### Decision: Adopt `Delivery Planner` as the public role name
- **Decided:** Replace user-facing `Planner` references with `Delivery Planner`.
- **Rationale:** It is clearer than `Planner`, lighter than Agile-derived labels, and less misleading than `Release Planner`.
- **Alternatives considered:** `Slice Planner`, `Release Planner`, `Scrum Master`.
- **Implementation discretion:** A future compatibility decision may rename the underlying skill folder, but that is not required for this feature.

## Open Technical Questions
- Should the repository rename `.agents/skills/bmild-planner/` to match the public-facing `Delivery Planner` label, or preserve the folder name for trigger stability through `v0.5`?
- What exact shared wording should be copied into each primary persona's `SKILL.md` to enforce the opening and handoff contracts without making all personas sound identical?
- Should BMAD migration guidance live only in `README.md`, or also in a dedicated migration document referenced from the top-level onboarding path?

## Archived Decisions
None.
