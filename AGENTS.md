# Agents

The output of this project are the agent skills located in the `.agents/skills/` directory. Other files support development, testing and version control of the agent skills.

## Skill Development Guidelines

BMILD skills must follow these API-like design principles:

1. **Design the Signature First (`description`)**: 
   The `description` field in the frontmatter is the function signature. It must be specific about when to trigger and explicitly state what boundaries it does not cover (e.g., "Not for architectural design").
2. **Top-of-Body Directives**: 
   Immediately following the frontmatter, standardize the framing:
   - **Persona**: 1-2 sentences defining the character and angle.
   - **Thinking mode**: (Optional) e.g., use an explicit deep reasoning mode for complex architectural decisions.
   - **Modes**: Outline specific execution modes (e.g., "Feature mode", "Platform mode", "Review mode").
3. **Teach Reasoning**: 
   Do not just list rules. Explain what goes wrong without the pattern, how to diagnose it, and provide before/after examples.

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
