![BMad Method](banner-bmild.png)
# Breakthrough Method for Interactive Leads Development
![Release](https://img.shields.io/github/v/release/micfre/BMILD?include_prereleases&label=Version)
[![Build Status](https://img.shields.io/github/actions/workflow/status/micfre/BMILD/release.yml?label=Build)](https://github.com/micfre/BMILD/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

BMILD is a set of agent Skills for moving from idea to shipped work without a heavy workflow wrapper. It keeps the lifecycle explicit, keeps the persona roster compact, and expects personas to read project context before they question you or start work.

## Start Here

You do not need to start at the beginning. Pick the stage you are in and invoke the matching persona.

| If you need to... | Start with | What they do |
| :--- | :--- | :--- |
| Shape an idea or define requirements | **Faisal (PM)** | Frames the problem, users, requirements, success criteria, and scope. |
| Design the frontend experience | **Katrina (UX)** | Defines flows, interaction model, information architecture, and visual direction. |
| Design the backend or system contracts | **Lance (Architect)** | Defines tech decisions, schema, APIs, and service contracts. |
| Break approved design into delivery work | **Sonia (Delivery Planner)** | Checks readiness, creates ordered Slices, sizes them to practical context limits, keeps Slice status legible, and reroutes when execution exposes blockers. |
| Implement a Slice | **Alex (Developer)** | Builds one Slice against the approved design contracts. |
| Diagnose an issue or verify quality | **Rahat (QA)** | Runs root-cause analysis, improves test coverage, and verifies quality gates. |
| Map a BMAD intent to BMILD | **Jump to BMAD Migration Guide** | Find the closest BMILD entry point without expecting persona parity. |

### Example Invocations

- "Faisal, help me frame a new feature for bulk account deactivation."
- "Katrina, design the onboarding flow for this feature."
- "Lance, design the backend contracts for this service."
- "Everyone, let's debate how to deal with cross-cutting on this requirement."
- "Sonia, assign this feature into implementation slices."
- "Alex, implement slice 2."
- "Rahat, verify slice 2 and review the test coverage."

## Lifecycle

BMILD's canonical lifecycle roster is:

1. **PM**: product framing and requirements
2. **UX**: frontend experience and interaction design
3. **Architect**: system design and technical contracts
4. **Delivery Planner**: readiness, Slice planning, context-aware Slice sizing, status visibility, and rerouting
5. **Developer**: Slice implementation
6. **QA**: verification, diagnosis, and regression protection

This is the primary working set. BMILD deliberately keeps it compact.

## How Handoffs Work

Primary personas are expected to behave as if they are joining an ongoing effort, not opening a blank slate.

Each persona should:

1. Read the relevant live context from `plans/`
2. State what stage or gap appears current
3. Ask only the next unresolved question, or take the next execution step

When a stage is complete enough to transfer, the persona should say:

1. What is now complete enough
2. What artifact was written or updated
3. Which persona should engage next and why

That means BMILD should tell you who comes next instead of making you infer it.

## BMAD Migration Guide

BMILD is BMAD-adjacent, but it is intentionally narrower. The goal is not persona-count parity. The goal is complete lifecycle coverage with fewer primary lanes and less process overhead.

| If you would have used BMAD for... | Start with BMILD |
| :--- | :--- |
| Product framing, PRD work, or requirement discovery | **Faisal (PM)** |
| UX flows, screens, or frontend behavior | **Katrina (UX)** |
| Architecture, schema, API design, or stack choices | **Lance (Architect)** |
| Release planning, readiness checks, or breaking work into delivery slices | **Sonia (Delivery Planner)** |
| Implementation | **Alex (Developer)** |
| Debugging, RCA, regression tests, or quality verification | **Rahat (QA)** |

What BMILD does not try to replicate:

- Large persona catalogs
- Workflow proliferation
- Scrum ceremony language
- Separate planning and status personas for work that Sonia can already own

## Modes

These are not additional primary lifecycle lanes:

- **Advanced Elicitation**: stress-test and refine an output
- **Interactive Leads**: structured multi-persona debate
- **Brainstorming**: facilitated ideation session

Use them when you need a different mode of thinking, not because the main lifecycle is missing a role.

## Why BMILD Feels Different

BMILD is simpler and more skill-native than BMAD-style setups:

- Fewer primary personas to juggle
- No installer or orchestrator required
- Built-in markdown memory under `plans/`
- Stronger debugging discipline through QA-led RCA

BMILD is also opinionated:

- AI work benefits from spec-driven execution
- Context management matters more than story-format purity
- Slice size should be shaped around effective context windows, not Scrum ritual

## Quick Start

1. Put the `.agents/skills` directory where your IDE or CLI expects skills.
2. Invoke the persona for the stage you are in.
3. Let that persona read context and route the next handoff.
4. If you want a compact first-run guide, read [BMILD_ONBOARDING.md](BMILD_ONBOARDING.md).

### Supported IDEs and CLIs

Until version v0.5, only Codex is being actively tested.

Direct drop-in:

| Environment | Scan Location |
| :--- | :--- |
| **Antigravity** | `.agents/skills/` |
| **OpenAI Codex** | `.agents/skills/` |

Relocate to:

| Environment | Scan Location |
| :--- | :--- |
| **Claude Code** | `.claude/skills/` |
| **Cursor** | `.cursor/skills/` |
| **Kilo Code** | `.kilocode/skills/` |
| **Opencode** | `.opencode/skills/` |
| **VS Code Copilot** | `.github/skills/` |

### Skill Folders

```text
.agents/
└── skills/
    ├── bmild-arch/          # Architect
    ├── bmild-brainstorming/ # Brainstorming facilitator
    ├── bmild-dev/           # Developer
    ├── bmild-elicit/        # Advanced Elicitation
    ├── bmild-debate/            # Interactive Leads
    ├── bmild-planner/       # Delivery Planner
    ├── bmild-pm/            # Product Manager
    ├── bmild-qa/            # QA
    └── bmild-ux/            # UX Designer
```

Each skill folder contains a `SKILL.md` and, for multi-step skills, a `steps/` subdirectory.

## Memory Model

BMILD writes working memory into a `plans/` directory at the project root so personas can situate themselves across sessions.

```text
plans/
├── platform/
│   ├── _context.md
│   ├── spec.md
│   ├── ux-design.md
│   ├── system-design.md
│   └── slices.md
└── features/
    └── <feature-name>/
        ├── _context.md
        ├── spec.md
        ├── ux-design.md
        ├── system-design.md
        ├── slices.md
        ├── slice-<N>.md
        └── rca-<slug>.md
```

`_context.md` is the entry point. Personas load only the `live` documents relevant to the current engagement mode.

## BMAD Compatibility

BMILD and BMAD should not be installed side by side when their trigger phrases overlap.

- To use BMILD, install the `bmild-*` skills and remove or archive the `bmad-*` skills from the same skill path.
- When you stop using BMILD, remove the `bmild-*` skills. Any `plans/` memory files stay in your project unless you choose to delete them.

## Available Skills

### Primary Personas

- **Faisal (PM)**: problem framing, user needs, requirements elicitation
- **Katrina (UX Designer)**: interaction model, visual design, user flows
- **Lance (Architect)**: system design, database schema, API contracts
- **Sonia (Delivery Planner)**: readiness, Slice decomposition, Slice flow visibility, rerouting
- **Alex (Developer)**: Slice implementation
- **Rahat (QA)**: root cause analysis, diagnosis, quality gates

### Special Modes

- **Advanced Elicitation**
- **Interactive Leads**
- **Brainstorming**

## Roadmap

- v0.2 Persona breadth stable
- v0.3 Persona interactivity stable
- v0.4 Dogfood version
- v0.5 First public version

## Acknowledgements

BMILD is built upon and inspired by the following projects:

- **[BMAD-METHOD](https://github.com/the-bmad-group/bmad)**: core persona archetypes and interactive patterns are adapted from BMAD.
- **[Kilo Code](https://github.com/kilo-code)**: the QA debugging methodology is adapted from Kilo Code's debug prompt.

All referenced materials are used in accordance with their respective MIT licenses.

---

\* BMILD is not trying to be "better than BMAD" in the abstract. It is a narrower fit for teams or individuals who want fewer personas and lighter process.

\*\* Slice sizing guidance is based on practical context-window limits in modern coding agents rather than on Agile story semantics.
