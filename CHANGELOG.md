# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

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

## [0.2.0] - 2026-04-26

## [0.1]

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
