![BMad Method](banner-bmild.png)
# BMILD -- Breakthrough Method for Interactive Leads Development
![Release](https://img.shields.io/github/v/release/micfre/BMILD?include_prereleases&label=Version)
[![Build Status](https://img.shields.io/github/actions/workflow/status/micfre/BMILD/release.yml?label=Build)](https://github.com/micfre/BMILD/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

BMILD is a handful of carefully crafted prompts that give you and your AI coding agent a cross-functional team. Drop the skill folders next to your code, call on a persona by name, and get spec-driven development without the ceremony.

No installer. No dependencies. No separate orchestrator. Only Skill-native files.

---

## You should care about this if

You believe, as I do:

1. **AI development benefits enormously from a spec-driven approach.** The upfront investment in properly specifying what you're building pays dividends when the agent writes code. AI will make it up or ignore it if it isn't properly specified, with long-horizon "iterate and fix" as the cost.

2. **AI development is not human development.** Epics, stories, sprints, and story points exist to manage communication friction and estimate human effort. AI doesn't have those problems. What AI needs more is good context management -- development units sized to context windows, not story points -- and clear design contracts to build against.

This is the reason that BMILD exists. If you want the full Agile ceremony with AI, [BMAD](https://github.com/the-bmad-group/bmad) does that well and BMILD has grown directly out of it.

## What is it, really?

Ten skill folders. Each contains a prompt that gives your AI agent a persona with a defined role, a voice, and strict scope boundaries. Together they cover the full development lifecycle:

| Persona | Role | What they actually do |
| :--- | :--- | :--- |
| **Faisal**&nbsp;🟦 | Product Manager | Asks "WHY?" relentlessly. Won't let you ship vague requirements. Challenges your first answer, your second answer, and probably your third. |
| **Katrina**&nbsp;🟩 | UX Designer | Owns the complete frontend experience. Advocates for users without losing sight of what's buildable. Decisive, not decorative. |
| **Lance**&nbsp;🟥 | Architect | Names the cost of every choice. Produces implementable contracts -- schema columns, endpoint shapes, service signatures -- not high-level boxes and arrows. |
| **Sonia**&nbsp;🟧 | Delivery Planner | Zero tolerance for ambiguity in implementation inputs. Sizes work to fit context windows, not story points. |
| **Alex**&nbsp;🟪 | Developer | Matches existing patterns, doesn't invent new ones. Reads the repo's conventions before writing a line. Ultra-succinct, implementation-focused. |
| **Rahat**&nbsp;🟨 | QA & Reliability | Diagnoses before fixing. Breadth-first hypothesis generation RCA protocol. Never proposes a code change until root cause is confirmed by evidence. |
| **Zach**&nbsp;⬜ | Security | Contextual SAST code review. Prioritizes high-confidence, actionable vulnerabilities over theoretical noise. Perspective is grounded in real-world exploitability. |

Plus three interactive modes that work across personas:

- **Debate** 🌀: A structured multi-persona design debate session. Faisal, Katrina, Lance, and Rahat argue it out -- surfacing tensions, not diplomatic consensus. Think of it like BMAD's "Party Mode" but named for what it actually does.
- **Elicit** ⚡: Stress-test any output. 20+ structured methods to push requirements, UX decisions, or architecture past "good enough" into genuinely strong.
- **Brainstorm** 💡: Open-ended ideation designed to get past the first 20 obvious ideas. Anti-bias protocols prevent the LLM from clustering around a single direction.

## How it works

The personas are designed around a two-tier model:

**Design tier** (Faisal, Katrina, Lance) -- These personas slow down. They probe, they elicit, they push back. Their job is to surface what would otherwise go unstated. Modern LLMs inherently want to start immediately and get to green fast; the design personas resist that and ensure the user drives the pace.

**Execution tier** (Sonia, Alex, Rahat, Zach) -- These personas lean into speed. They activate lean, act on coherent inputs, and hand back precisely when a blocker is outside their authority. Less ceremony, more working code.

Sonia, as the pivot between tiers, is where BMILD earns its keep. The spec gets the scrutiny it deserves. It is structurally unavoidable to bypass the readiness checks, the user does not need to remember to separately call on a readiness skill before planning development deliverables. Sonia takes care of this and lets you know it's ready. Then the code gets written without theatrical gates.

### Handoffs

Personas read project context from `plans/` before they speak. They tell you what stage appears current, what's complete, and who should engage next. You don't have to remember the workflow -- they do, and they route it.

### Memory

No orchestrator, no state machine. Personas write directly to a `plans/` directory at your project root using plain markdown. The `_context.md` file in each folder tracks what's live vs archived. Personas load only what's relevant.

```
plans/
├── platform/                         # Greenfield or global refactors
│   ├── _context.md                   # Index -- all personas read this first
│   ├── spec.md                       # PM output
│   ├── ux-design.md                  # UX output
│   ├── system-design.md              # Arch output
│   └── slices.md                     # Planner output: Slice registry
└── features/
    └── <feature-name>/               # One folder per feature
        ├── _context.md
        ├── spec.md
        ├── ux-design.md
        ├── system-design.md
        ├── slices.md
        ├── slice-<N>.md              # One file per Slice
        ├── rca-<slug>.md             # QA root cause analysis
        └── security-review-<slug>.md # Sec security findings
```

## Getting started

1. Put the `.agents/skills/` directory where your IDE or CLI looks for skills (see table below).
2. Say: `Faisal, help me frame a feature for [your idea].`
3. Follow the handoffs. Faisal will tell you who's next.

Or jump in wherever makes sense:

- Have a design but need it built? → `Sonia, decompose this into slices.`
- Something's broken? → `Rahat, diagnose this.`
- Need to step outside of the box? → `Brainstorm this.`
- Want to challenge something you just produced? → `Elicit this.`
- Need cross-functional input on a hard decision? → `Debate this.`

### Supported environments

BMILD works anywhere that supports the agent Skills pattern. It's just folders with markdown (and YAML) files so it's portable and shareable across the team with simple version control through github.

**Drop-in** (skills are already scanned from `.agents/`):

| Environment | Path |
| :--- | :--- |
| **Antigravity** | `.agents/skills/` |
| **OpenAI Codex** | `.agents/skills/` |

**Relocate to** (copy `bmild-*` folders into the expected path):

| Environment | Path |
| :--- | :--- |
| **Claude Code** | `.claude/skills/` |
| **Cursor** | `.cursor/skills/` |
| **Kilo Code** | `.kilocode/skills/` |
| **Opencode** | `.opencode/skills/` |
| **VS Code Copilot** | `.github/skills/` |

## What makes BMILD different

### vs. no framework at all

You get the full lifecycle -- requirements, UX, architecture, planning, implementation, QA -- without installing anything or learning a new tool. The prompts enforce quality gates that prevent the common failure: the agent builds what it understood, not what you meant.

### vs. BMAD

BMILD is built on BMAD-METHOD. The persona archetypes, the interactive modes (Party Mode → Debate, Advanced Elicitation, Brainstorming) are derived from BMAD. This is not a competitor or trying to be 'better' in the abstract, but rather it's a milder and narrower extraction.

Where BMILD diverges:

- **7 personas instead of 12+.** Broader per-persona scope, less juggling, no domain overlap. And an easier mental model of who to talk to.
- **No installer.** BMAD uses an installer. BMILD is file copy. BMILD stays equally usable across any environment that supports agent Skills, not by the installer support that's been built.
- **Skill-native.** Workflows aren't managed by proprietary workflow files with skill wrappers. The prompts are self-contained.
- **Slices replace stories.** Development units are sized with a lightweight tokenizer to an implementation-session context window, not to Agile story semantics. The evidence is that important stuff gets lost in the middle of large context window -- see 'Needle in a Haystack/NIAH' benchmarks -- and scope decomposition is driven by this physic rather than Agile/INVEST story format.
- **Less ceremony.** The design personas insist on thoroughness. The execution personas strip away everything that doesn't contribute to working code. BMILD deliberately avoids performative theatre, gates that exist to look rigorous rather than to catch real problems.
- **Integrated readiness gate.** BMAD has a readiness verification skill, but it's a separate step you invoke before implementation. In BMILD, the equivalent is built into the Delivery Planner -- Sonia can't decompose work into Slices without first verifying that every Must Have in the spec has downstream coverage in UX or architecture. The gate is structurally unavoidable, not a step you must remember to run.
- **Structured degugging.** A strict 7-step root cause analysis protocol with mandatory breadth-first hypotheses, ranked by fit/frequency/recency, validated by evidence before any code is touched. Many debugging flows can, and BMAD's does in my experience, funnel the agent into postulating a single domain and single cause prematurely.

### BMAD compatibility

BMILD and BMAD should not be installed side-by-side as their trigger phrases overlap and an agent could flip non-deterministically. When you want to use BMILD, put `bmild-*` skills in the skills folder. If you want to stop, remove them. Any `plans/` memory files stay in your project.

BMILD doesn't look at BMAD planning artifacts, but this could change in the future.

## Roadmap

- v0.2 -- Persona breadth stable
- v0.3 -- Persona interactivity stable
- v0.4 -- Dogfood version
- v0.5 -- First public version

## Acknowledgements

BMILD is built upon and inspired by:

- **[BMAD-METHOD](https://github.com/the-bmad-group/bmad)**: The persona archetypes and interactive patterns are adapted from BMAD. BMILD wouldn't exist without the foundation BMAD laid.
- **[Kilo Code](https://github.com/kilo-code)**: The QA debugging methodology is adapted from Kilo Code's Debug prompt.
- **[Tokencast](https://github.com/krulewis/tokencast)**: The tokenizer algorithm used by the Planner persona is adapted from krulewis' implementation in Tokencast.

All referenced materials are used in accordance with their respective MIT licenses.
