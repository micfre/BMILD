# Agents

The output of this project are the agent skills located in the `.agents/skills/` directory. Other files support development, testing and version control of the agent skills.

## Skill Development Guidelines

BMILD skills must follow these API-like design principles:

1. **Design the Signature First (`description`)**: 
   The `description` field in the frontmatter is the function signature. It must be specific about when to trigger and explicitly state what boundaries it does not cover (e.g., "Not for architectural design").
2. **Uniform skill structure**: 
   Each skill body uses these sections in this order:
   - **`Persona`**: Name, role, scope boundary, voice, and sign-off directive (`Sign off as [Name] [icon]`). Do not use `Always prefix` — identity is expressed at sign-off only.
   - **`Modes`**: Execution modes (e.g., "Feature mode", "Platform mode") and any execution phases.
   - **`## Activation`**: A lean 2–4 line principle. Do not narrate context loading. Do not ask questions already answered by loaded documents.
   - **`## Capabilities`**: The skill's core competencies. Skills that drive specification (PM, UX, Arch) include a `### Deeper Engagement` subsection that explicitly surfaces `bmild-elicit`, `bmild-debate`, and `bmild-propose` as active options at any point in the session.
   - **`## Partial Context Behavior`**: How the skill handles non-linear or incomplete context entry. For spec generation: treat gaps as elicitation opportunities, do not skip. For execution: infer and flag, do not block.
   - **`## BMILD Workflow Integration`**: Context loading paths, output artifact formats (with templates), handoff close, and thinking mode directive.
3. **Skill Structure**:
   Keep skill structure aligned across all personas to the extent that is reasonable to do to. Avoid patching a single skill as this may solve the local issue but will lead to drift that makes skills behave differently over time and create for more maintanace overhead.
4. **Context-Aware Personas**: 
   Personas do their own thinking and are not bound by prescriptive linear flows or rigid tiers. They are domain specialists activated by the artifact state. Personas focusing on specification (PM, UX, Arch) slow down, probe, and elicit — their job is to surface what would otherwise go unstated. Personas focusing on execution (Planner, Dev, QA, Sec) activate lean, act on coherent inputs, and hand back precisely when a blocker is outside their domain authority.
5. **Teach Reasoning**: 
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

BMILD's memory is stored in the folder specified by `plan_folder` in `.bmild.toml` (defaults to `plans/`) in the project root. Personas read and write here to maintain context across sessions.
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
        ├── rca-<slug>.md        # QA output: root cause analysis
        └── security-review-<slug>.md # Sec output: security findings
```

`_context.md` is the entry point for every persona. It lists documents that are currently `live` (in-use) vs. `archived`. Personas load only what is live and only what is relevant to the current engagement mode.

## Philosophical guidance

When faced with an ambiguous skill design choice use these points to align decisions:
- Resist patterns that funnel obvious progress through theatrical gates. Ceremony does not equate to rigor.
- Manage quality floor without limiting quality ceiling. Allow performant models to work to their fullest, don't let quality of output fall when using lower-parameter count models.

## External references

There are 3rd-party references in external_references\ which cover alternative and adjacent spec-driven agentic coding workflow implementations
Ask for permission to access it when you need to, as it is ignored by default
Do not make any modifications to any files in external_references\ folders

## Documention

Keep README, AGENTS and CHANGELOG up to date as project evolves

## Versioning

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
