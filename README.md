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

1. **Solid specs lead to verifiable code.** The upfront work of specifying what you are building pays back when the agent writes code. Under-specified work tends toward long iteration loops that are expensive to escape.

2. **AI needs context management, not Agile ceremony.** Epics, stories, sprints, and points exist to coordinate people and estimate human effort. AI has different constraints. It benefits from development units sized to context windows and from clear, verifiable design contracts to build against.

BMAD runs the full Agile-with-AI ceremony and does it well. BMILD grew out of BMAD and takes a narrower path.

## How a feature moves through BMILD

A feature flows through a small set of roles. Each one hands a usable contract to the next.

1. **Frame.** Faisal (PM) turns an idea into a product brief and PRD: problem, users, success criteria, MVP and Growth priority.
2. **Design.** Katrina (UX) and Lance (Arch) produce observable user flows and implementable contracts (schema, endpoint shapes, service signatures), reading the PM artifacts as fixed upstream truth.
3. **Plan.** Sonia (Planner) verifies readiness, that every Must Have in the spec has downstream coverage in UX or architecture, then decomposes the work into vertical Slices sized to a context window and sequenced by phase. The readiness check is built into planning, not a step you have to remember to run.
4. **Implement.** Alex (Dev) builds each Slice against the contracts, promotes durable technical truth into `system-design.md`, and flags required documentation.
5. **Verify.** Rahat (QA) runs root-cause analysis and verification, and Zach (Security) reviews for exploitable findings. Both close the loop or route repairs.

The roles sit in two tiers. The **design tier** (Faisal, Katrina, Lance) is deliberate: they probe and elicit to surface what would otherwise go unstated, and they set the pace against the agent's pull toward starting fast. The **execution tier** (Sonia, Alex, Rahat, Zach) plans and implements with context-bounded units and verification pre-planned in.

Sonia is the pivot. Readiness is enforced at her step, and the system's running memory is kept there.

When a change mid-flight invalidates two or more design artifacts, a PRD edit that ripples into UX and architecture, or an implementation discovery that forces upstream rework, Sonia switches to **Course-Correction**. She decomposes the change into bounded questions, convenes a Roundtable per question, records what you ratify in a `change-proposal-<slug>.md`, and produces an ordered handoff chain so each owner patches their own artifact.

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

## Handoffs and memory

Personas read project context from the memory folder before they speak, tell you what stage appears current, and route to whoever should engage next. You do not have to remember the workflow; they do.

A handoff is an obligation, not an exit. Each persona passes a usable contract downstream: problem framing, UX flows, architecture contracts, phased Slices, acceptance checks, verification evidence, security findings. Every standard close keeps two lines separate: `For you, ...` for a real user action that finishes the current step (review the artifact, answer a queued decision, run a manual check), and `Next.` for the workflow move to the next persona or a terminal state.

When ambiguity appears, BMILD routes it instead of preserving it as durable chat:

- into `handoff.md` when another owner's action is needed for a source-artifact defect, a cross-artifact conflict, or a promotion request
- into a bounded assumption inside the consuming artifact when the risk is low and reversible
- directly into the source artifact when the truth is now known and no further owner judgment is required
- to an explicit defer, reject, or supersede when that is the honest state

Handoff items are non-authoritative until the owning persona promotes a resolution into the target artifact. Each persona auto-runs Handback when items target its artifacts, so invoking the persona by name is enough.

One settlement path deserves naming. When a presiding persona finds a *settled* fact (code truth, an in-session decision, a prior ratified roundtable, or an obvious single-option constraint) that belongs in another owner's artifact, it can scribe the patch in its own turn: it loads the target owner's voice from their `SOUL.md`, writes the patch with dual attribution, and skips the handoff. Scribe is not authorship; it transcribes settled facts and never decides open ones. Genuinely open items and high-stakes surfaces (data model, API contract, security, compliance) still route. The full gate and procedure live in `docs/scribe-path.md`.

**AGENTS.md is the authoritative reference** for the artifact list, owners and consumers, the memory folder layout, the `registry.md` format, and the governance rules. The rest of this README is conceptual.

## Memory layout

Personas write plain markdown to the folder set by `plan_folder` in `.bmild.toml` (default `plans/`). Paths resolve relative to the project root, so memory can live alongside source or separate from it.

```
<project-root>/
├── DESIGN.md                       # Katrina: durable global UX patterns (palette, typography, component rules)
└── plans/                          # or your plan_folder
    ├── context-map.md              # cross-initiative semantic map
    ├── rollup.md                   # initiative index, aliases, status, decision log
    ├── adr/                        # drift-protection ADRs (triple-axis gated)
    └── <initiative>/
        ├── registry.md             # live / archived / stale artifact state
        ├── context.md              # initiative-local terms, boundaries, relationships
        ├── product-brief.md        # Faisal
        ├── prd.md                   # Faisal
        ├── ux-design.md            # Katrina
        ├── system-design.md        # Lance (and Alex's promoted technical truth)
        ├── handoff.md              # owner-to-owner coordination
        ├── change-proposal-<slug>.md # Sonia, Course-Correction
        ├── verification-matrix.md  # Sonia / Rahat
        ├── slices.md, slice-<N>.md # Sonia
        ├── rca-<slug>.md           # Rahat
        └── security-review-<slug>.md # Zach
```

When you name an initiative, personas check the initiative folder first, then `rollup.md`. Initiative work starts from `registry.md`, loads `context.md` and the live artifacts, and skips anything marked stale.

## Project configuration

Project-level settings live in `.bmild.toml` at the repository root. Personas read them to adapt their behavior.

- `plan_folder`: (default `"plans/"`) directory where memory artifacts (specs, designs, slices) are stored. Used globally to read and write context files.
- `user_name`: (optional) your preferred name. Used by named personas to address you in their responses.
- `slice_target`: (default `170000`) target context tokens for sizing vertical slices. Used by Sonia when budgeting slices.
- `tokenizer_base`: (default `15000`) base token cost used by the slice-budgeting tokenizer.
- `tokenizer_multiplier`: (default `1.25`) multiplier applied by the slice-budgeting tokenizer.

Sonia passes `slice_target`, `tokenizer_base`, and `tokenizer_multiplier` straight through to the wrapper script in the planner skill folder (`scripts/run-budget-slice.sh`). She does not reinterpret them.

### Skill validation

Run the local structural validator after editing skills:

```sh
scripts/validate-skills.sh .
```

It checks frontmatter names, description length, required BMILD sections, standard persona handoff sections, `Progress:` checklists for ordered workflows, accidental markdown table rows in skill surfaces and validator-owned docs, and regressions to retired artifact names in active guidance.

## Getting started

1. Put the `.agents/skills/` directory where your IDE or CLI looks for skills (see below).
2. Say: `Faisal, help me frame a feature for [your idea].`
3. Follow the handoffs. Faisal will tell you who is next.

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
| Mid-flight change invalidates multiple docs | **Course-Correction** (via Sonia) | `Sonia, correct course on [initiative] because [reason].` |

### Supported environments

BMILD has two requirements:

- works anywhere that supports the agent Skills pattern
- the workspace must have BASH available (WSL, Linux, and macOS all do)

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
- **Context-bounded vertical Slices.** Development units are sized with a tokenizer to an implementation-session context window, not to Agile story semantics, because important detail gets lost in the middle of large context windows (see Needle-in-a-Haystack benchmarks). Slice sequencing follows the MVP, Growth, and Vision cuts in the product spec.
- **Integrated readiness gate.** Readiness verification is built into the Delivery Planner. Sonia cannot decompose work into Slices without first confirming that every Must Have has downstream coverage. The gate is structurally unavoidable.
- **Course-Correction.** When a mid-flight change hits two or more design artifacts, Sonia coordinates a bounded, roundtable-driven path back to coherent specs instead of fragmenting the rework.
- **Structured debugging.** A breadth-first root-cause protocol ranked by fit, frequency, and recency runs before any code is touched, to avoid premature anchoring on a single cause.
- **Scribe path and `SOUL.md`.** Persona voice lives in a sibling `SOUL.md` so it is independently addressable for roundtable attendee-voice loading and for in-context scribing of settled facts into another owner's artifact (see `docs/scribe-path.md`).
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

## Thanks

BMILD is built upon and inspired by:

- **[BMAD-METHOD](https://github.com/the-bmad-group/bmad)**: the persona archetypes and interactive patterns are adapted from BMAD.
- **[SOUL.md](https://github.com/aaronjmars/soul.md)**: informed the distinctive persona voices.
- **[Grill-with-Docs](https://github.com/mattpocock/skills/blob/main/skills/engineering/grill-with-docs/SKILL.md)**: the context and ADR log format is adapted from mattpocock's skill.
- **[GSD](https://github.com/gsd-build/get-shit-done)**: the Nyquist validation rule is adapted to specific skill behaviours.
- **[Kilo Code](https://github.com/kilo-code)**: the QA debugging methodology is adapted from Kilo Code's Debug prompt.
- **[Tokencast](https://github.com/krulewis/tokencast)**: the tokenizer algorithm used by the Planner is adapted from krulewis' implementation.

All referenced materials are used in accordance with their respective MIT licenses.
