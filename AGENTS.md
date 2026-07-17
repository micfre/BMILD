# Agents

The output of this project are the agent skills located in the `.agents/skills/` directory. Other files support development, testing and version control of the agent skills.

## Skill Development Guidelines

BMILD skills must follow these API-like design principles:

1. **Follow the Spec**:
   The industry skills specification is stored in `docs/best-practices/`.
   - `agent-skills-specification.md` includes the specification (from live site: <https://agentskills.io/specification>).
   - `agent-skills-best-practices.md` offers implementation guidelines (from live site: <https://agentskills.io/skill-creation/best-practices>).
2. **Follow the Skill Structure**:
   The skill-development templates in `docs/` are official BMILD documentation for skill format, content and shape.
   - Mode-specific instructions live in each skill's `resources/`.
   - Artifact templates live in each skill's `assets/`.
3. **Skill Structure**:
   Keep skill structure aligned across all personas to the extent that is reasonable to do to. Avoid patching a single skill as this may solve the local issue but will lead to drift that makes skills behave differently over time and create for more maintanace overhead.
4. **Context-Aware Personas**:
   Personas do their own thinking and are not bound by prescriptive linear flows or rigid tiers. They are domain specialists activated by the artifact state. Personas PM, UX, Arch are referred to as design-tier personas, personas Planner, Dev, QA and Sec are referred to as execution-tier personas, and together they are the 'standard' personas. Brainstorming, Elicit and Roundtable are the advanced elicitation skills.
5. **Context Loading Policy**:
   - PM and Dev usually reload memory artifacts because they often run in fresh windows. Dev may skip BMILD memory reads in Prototype or Bug Fix Mode when the work is local and does not depend on documented behaviour, but if implementation reveals durable technical truth it should be promoted into `system-design.md`, and if another owner must act it should be routed through `handoff.md`.
   - UX and Arch may skip disk reads only when the required artifact contents are visibly present in the current conversation and are not likely stale; otherwise reload.
   - Planner, QA, and Sec always reload relevant live artifacts because errors cascade from stale planning, verification, and review context.
   - Advanced modes (Debate, Brainstorming, Elicit) prefer the current conversation context and only read memory when the invoked topic cannot be grounded from chat.
6. **Teach Reasoning**:
   Do not just list rules. Explain what goes wrong without the pattern, how to diagnose it, and provide before/after examples.
7. **Prefer Subtle, Iterative Changes**:
   Treat feedback as refinements. Make small, deliberate edits rather than broad rewrites; each change should be reversible and minimal.
8. **Avoid fragile markdown tables in skill outputs**:
   Some harnesses render or parse tables poorly. Prefer compact bullet structures for conversational output and artifact templates unless a table is clearly more reliable in the target environment.

## Target platforms

First-class design targets:

### Harnesses

- Claude Code
- Codex CLI
- Opencode

### LLMs

- Floating list: top 15 SWE-Bench Verified performers

## Configuration (`.bmild.toml`)

Project-level settings are defined in `.bmild.toml` at the repository root. The personas read these configurations to dynamically adapt their behavior.

- `plan_folder`: (Default: `"plans/"`) Directory where BMILD's memory artifacts (specs, designs, slices) are stored. Used globally by all personas to read and write context files.
- `user_name`: (Optional) The user's preferred name. Used by named personas (e.g., Faisal, Katrina, Sonia) to address the user personally in their conversational responses.
- `slice_target`: (Default: `170000`) Target context token limit for sizing vertical implementation slices. Used by `bmild-planner` (Sonia) when performing Slice Budgeting to evaluate if work exceeds safe token boundaries.
- `commit`: (Default: `0`; `commit = 0`) Alex/Rahat completion posture. `commit = 1` requests a rich message plus one eligible local Git commit, and `commit = 2` requests the message only.
- `format`: (Optional) Alex/Rahat commit-message format. MVP recognizes `conventional-commits`; omission uses bounded local-history inference (10-message maximum, 3 usable minimum, 60% agreement) with Conventional Commits fallback.
- `branch`: (Default: `"current"`) Alex/Rahat commit target, either the attached current branch or the confirmed initiative slug. A required initiative switch/create is allowed only from a completely clean repository.

### Alex/Rahat commit-posture contract

- Applies only after the distinct commit-ready gates in Alex's Spec-Dev, Spec-Fix, Direct-Dev, and Direct-Fix and Rahat's Spec-Fix and Direct-Fix; failed, blocked, incomplete, no-change, unsafe, baseline-overlap, or declined Fix Election handoff work is never commit-ready.
- Active harness and applicable `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and nested guidance is deny-wins. Configured posture is durable authorization only where guidance permits explicit requests; ambiguity or unreadable applicable policy downgrades to message-only.
- Posture `1` creates at most one local commit with normal hooks, `git commit --only`, and literal message/path transport. Only invocation-attributable paths that were clean at baseline are eligible; unrelated index and working-tree state must survive.
- Branch mutation requires clean state and never uses stash. Commit posture never fetches, pulls, pushes, opens PRs, bypasses hooks, amends, rebases, resets, reverts, or otherwise rewrites history.
- The six mode resources (four Alex + two Rahat) carry byte-identical marked preflight and completion blocks at point of use. `tests/commit-posture-contract.sh` guards identity, placement, configuration/docs alignment, and isolated Git fixture behavior. Rahat's Fix Election and RCA protocol blocks are guarded by `tests/fix-election-contract.sh`.
- MVP supports Conventional Commits plus inferred local repository structure. Additional named/custom formats are Growth; native non-Git commits are Vision.

## Memory structure

BMILD's memory is stored in the folder specified by `plan_folder` in `.bmild.toml` (defaults to `plans/`) in the project root. Personas read and write here to maintain context across sessions.
This can be structured alongside project source or kept separately — the personas resolve all paths relative to the project root.

```
<project-root>/
├── DESIGN.md                       # Katrina output: durable global UX patterns (palette, typography, component rules). Project-root because it is a project-wide standard.
└── plans/ (or your custom plan_folder)
    ├── context-map.md             # Project-level semantic map across initiatives, shared concepts, and boundaries.
    ├── rollup.md                  # Initiative index, aliases, status summary, and Decision Log.
    ├── adr/                       # Drift-protection ADRs (triple-axis gated; initiative-local or cross). Created lazily.
    └── <initiative-name>/         # The atomic unit of work (Feature / Initiative).
        ├── registry.md            # Initiative-local live/archive/stale artifact registry.
        ├── context.md             # Initiative-local semantic context: terms, boundaries, relationships, ambiguities.
        ├── product-brief.md       # Faisal output: problem, users, success criteria, scope, vision.
        ├── prd.md                 # Faisal output: requirements, journeys, prioritization, NFRs, doc scope.
        ├── ux-design.md           # Katrina output: initiative-specific flows, screen states, interaction rules.
        ├── system-design.md       # Lance output: schema, API contracts, service contracts, tech choices, and durable implementation-confirmed technical truth.
        ├── handoff.md             # Initiative-local owner-to-owner coordination for source defects, cross-artifact conflicts, and promotion requests.
        ├── change-proposal-<slug>.md # Sonia output (Course-Correction mode): impact map, bounded questions, roundtable synthesis records, ordered handoff chain, and related handoff references for a cross-artifact change.
        ├── verification-matrix.md # Sonia/Rahat: proof map for requirements and Slices.
        ├── slices.md              # Sonia output: Slice registry.
        ├── slice-<N>.md           # One file per Slice.
        ├── rca-<slug>.md          # Rahat output: root cause analysis.
        └── security-review-<slug>.md # Zach output: security findings.
```

Path rationale:
- `DESIGN.md` lives at the **project root** as a project-wide standard, treated like `README.md`.
- `context-map.md` lives at the **configured `plan_folder` level** because it describes durable cross-initiative semantics and boundaries.
- `rollup.md` lives at the **configured `plan_folder` level** because it is the operational index of initiatives, aliases, status, and notable decisions.
- `adr/` lives at the **configured `plan_folder` level** as the single discovery point for drift-protection ADRs (triple-axis gated; tagged by `scope:` frontmatter as initiative-local or `_cross`). Active design rationale for an initiative stays in `system-design.md` §2; only decisions passing the triple-axis drift test promote to `adr/`.
- `registry.md` exists **only per initiative** because liveness and staleness are initiative state, not global semantic context.

`registry.md` is the entry point for initiative-scoped artifact state. It lists which initiative artifacts are currently `live`, `archived`, or `stale`. Personas load only what is live and only what is relevant to the current engagement mode.

### `registry.md` format

Every `registry.md` follows this structure (see the active `registry-template.md` asset):

```markdown
---
scope: <initiative-name>
timestamp: YYYY-MM-DD
---

## Live
- product-brief.md
- prd.md
- ux-design.md

## Archived

## Stale
- prd.md (driven by H-007 in handoff.md)
- slices.md (driven by H-007 in handoff.md)
```

- `## Live` — filenames of artifacts currently in use. One per line, prefixed with `- `.
- `## Archived` — filenames of superseded artifacts, same format.
- `## Stale` — filenames of artifacts that have been superseded mid-flight by an upstream change and must not be consumed as current truth until repaired. Each line names the artifact and the handoff item or `change-proposal-<slug>.md` driving the staleness. The owning persona moves the line out of `## Stale` and back to `## Live` when their patch is applied.
- Frontmatter `scope` identifies the initiative.
- Frontmatter `timestamp` is the date of the last change.

### Initiative naming

- Initiative names are **lowercase-kebab-case identifiers** (e.g. `py-tokenizer`, `portable-soul`) — written to disk as folder names, so they must stay safe across filesystems, shells, and links. Lowercase avoids case-sensitivity collisions between case-insensitive (macOS/Windows) and case-sensitive (Linux) filesystems; hyphens are universally filesystem-, shell-, and URL-safe.
- **Confirm at minting, never auto-transform.** Whoever creates an initiative folder — the user, or any design-tier persona as entry point — confirms a kebab-case slug with the user *before* writing the folder. Silently rewriting a proposed name is forbidden.
- **Skill-authoring discipline.** This rule ships inside each entry-persona skill's initiative-creation step (PM, UX, Arch, sometimes Sec). It is duplicated by necessity (shared skill components are not portable enough to rely on), so the copies must be kept identical. Canonical rationale: `plans/adr/0004-kebab-case-initiative-names.md`; a co-owned identity test should guard against drift.

### Cross-artifact flow

- `context-map.md`: created and maintained primarily by Faisal; consumed when work spans multiple initiatives or shared semantic boundaries; defines project-level contexts, shared concepts, and cross-context relationships.
- `rollup.md`: created and maintained primarily by Sonia; consumed by all standard personas when resolving initiative names, aliases, or current status; includes `## Decision Log` for durable, concise cross-initiative history.
- `adr/<NNNN-slug>.md`: drift-protection ADRs created and maintained by Lance when a decision is hard to reverse, surprising without context, and the result of a real trade-off (the triple-axis gate; initiative-local or cross-initiative, tagged by `scope:` frontmatter); consumed by Sonia, Alex, Rahat, and Zach when their work touches that durable decision. Active design rationale stays in `system-design.md` §2; the ADR records the *why* so a future reader does not "fix" a deliberate choice.
- `context.md`: created and maintained by Faisal, Katrina, Lance, and Zach; consumed by all standard personas; defines initiative-local terms, boundaries, relationships, and resolved ambiguities. It is for meaning, not implementation detail.
- `product-brief.md`: created by Faisal; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines problem, users, success criteria, scope, and vision. Entry contract for downstream design.
- `prd.md`: created by Faisal once a brief exists; consumed by Katrina, Lance, Sonia, Rahat, and Zach; defines functional requirements, journeys, prioritization (MVP / Growth), NFRs, and required documentation updates (README, contributor guides, runbooks, release notes, onboarding, user-facing help). Validated through coverage checks and verification matrix entries.
- Project-root `DESIGN.md`: created and maintained by Katrina; carries durable global UX patterns (palette, typography, global component rules) distilled from initiative-specific UX work.
- `ux-design.md`: created by Katrina; consumed by Lance, Sonia, Alex, Rahat, and Zach; validated through observable user-state checks.
- `system-design.md`: created by Lance; consumed by Sonia, Alex, Rahat, and Zach; validated through implementability, testability, and security review. Alex also writes durable implementation-confirmed technical truth here when no other owner's judgment is required.
- `handoff.md`: initiative-local coordination artifact for source-artifact defects, cross-artifact conflicts, and promotion requests that require another owner's action. It is non-authoritative until the target owner updates the target artifact. A scribe-applied item carries `Promotion Record: applied_by_scribe — …` and closes on write (see `docs/scribe-path.md`).
- `change-proposal-<slug>.md`: created by Sonia in Course-Correction mode when a change affects ≥2 source-artifact owners; carries the impact map, bounded questions, roundtable synthesis records, ordered handoff chain, and handoff references. Sonia coordinates and orders; design-tier decisions are deliberated via Roundtable and authored by the owning persona in Handback.
- `slices.md` and `slice-<N>.md`: created by Sonia; consumed and updated by Alex; verified by Rahat and Zach; recut by Sonia when implementation reveals a planning problem.
- `verification-matrix.md`: created by Sonia during readiness when proof boundaries matter; repaired or expanded by Rahat; consumed by Alex; validated by Rahat during verification.
- `rca-<slug>.md`: created or updated by Rahat for confirmed defects; after root-cause confirmation Rahat offers Fix Election — implement in-session or hand off to Alex with Implementation Context so a fresh window retains discovery; closed by Rahat after evidence shows the regression is covered.
- `security-review-<slug>.md`: created by Zach when exploitable findings exist; consumed by Alex for implementation fixes or Lance/Katrina for design changes; closed by Zach after remediation is verified.
- Documentation files: requirements defined by Faisal, implemented by Alex, and verified by Rahat against the shipped behaviour.

Governance rule:
- authoritative state lives in BMILD source artifacts, not in `handoff.md` history
- `accepted` is an intermediate workflow state, not a truth state
- unresolved user elicitation lives in chat unless async owner-to-owner continuity requires a governed handoff item
- **Scribe path** (`docs/scribe-path.md`): a presiding persona may transcribe a *settled* fact into another owner's artifact in-context under the shared Scribe-Eligibility gate. This is **scribe ≠ author** — it transcribes settled facts; it never authors decisions (genuinely open items route). **Canonical-tier artifacts** (`context-map.md`, `[plan_folder]/adr/`, project-root `DESIGN.md`) are a hard fence and always route. Attribution is passive provenance (`applied_by_scribe`): traceability, not deferred audit — no required later action by the voiced owner. ≥2-owner cascades still route to Course-Correction. This is the second canonical consumer of each persona's `SOUL.md` (after roundtable attendee-voice loading), per `plans/adr/0003-persona-soul-canonical-voice.md`.

RCA path rule: initiative-linked defects live in the initiative folder.

## Open Knowledge Format (OKF) conformance

The configured `plan_folder` (default `plans/`) is an **[OKF v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) bundle**. Each BMILD memory artifact is an OKF *concept* (one markdown document with YAML frontmatter); initiative folders are subdirectories. Project-root `DESIGN.md`, `README.md`, `AGENTS.md`, and `docs/` are **outside** the bundle.

Frontmatter on every in-bundle artifact carries the OKF fields first, then BMILD workflow extensions:

- `type` — **required** by OKF. BMILD owns its own (unregistered) type vocabulary:
  - `Product Brief`, `PRD`, `UX Design`, `System Design`, `Slice`, `Slice Registry`, `ADR`, `RCA`, `Security Review`, `Handoff`, `Registry`, `Rollup`, `Context Map`, `Context`, `Verification Matrix`, `Change Proposal`.
  - OKF consumers MUST tolerate unknown types and treat unmatched values as generic concepts.
- `title`, `description` — recommended display fields used by index generators and previews.
- `timestamp` — last-modified date (ISO 8601). Replaces the legacy `updated` field.
- BMILD extensions (`scope`, `slice`, `status`, `author`, `created`, `slug`, `severity`, `owner`, `next_owner`, etc.) are preserved by OKF consumers on round-trip.

Cross-linking: navigable references between artifacts use markdown links so OKF graph consumers can traverse (bundle-relative or relative). Instructional prose and enum option lists may keep backtick-quoted paths where a link would add noise.

Reserved filenames: BMILD keeps its own index/coordination artifacts (`registry.md`, `rollup.md`, `context-map.md`) rather than adopting OKF's `index.md` / `log.md`. OKF consumers treat them as generic concepts; their BMILD-specific body structure is preserved.

Grandfathering: artifacts already in `plan_folder` before OKF conformance are grandfathered and may lack OKF frontmatter. Conformance applies to artifacts generated from the current templates; the bundle becomes fully conformant as legacy artifacts turn over.

## Philosophical guidance

When faced with an ambiguous skill design choice use these points to align decisions:
- Resist patterns that funnel obvious progress through theatrical gates. Ceremony does not equate to rigor.
- Manage quality floor without limiting quality ceiling. Allow performant models to work to their fullest, don't let quality of output fall when using lower-parameter count models.

## External references

There are 3rd-party references in `external_references/` which cover alternative and adjacent spec-driven agentic coding workflow implementations
Ask for permission to access it when you need to, as it is ignored by default
Do not make any modifications to any files in `external_references/` folders

## Documentation

Keep README, AGENTS and CHANGELOG up to date as project evolves. PM defines which documentation needs to change, Dev owns the edits, and QA verifies that the resulting documentation matches implemented behaviour.
Planner slice-budgeting references invoke the platform-native estimator directly: resolve the active `bmild-planner` skill directory for the current harness, then run `bash <planner-skill-dir>/scripts/run-budget-slice.sh` on macOS/Linux/WSL or `powershell -File <planner-skill-dir>/scripts/run-budget-slice.ps1` on Windows-native. For example, the planner skill may live under `.agents/skills/bmild-planner/` in many CLI/IDE environments or `.claude/skills/bmild-planner/` in Claude Code. The agent invoking the script already knows the host OS (its own shell tells it), so no launcher wrapper or interpreter probing is used; both scripts emit the same byte-identical TSV contract (see `plans/bash-tokenizer/system-design.md` §4 and ADR 0005).

## Versioning

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
