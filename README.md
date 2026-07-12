![BMILD](banner-bmild.png)

# BMILD

*Big Methods, Ideally Less Drama*

<!-- bmild-version-badge -->
![Version](https://img.shields.io/badge/Version-0.3.0-orange)
[![Build Status](https://img.shields.io/github/actions/workflow/status/micfre/BMILD/ci.yml?label=Build%20Status)](https://github.com/micfre/BMILD/actions/workflows/ci.yml)
[![Release Status](https://github.com/micfre/BMILD/actions/workflows/release.yml/badge.svg)](https://github.com/micfre/BMILD/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

BMILD is a small cross-functional team for your coding agent. It gives the agent durable roles, a shared working memory, and a way to move from an idea to verified code without turning your project into an Agile reenactment.

Copy a handful of skill folders into your project. Talk to a persona when you need one. The work and its decisions live in normal Markdown beside your code. There is no service to run, no account, no framework runtime, and no prescribed ceremony to perform.

BMILD is for people who want the useful parts of spec-driven development: clearer intent, implementable decisions, small enough work, real verification, and a record of why things are the way they are. It is deliberately not another agent loop that creates a pile of tickets and calls that a process.

## First two minutes with BMILD

1. Put the `bmild-*` skill folders where your agent discovers skills.
2. Start where you actually are, not where a workflow says you should be. For example: `Faisal, help me frame a feature for team invites.`
3. Let the relevant persona write a useful artifact and hand you to the next owner when there is one.
4. When the work is ready, Sonia turns it into small vertical Slices sized for an LLM implementation session, with verification planned before code is written.
5. If the work changes, BMILD marks affected artifacts stale, records the decision and routes the repair to the right owner. It does not pretend the original plan is still true.

That is the whole idea: retain context and judgment while keeping the interaction human and direct.

## Start here

BMILD is skill-native. Copy the folders from this repository into the skills directory for the repository you want to work in. You can vendor them, use a symlink, or distribute them through your normal team setup.

```sh
mkdir -p .agents/skills
cp -R /path/to/BMILD/.agents/skills/bmild-* .agents/skills/
```

Skill locations for harnesses are:

- **Codex:** `.agents/skills/`
  (as well as many other harnesses which use 'standard' discovery paths)
- **Claude Code:** `.claude/skills/`
- **OpenCode:** `.opencode/skills/`

Then open your project with a capable coding model and say one of these things:

```text
Faisal, help me frame a feature for team invites.
Katrina, design the experience for the existing billing settings.
Rahat, diagnose this failing CI test.
Alex, implement slice 2 for team-invites.
```

There is no required “start BMILD” command. Calling the persona by name is the best way to activate them (their names aren't just ornamentation, they are unique calling cards which activate the skills). A persona looks at the available context and the state of the work, then takes the appropriate approach. If you have an existing project and a specific problem, say so. If you have a vague idea, say that instead.

### First day with BMILD

The first day should feel practical, not like onboarding for a project-management tool.

- **Starting something new?** Ask Faisal to frame it. He helps establish the problem, users, scope, success criteria, and the first version of the requirements.
- **Already have direction?** Go straight to Katrina for interaction design or Lance for architecture. BMILD does not make you recreate a product brief just to earn permission to discuss an API.
- **Ready to implement a written spec?** Ask Sonia for readiness and a Slice plan, then hand a Slice to Alex.
- **Fixing a bug or an awkward old area?** Start with Rahat. The point is to establish a cause and evidence before changing code, not force a greenfield process onto a maintenance task.
- **Facing a real trade-off?** Ask for a Roundtable, or use Elicit to push a draft past its first plausible answer. You still make the call.

By the end of the first day using BMILD, you should have a small body of project memory that an agent can re-enter tomorrow: the current problem, a few decisions, what is live, what is stale, and what comes next. You do not need every artifact for every piece of work. If you forget where you left off, just ask Sonia, she knows.

## A good default `.bmild.toml`

`.bmild.toml` is optional. To create preferences, create and save it at the project root. With no file, BMILD uses sensible defaults and stores its working memory in `plans/`. Adding this small version early is enough for most projects:

```toml
user_name = "Developer"
plan_folder = "plans/"
slice_target = 300000
```

- `user_name` lets the named personas address you naturally. It is a small thing, but it makes a long working session less anonymous.
- `plan_folder` is where BMILD keeps its Markdown memory, relative to the repository root. Leave it as `plans/` unless you have a reason to keep generated project memory elsewhere.
- `slice_target` is the token budget Sonia uses for one implementation Slice. It is not the model’s advertised maximum context window: leave room for the agent’s instructions, repository context, tool output, reasoning, and verification. As a starting point, use roughly 30% of the usable window when you want a conservative plan; 50% is a more liberal ceiling for stable, well-understood work. Context quality degrades as a window fills, so lower is usually safer.

## About automated commits

The default is `commit = 0`: Alex makes no commit and does not prepare a commit message. The following is a safe starting point when you want to make the behaviour explicit:

```toml
commit = 0                         # 0: off; 1: message + eligible local commit; 2: message only
# format = "conventional-commits" # omit to infer local history, then fall back here
branch = "current"                # current | initiative
```

Use `commit = 2` when you want Alex to prepare a message without changing Git state. Use `commit = 1` when you want at most one eligible local commit after successful, attributable work. In either mode, repository and harness guidance can only reduce that authority. With posture `1`, BMILD preserves unrelated changes, uses normal hooks, and commits only the paths Alex changed in that invocation. If the state is unsafe, incomplete, blocked, or cannot be cleanly attributed, Alex falls back to a message-only result or does nothing.

Set `format = "conventional-commits"` for that explicit message style; otherwise Alex makes a bounded attempt to infer the local convention before falling back to it. Keep `branch = "current"` to stay on your selected branch. Use `branch = "initiative"` only when you want eligible commit work to use the confirmed initiative branch and understand that a clean worktree is required for any switch or creation.

> [!WARNING]
> Automated commit posture is deliberately local-only. It never fetches, pulls, pushes, opens a pull request, stashes, amends, rebases, resets, bypasses hooks, or rewrites history.

### About Slice sizing and tokenizer settings

Sonia budgets Slices for an LLM implementation session rather than estimating human effort. This is a useful distinction: an apparently small change can require too many reads, edits, and decisions to fit safely in one context window; a larger-looking change can be straightforward when the context is tight and stable.

You do **not** need to tune the tokenizer settings on day one. Leave `slice_target` and the `tokenizer_*`, `penalty_*`, `edit_premium`, and `carry_cap` values alone unless you are deliberately calibrating the planner for a known model and repository shape. They are informed planning controls, not an exact science, and this surface is likely to become simpler. The default behaviour is the right place to start.

If you later want to tune the planning budget, begin with only `slice_target`: set it to a conservative implementation-session context budget for the model you actually use. Treat the resulting estimate as a signal to split, recut, or hand back work—not a promise about token consumption.

Note that every LLM provider, model tier, and reasoning depth will have significantly different token consumption and while BMILD has a "real" tokenizer, it cannot be calibrated for every variant out there. You can tune the preferences over time, but this is not something to worry about early on.

## Why BMILD is different

### It is not a scripted workflow

BMILD has a common path—frame, design, plan, implement, verify—but it is a map of ownership, not a funnel. Personas activate from the state of the work and the artifacts already present.

That matters in real repositories. Greenfield work may begin with product framing. Brownfield work may begin with a failing test, an undocumented architectural constraint, or a half-finished feature that needs a careful re-plan. You can run any number of initiatives in parallel. Each has its own folder and live artifact registry, while shared meaning and durable cross-project decisions remain visible at the project level.

It also adapts to you. If you want help finding the questions, the design-tier personas probe and slow the agent down where the stakes are real. If you already know the decision, say it; the persona captures its consequences rather than making you sit through a performance of discovery. BMILD is meant to provide judgment and structure where they help, not to demand a ritual before useful work can start.

### It replaces Agile ceremony with context management

Epics, stories, sprints, and points were built to coordinate people and forecast human capacity. They can be useful in their setting. They are not a natural unit of work for a coding model.

BMILD uses an **initiative** for a coherent piece of product or system work and a **Slice** for a vertical, verifiable implementation unit. Slices are deliberately bounded by the context an LLM needs to read, reason, edit, and verify safely. Their planning includes expected reads, edits, acceptance criteria, and proof—not a made-up point value.

This is the central design choice in BMILD. The framework optimizes the agent’s usable context and the clarity of its inputs, not the appearance of a familiar delivery process. You can still use your existing issue tracker, sprint cadence, or team rituals if they serve people. BMILD simply does not mistake them for the agent’s operating system.

### It treats artifacts as working contracts

The memory is plain Markdown, but it is not a chat transcript. Each meaningful document has an owner, consumers, and a job:

- product and requirements documents capture intent and priority;
- UX and system-design documents make the experience and technical contracts concrete;
- Slices and verification matrices turn approved work into an implementable, provable plan;
- RCA and security-review artifacts keep confirmed failures and findings from becoming tribal knowledge.

BMILD can work from either greenfield or in a brownfield environment. BMILD is designed to groundtruth at every stage, it will not -- or rather tries hard not to -- write a beautiful spec document that collides with existing code reality that it never thought to look for.

The benefit is simple: a fresh agent session has something better than a summary to work from. It can identify what is current, what it should read, and what it is allowed to change. You can inspect and edit every part of it without anything proprietary.

### It assumes specifications will drift

Plans change. Implementation reveals constraints. A product decision invalidates UX or architecture work. A decision made in chat is easy to lose. BMILD treats this as a normal day.

- `registry.md` identifies which initiative artifacts are **live**, **archived**, or **stale**, so a persona does not confidently build against superseded guidance.
- `context.md` keeps initiative-local terms, boundaries, and resolved ambiguities. `context-map.md` carries the cross-initiative version of that shared meaning.
- A decision goes into an ADR only when it is hard to reverse, surprising without context, and the product of a real trade-off. Active rationale stays where the work happens; the ADR protects the decisions future maintainers are most likely to “fix” by accident.

> [!NOTE]
> A handoff is for a judgment another owner still needs to make. When a fact is already settled—by the code, a ratified decision, or a single clear constraint—a persona may scribe that narrow fact into another owner’s artifact in the same session. Scribing records settled truth; it never authors a new decision. It carries provenance and checks the target persona’s point of view, while project-wide `DESIGN.md`, `context-map.md`, and ADRs always use the normal owner route.

When a change affects multiple design owners, Sonia’s course-correction mode maps the impact, breaks it into bounded questions, convenes the required perspectives, and orders the repairs. It is re-planning without throwing away the context that made the original plan useful.

### It makes handoffs useful

A handoff is not “someone else’s problem now.” It is a precise request to the persona that owns the canonical artifact: what changed, why it matters, the decision or evidence they need, and exactly what source document may need repair. When that owner returns, their handback updates the canonical spec and records the promotion. The handoff itself is coordination history, never a competing source of truth.

This is a major part of how BMILD contains spec drift. Decisions and unresolved questions do not hang indefinitely in an ever-expanding chat log, where a later session can miss or reinterpret them. A resolution lands in the artifact that governs the work; its downstream consumers are then classified as unaffected, needing a minor update, or stale. Larger cascades go to Sonia for Course-Correction.

This makes BMILD particularly comfortable for work that crosses sessions, agents, or people. It gives continuity without pretending that the system can make unresolved decisions on your behalf.

## The team

BMILD has seven standard personas and three interactive modes. They are deliberately opinionated about their own responsibilities, but they are not a chain of approval gates.

- **Faisal 🟦 — Product Manager:** frames the problem, users, scope, success criteria, and requirements. Useful when the “why” or “what” is still blurry.
- **Katrina 🟩 — UX Designer:** owns information architecture, flows, states, interaction rules, and the experience people will actually have.
- **Lance 🟫 — Architect:** turns a chosen direction into implementable data, API, service, and technology contracts; makes trade-offs explicit.
- **Sonia 🟧 — Delivery Planner:** checks whether a design is ready to build, creates verification coverage, sizes vertical Slices, and re-plans when reality changes.
- **Alex 🟪 — Developer:** implements Slices, bounded direct work, and fixes while respecting the project’s existing code and durable memory.
- **Rahat 🟨 — QA & Reliability:** diagnoses before fixing, plans proof, records RCAs where they will matter later, and verifies the shipped behaviour.
- **Zach 🟥 — Security:** performs contextual security review and prioritizes concrete, exploitable issues over generic warning noise.

The three interactive modes are available whenever they help. A persona may suggest one when the work would benefit from wider options, a stress test, or cross-functional trade-offs; you can also ask for one directly at any time. The calling session is suspended, not discarded, so the original persona resumes with the facilitator’s output and does not re-ask what you have already settled.

- **Brainstorm:** expands the option space before convergence.
- **Elicit:** strengthens a draft through structured questioning and challenge.
- **Roundtable:** brings the relevant perspectives to one bounded decision, makes trade-offs visible, and leaves the decision with you. `Debate` remains a valid trigger.

## What the work looks like

> [!NOTE]
> **Workflow visual placeholder** — replace this callout with the BMILD workflow image.

The workflow is intentionally non-linear. You might start at Alex for a small bounded change. Rahat may surface a design flaw that needs Lance. An existing UX design may be enough to begin planning. Sonia may send a change upstream rather than papering over a gap. The important part is that the next move is based on the state of the work, not which box you were supposed to visit first.

### Readiness is a quality check, not a ceremony

Before Sonia decomposes a design into implementation Slices, she checks that the work is actually ready: the required intent is covered downstream, the contracts are usable, and the proof boundary is clear enough to verify. If the answer is no, the useful outcome is a specific handoff to repair the gap—not a plan that makes ambiguity look organized.

This is where BMILD earns the extra few minutes of thought. An LLM can produce code very quickly from a weak prompt. It can also create a polished but expensive misunderstanding. Readiness exists to keep the agent from silently deciding product, UX, or architectural questions that have not been decided.

> [!TIP]
> Use a model and reasoning depth you trust for Sonia’s readiness and Slice planning, and for Rahat’s Nyquist verification and final evidence. Sonia’s plan directly shapes Alex’s implementation effort; Rahat’s verification closes the loop against it. Deeper reasoning is most valuable on consequential work, but it is not a substitute for clear requirements, code evidence, or an honest “not ready” verdict.

### Context has a cost

BMILD uses more tokens than asking an agent for a one-shot patch. It spends them on role instructions, durable artifacts, and the evidence needed to make a decision or verify a result. That is intentional: the framework trades some up-front context for fewer rediscovered decisions, less drift, and less code built on an invented interpretation.

It manages that cost through progressive disclosure rather than loading the whole project memory every turn. The compact core skill selects the active mode; detailed mode instructions load only when that mode needs them. Personas load the relevant **live** artifacts for the named initiative and task, not archived or stale material and not unrelated initiative folders.

There is an important safety exception. UX and Architecture may reuse artifact contents already visible in the conversation when they are still trustworthy, and the advanced modes prefer the current conversation unless files are needed to ground the question. Planner, QA, and Security deliberately reload relevant live artifacts because stale planning, verification, or security context can do more damage than the extra tokens. In other words, BMILD optimizes context use; it does not pretend that reliable work is free.

## Memory, without a platform

By default, BMILD writes its durable project memory under `plans/`. The paths are relative to the project root and are ordinary Markdown files with frontmatter, so the material stays portable and reviewable.

```text
<project-root>/
├── .bmild.toml                    # optional preferences
├── DESIGN.md                      # durable project-wide UX patterns
└── plans/                         # or your configured plan_folder
    ├── context-map.md             # cross-initiative concepts and boundaries
    ├── rollup.md                  # initiative index, status, decision log
    ├── adr/                       # selected durable decisions
    └── <initiative-name>/
        ├── registry.md            # live, archived, and stale artifacts
        ├── context.md             # local terms, boundaries, ambiguities
        ├── product-brief.md
        ├── prd.md
        ├── ux-design.md
        ├── system-design.md
        ├── handoff.md
        ├── verification-matrix.md
        ├── slices.md and slice-<N>.md
        ├── rca-<slug>.md
        └── security-review-<slug>.md
```

An initiative is an atomic body of work, not an Agile epic. Its name is a confirmed lowercase kebab-case identifier, such as `team-invites`. `registry.md` is the initiative’s entry point: it tells a returning persona which documents are current and which have been made stale by an upstream change.

### Works with existing standards

BMILD keeps project-wide UX patterns in root-level [`DESIGN.md`](https://github.com/google-labs-code/design.md), aligned with Google’s lightweight design-document convention. Katrina distils a pattern there only when it applies beyond one initiative; initiative-specific interaction decisions stay in `ux-design.md`.

The configured `plan_folder` is an [Open Knowledge Format (OKF) v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) bundle. Each BMILD memory artifact inside it is an OKF concept with standard YAML frontmatter first and BMILD workflow fields preserved alongside it; Markdown links make the corpus traversable. `DESIGN.md`, `README.md`, and project documentation sit outside that bundle. This is compatibility, not a new platform dependency: BMILD works as plain Markdown whether or not an OKF consumer is present.

## Practical prompts

Use the role you need, in ordinary language. These are starting points, not special commands:

```text
Faisal, I have a rough idea for self-serve team invites. Help me decide what the MVP is.

Katrina, the invite flow exists but feels confusing. Design a better flow from the current repository context.

Lance, we need tenant-aware roles. Design the data and API contracts for it.

Sonia, check whether team-invites is ready and plan the first implementation phase.

Alex, implement slice 1 for team-invites.

Rahat, this intermittent invitation-email test is failing in CI. Diagnose it before changing code.

Zach, review the invitation acceptance endpoint and its trust boundaries.

Roundtable the question of whether invitations should expire.
```

You can name an initiative, point at a failing test, paste a decision, or say “I do not know where to start.” The personas should meet the work at that level.

## Compatibility and expectations

BMILD is designed first for Codex, Claude Code, and OpenCode, and it may work in other environments that support the agent Skills pattern. The planner uses a native shell script on macOS, Linux, and WSL, and an equivalent PowerShell script on Windows-native environments.

Use a capable coding model. BMILD asks the agent to make semantic distinctions—what is live versus stale, who owns a question, whether a decision belongs in an ADR, and what context an implementation really needs. Better reasoning models will make more of the framework; the files remain useful regardless.

BMILD is intentionally lightweight, but it is not invisible. It writes project memory, asks questions when decisions matter, and sometimes tells you that a plan is not ready. That is the trade: a little deliberate work now for less rework and less forgotten context later.

### Working beside other frameworks

BMILD grew out of [BMAD-METHOD](https://github.com/the-bmad-group/bmad), whose persona archetypes and interactive patterns were formative. The difference is one of operating model: BMAD runs a fuller Agile-with-AI approach; BMILD is skill-native, artifact-led, and deliberately less prescriptive.

Do not install BMILD and BMAD skills side by side in the same discovery location. They share trigger language and can make an agent select unpredictably. BMILD does not currently read or convert BMAD planning artifacts.

### Removing BMILD

Remove the `bmild-*` folders from your skills directory, and the `.bmild.toml` file from project root if it exists. The Markdown memory remains in your project until you decide to delete it. There is no service, database, or hidden state to unwind.

## What to look at next

- You made it through the README, congrats!
- Browse [`.agents/skills/`](.agents/skills/) to see the portable skill folders that make up the framework.
- Read the `SOUL.md` in each persona folder to discover the point of view behind its role.
- Read [`AGENTS.md`](AGENTS.md) for the authoritative artifact map, ownership rules, memory layout, and governance details.
- Read [`.bmild.toml.example`](.bmild.toml.example) when you want the complete current set of configuration options.

## Roadmap

> [!TIP]
> **You are here: v0.3.** The foundations are in place; the remaining work is to make the operating model more interactive and ready for a first public release.

- [x] **v0.1** — Initial commit
- [x] **v0.2** — Persona scope stable
- [x] **v0.3** — Context memory structure stable
- [ ] **v0.4** — Persona interactivity stable
- [ ] **v0.5** — First public version

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
