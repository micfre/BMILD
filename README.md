![BMILD](banner-bmild.png)

# BMILD

*Big Methods, Ideally Less Drama*

<!-- bmild-version-badge -->
![Version](https://img.shields.io/badge/Version-0.2.9-orange)
[![Build Status](https://img.shields.io/github/actions/workflow/status/micfre/BMILD/ci.yml?label=Build%20Status)](https://github.com/micfre/BMILD/actions/workflows/ci.yml)
[![Release Status](https://github.com/micfre/BMILD/actions/workflows/release.yml/badge.svg)](https://github.com/micfre/BMILD/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

BMILD gives you and your AI coding agent a cross-functional team from a handful of skill folders. Drop the folders next to your code, call a persona by name, and work spec-driven without the ceremony.

Just files. No installer, no dependencies, no orchestrator. Skill-native prompts and an optional TOML for repo preferences.

---

## Why BMILD exists

1. **Solid specs lead to verifiable code.** The upfront work of specifying what you are building pays back when the agent writes code. Under-specified work leads to fast code creation but can leave critical decisions in the hands of the LLM, which can take more time to fix. This is really just why Spec-Driven Development exists. Good spec up front, less drama on the back. BMILD provides an agentic loop for SDD.

2. **BMAD-METHOD is excellent, and was my preferred framework.** I built both greenfield and features with BMAD and after learning its ways, it became enjoyable. I found however that I had to fit its model and endure its stepwise process more than I wanted. No criticism intended, BMAD is great and deserves a place at the top of agentic SDD but I wanted something more flexible, less theatrical, and as performant. BMILD was born out of BMAD, leveraging many of its concepts.

3. **AI needs context management, not Agile ceremony.** Epics, stories, sprints, and points exist to coordinate people and estimate human effort. AI has different constraints. It benefits from development units sized to context windows and from clear, verifiable design contracts to build against.

BMAD runs the full Agile-with-AI ceremony and does it well. BMILD grew out of BMAD and takes a narrower path.

## How the work flows

Personas are not pipeline stages. They activate by the state of your artifacts, so you can enter anywhere. Have a half-formed idea? Faisal frames it. Already know the UX? Start with Katrina. A slice is drafted and waiting? Hand it to Alex. Each persona reads the memory folder, tells you what looks current and complete, and routes to whoever should engage next.

The common path runs frame, design, plan, implement, verify, and the personas come in two tiers. The **design tier** (Faisal, Katrina, Lance) is deliberate: they probe and elicit to surface what would go unstated, and they hold the pace against the agent's pull toward starting fast. The **execution tier** (Sonia, Alex, Rahat, Zach) plans and implements with context-bounded units and verification pre-planned in. Sonia is the pivot: readiness is enforced at her step, and the running memory lives there.

The path is a map of who owns what, not a gate you must walk in order. You enter wherever the work is.

## The team

Ten skill folders. Each holds a prompt that gives your agent a persona with a defined role, a voice, and strict scope boundaries.

| Persona | Role | What they do |
| :--- | :--- | :--- |
| **Faisal**&nbsp;🟦 | Product Manager | Frames the problem and requirements. Probes the "why" and resists vague specs. |
| **Katrina**&nbsp;🟩 | UX Designer | Owns the frontend experience: flows, states, interaction rules. Decisive about users, aware of what is buildable. |
| **Lance**&nbsp;🟫 | Architect | Produces implementable contracts: schema columns, endpoint shapes, service signatures. Names the cost of every choice. |
| **Sonia**&nbsp;🟧 | Delivery Planner | Enforces readiness and sizes work to context windows. Zero tolerance for ambiguity in implementation inputs. |
| **Alex**&nbsp;🟪 | Developer | Implements planned Slices, prototypes bounded work, and fixes bugs. Matches existing patterns and promotes durable truth upstream. |
| **Rahat**&nbsp;🟨 | QA & Reliability | Diagnoses before fixing. Applies minimal confirmed fixes when evidence is clear and persists RCA for future context. |
| **Zach**&nbsp;🟥 | Security | Contextual SAST review. Prioritizes high-confidence, exploitable findings over theoretical noise. |

Plus three interactive modes that work across personas:

- **Roundtable** 🌀: structured multi-persona deliberation with attendance set per question. The convened leads surface trade-offs as Non-negotiable, Preference, or Open, without recommending a decision. You decide; the owning persona patches. ("Debate" remains a valid trigger; the rename reflects what the skill does.)
- **Elicit** ⚡: helps you expand your own thinking. 20+ structured methods to push requirements, UX, or architecture past "good enough."
- **Brainstorm** 💡: open-ended ideation to get past the obvious answers. Anti-bias protocols keep the facilitator from clustering around a single direction.

## Every document has an author, a consumer, and a reviewer

Each artifact names who writes it, who reads it, and who verifies it. Faisal authors the PRD; Katrina, Lance, Sonia, Rahat, and Zach read it as upstream truth; Rahat verifies the shipped behaviour against it. These lines are what let a persona enter mid-stream and know immediately what is fixed and what it owns. AGENTS.md carries the full author, consumer, and reviewer map.

## Slices, not stories

Development units are sized to a context window, not to Agile story points. A Slice is a vertical unit budgeted with a real tokenizer to fit one implementation session, because important detail gets lost in the middle of large context windows (see Needle-in-a-Haystack benchmarks). Slices are sequenced by the MVP, Growth, and Vision cuts in the product spec. The budget math runs in the planner skill folder, `scripts/run-budget-slice.sh`, against the `slice_target`, `tokenizer_base`, and `tokenizer_multiplier` you set in `.bmild.toml`.

## Keeping specs honest

Specs drift. The code changes, decisions get made in chat, an upstream artifact shifts and the downstream ones go stale. BMILD treats drift as the central problem and holds it with three coordinated mechanisms:

- **Shared meaning.** `context.md` carries initiative-local terms and boundaries; `context-map.md` carries the cross-initiative map. When a word means two things, the glossary catches it before it reaches code.
- **Durable decisions.** A choice that is hard to reverse, surprising without context, and the result of a real trade-off promotes to an ADR in `adr/`. Everything else stays in `system-design.md`, so active rationale is not buried in an archive.
- **Coordinated correction.** When a change needs another owner, it routes through `handoff.md` instead of being absorbed silently. The owning persona promotes the resolution into the target artifact, so authoritative truth always lives in source artifacts, not in handoff history.

## A voice that travels

Each persona carries a distinct, fully-formed voice, and it shows up intact in two places beyond its own workflow. In a **Roundtable**, the convened leads argue a bounded question in their own register, with attendance set per question, and surface trade-offs as Non-negotiable, Preference, or Open without recommending a decision. In a **guest appearance**, one persona scribes a settled fact into another owner's artifact and speaks in that owner's voice while doing it. The voice lives next to the skill, in `SOUL.md`, so it loads on demand without dragging the whole persona along. The scribe eligibility gate lives in `docs/scribe-path.md`.

**AGENTS.md is the authoritative reference** for the artifact list, the memory folder layout, the `registry.md` format, and the full governance rules. The rest of this README is conceptual.

## Memory layout

Personas write plain markdown to the folder set by `plan_folder` in `.bmild.toml` (default `plans/`). Paths resolve relative to the project root, so memory can live alongside source or separate from it.

```
<project-root>/
├── .bmild.toml                       # BMILD preferences (optional)
├── DESIGN.md                         # durable global UX patterns                        Katrina 🟩
└── plans/                            # or your own specified plan_folder
    ├── context-map.md                # cross-initiative semantic map
    ├── rollup.md                     # initiative index, aliases, status, decision log
    ├── adr/                          # drift-protection architecture design records
    └── <initiative>/                 # per named initiative, always lowercase kebab-case
        ├── registry.md               # live / archived / stale artifact state
        ├── context.md                # drift protection terms, boundaries, relationships
        ├── product-brief.md          # problem space, success criteria, scope            Faisal 🟦
        ├── prd.md                    # functional requirements, journeys, prioritization Faisal 🟦
        ├── ux-design.md              # user experience decisions and specs               Katrina 🟩
        ├── system-design.md          # architectural decisions and specs                 Lance 🟫
        ├── handoff.md                # owner-to-owner coordination (PR-like in function)
        ├── change-proposal-<slug>.md # course-correction
        ├── verification-matrix.md    # Nyquist verification matrix                       Sonia 🟧
        ├── slices.md, slice-<N>.md   # task decomposition, implementation plans          Sonia 🟧
        ├── rca-<slug>.md             # debug discovery and root cause analysis           Rahat 🟨
        └── security-review-<slug>.md # SAST review notes                                 Zach 🟥
```

When you name an initiative, personas check the initiative folder first, then `rollup.md`. Initiative work starts from `registry.md`, loads `context.md` and the live artifacts, and skips anything marked stale.

## "Standards" aware file structure

Katrina 🟩 writes to `DESIGN.md` for global patterns, as well as to `ux-design.md` for initiative-scoped specs, ensuring compliance with repos that leverage Google's **[DESIGN.md](https://github.com/google-labs-code/design.md)** spec

BMILD is compatible with Google's **[OKF](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)** (Open Knowledge Format) spec. The `plans_folder` acts as an OKF bundle: every memory artifact carries OKF frontmatter and graph-traversal links so the corpus is ingestible by OKF consumers.

## Project configuration

Project-level settings live in `.bmild.toml` at the repository root. Personas read them to adapt their behavior.

- `plan_folder`: (default `"plans/"`) directory where memory artifacts (specs, designs, slices) are stored. Used globally to read and write context files.
- `user_name`: (optional) your preferred name. Used by named personas to address you in their responses.
- `slice_target`: (default `170000`) target context tokens for sizing vertical slices. Used by Sonia when budgeting slices.
- `tokenizer_base`: (default `15000`) base token cost used by the slice-budgeting tokenizer.
- `tokenizer_multiplier`: (default `1.00`) multiplier applied by the slice-budgeting tokenizer.

## Getting started

1. Put the `.agents/skills/` directory where your IDE or CLI looks for skills (see below).
2. (optional) Update `.bmild.toml` with your (or your team's) name, and your preferred location on disk for the plan folder.
3. Say: `Faisal, help me frame a feature for [your idea].`
4. Follow the handoffs. Faisal will tell you who is next.

Or jump in wherever makes sense:

| Where you are | Who to call | What to say |
| :--- | :--- | :--- |
| I have an idea | **Faisal** 🟦 | `Faisal, help me frame a feature for [idea].` |
| I know what to build, need the UX | **Katrina** 🟩 | `Katrina, design the user experience for [feature].` |
| I need backend contracts | **Lance** 🟫 | `Lance, design the API and data model for [feature].` |
| Design is done, need a plan | **Sonia** 🟧 | `Sonia, check readiness and decompose into slices.` |
| I have a slice ready to build | **Alex** 🟪 | `Alex, implement slice 3.` |
| Something is broken | **Rahat** 🟨 | `Rahat, diagnose this failure.` |
| I want a security review | **Zach** 🟥 | `Zach, review this code for security vulnerabilities.` |

You can also engage the interactive modes at any point:

| What you need | Mode | What to say |
| :--- | :--- | :--- |
| Stress-test a spec or design | **Elicit** ⚡ | `Elicit this.` |
| Cross-functional input on a hard decision | **Roundtable** 🌀 | `Roundtable this.` (or `Debate this.`) |
| Ideate outside the obvious answers | **Brainstorm** 💡 | `Brainstorm this.` |

### Supported environments

BMILD has two requirements:

- works anywhere that supports the agent Skills pattern
- the workspace must have BASH available (WSL, Linux, and macOS all do) for the tokenizer script

#### First-class environments

| Environment | Path to Agent Skills |
| :--- | :--- |
| **OpenAI Codex** | `.agents/skills/` |
| **Opencode** | `.opencode/skills/` |
| **Claude Code** | `.claude/skills/` |

Other environments may work fine. BMILD does not currently design for or test against them.

#### LLM capability recommendation

BMILD uses complex non-linear semantic routing. This sets a minimum floor for recommended LLM capability. Roughly, any model in the **top 15** of the **SWE-Bench Verified** ranking will perform well.

### Backing out

Remove the `bmild-*` folders from your skills directory. The memory files stay in your project unless you delete them; they are plain markdown.

## Relationship to other work

BMILD grew out of [BMAD-METHOD](https://github.com/the-bmad-group/bmad). The persona archetypes and the interactive modes are adapted from it.

On its own terms, BMILD is:

- **Skill-native and portable.** File copy, no installer. Distribute to a team through git, reuse across local repos with symlinks, and stay equally usable in any environment that supports agent Skills.
- **Integrated readiness gate.** Readiness verification is built into the Delivery Planner. Sonia cannot decompose work into Slices without first confirming that every Must Have has downstream coverage. The gate is structurally unavoidable.
- **Structured debugging.** A breadth-first root-cause protocol ranked by fit, frequency, and recency runs before any code is touched, to avoid premature anchoring on a single cause.
- **Initiatives and Slices** replace epics and stories.

### Installing alongside BMAD

BMILD and BMAD share trigger phrases. Running them side by side can flip an agent non-deterministically. To use BMILD, put `bmild-*` skills in the skills folder; to stop, remove them. Memory files are plain markdown and stay in your project. BMILD does not read BMAD planning artifacts today.

## Roadmap

```
- v0.1 -- Initial commit
- v0.2 -- Persona scope stable (Current)
- v0.3 -- Context memory structure stable
- v0.4 -- Persona interactivity stable
- v0.5 -- First public version
```

## Personal Note

### Who am I?

I am a career Product Manager, with many years in services and system development from mobile to Internet, with scope from UX to marketing on the consumer-facing side to rating and subscription in the backend and provisioning systems in the core. I have worked in waterfall and Agile environments, with teams that spanned time zones and continents. I have worked with some of the best system-minded people in the business. The names of the personas are picked from among these outstanding people.

### What do I get out of releasing it?

Simply, I built BMILD because it helps me with the work I am doing. It's fast, adaptive, effective and -- what is especially rewarding -- it's engaging and enjoyable to use. Yes, there are tens of thousands of projects like this, but there are definitely some novel ideas in here worth stealing if nothing else. Yours for the taking.

## Thanks

BMILD is built upon and inspired by:

- **[BMAD-METHOD](https://github.com/the-bmad-group/bmad)**: the persona archetypes and interactive patterns are adapted from BMAD.
- **[SOUL.md](https://github.com/aaronjmars/soul.md)**: informed the distinctive persona voices.
- **[Grill-with-Docs](https://github.com/mattpocock/skills/blob/main/skills/engineering/grill-with-docs/SKILL.md)**: the context and ADR log format is adapted from mattpocock's skill.
- **[GSD](https://github.com/gsd-build/get-shit-done)**: the Nyquist validation rule is adapted to specific skill behaviours.
- **[Kilo Code](https://github.com/kilo-code)**: the QA debugging methodology is adapted from Kilo Code's Debug prompt.
- **[Tokencast](https://github.com/krulewis/tokencast)**: the tokenizer algorithm used by the Planner is adapted from krulewis' implementation.

All referenced materials are used in accordance with their respective MIT licenses.
