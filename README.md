![BMad Method](banner-bmild.png)
# Breakthrough Method for Interactive Leads Development
![Version](https://img.shields.io/badge/ver-0.1-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

BMILD is a set of agent Skills designed for leading complex development tasks through persona-driven interactions (Product Manager, Architect, UX Designer, Developer, QA, etc.).
BMILD heavily leverages BMAD-METHOD's approach but narrows it and simplifies it. I enjoy many aspects of BMAD, particularly Party Mode, but overall it is process-heavy and can promote fatigue for many tasks.
BMILD is Skill-native and dependency-free, requires no "installation" (just drop folders in the right place) and is just as easily backed out.

## Assuming you have awareness of BMAD, and that's why you are here:

**BMILD is simpler and Skills-native**

- Reduced number of agent personas, less juggling
- No installation, and easy backout if it's not a good fit for you

**BMILD is not better\* than BMAD, but it has some improvements**

- Built-in memory that is written by the agent personas themselves, without any orchestrator required
  - An understanding of efforts that are platform-wide (major horizontal refactors) or feature-specific
  - Sequential efforts are just as easy to get into as the greenfield project, memory is not confused by several coincident or completed projects in the memory workspace
- Greatly improved debugging workflow
  - Implements a strict root cause analysis protocol, which forces a breadth-first hypothesis generation before narrowing options for fixes, backed by instrumentation, before touching code

**BMILD is opinionated**

You have to believe this to believe that BMILD is a good fit for your way of working:
- AI development benefits greatly from a spec-driven approach and this upfront investment pays dividends
- AI development is not the same as "human" development when it comes to development effort (story points) and communication friction, for which epics, stories, sprints are heavily weighted to help manage — and therefore AI development does not benefit from directly replicating these aspects of Agile when it comes to scope decomposition, atomic development units and debugging workflow
  - AI will make it up or ignore it if it is not properly specified, so it's worth taking the time to properly specify it
  - AI needs good context management -- not an INVESTable story -- to produce good code, so build development slices around context windows not stories

## If you are new to BMAD and BMILD, here's what it can do for you:

# Core Principles

- **Persona-Driven**: Interactions mimic a cross-functional team.
- **Spec-Driven**: Every step is guided by clear design contracts.

## Quick Start

1. Put the `.agents/skills` directory where your IDE or CLI will find it
2. Call on the PM persona, Faisal, to get started with your idea
3. Party Mode is called Interactive Leads here, but you can just call for a "debate" at any time

## The Longer Version

### IDE and CLI support

BMILD is Skills-native and will work with any IDE or CLI that supports agent Skills.
It's just files, so can be shared across teams with version control

### BMAD Compatibility

BMILD is inherently incompatible with BMAD because the skills have the same or similar listening triggers, and an agent could flip a BMAD skill or a BMILD skill non-deterministically.
 - When you want to use BMILD, put `bmild-*` skills in the agent skills folder
 - When you no longer want to use BMILD, delete `bmild-*` skills from the agent skills folder. BMILD creates memory file structure in the project root directorey at plans\ so those files will remain (and you probably want them to)

## Differences from BMAD

- BMAD has many more agents and discrete workflows
- BMILD has six agents with broader yet non-overlapped domains and perspectives that still cover the end-to-end development lifecycle


- BMAD offers highly valuable advanced elicitation, Party Mode, and brainstorming modes
- BMILD offers these three as well, renaming Party Mode to Interactive Leads but you can always just ask for a "debate"


- BMAD has personas with names and icons
- BMILD drops the icons in favor of equally-clear but less-cute colored squares, and tones down the ceremony, and replaces names with some of the greats I have worked with in my past experience (I would be tickled if they recognized themselves)


- BMAD is well-tuned for large, greenfield projects and is less well-tuned for sequential feature development
- BMILD responds well to greenfield, platform-level brownfield (large refactors) and feature-specific development. In fact, it's the first question that the PM will ask you


- BMAD follows Agile principles closely through the full lifecycle, no surprise, that's the intent and it does it well
- BMILD, as a highly-opinionated deviation, believes that context window is a more important dimension around which to subdivide a development
- BMILD uses features (primary value delivery unit) and slices (single-context window development unit) to decompose the spec into delivered work


- BMAD decomposes scope into Agile-defined Epics and Stories
- BMILD tunes to one context window for the development slice, specifically targeting 170K tokens which is ~70% of the common 250K effective context window of many modern coding agents**


- BMAD has a broken debug prompt (in my opinion) which railroads the agent into choosing a single domain or service layer and a single cause for observed problems
- BMILD has the QA persona handle both test implementation and issue resolution, using a strict RCA and evidence-led protocol before any code is touched. Dev can do it for typos and direct fixes, but QA does it so much better


- BMAD is transitioning*** to a Skill-centric approach, but many or most of the workflows are managed in several, deep proprietary workflow files with a Skill "wrapper" in place
- BMILD is fully Skill-native, it doesn't call other code, it doesn't have deeply nested workflows


- BMAD has first-class support for Claude Code, Cursor and Codex CLI
- BMILD doesn't need IDE- or harness-specific tooling, as it leverages the Skills standard (only folder structure is different)

## Folder structure

### Agent skills

```
.agents/
└── skills/
    ├── bmild-arch/          # Architect
    ├── bmild-brainstorming/ # Brainstorming facilitator
    ├── bmild-dev/           # Developer
    ├── bmild-elicit/        # Advanced Elicitation
    ├── bmild-il/            # Interactive Leads
    ├── bmild-planner/       # Planner
    ├── bmild-pm/            # Product Manager
    ├── bmild-qa/            # QA
    └── bmild-ux/            # UX Designer
```

Each skill folder contains a `SKILL.md` and, for multi-step skills, a `steps/` subdirectory.

### Supported IDEs and CLIs

Many agentic environments will support the Skill folder pattern. Put Skills found in `.agents/skills` folder in the path expected by your tool:

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

### BMILD memory

BMILD's memory lives in a `plans/` directory at your project root. Personas read and write here to maintain context across sessions. You can structure this alongside your project source or keep it separate — the personas resolve all paths relative to the project root.

```
plans/
├── platform/                    # Platform-level context (greenfield or large refactors)
│   ├── _context.md              # Index of live documents — all personas read this first
│   ├── spec.md                  # PM output: problem statement, requirements, success criteria
│   ├── ux-design.md             # UX output: interaction model, visual language, flows
│   ├── system-design.md         # Arch output: schema, API contracts, tech decisions
│   └── slices.md                # Planner output: platform-level Slice registry
└── features/
    └── <feature-name>/          # One folder per feature
        ├── _context.md          # Index of live documents for this feature
        ├── spec.md              # PM output
        ├── ux-design.md         # UX output
        ├── system-design.md     # Arch output
        ├── slices.md            # Planner output: Slice registry
        ├── slice-<N>.md         # One file per Slice
        └── rca-<slug>.md        # QA output: root cause analysis
```

`_context.md` is the entry point for every persona. It lists documents that are currently `live` (in-use) vs. `archived`. Personas load only what is live and only what is relevant to the current engagement mode.

## Available Skills

### Personas

- **Faisal (PM)**: Problem framing, user needs, requirements elicitation.
- **Katrina (UX Designer)**: Interaction model, visual design, user flows.
- **Lance (Architect)**: System design, database schema, API contracts.
- **Sonia (Planner)**: Decomposes designed features into ordered, implementable Slices.
- **Alex (Developer)**: Implements Slices following design contracts.
- **Rahat (QA)**: Root cause analysis, diagnosis, quality gates.

### Special modes

- **Advanced Elicitation**: Stress-tests and refines outputs.
- **Interactive Leads (debate)**: Structured multi-persona design debate.
- **Brainstorming**: Facilitated brainstorming session.

## Acknowledgements

BMILD is built upon and inspired by the following projects:

- **[BMAD-METHOD](https://github.com/the-bmad-group/bmad)**: Core persona archetypes and interactive patterns (Party Mode, Advanced Elicitation, Brainstorming) are adapted from the BMAD project.
- **[Kilo Code](https://github.com/kilo-code)**: The systematic debugging methodology used by the QA persona is adapted from Kilo Code's debug prompt.

All referenced materials are used in accordance with their respective MIT licenses.

---

\* - I have no desire to offend any die hard BMAD adherents, I am here myself because I chose BMAD over alternatives for my own work, and I am simply offering an alternative that I have shaped and grown to appreciate. The only thing I am perhaps overly fond of is the name, I do like it

\*\* at the time I am writing this, based on early version 6 releases

\*\*\* of course 1 million token context windows exist, but context recall degrades sharply at higher token utilization (the "Lost in the Middle" phenomenon or as demonstrated by "Needle in a Haystack" / NIAH benchmarks)