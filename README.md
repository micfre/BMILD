![BMILD](banner-bmild.png)

# BMILD -- Breakthrough Method for Interactive Leads Development

<!-- bmild-version-badge -->
![Version](https://img.shields.io/badge/Version-0.2.9)
[![Build Status](https://img.shields.io/github/actions/workflow/status/micfre/BMILD/ci.yml?label=Build%20Status)](https://github.com/micfre/BMILD/actions/workflows/ci.yml)
[![Release Status](https://github.com/micfre/BMILD/actions/workflows/release.yml/badge.svg)](https://github.com/micfre/BMILD/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> [!IMPORTANT]
> BMILD is entering a phase of increased churn. Planning artifacts have just received a significant
> architectural enhancement which means spec/design documents created in <0.2.1 may not be directly
> compatible in later versions. The VERSION and roadmap are still accurate signals for stability
> milestones. Context memory file structure will be locked at v0.3.0.

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
| **Lance**&nbsp;🟫 | Architect | Names the cost of every choice. Produces implementable contracts -- schema columns, endpoint shapes, service signatures -- not high-level boxes and arrows. |
| **Sonia**&nbsp;🟧 | Delivery Planner | Zero tolerance for ambiguity in implementation inputs. Sizes work to fit context windows, not story points. |
| **Alex**&nbsp;🟪 | Developer | Implements planned Slices, prototypes bounded repo work, and fixes bugs. Matches existing patterns, avoids needless ceremony, and promotes durable implementation truth into the governing artifacts instead of sidecars. |
| **Rahat**&nbsp;🟨 | QA & Reliability | Diagnoses before fixing. Can apply minimal confirmed fixes when evidence is clear, and persists RCA when future context needs it. |
| **Zach**&nbsp;🟥 | Security | Contextual SAST code review. Prioritizes high-confidence, actionable vulnerabilities over theoretical noise. Perspective is grounded in real-world exploitability. |

Plus three interactive modes that work across personas:

- **Roundtable** 🌀: Structured multi-persona deliberation with flexible attendance. The convened design-tier leads surface trade-offs in front of you — Non-negotiable, Preference, Open — without recommending a decision. The user decides; the owning persona patches. Attendance is set per question, not fixed. ("Debate" remains a valid trigger phrase; the rename reflects what the skill actually does.)
- **Elicit** ⚡: Added help to expand your own thinking and intent. 20+ structured methods to push requirements, UX decisions, or architecture past "good enough" into genuinely strong.
- **Brainstorm** 💡: Open-ended ideation designed to get past obvious ideas. Anti-bias protocols prevent the facilitator from clustering around a single direction.

## BMILD works through

The personas are designed around a two-tier model:

**Design tier** (Faisal, Katrina, Lance) -- These personas are deliberate. They probe, they elicit, they question. Their job is to surface what would otherwise go unstated. Modern LLMs inherently want to start immediately and get to green fast; the design personas resist that and ensure the user drives the pace.

**Execution tier** (Sonia, Alex, Rahat, Zach) -- These personas plan and implement with context-window optimized vertical slices and robust quality pre-planning and verification. They activate lean, act on coherent inputs, and hand back when a blocker is outside their authority. Less ceremony, more efficient path to working code.

Sonia, as the pivot between tiers, is where BMILD earns its keep. The spec gets the scrutiny it deserves. It is structurally unavoidable to bypass the readiness checks, the user does not need to remember to separately call on a readiness skill before planning development deliverables. Sonia takes care of this and lets you know it's ready. Sonia's also responsible for the overall system memory.

When a change request mid-flight invalidates two or more design-tier artifacts — a PRD change that ripples into UX and architecture, a design decision discovered during implementation that forces rework upstream — Sonia enters **Course-Correction** mode. She doesn't make design decisions herself; she decomposes the change into bounded questions, convenes a Roundtable per question, records the user-ratified synthesis in a `change-proposal-<slug>.md`, and produces an ordered handoff chain so each owning persona patches their own artifact in sequence. Trigger phrases include "correct course", "change request", "spec change", or "rework needed".

### Handoffs

Personas read project context from the configured memory folder before they speak. They tell you what stage appears current, what's complete, and who should engage next. You don't have to remember the workflow -- they do, and they route it.

Handoffs are obligations, not exits. Each persona passes a usable contract to the next teammate:

- Faisal passes problem framing, success criteria, and MVP/Growth priority.
- Katrina passes observable UX flows, states, and interaction decisions.
- Lance passes implementable architecture contracts.
- Sonia passes phase-scoped Slices, likely required reads, and verification boundaries.
- Alex passes checked acceptance criteria for planned Slices, promoted technical truth in `system-design.md` when warranted, required documentation updates, and user verification actions.
- Rahat passes persistent verification evidence, documentation verification, documented defects, and minimal confirmed repairs when QA can close the loop directly.
- Zach passes only high-confidence security findings with owner and remediation path.

Every standard persona close has two different jobs:

- `For you, ...` is only for a real user-facing action that helps complete the step just finished, such as reviewing the written artifact, answering a queued decision, or running a manual verification check.
- `Next.` is the workflow move to the next persona or terminal state.

Those lines should stay separate. Internal memory bookkeeping belongs in artifacts, not in the user-action line, unless the user must act on it.

When ambiguity appears, BMILD does not preserve it as durable chat threaded through source artifacts. It routes the issue into one of four governed outcomes:

- `handoff.md` for source-artifact defects, cross-artifact conflicts, or promotion requests that require another owner's action
- bounded assumptions inside the consuming source artifact when the risk is low and reversible
- direct promotion into the governing source artifact when the truth is now known and no further owner judgment is required
- explicit defer, reject, or supersede outcomes when that is the honest state

Handoff items are non-authoritative by design. A resolution becomes truth only after the owning persona promotes it into the target source artifact.

Each standard persona auto-routes to its **Handback** mode when handoff items target its artifacts. The user does not need to remember the handoff file or invoke handback explicitly — invoking the persona by name (e.g., "Lance, look at py-tokenizer") is enough; the persona checks `handoff.md` at activation and runs Handback if items are waiting. When a single promotion invalidates ≥2 downstream owners, the closing handoff routes to Sonia for Course-Correction instead of fragmenting into separate per-owner threads.

Advanced modes are team tools. Roundtable resolves consequential ambiguity with attendance configured per question, Elicit strengthens a draft, and Brainstorm expands options before convergence. When invoked from inside a named persona workflow, they return patch-ready notes to that persona instead of taking over artifact ownership.

Named personas also open with a compact operating stance that identifies who is speaking, the work type, the active scope, and the role boundary. This keeps weaker harnesses oriented without turning the personas into rigid scripts.

### Artifact Flow

BMILD artifacts have owners and consumers:

- `product-brief.md`: created by Faisal; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines problem, users, success criteria, scope, and vision. Entry contract for downstream design.
- `prd.md`: created by Faisal once a brief exists; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines functional requirements, journeys, prioritization (MVP / Growth), NFRs, and required documentation updates (README, contributor guides, runbooks, release notes, onboarding, user-facing help). Validated through coverage checks and verification matrix entries.
- `[plan_folder]/context-map.md`: created and maintained primarily by Faisal; consumed when work spans multiple initiatives or shared semantic boundaries; defines project-level contexts, shared concepts, and cross-context relationships.
- `[plan_folder]/rollup.md`: created and maintained primarily by Sonia; consumed by all standard personas when resolving initiative names, aliases, or current status; includes `## Decision Log` for durable, concise cross-initiative history.
- `[plan_folder]/adr/<NNNN-slug>.md`: drift-protection ADRs created and maintained by Lance when a decision is hard to reverse, surprising without context, and the result of a real trade-off (the triple-axis gate; initiative-local or cross-initiative, tagged by `scope:` frontmatter); consumed by Sonia, Alex, Rahat, and Zach when their work touches that durable decision. Active design rationale stays in `system-design.md` §2.
- `context.md`: created and maintained by Faisal, Katrina, Lance, and Zach; consumed by all standard personas; defines initiative-local terms, boundaries, relationships, and resolved ambiguities. It is for meaning, not implementation detail.
- Project-root `DESIGN.md`: created and maintained by Katrina; carries durable global UX patterns (palette, typography, global component rules) distilled from initiative-specific UX work.
- `ux-design.md`: created by Katrina; consumed by Lance, Sonia, Alex, Rahat, and Zach; validated through observable user-state checks.
- `system-design.md`: created by Lance; consumed by Sonia, Alex, Rahat, and Zach; validated through implementability, testability, and security review. Alex also writes durable implementation-confirmed technical truth here when no other owner's judgment is required.
- `handoff.md`: initiative-local coordination artifact for source-artifact defects, cross-artifact conflicts, and promotion requests that require another owner's action. It is non-authoritative until the target owner updates the target artifact.
- `change-proposal-<slug>.md`: created by Sonia in Course-Correction mode when a change affects ≥2 source-artifact owners; carries the impact map, bounded questions, roundtable synthesis records, ordered handoff chain, and handoff references. Sonia coordinates and orders; design-tier decisions are deliberated via Roundtable and authored by the owning persona in Handback.
- `slices.md` and `slice-<N>.md`: created by Sonia; consumed and updated by Alex; verified by Rahat and Zach; recut by Sonia when implementation reveals a planning problem.
- `verification-matrix.md`: created by Sonia during readiness when proof boundaries matter; repaired or expanded by Rahat; consumed by Alex; validated by Rahat during verification.
- `rca-<slug>.md`: created or updated by Rahat for confirmed defects; consumed by Rahat or Alex for fixes depending on scope; closed by Rahat after evidence shows the regression is covered.
- `security-review-<slug>.md`: created by Zach when exploitable findings exist; consumed by Alex for implementation fixes or Lance/Katrina for design changes; closed by Zach after remediation is verified.
- Documentation files: requirements defined by Faisal, implemented by Alex, and verified by Rahat against the shipped behaviour.

Governance rule:
- authoritative state lives in BMILD source artifacts, not in `handoff.md` history
- `accepted` is an intermediate workflow state, not a truth state
- unresolved user elicitation lives in chat unless async owner-to-owner continuity requires a governed handoff item

RCA path rule: initiative-linked defects live in the initiative folder.

### Memory

No orchestrator, no state machine. Personas write directly to the folder specified by `plan_folder` in `.bmild.toml` (defaults to `plans/`) at your project root using plain markdown. This can be structured alongside project source or kept separately — the personas resolve all paths relative to the project root.

When you name an initiative, standard personas check the exact initiative folder first, then consult `rollup.md` if it is absent. Initiative-scoped work starts from `registry.md`, then loads `context.md` and the relevant live artifacts. Design-tier personas use PM artifacts as fixed upstream truth: Katrina and Lance read `product-brief.md` and `prd.md` before eliciting, then ask only UX- or architecture-owned follow-up questions. Lance also treats `ux-design.md` as an upstream interaction contract. Katrina reads `system-design.md` when present for technical constraints only, not as a source of UX intent.

```
<project-root>/
├── DESIGN.md                       # Katrina output: durable global UX patterns (palette, typography, component rules). Project-root because it is a project-wide standard.
└── plans/ (or your custom plan_folder)
    ├── context-map.md             # Project-level semantic map across initiatives, shared concepts, and boundaries.
    ├── rollup.md                  # Initiative index, aliases, status summary, and Decision Log.
    ├── adr/                       # Drift-protection ADRs (triple-axis gated; initiative-local or cross). Created lazily.
    └── <initiative-name>/          # The atomic unit of work (Feature / Initiative).
        ├── registry.md             # Initiative-local live/archive/stale artifact registry.
        ├── context.md              # Initiative-local semantic context: terms, boundaries, relationships, ambiguities.
        ├── product-brief.md        # Faisal output: problem, users, success criteria, scope, vision.
        ├── prd.md                  # Faisal output: requirements, journeys, prioritization, NFRs, doc scope.
        ├── ux-design.md            # Katrina output: initiative-specific flows, screen states, interaction rules.
        ├── system-design.md        # Lance output: schema, API contracts, service contracts, tech choices, and durable implementation-confirmed technical truth.
        ├── handoff.md              # Initiative-local owner-to-owner coordination for source defects, cross-artifact conflicts, and promotion requests.
        ├── change-proposal-<slug>.md # Sonia output (Course-Correction mode): impact map, bounded questions, roundtable synthesis, ordered handoff chain.
        ├── verification-matrix.md  # Sonia/Rahat: proof map for requirements and Slices.
        ├── slices.md               # Sonia output: Slice registry.
        ├── slice-<N>.md            # One file per Slice.
        ├── rca-<slug>.md           # Rahat output: root cause analysis.
        └── security-review-<slug>.md # Zach output: security findings.
```

Path rationale:
- `DESIGN.md` lives at the **project root** as a project-wide standard, treated like `README.md`.
- `context-map.md` lives at the **configured `plan_folder` level** because it describes durable cross-initiative semantics and boundaries.
- `rollup.md` lives at the **configured `plan_folder` level** because it is the operational index of initiatives, aliases, status, and notable decisions.
- `adr/` lives at the **configured `plan_folder` level** as the single discovery point for drift-protection ADRs (triple-axis gated; tagged by `scope:` frontmatter as initiative-local or `_cross`). Active design rationale for an initiative stays in `system-design.md` §2; only decisions passing the triple-axis drift test promote to `adr/`.
- `registry.md` exists **only per initiative** because liveness and staleness are initiative state, not global semantic context.

`registry.md` is the initiative-local entry point for artifact state. It lists documents that are currently `live`, `archived`, or `stale`. Personas load only what is live and only what is relevant to the current engagement mode.

Every `registry.md` follows this structure:

```markdown
---
scope: <initiative-name>
updated: YYYY-MM-DD
---

## Live
- product-brief.md
- prd.md
- ux-design.md

## Archived

## Stale
- prd.md (driven by H-007 in handoff.md)
```

- `## Live` — filenames of artifacts currently in use. One per line, prefixed with `- `.
- `## Archived` — filenames of superseded artifacts, same format.
- `## Stale` — filenames of artifacts superseded mid-flight by an upstream change that must not be consumed as current truth until the owning persona repairs them. Each line names the artifact and the `handoff.md` item or `change-proposal-<slug>.md` driving the staleness. The line moves back to `## Live` when the patch lands.
- Frontmatter `scope` identifies the initiative.
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

It checks frontmatter names, description length, required BMILD sections, standard persona handoff sections, `Progress:` checklists for ordered workflows, accidental markdown table rows in BMILD skill surfaces and validator-owned docs, and regressions to retired BMILD artifact names in active guidance.

## Getting started

1. Put the `.agents/skills/` directory where your IDE or CLI looks for skills (see table below).
2. Say: `Faisal, help me frame a feature for [your idea].`
3. Follow the handoffs. Faisal will tell you who's next.

Or jump in wherever makes sense:

| Where you are | Who to call | What to say |
| :--- | :--- | :--- |
| I have an idea | **Faisal** 🟦 | `Faisal, help me frame a feature for [idea].` |
| I know what to build, need the UX | **Katrina** 🟩 | `Katrina, design the user experience for [feature].` |
| I need backend contracts | **Lance** 🟫 | `Lance, design the API and data model for [feature].` |
| Design is done, need implementation plan | **Sonia** 🟧 | `Sonia, check readiness and decompose into slices.` |
| I have a slice ready to build | **Alex** 🟪 | `Alex, implement slice 3.` |
| Something is broken | **Rahat** 🟨 | `Rahat, diagnose this failure.` |
| I want a security review | **Zach** 🟥 | `Zach, review this code for security vulnerabilities.` |

You can also engage the interactive modes at any point:

| What you need | Mode | What to say |
| :--- | :--- | :--- |
| Stress-test a spec or design | **Elicit** ⚡ | `Elicit this.` |
| Cross-functional input on a hard decision | **Roundtable** 🌀 | `Roundtable this.` (or `Debate this.`) |
| Ideate outside the obvious answers | **Brainstorm** 💡 | `Brainstorm this.` |
| Mid-flight change request invalidates multiple docs | **Course-Correction** (via Sonia) | `Sonia, correct course on [initiative] because [reason].` |

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
  - **Party Mode:** → Roundtable. "Roundtable this topic." The leads come together with flexible attendance — the convened subset depends on the question. *<small>Currently operates in a single context window, does not spawn subagents (which is a cool trick BMAD is implementing).</small>*
  - **Advanced Elicitation:** → Elicit. "Help me articulate this topic." Intelligent objective-oriented probing.
  - **Brainstorming:** → Brainstorm. "Start a brainstorm on this topic." Operates essentially the same.
  - **Correct Course:** → Course-Correction (a Sonia mode, not a separate skill). Sonia coordinates and orders the cross-artifact handoff chain; she does not author design-tier patches herself. The owning persona patches in Handback.
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
- **[SOUL.md](https://github.com/aaronjmars/soul.md)**: Provided useful input to develop distinctive agent personas.
- **[Grill-with-Docs](https://github.com/mattpocock/skills/blob/main/skills/engineering/grill-with-docs/SKILL.md)**: Context and ADR logs format adapted from mattpocock's Grill-with-Docs.
- **[GSD](https://github.com/gsd-build/get-shit-done)**: Nyquist Validation rule adapted to specific skill behaviours.
- **[Kilo Code](https://github.com/kilo-code)**: The QA debugging methodology is adapted from Kilo Code's Debug prompt.
- **[Tokencast](https://github.com/krulewis/tokencast)**: The tokenizer algorithm used by the Planner persona is adapted from krulewis' implementation in Tokencast.

All referenced materials are used in accordance with their respective MIT licenses.
