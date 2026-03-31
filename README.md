![BMad Method](banner-bmild.png)
# Breakthrough Method for Interactive Leads Development
![Release](https://img.shields.io/github/v/release/micfre/BMILD?include_prereleases&label=Version)
[![Build Status](https://img.shields.io/github/actions/workflow/status/micfre/BMILD/release.yml?label=Build)](https://github.com/micfre/BMILD/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

BMILD is a set of agent Skills for moving from idea to shipped work without a heavy workflow wrapper. It keeps the lifecycle explicit, keeps the persona roster compact, and expects personas to read project context before they question you or start work.

## Quick Start

1. Put the `.agents/skills` directory where your IDE or CLI expects skills.
2. Invoke the persona for the stage you are in.
3. Let that persona read context and route the next handoff.

## Working with BMILD

You do not need to start at the beginning. Pick the stage you are in and invoke the matching persona.

| If you need to... | Start with | What they do |
| :--- | :--- | :--- |
| Shape an idea or define requirements | **Faisal (PM)** | Frames the problem, users, requirements, success criteria, and scope. |
| Design the frontend experience | **Katrina (UX)** | Defines flows, interaction model, information architecture, and visual direction. |
| Design the backend or system contracts | **Lance (Architect)** | Defines tech decisions, schema, APIs, and service contracts. |
| Break approved design into delivery work | **Sonia (Delivery Planner)** | Checks readiness, creates ordered Slices, sizes them to practical context limits, keeps Slice status legible, and reroutes when execution exposes blockers. |
| Implement a Slice | **Alex (Developer)** | Builds one Slice against the approved design contracts. |
| Diagnose an issue or verify quality | **Rahat (QA)** | Runs root-cause analysis, improves test coverage, and verifies quality gates. |

### Example Phrasing

- "Faisal, help me frame a new feature for bulk account deactivation."
- "Katrina, design the onboarding flow for this feature."
- "Lance, design the backend contracts for this service."
- "Everyone, let's debate how to deal with cross-cutting on this requirement."
- "Sonia, assign this feature into implementation slices."
- "Alex, implement slice 2."
- "Rahat, verify slice 2 and review the test coverage."

### Advanced Interactive Modes

- **Brainstorming**
- **Debate**
- **Elicitation**

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

BMILD is milder and narrower than BMAD. The goal is complete lifecycle coverage with fewer primary lanes and less overhead from ceremony.
The goal is not to be AGILE-parity particularly in planning and delivery phases. Epics, Stories and Sprints are replaced by Features and Slices.
The excellent interactive mode concepts from BMAD are adopted in BMILD. Ask for a 'debate' rather than Party Mode.

| If you would have used BMAD for... | Start with BMILD |
| :--- | :--- |
| Product framing, PRD work, or requirement discovery | **Faisal (PM)** |
| UX flows, screens, or frontend behavior | **Katrina (UX)** |
| Architecture, schema, API design, or stack choices | **Lance (Architect)** |
| Release planning, readiness checks, or breaking work into delivery slices | **Sonia (Delivery Planner)** |
| Implementation | **Alex (Developer)** |
| Debugging, RCA, regression tests, or quality verification | **Rahat (QA)** |

## BMAD Compatibility

BMILD and BMAD should not be installed side by side when their trigger phrases overlap.

- To use BMILD, install the `bmild-*` skills and remove or archive the `bmad-*` skills from the same skill path.
- When you stop using BMILD, remove the `bmild-*` skills. Any `plans/` memory files stay in your project unless you choose to delete them.

## Why BMILD Feels Different

BMILD is narrower and milder, yet responsive to context and semantics for an adaptive workflow:

- Skill-native, works anywhere that supports agent skills standard
- Conversational, context-aware and non-linear workflow
- Built-in memory using simple markdown under `plans/` managed by the personas themselves
- No installer, dependencies or orchestrator required

BMILD is also opinionated about where to speed up versus slow down:

- Modern execution-focused LLMs inherently want to start immediately and get to green fast
  - The design personas ensure that the user drives the pace and the priorty is on full coverage and solid specs
  - The delivery personas lean into speed and efficiency of the development agentic loop with less process overhead
- Context management matters more than story-format purity
  - The planner persona builds slices so each will consume about one fresh context window when implemented
  - Slices remain vertically-oriented where appropriate, and unit testable

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
    ├── bmild-brainstorming/ # Brainstorming mode
    ├── bmild-dev/           # Developer
    ├── bmild-elicit/        # Advanced Elicitation mode
    ├── bmild-debate/        # Debate mode
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

## Roadmap

- v0.2 Persona breadth stable
- v0.3 Persona interactivity stable
- v0.4 Dogfood version
- v0.5 First public version

## Acknowledgements

BMILD is built upon and inspired by the following projects:

- **[BMAD-METHOD](https://github.com/the-bmad-group/bmad)**: core persona archetypes and interactive patterns are adapted from BMAD.
- **[Kilo Code](https://github.com/kilo-code)**: the QA debugging methodology is adapted from Kilo Code's debug prompt.
- **[Tokencast](https://github.com/krulewis/tokencast)**: the tokenizer algorithm used by Planner persona adapted from krulewis' version in tokencast.

All referenced materials are used in accordance with their respective MIT licenses.

---

\* BMILD is not trying to be "better than BMAD" in the abstract. It is a narrower fit for teams or individuals who want fewer personas and lighter process.

\*\* Slice sizing guidance is based on practical context-window limits in modern coding agents rather than on Agile story semantics.
