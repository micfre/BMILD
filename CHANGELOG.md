# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-04-26

### Added

- Documentation improvements
- Example output from Interactive Leads debate
- Added `plan_folder` configuration to `.bmild.toml` (defaulting to `plans/`) to allow custom location for memory artifacts

### Changed

- Standardized PM, UX, Architect, Delivery Planner, Dev, and QA skill prompts around context-first openings and explicit next-persona handoffs
- Expanded the Delivery Planner skill contract to cover readiness checks, Slice sequencing, Slice status visibility, and rerouting when implementation exposes blockers or gaps
- Extended the Delivery Planner with a lightweight Slice-budgeting method, a visible budgeting reference asset, and `Likely Required Reads` in Slice handoff artifacts
- Reworked `README.md` into a stage-based discovery surface with lifecycle routing, explicit handoff guidance, and BMAD intent mapping
- Added `ONBOARDING.md` as a compact first-run and BMAD migration guide that reinforces midstream entry and the Delivery Planner role
- Added pre-handoff engagement gates to PM, UX, and Arch: each lead must walk the user through outstanding domain-specific Open Questions and unvalidated Assumptions, and confirm the output artifact is written, before offering handoff; handoff target is now context-adaptive rather than hard-coded
- Added conversational issue communication requirement to PM, UX, and Arch: when any design-tier lead surfaces an open issue requiring user direction, they must explain it in conversation (state issue, options, recommendation) rather than logging it silently to the spec
- Fixed Arch feature-mode context rule: Lance no longer requires `plans/platform/system-design.md` to exist before designing a feature; proceeds from available context and surfaces missing platform constraints as assumptions instead of blocking
- Debate synthesis is now execution-first: after synthesis is confirmed and open items are resolved, the facilitator applies all agreed factual changes to the relevant spec documents and appends the synthesis record, then reports what changed; passive "offer to append" and "cleanup" framing removed
- Elicit apply/discard halt softened to judgment-based: clear improvements are applied and reported without halting; halt is retained only when a method produces competing alternatives or genuinely ambiguous direction; user can say "undo" to revert
- Brainstorming session close is now execution-first: the facilitator proactively synthesizes and presents the summary rather than waiting to be asked
- Fixed two hardcoded absolute paths in Delivery Planner (`bmild-planner`) to use relative paths (`./references/slice-budget-reference.md`), ensuring portability across IDEs that install skills in different root locations

## [0.1]

### Added

- Initial release

## [Roadmap]

Anticipated roadmap:

- 0.2 persona breadth stable
- 0.3 persona interactivity stable
- 0.4 dogfood version
- 0.5 public version
