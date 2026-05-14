# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Replaced legacy durable question-thread patterns with governed `spec-patch-queue.md` and `user-attention.md` workflows, plus conditional `decision-log.md` guidance across PM, UX, Arch, Planner, Dev, QA, Security, README, and AGENTS documentation.
- Moved groundtruthing guidance out of PM core craft standards and into mode workflows that perform codebase discovery.
- Added code intelligence guidance to mode workflows before file-heavy repository discovery, preferring symbol-aware, AST-aware, or semantic search tools when available.
- Added elicitation queue previews so PM, UX, and Arch name expected question categories and approximate question count before beginning persona-native elicitation.
- Tightened advanced mode handback: Debate, Elicit, and Brainstorming now preserve artifact ownership and return patch-ready notes to the invoking persona unless explicitly authorized to write.
- Expanded QA authority so Rahat can apply minimal confirmed fixes, added QA Spec-Fix and Direct-Fix workflows, and added a lightweight Diagnostic path for small local defects.
- Updated named-persona opening guidance across personas so the operating stance appears only after mode selection and never as placeholder mode-selection narration.
- Changed Lance's icon to `⬛` and Zach's icon to `🟥` for better renderer compatibility.
- Added `version` and `license` metadata to all BMILD skill frontmatter, keeping `bmild-dev` at `0.2.1` and setting the remaining skills to `0.2.0`.
- Removed unintended whole-template markdown code fences from BMILD asset template files so generated artifacts render as markdown rather than fenced code blocks.
- Added BMILD Working Team, Workflow, Definition of Done, and Gotchas guidance across all personas and interactive modes.
- Made Arch and UX conversation-first before artifact authoring, including explicit conflict surfacing and post-authoring synthesis.
- Moved Nyquist verification matrix ownership into Planner readiness, with QA retaining repair/backfill ownership.
- Updated Planner to default to approved-phase planning, prefer minimum viable Slice count, and produce stronger `Likely Required Reads`.
- Updated Dev and QA handoffs to persist AC checks, user verification actions, and actionable verification failures.
- Replaced fragile markdown-table output patterns in skill templates and interactive step files with bullet-based structures.
- Refined Gotchas guidance and skill sections to focus on surprising execution facts rather than restating established rules.
- Added `scripts/validate-skills.sh` to check BMILD skill structure and table-free output surfaces.
- Tightened Planner, Dev, and QA phase/readiness flow: approved-phase planning, future-phase placeholders, required-read preflight checks, and QA/security status ownership.
- Converted ordered persona and step-file workflows to `Progress:` checklists while keeping guidelines as prose or ordinary bullets.
- Updated design-tier decision interaction in PM, UX, and Arch to use labelled option blocks and prefer native structured response-picker tools for constrained choices, with a portable plain-text fallback when no such tool exists.
- Tightened structured-question guidance so PM, UX, and Arch should use native question tools for bounded choices when available, or explicitly state why text fallback was used.
- Updated Elicit to run one best-fit technique proactively, then ask the user to choose from 2-3 follow-up techniques or respond naturally.
- Clarified multi-speaker labeling so Debate and Elicit persona methods only repeat icon/name when the speaker changes.
- Defined documentation ownership: PM identifies required docs, Dev writes them, and QA verifies them against implemented behaviour.
- Added cross-persona operating stance and scope checkpoint guidance for the seven named personas to anchor mode, scope, role boundary, and handoff closure.
- Clarified QA authority: Rahat owns tests, verification matrices, RCA artifacts, QA evidence, and findings documentation, while Alex owns production fixes.
- Tightened QA RCA path rules so initiative-linked defects write under the initiative folder; `_system` is reserved for genuinely global defects.
- Moved named-persona sign-off guidance out of Persona blocks and removed pronoun labels from named personas.
- Updated UX activation and DESIGN.md handling so Katrina reads existing `DESIGN.md` for all scopes and preserves existing structure when updating it.
- Added target responder, status, and deferral-consequence fields for design-tier Open Questions and Handoff Questions, with Planner readiness checks for question closure.
- Added first-person voice guidance to all seven named personas.
- Updated Planner slice budgeting guidance to invoke the skill-local tokenizer with `bash` and persist the returned token estimate in Slice Planning Notes.
- Reframed Dev modes around user intent: Spec, Prototype, and Bug Fix, with shared implementation discipline and mode-specific memory, handoff, and documentation contracts.
- Added Dev note persistence for prototype and bug-fix work that would otherwise disappear into chat-only context.

## [0.1] - 2026-04-20

### Added

- **New Security Persona**: Introduced **Zach (Security)** for security-focused code and architecture review.
- **Configurable Artifact Location**: Added `plan_folder` to `.bmild.toml` for custom memory artifact paths.
- **Personalized Authorship**: All specs and artifacts now track personalized authorship (e.g., "Mike + Faisal (PM)").
- **Algorithmic Tokenizer**: BASH-based tokenizer for deterministic Slice budgeting and context window management.
- **Onboarding Guide**: Added `ONBOARDING.md` for first-run setup and migration from legacy BMAD workflows.
- **Assumptions Interactive Mode**: New mode for groundtruthing specifications against the existing codebase.

### Changed

- **Implicit Context Memory**: Refactored to a universal, non-stateful persistence model for both system and initiative-scoped development.
- **Unified Skill Lifecycle**: Standardized activation and exit sequences across all personas for consistent environment resolution and handoff hygiene.
- **Enhanced Design Elicitation**: Added pre-handoff engagement gates (open questions/assumptions) and conversational issue communication to PM, UX, and Arch personas.
- **Execution-First Synthesis**: Refined Debate, Brainstorming, and Propose skills to proactively apply agreed changes to specifications.
- **Expanded Delivery Planner**: Upgraded Sonia with readiness checks, Slice sequencing, status visibility, and automated rerouting.
- **Documentation Overhaul**: Reworked `README.md` into a stage-based discovery surface with explicit lifecycle routing.

### Fixed

- Improved inter-agent scope awareness and handoff hygiene across all personas.
- Fixed Arch feature-mode context rule to allow designing features without pre-existing platform constraints.
- Resolved hardcoded absolute paths in Delivery Planner references to ensure portability.
- Fixed mode inference for PM persona when handling greenfield vs. brownfield projects.

## [Roadmap]

Anticipated roadmap:

- 0.2 persona breadth stable
- 0.3 persona interactivity stable
- 0.4 dogfood version
- 0.5 public version
