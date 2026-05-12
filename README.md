![BMILD](banner-bmild.png)

# BMILD -- Breakthrough Method for Interactive Leads Development

![Release](https://img.shields.io/github/v/release/micfre/BMILD?include_prereleases&label=Version)
[![Build Status](https://img.shields.io/github/actions/workflow/status/micfre/BMILD/ci.yml?label=Build%20Status)](https://github.com/micfre/BMILD/actions/workflows/ci.yml)
[![Release Status](https://github.com/micfre/BMILD/actions/workflows/release.yml/badge.svg)](https://github.com/micfre/BMILD/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

```
BMILD is entering a phase of increased churn. Planning artifacts are in flux. An arcitectural shift
in persona adaptability and self-steering is in planning (Dev skill is prototype). This should
stabilize when VERSION is incremented to 0.3.0. Until then, it will remain workable end-to-end though
spec/design documents created in <0.2.1 may not be compatible in later versions.
```

BMILD is a handful of carefully crafted prompts that give you and your AI coding agent a cross-functional team. Drop the skill folders next to your code, call on a persona by name, and get spec-driven development without the ceremony.

No installer. No dependencies. No separate orchestrator. Only Skill-native files.

---

## BMILD exists to

1. **Help the user create solid specs and verifiable code.** The upfront investment in properly specifying what you're building pays dividends when the agent writes code. AI will make it up or ignore it if it isn't properly specified, with long-horizon "iterate and fix" as the cost.

2. **Eliminate high process cost of frameworks that rigidly emulate Agile ceremony.** Epics, stories, sprints, and story points exist to manage communication friction and estimate human effort. AI doesn't have those problems. What AI needs more is good context management -- development units sized to context windows, not story points -- and clear, verifiable design contracts to build against.

These are the reasons that BMILD exists. If you want the full Agile ceremony with AI, [BMAD](https://github.com/the-bmad-group/bmad) does that well and BMILD has grown directly out of it.

## BMILD is built with

Ten skill folders. Each contains a prompt that gives your AI agent a persona with a defined role, a voice, and strict scope boundaries. Together they cover the full development lifecycle:

| Persona | Role | What they actually do |
| :--- | :--- | :--- |
| **Faisal**&nbsp;🟦 | Product Manager | Asks "WHY?" relentlessly. Won't let you ship vague requirements. Challenges your first answer, your second answer, and probably your third. |
| **Katrina**&nbsp;🟩 | UX Designer | Owns the complete frontend experience. Advocates for users without losing sight of what's buildable. Decisive, not decorative. |
| **Lance**&nbsp;🟥 | Architect | Names the cost of every choice. Produces implementable contracts -- schema columns, endpoint shapes, service signatures -- not high-level boxes and arrows. |
| **Sonia**&nbsp;🟧 | Delivery Planner | Zero tolerance for ambiguity in implementation inputs. Sizes work to fit context windows, not story points. |
| **Alex**&nbsp;🟪 | Developer | Implements planned Slices, prototypes bounded repo work, and fixes bugs. Matches existing patterns, avoids needless ceremony, and leaves lightweight memory when work could affect future specs. |
| **Rahat**&nbsp;🟨 | QA & Reliability | Diagnoses before fixing. Breadth-first hypothesis generation RCA protocol. Never proposes a code change until root cause is confirmed by evidence. |
| **Zach**&nbsp;⬜ | Security | Contextual SAST code review. Prioritizes high-confidence, actionable vulnerabilities over theoretical noise. Perspective is grounded in real-world exploitability. |

Plus three interactive modes that work across personas:

- **Debate** 🌀: A structured multi-persona design debate session. Faisal, Katrina, Lance, and Rahat argue it out -- surfacing tensions from different perspectives. It's BMAD's "Party Mode" but named for what it actually does.
- **Elicit** ⚡: Added help to expand your own thinking and intent. 20+ structured methods to push requirements, UX decisions, or architecture past "good enough" into genuinely strong.
- **Brainstorm** 💡: Open-ended ideation designed to get past obvious ideas. Anti-bias protocols prevent the facilitator from clustering around a single direction.

## BMILD works through

The personas are designed around a two-tier model:

**Design tier** (Faisal, Katrina, Lance) -- These personas are deliberate. They probe, they elicit, they question. Their job is to surface what would otherwise go unstated. Modern LLMs inherently want to start immediately and get to green fast; the design personas resist that and ensure the user drives the pace.

**Execution tier** (Sonia, Alex, Rahat, Zach) -- These personas plan and implement with context-window optimized vertical slices and robust quality pre-planning and verification. They activate lean, act on coherent inputs, and hand back when a blocker is outside their authority. Less ceremony, more efficient path to working code.

Sonia, as the pivot between tiers, is where BMILD earns its keep. The spec gets the scrutiny it deserves. It is structurally unavoidable to bypass the readiness checks, the user does not need to remember to separately call on a readiness skill before planning development deliverables. Sonia takes care of this and lets you know it's ready. Sonia's also responsible for the overall system memory.

### Handoffs

Personas read project context from the configured memory folder before they speak. They tell you what stage appears current, what's complete, and who should engage next. You don't have to remember the workflow -- they do, and they route it.

Handoffs are obligations, not exits. Each persona passes a usable contract to the next teammate:

- Faisal passes problem framing, success criteria, and MVP/Growth priority.
- Katrina passes observable UX flows, states, and interaction decisions.
- Lance passes implementable architecture contracts.
- Sonia passes phase-scoped Slices, likely required reads, and verification boundaries.
- Alex passes checked acceptance criteria for planned Slices, Dev notes for prototype and bug-fix work, required documentation updates, and user verification actions.
- Rahat passes persistent verification evidence, documentation verification, and documented defects.
- Zach passes only high-confidence security findings with owner and remediation path.

Advanced modes are team tools. Debate resolves consequential ambiguity, Elicit strengthens a draft, and Brainstorm expands options before convergence.

Named personas also open with a compact operating stance that identifies who is speaking, the work type, the active scope, and the role boundary. This keeps weaker harnesses oriented without turning the personas into rigid scripts.

### Artifact Flow

BMILD artifacts have owners and consumers:

- `product-brief.md`: created by Faisal; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines problem, users, success criteria, scope, and vision. Entry contract for downstream design.
- `prd.md`: created by Faisal once a brief exists; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines functional requirements, journeys, prioritization (MVP / Growth), NFRs, and required documentation updates (README, contributor guides, runbooks, release notes, onboarding, user-facing help). Validated through coverage checks and verification matrix entries.
- `plans/CHARTER.md`: emergent project-level artifact. Seeded or updated by Faisal only when an initiative establishes a project-level invariant (vision, target users, competitive positioning), conflicts with a sibling initiative's `product-brief.md`, or the user explicitly requests it. Consumed by all design-tier personas as a constraint when present; absent on most projects until a coherence-forcing event occurs.
- `plans/ARCHITECTURE.md`: created and maintained by Lance; carries rationale (tech stack, invariants Alex must respect, migration patterns, alternatives rejected). Cross-links to `AGENTS.md`/`CLAUDE.md`/`README.md` for operator mechanics rather than restating them.
- Project-root `DESIGN.md`: created and maintained by Katrina; carries durable global UX patterns (palette, typography, global component rules) distilled from initiative-specific UX work.
- `ux-design.md`: created by Katrina; consumed by Lance, Sonia, Alex, Rahat, and Zach; validated through observable user-state checks.
- `system-design.md`: created by Lance; consumed by Sonia, Alex, Rahat, and Zach; validated through implementability, testability, and security review.
- `slices.md` and `slice-<N>.md`: created by Sonia; consumed and updated by Alex; verified by Rahat and Zach; recut by Sonia when implementation reveals a planning problem.
- `dev-note-<slug>.md`: created or updated by Alex for Prototype and Bug Fix work that changes durable behaviour, leaves reusable code, records fix rationale, or creates future-spec facts; consumed by Faisal, Katrina, Lance, Sonia, Rahat, and Zach when formalizing, verifying, or reviewing later work.
- `verification-matrix.md`: created by Sonia during readiness when proof boundaries matter; repaired or expanded by Rahat; consumed by Alex; validated by Rahat during verification.
- `rca-<slug>.md`: created or updated by Rahat for confirmed defects; consumed by Alex for fixes; closed by Rahat after evidence shows the regression is covered.
- `security-review-<slug>.md`: created by Zach when exploitable findings exist; consumed by Alex for implementation fixes or Lance/Katrina for design changes; closed by Zach after remediation is verified.
- Documentation files: requirements defined by Faisal, implemented by Alex, and verified by Rahat against the shipped behaviour.

RCA path rule: initiative-linked defects live in the initiative folder. `_system/rca-<slug>.md` is valid only for genuinely global defects with no initiative, Slice, or initiative `_context.md` owner.

### Memory

No orchestrator, no state machine. Personas write directly to the folder specified by `plan_folder` in `.bmild.toml` (defaults to `plans/`) at your project root using plain markdown. This can be structured alongside project source or kept separately — the personas resolve all paths relative to the project root.

```
<project-root>/
├── DESIGN.md                       # Katrina output: durable global UX patterns (palette, typography, component rules). Project-root because it is a project-wide standard.
└── plans/ (or your custom plan_folder)
    ├── CHARTER.md                  # Faisal output: emergent — seeded only when a project-level invariant is established or a cross-initiative conflict is resolved.
    ├── ARCHITECTURE.md             # Lance output: durable rationale (tech stack, invariants Alex must respect, alternatives rejected). Canonical, plans/-level.
    ├── _system/                    # Global memory artifacts shared across initiatives.
    │   ├── _context.md             # Index of globally-live documents.
    │   └── _rollup.md              # Central registry of all active features/initiatives.
    └── <initiative-name>/          # The atomic unit of work (Feature / Initiative).
        ├── _context.md             # Index of live documents for this initiative.
        ├── product-brief.md        # Faisal output: problem, users, success criteria, scope, vision.
        ├── prd.md                  # Faisal output: requirements, journeys, prioritization, NFRs, doc scope.
        ├── ux-design.md            # Katrina output: initiative-specific flows, screen states, interaction rules.
        ├── system-design.md        # Lance output: schema, API contracts, service contracts, tech choices.
        ├── verification-matrix.md  # Sonia/Rahat: proof map for requirements and Slices.
        ├── slices.md               # Sonia output: Slice registry.
        ├── slice-<N>.md            # One file per Slice.
        ├── dev-note-<slug>.md      # Alex output: prototype and bug-fix memory.
        ├── rca-<slug>.md           # Rahat output: root cause analysis.
        └── security-review-<slug>.md # Zach output: security findings.
```

Path rationale:
- `DESIGN.md` lives at the **project root** as a project-wide standard, treated like `README.md`.
- `CHARTER.md` and `ARCHITECTURE.md` live at the **`plans/` level** as canonical, durable rationale documents owned by Faisal and Lance respectively.
- `_context.md` and `_rollup.md` live under **`plans/_system/`** as global memory artifacts.
- `ARCHITECTURE.md` carries rationale; `AGENTS.md` / `CLAUDE.md` / `README.md` carry operator mechanics. Lance cross-links rather than restating.

`_context.md` is the entry point for every persona. It lists documents that are currently `live` (in-use) vs. `archived`. Personas load only what is live and only what is relevant to the current engagement mode.

Every `_context.md` follows this structure:

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

### Project configuration

Project-level settings are defined in `.bmild.toml` at the repository root. The personas read these configurations to dynamically adapt their behavior.

- `plan_folder`: (Default: `"plans/"`) Directory where BMILD's memory artifacts (specs, designs, slices) are stored. Used globally by all personas to read and write context files.
- `user_name`: (Optional) The user's preferred name. Used by named personas (e.g., Faisal, Katrina, Sonia) to address the user personally in their conversational responses.
- `slice_target`: (Default: `170000`) Target context token limit for sizing vertical implementation slices. Used by `bmild-planner` (Sonia) when performing Slice Budgeting to evaluate if work exceeds safe token boundaries.

### Skill validation

Run the local structural validator after editing skills:

```sh
scripts/validate-skills.sh .
```

It checks frontmatter names, description length, required BMILD sections, standard persona handoff sections, `Progress:` checklists for ordered workflows, and accidental markdown table rows in BMILD skill surfaces and validator-owned docs.

## Getting started

1. Put the `.agents/skills/` directory where your IDE or CLI looks for skills (see table below).
2. Say: `Faisal, help me frame a feature for [your idea].`
3. Follow the handoffs. Faisal will tell you who's next.

Or jump in wherever makes sense:

| Where you are | Who to call | What to say |
| :--- | :--- | :--- |
| I have an idea | **Faisal** 🟦 | `Faisal, help me frame a feature for [idea].` |
| I know what to build, need the UX | **Katrina** 🟩 | `Katrina, design the user experience for [feature].` |
| I need backend contracts | **Lance** 🟥 | `Lance, design the API and data model for [feature].` |
| Design is done, need implementation plan | **Sonia** 🟧 | `Sonia, check readiness and decompose into slices.` |
| I have a slice ready to build | **Alex** 🟪 | `Alex, implement slice 3.` |
| Something is broken | **Rahat** 🟨 | `Rahat, diagnose this failure.` |
| I want a security review | **Zach** ⬜ | `Zach, review this code for security vulnerabilities.` |

You can also engage the interactive modes at any point:

| What you need | Mode | What to say |
| :--- | :--- | :--- |
| Stress-test a spec or design | **Elicit** ⚡ | `Elicit this.` |
| Cross-functional input on a hard decision | **Debate** 🌀 | `Debate this.` |
| Ideate outside the obvious answers | **Brainstorm** 💡 | `Brainstorm this.` |

### Supported environments

BMILD has two requirements:
- works anywhere that supports the agent Skills pattern
- the workspace must have BASH available (WSL, Linux, macOS all do)

#### First-class environments

| Environment | Path to Agent Skills |
| :--- | :--- |
| **OpenAI Codex** | `.agents/skills/` |
| **Opencode** | `.opencode/skills/` |
| **Claude Code** | `.claude/skills/` |

Other environments may work perfectly well. Currently BMILD does not design for them, nor test against them.

#### LLM capability recommendation

BMILD uses complex non-linear semantic routing. This sets a minimum floow for recommended LLM capability.
Roughly, any model in **top 15** ranking of **SWE-Bench Verified** will perform well.

### Backing out

Remove the `bmild-*` folders from your skills directory. The memory files stay in your project unless you choose to delete them — they're plain markdown.

## BMILD is different than

### no framework at all

You get the full lifecycle -- requirements, UX, architecture, planning, implementation, QA -- without installing anything or learning a new tool. The prompts enforce quality gates that prevent the common failure: the agent builds what it understood, not what you meant.

### BMAD

BMILD is built on BMAD-METHOD. The persona archetypes and the interactive modes are derived from BMAD. BMILD takes a narrower and simpler approach to building high-quality specs.

Where BMILD diverges:

- Philosophically:
  - **Broader persona scope.** Fewer personas, broader per-persona scope, personas adapt to context without routing you into brittle stepwise flows. And an easier mental model of who to talk to.
  - **Portable, no installer.** BMAD uses an installer. BMILD is file copy. BMILD stays equally usable across any environment that supports agent Skills. Distribute to the team effortlessly via github. Reuse across local repos with symlinks.
  - **Less ceremony.** The design personas insist on thoroughness. The execution personas strip away everything that doesn't contribute to working code. BMILD deliberately avoids performative theatre, gates that exist to look rigorous rather than to catch real problems.
- Functionally:
  - **Context-bounded vertical Slices.** Atomic development units are sized with a lightweight tokenizer to an implementation-session context window, not to Agile story semantics. The evidence is that important stuff gets lost in the middle of large context window -- see 'Needle in a Haystack/NIAH' benchmarks -- and scope decomposition is driven by this physic. Slice planning also sequences based on MVP/growth/vision cuts specified in the product spec.
  - **Integrated readiness gate.** BMAD has a readiness verification skill, but it's a separate step you invoke before implementation. In BMILD, the equivalent is built into the Delivery Planner -- Sonia can't decompose work into Slices without first verifying that every Must Have in the spec has downstream coverage in UX or architecture. The gate is structurally unavoidable, not a step you must remember to run.
  - **Structured debugging.** A breadth-first root cause analysis protocol ranked by fit/frequency/recency before any code is touched. Many debugging flows can prematurely funnel the agent into anchoring on a single domain and single cause.
- Semantically:
  - **Party Mode:** → Debate. "Start a debate on this topic." The leads come together. *<small>Currently operates in a single context window, does not spawn subagents (which is a cool trick BMAD is implementing).</small>*
  - **Advanced Elicitation:** → Elicit. "Help me articulate this topic." Intelligent objective-oriented probing.
  - **Brainstorming:** → Brainstorm. "Start a brainstorm on this topic." Operates essentially the same.
  - **Epics, Stories:** → Initiatives, Slices.

### BMAD compatibility

BMILD and BMAD should not be installed side-by-side as their trigger phrases overlap and an agent could flip non-deterministically. When you want to use BMILD, put `bmild-*` skills in the skills folder. If you want to stop, remove them. Any memory files stay in your project.

BMILD doesn't look at BMAD planning artifacts, but this could change in the future.

## Roadmap

```
- v0.1 -- Initial commit
- v0.2 -- Persona scope stable (Current)
- v0.3 -- Context memory structure stable
- v0.4 -- Persona interactivity stable
- v0.5 -- First public version
```

## BMILD thanks the OSS community

BMILD is built upon and inspired by:

- **[BMAD-METHOD](https://github.com/the-bmad-group/bmad)**: The persona archetypes and interactive patterns are adapted from BMAD.
- **[GSD](https://github.com/gsd-build/get-shit-done)**: Nyquist Validation rule adapted to specific skill behaviours.
- **[Kilo Code](https://github.com/kilo-code)**: The QA debugging methodology is adapted from Kilo Code's Debug prompt.
- **[Tokencast](https://github.com/krulewis/tokencast)**: The tokenizer algorithm used by the Planner persona is adapted from krulewis' implementation in Tokencast.

All referenced materials are used in accordance with their respective MIT licenses.
