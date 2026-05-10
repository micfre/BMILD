# Agents

The output of this project are the agent skills located in the `.agents/skills/` directory. Other files support development, testing and version control of the agent skills.

## Skill Development Guidelines

BMILD skills must follow these API-like design principles:

1. **Follow the Spec**:
   The official specification in `docs/` is authoritative — mirror and enforce its rules across skills (triggers, frontmatter, structure, and behavior).
2. **Uniform skill structure**:
   Each skill body uses these sections in this order:
   - **`Persona`** (the unlabelled lead paragraph after the frontmatter): Name, role, scope boundary, and voice. Do not include pronoun labels. Do not use `Always prefix` — identity is expressed in the opening operating stance and final sign-off only.
   - **`## BMILD Working Team`**: Positive frame for how the skill contributes to the team value chain, which teammates depend on its output, why interactivity matters, when advanced team tools such as `bmild-debate`, `bmild-elicit`, or `bmild-brainstorming` are useful, and the persona-name rule (refer to teammates by persona name, never skill name).
   - **`## Activation`**: Unified entry sequence — resolve environment from `.bmild.toml`, determine scope, load context memory, load persona inputs, handle incomplete context, open with one compact operating stance line, then begin. Standard skills use the full sequence; cross-cutting skills use a simplified version.
   - **`## Workflow`**: Linear process, mode variants, retry loops, scope checkpoints, and the first actionable "begin" behaviour. Modes are workflow modifiers, not a separate instruction set. True ordered work uses a `Progress:` checklist with `- [ ] Step N: ...`; general guidelines use prose or ordinary bullets.
   - **`## Capabilities`**: The skill's toolkit, named modes, and reusable techniques.
   - **`## Definition of Done`**: Quality bar, success criteria, verification checks, and evidence required before handoff.
   - **`## Standards`** (named per skill, e.g., `## Elicitation Standards`, `## Design Standards`, `## Planning Standards`, `## Verification Standards`, `## Security Review Standards`, `## Pre-Edit Discipline`): Craft rules that apply across all modes — coaching posture, gap checklists, decision-handling, debate/elicit/brainstorm trigger heuristics, pre-artifact checkpoints. Mode documents govern sequence; this section governs craft.
   - **`## Exit and Handoff`** (Standard skills only): Unified exit sequence — write artifact using templates in `assets/`, register in context memory, check gates, close with handoff statement, and sign off as `[Name] [icon]`. Cross-cutting skills omit this section. The persona-name rule lives in BMILD Working Team, not here.
   - **`## Scope Boundary`**: What the skill explicitly does not do.
   - **`## Gotchas`**: High-value corrections from real execution traces. Use for facts that defy reasonable assumptions or steer unpredicted events; do not restate rules already established elsewhere.

   Artifact templates live in each skill's `assets/`. Context memory templates live in each skill's `assets/context-memory-template.md`.
3. **Skill Structure**:
   Keep skill structure aligned across all personas to the extent that is reasonable to do to. Avoid patching a single skill as this may solve the local issue but will lead to drift that makes skills behave differently over time and create for more maintanace overhead.
   Named standard personas open with one compact operating stance line: `[Name] [icon] — <mode/work type>. Scope: <scope>. <boundary statement>.` This anchors identity and mode for weaker harnesses without repeating persona labels across every paragraph. Cross-cutting skills do not use this pattern unless specifically designed for it.
   Modes describe why the skill is being invoked: user intent, entry condition, or artifact state. Avoid mode names that only describe internal mechanics, effort level, or implementation texture. Author capabilities as shared behaviours plus mode-specific behaviours so common discipline stays consistent while each mode has a clear persistence, handoff, and documentation contract.
4. **Context-Aware Personas**:
   Personas do their own thinking and are not bound by prescriptive linear flows or rigid tiers. They are domain specialists activated by the artifact state. Personas focusing on specification (PM, UX, Arch) slow down, probe, and elicit — their job is to surface what would otherwise go unstated. Personas focusing on execution (Planner, Dev, QA, Sec) activate lean, act on coherent inputs, and hand back precisely when a blocker is outside their domain authority.
5. **Context Loading Policy**:
   - PM and Dev usually reload memory artifacts because they often run in fresh windows. Dev may skip BMILD memory reads in Prototype or Bug Fix Mode when the work is local and does not depend on documented behaviour, but should still persist a lightweight Dev note when the change can affect future understanding.
   - UX and Arch may skip disk reads only when the required artifact contents are visibly present in the current conversation and are not likely stale; otherwise reload.
   - Planner, QA, and Sec always reload relevant live artifacts because errors cascade from stale planning, verification, and review context.
   - Advanced modes (Debate, Brainstorming, Elicit) prefer the current conversation context and only read memory when the invoked topic cannot be grounded from chat.
6. **Teach Reasoning**:
   Do not just list rules. Explain what goes wrong without the pattern, how to diagnose it, and provide before/after examples.
7. **Prefer Subtle, Iterative Changes**:
   Treat feedback as refinements. Make small, deliberate edits rather than broad rewrites; each change should be reversible and minimal.
8. **Avoid fragile markdown tables in skill outputs**:
   Some harnesses render or parse tables poorly. Prefer compact bullet structures for conversational output and artifact templates unless a table is clearly more reliable in the target environment.

### Skills Documentation

- specification: <https://agentskills.io/specification>
- best practices: <https://agentskills.io/skill-creation/best-practices>

## Target platforms

- WSL
- Linux
- macOS

- Antigravity
- Claude Code
- Cursor
- Kilo Code
- Opencode
- OpenAI Codex
- VS Code Copilot (WSL)

## Configuration (`.bmild.toml`)

Project-level settings are defined in `.bmild.toml` at the repository root. The personas read these configurations to dynamically adapt their behavior.

- `plan_folder`: (Default: `"plans/"`) Directory where BMILD's memory artifacts (specs, designs, slices) are stored. Used globally by all personas to read and write context files.
- `user_name`: (Optional) The user's preferred name. Used by named personas (e.g., Faisal, Katrina, Sonia) to address the user personally in their conversational responses.
- `slice_target`: (Default: `170000`) Target context token limit for sizing vertical implementation slices. Used by `bmild-planner` (Sonia) when performing Slice Budgeting to evaluate if work exceeds safe token boundaries.

## Memory structure

BMILD's memory is stored in the folder specified by `plan_folder` in `.bmild.toml` (defaults to `plans/`) in the project root. Personas read and write here to maintain context across sessions.
This can be structured alongside project source or kept separately — the personas resolve all paths relative to the project root.

```
plans/ (or your custom plan_folder)
├── CHARTER.md                   # PM output: emergent — seeded only when a project-level invariant is established or a cross-initiative conflict is resolved
├── _system/                     # Global constraints, shared architecture, tech stack
│   ├── _context.md              # Index of live documents — all personas read this first
│   ├── _rollup.md               # Central registry of all active features/initiatives
│   ├── ARCHITECTURE.md          # Arch output: durable rationale (tech stack, invariants, alternatives rejected)
│   └── DESIGN.md                # UX output: durable global patterns (palette, typography, component rules)
└── <initiative-name>/           # The atomic unit of work (Feature / Initiative)
    ├── _context.md              # Index of live documents for this initiative
    ├── product-brief.md         # PM output: problem, users, success criteria, scope, vision
    ├── prd.md                   # PM output: requirements, journeys, prioritization, NFRs, doc scope
    ├── ux-design.md             # UX output: initiative-specific flows, screen states, interaction rules
    ├── system-design.md         # Arch output: schema, API contracts, service contracts, tech choices
    ├── verification-matrix.md   # Planner/QA proof map for requirements and Slices
    ├── slices.md                # Planner output: Slice registry
    ├── slice-<N>.md             # One file per Slice
    ├── dev-note-<slug>.md       # Dev output for prototype and bug-fix memory
    ├── rca-<slug>.md            # QA output: root cause analysis
    └── security-review-<slug>.md # Sec output: security findings
```

`ARCHITECTURE.md` and `DESIGN.md` may live at the project root or under `plans/_system/`, depending on project convention. They carry rationale and durable patterns; operator mechanics (commands, conventions, gates) live in `AGENTS.md`/`CLAUDE.md`/`README.md`. Lance and Katrina cross-link rather than restate.

`_context.md` is the entry point for every persona. It lists documents that are currently `live` (in-use) vs. `archived`. Personas load only what is live and only what is relevant to the current engagement mode.

### `_context.md` format

Every `_context.md` follows this structure (template in each skill's `assets/context-memory-template.md`):

```markdown
---
scope: <initiative-name> | _system
updated: YYYY-MM-DD
---

## Live
- product-brief.md
- prd.md
- ux-design.md

## Archived
```

- `## Live` — filenames of artifacts currently in use. One per line, prefixed with `- `.
- `## Archived` — filenames of superseded artifacts, same format.
- Frontmatter `scope` identifies the initiative or if it is the global `_system` context.
- Frontmatter `updated` is the date of the last change.

### Cross-artifact flow

- `product-brief.md`: created by Faisal; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines problem, users, success criteria, scope, and vision. Entry contract for downstream design.
- `prd.md`: created by Faisal once a brief exists; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines functional requirements, journeys, prioritization (MVP / Growth), NFRs, and required documentation updates (README, contributor guides, runbooks, release notes, onboarding, user-facing help). Validated through coverage checks and verification matrix entries.
- `CHARTER.md`: emergent project-level artifact at `plans/CHARTER.md`. Seeded or updated by Faisal only when an initiative establishes a project-level invariant (vision, target users, competitive positioning), conflicts with a sibling initiative's `product-brief.md`, or the user explicitly requests it. Consumed by all design-tier personas as a constraint when present; absent on most projects until a coherence-forcing event occurs.
- `ARCHITECTURE.md`: created and maintained by Lance; carries rationale (tech stack, invariants Alex must respect, migration patterns, alternatives rejected). Cross-links to `AGENTS.md`/`CLAUDE.md`/`README.md` for operator mechanics rather than restating them.
- `DESIGN.md`: created and maintained by Katrina; carries durable global UX patterns (palette, typography, global component rules) distilled from initiative-specific UX work.
- `ux-design.md`: created by Katrina; consumed by Lance, Sonia, Alex, Rahat, and Zach; validated through observable user-state checks.
- `system-design.md`: created by Lance; consumed by Sonia, Alex, Rahat, and Zach; validated through implementability, testability, and security review.
- `slices.md` and `slice-<N>.md`: created by Sonia; consumed and updated by Alex; verified by Rahat and Zach; recut by Sonia when implementation reveals a planning problem.
- `dev-note-<slug>.md`: created or updated by Alex for Prototype and Bug Fix work that changes durable behaviour, leaves reusable code, records fix rationale, or creates future-spec facts; consumed by Faisal, Katrina, Lance, Sonia, Rahat, and Zach when formalizing, verifying, or reviewing later work.
- `verification-matrix.md`: created by Sonia during readiness when proof boundaries matter; repaired or expanded by Rahat; consumed by Alex; validated by Rahat during verification.
- `rca-<slug>.md`: created or updated by Rahat for confirmed defects; consumed by Alex for fixes; closed by Rahat after evidence shows the regression is covered.
- `security-review-<slug>.md`: created by Zach when exploitable findings exist; consumed by Alex for implementation fixes or Lance/Katrina for design changes; closed by Zach after remediation is verified.
- Documentation files: requirements defined by Faisal, implemented by Alex, and verified by Rahat against the shipped behaviour.

RCA path rule: initiative-linked defects live in the initiative folder. `_system/rca-<slug>.md` is valid only for genuinely global defects with no initiative, Slice, or initiative `_context.md` owner.

## Philosophical guidance

When faced with an ambiguous skill design choice use these points to align decisions:
- Resist patterns that funnel obvious progress through theatrical gates. Ceremony does not equate to rigor.
- Manage quality floor without limiting quality ceiling. Allow performant models to work to their fullest, don't let quality of output fall when using lower-parameter count models.

## External references

There are 3rd-party references in external_references\ which cover alternative and adjacent spec-driven agentic coding workflow implementations
Ask for permission to access it when you need to, as it is ignored by default
Do not make any modifications to any files in external_references\ folders

## Documentation

Keep README, AGENTS and CHANGELOG up to date as project evolves. PM defines which documentation needs to change, Dev owns the edits, and QA verifies that the resulting documentation matches implemented behaviour.

## Versioning

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
