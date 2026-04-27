# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-04-26

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


## [0.1]

### Added

- Initial release

## [Roadmap]

Anticipated roadmap:

- 0.2 persona breadth stable
- 0.3 persona interactivity stable
- 0.4 dogfood version
- 0.5 public version
