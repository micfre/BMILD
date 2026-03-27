# Agents

The output of this project are the agent skills located in the `.agents/skills/` directory. Other files support development, testing and version control of the agent skills.

## Target platforms

- Antigravity
- Claude Code
- Cursor
- Kilo Code
- Opencode
- OpenAI Codex
- VS Code Copilot

## Memory structure

BMILD's memory is stored in folder `plans/` in project root. Personas read and write here to maintain context across sessions.
This can be structured alongside project source or kept separately — the personas resolve all paths relative to the project root.

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

## BMAD references

BMAD code and skill reference is stored in folder `_bmad\`
Ask for permission to access it when you need to, as it is ignored by default

## Documention

Keep README, AGENTS and CHANGELOG up to date as project evolves

## Versioning

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
