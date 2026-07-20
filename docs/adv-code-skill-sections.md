# BMILD Advanced Core Skill Sections

This document defines the go-forward structure for BMILD advanced facilitation `SKILL.md` files: `bmild-brainstorming`, `bmild-elicit`, and `bmild-roundtable`.

Advanced facilitation skills are cross-cutting team tools, not named personas. They do not own BMILD source artifacts, do not select among multiple modes, and do not use the named-persona operating stance format. Their core skill is the stable shell for facilitation identity, activation, single-session workflow, global facilitation norms, scope boundary, close shape, and gotchas. Step-specific execution remains in `resources/*.md`.

The design goal is progressive disclosure without behaviour change: the core skill starts exactly one facilitation session; the resource chain steers the session step by step.

## Frontmatter

Contains the Agent Skills metadata required for activation.

Required fields:

- `name`: skill directory name.
- `description`: what facilitation tool this is and when to invoke it. Use trigger-rich wording from the current skill.
- `metadata.version`: compatible with `VERSION` and `scripts/version-sync.sh`.
- `metadata.license`: project license value.

Design guidance:

- Preserve current trigger vocabulary, including casual user phrasing such as "brainstorm", "elicit", "debate", "roundtable", or equivalents already present in the skill.
- Keep frontmatter operational, not instructional. Behaviour belongs in the body.

## Role

Defines the facilitator identity, the skill's contribution to BMILD, and how it collaborates with named personas without taking over their authority.

This section replaces the former floating `Role` paragraph and separate `## BMILD Working Team` section.

### Your Role

Contains:

- Facilitator identity, icon, facilitation style, and session purpose.
- The specific thinking posture the skill protects: divergent breadth, rigorous elicitation, or structured deliberation.
- Authority boundary: the facilitator helps the caller think; it does not become a named persona or assume source-artifact ownership.
- Sign-off rule as `Facilitator <icon>`.

Authoring guidance:

- These skills are known as Facilitator with varying icons, not as named personas. Do not invent persona names.
- Do not use the standard named-persona stance line (`[Name] [icon] - <Mode Name>...`).
- Preserve speaker-label rules that are part of the skill's behaviour, especially roundtable's "label only when speaker changes" rule.

### Your Working Team

Contains:

- How the facilitator supports the BMILD value chain.
- Which named personas can use the output and how.
- How ownership is preserved when the facilitator is invoked inside another persona's workflow.
- When the facilitator returns output to the caller rather than writing artifacts directly.

Design guidance:

- Refer to named teammates by persona name, never by skill name, when describing collaboration.
- Avoid repeating the full artifact map. Name only the handoff and ownership boundaries this facilitator must protect.
- Roundtable must preserve its special roster and non-attendee rules in `Workflow / Global Norms`, not hide them only in a step resource.

## Entry and Activation

Defines the entry sequence for a single advanced facilitation session.

Advanced skills do not need mode lookup because each skill has exactly one facilitation mode. Activation resolves only the shared environment and context needed to start the session safely, then loads the first resource step.

### Context Reads

Contains shared context required before the first step resource loads.

Baseline:

- Read `.bmild.toml` at the project root.
- Resolve `plan_folder` relative to the project root; default to `plans/`.
- Read `user_name` when present for conversational address.
- Prefer current conversation context.
- Read BMILD memory only when the facilitation question cannot be grounded from chat.
- Load only live artifacts directly relevant to the question.

Design guidance:

- Do not front-load all initiative artifacts. Advanced facilitation often starts with content already present in conversation.
- If reloading risks stale-text elicitation or overfitting to unrelated artifacts, prefer the visible current context and state that choice.
- Put step-specific context reads in the step resource, especially roundtable's context-loading checklist.

### Session Routing

Contains the deterministic entry to the skill's resource chain.

Requirements:

- Name the first resource file.
- State that resources are self-steering and may hand off to the next step resource in sequence.
- If the starting topic or content is missing, ask one direct question before loading or executing the first substantive step.

Recommended shape:

- `Begin with resources/step-01-<name>.md. That resource controls the next resource handoff.`

Design guidance:

- Do not add `Mode Lookup`.
- Do not create an artificial mode name just to match named-persona templates.
- Do not duplicate the full step workflow in core; summarize the session arc only.

## Workflow

Defines the facilitator-level execution flow for the whole session.

The selected first resource supplies the detailed step sequence and resource-to-resource handoffs. The core workflow should be short enough to remain loaded throughout the session.

### Execution Order

Use a `Progress:` checklist for true ordered work.

Required baseline:

- [ ] Step 1: Start as `Facilitator <icon>` in the skill's native voice; do not use named-persona stance syntax.
- [ ] Step 2: Load the first step resource named in `Session Routing`.
- [ ] Step 3: Follow the resource chain as the execution script for this session.
- [ ] Step 4: Apply `Global Norms` throughout the work.
- [ ] Step 5: Complete the resource chain's closing or return step.

Design guidance:

- The resource chain is the mode. Preserve its self-steering handoffs.
- Opening behaviour may be conversational and minimal. Do not force ceremony that slows an interactive facilitation session.
- Where the current resource asks the facilitator to wait for the user, that wait is behaviour and must be preserved.

### Global Norms

Contains durable facilitation rules that apply across the entire skill.

Use for:

- The skill's interaction posture.
- Authority and ownership boundaries.
- Registry discipline, such as reading technique or method YAML files rather than inventing methods from memory.
- Session-loop rules that apply across all steps.
- Rules that protect known behaviour from drift.
- Roundtable attendee roster, invocation contexts, no-recommendation rule, attendee confirmation, and non-attendee constraints.

Design guidance:

- Put true skill-wide rules here even if they also appear operationally in a resource step. In that case, the resource may keep the operational prompt or checklist while core keeps the durable invariant.
- Do not move step-specific scripts, menus, or prompts into core.
- For brainstorming, preserve breadth-before-convergence and anti-clustering behaviour.
- For elicitation, preserve one-primary-method-first, user-selected iteration, ownership preservation, and `[x]` exit behaviour.
- For roundtable, preserve attendee selection, posture, flexible attendance, two invocation contexts, synthesis categories, and the no-recommendation rule.

### Trigger-Condition Rules

Contains reactive routing and interruption rules that can arise during the session.

Use for:

- Suggesting another advanced tool without invoking it autonomously.
- Returning to a named persona when a facilitator reaches an ownership boundary.
- Pausing for user confirmation when the session crosses domain, attendee, artifact-write, or decision authority boundaries.
- Handling ambiguous or multi-part questions.

Design guidance:

- Advanced skills may suggest other BMILD tools, but they should not create a parallel workflow without user or invoker confirmation.
- A facilitator can prepare patch-ready notes for an owner. Direct artifact writes require explicit authority from the user or active owner context.
- **Shared protocols (duplication floor):** when an advanced skill must execute a cross-cutting procedure (e.g. Ratification→Promotion), ship an identical `references/<two-word-kebab>.md` under each executing skill. Compact gate summaries live at point of use in `SKILL.md` / step resources; the full procedure loads via a relative path from the **active** skill root only. Never `docs/…` (does not ship) and never `../bmild-other/…` (cross-skill traversal). Drift is guarded by a repo-root identity/placement contract test (see `tests/promotion-protocol-contract.sh`).
- After a ratified durable-contract decision that leaves source artifacts stale, facilitators run the promotion gate before close: inventory with action classes, ask once, apply only scribe-eligible lines, route canonical-tier / multi-owner / high-stakes work. Close with an explicit state (`ratified_and_promoted` | `ratified_and_routed` | `ratified_pending_authorization` | `ratified_with_documentation_deferred`).

## Scope Boundary

States what the facilitator explicitly does not do.

Contains:

- Does not replace named personas or make their owned decisions.
- Does not write governed artifacts unless explicitly authorized and ownership permits it.
- Does not turn a facilitation session into a new BMILD workflow unless the user chooses that move.
- Does not invent technique or method names when a local registry exists.
- Skill-specific non-authority rules, such as roundtable not recommending a decision.
- Does not treat user authorization as a bypass of Scribe-Eligibility, canonical-tier fences, or ≥2-owner Course-Correction routing.

Design guidance:

- Keep boundaries specific to advanced facilitation.
- Preserve all existing skill-specific boundaries even when they do not appear in the named-persona template.

## Exit and Return

Defines the closing shape for advanced facilitation sessions.

Advanced skills return to the caller rather than performing named-persona workflow orchestration. Use `Exit and Return`, not `Exit and Handoff`, unless the skill already has a stronger local reason to preserve old wording.

Required close shape:

- State what the session produced.
- State what returns to the caller or user.
- Preserve ownership: name the target owner or invoking persona when relevant.
- Sign off as `Facilitator <icon>`.

Design guidance:

- Do not force named-persona `For you` / `Next` language onto advanced skills unless the current skill already uses those semantics.
- Preserve existing close phrases and return lines where they carry behavioural meaning.
- Roundtable may branch by invocation context: forward-direction returns synthesis to the invoking persona; course-correction returns or appends to `change-proposal-<slug>.md` as already specified.
- When the Ratification→Promotion gate fired, name the close state in the session outcome so consumers can honor it without re-asking the same gate.

## Gotchas

Captures high-value corrections from real execution traces.

Use for:

- Stale-context risks.
- User behaviour that predictably derails facilitation.
- Method or technique registry traps.
- Roundtable consensus, attendee, and recommendation traps.
- Ratified durable contracts that close without a promotion ask (leave the user to orchestrate documentation).

Design guidance:

- Do not restate rules already established elsewhere.
- Keep gotchas practical and specific.
- Prefer lived-session regressions: e.g. multi-artifact ratification without an ask-once promotion gate; wording-only tweaks that incorrectly fire the gate.
