# BMILD Core Skill Sections

This document defines the go-forward structure for BMILD core `SKILL.md` files.

The core skill is the stable shell: identity, activation, mode routing, scope boundary, and handoff shape. It should stay compact enough to load on every invocation (~100–130 lines for standard personas). Mode-specific reads, task steps, stakes behaviour, gates, and artifact-writing instructions belong in `resources/*.md` so each session loads only what it needs.

**Migration contract:** see [skill-refactor-contract.md](./skill-refactor-contract.md). Golden reference: `.agents/skills/bmild-pm/`.

---

## Frontmatter

Contains the Agent Skills metadata required for activation.

Required fields:

- `name`: skill directory name.
- `description`: what the persona does and when to invoke it. Use intent- and trigger-rich wording; keep within the Agent Skills 1024-character limit.
- `metadata.version`: compatible with `VERSION` and `scripts/version-sync.sh`.
- `metadata.license`: project license value.

Design guidance:

- The description carries activation weight before the full skill loads. Prefer "Use when..." phrasing, common user intents, near-miss boundaries, and persona names.
- Keep frontmatter operational, not instructional. Behaviour belongs in the body.

---

## Role

### Your Role and Voice

Persona identity, domain perspective, voice, and what the persona protects from downstream drift.

### NON-NEGOTIABLES

Overrides for harness defaults. Group early in the file:

- **First-person voice** in conversational chat (with explicit exception for the opening stance persona label if used).
- **Session wrappers:** opening stance first turn only; Exit and Handoff final turn only.
- **Code intelligence** (when the persona groundtruths repos): discovery before invention; prefer symbol/AST/semantic search before raw traversal — for PM, UX, Arch, Dev, and QA diagnostic work.

Optional persona-specific non-negotiables (opening/closing shape) remain here when the persona requires strict output form.

### Your Working Team

Place in the value chain, teammate dependencies, when to suggest `bmild-roundtable`, `bmild-elicit`, or `bmild-brainstorming`, and the persona-name rule (never skill names in chat).

---

## Entry and Activation

One-way entry: resolve environment → minimal shared context → choose exactly one mode → delegate to mode resource.

### Context Reads

Shared context before mode selection only:

- Read `.bmild.toml`; resolve and verify `plan_folder`; read `user_name` when present.
- Persona-specific global settings when present (e.g. Sonia's `slice_target` reference for slice budgeting — detail in planner mode resources).
- Initiative folder / `rollup.md` alias resolution.
- **Do not** load mode-specific artifacts here except existence checks required for mode detection.

### Mode Lookup

**Sole authority** for mode selection and resource file choice. Handback queue resolution is expressed here — not in a separate Queue Resolution / Handoff Resolution section.

Requirements:

- Read conditions top to bottom; stop at first match.
- **Handback precedence:** when `handoff.md` has queue items for this persona in `{proposed, accepted}`, enter handback mode immediately — do not evaluate lower modes.
- Persona-specific disambiguation when two modes match on ambiguous user intent (ask one question).
- Load only the matched mode resource and its criteria file **when the skill defines one**.

Recommended shape: table or numbered conditions naming mode, `resources/<file>.md`, and completion criteria path when applicable.

---

## Advanced Elicitation Triggers

Facilitator skill offers only (`bmild-roundtable`, `bmild-brainstorming`, `bmild-elicit`). Do not swap skills without user consent.

**Not in core:** section-transition gates, cross-persona blocking rules, or mode-specific routing — those belong in mode resources (or a short **Routing heuristics** block in core for Dev/QA only).

---

## Scope Boundary

What the persona does not do and where that work routes. Keep persona-specific; do not restate positive instructions in negative form.

---

## Exit and Handoff

Closing shape for the final turn only: completion statement, optional `For you`, `Next`, persona sign-off. Verbatim handoff invocation rules when creating/modifying `H-###` items.

Mode resources own artifact content and gates; this section owns close voice and orchestration.

---

## What does not belong in core `SKILL.md`

| Removed from core | Lives in |
| :--- | :--- |
| Workflow progress checklist | `resources/<mode>.md` Tasks |
| Global Directives (method, stakes pacing) | Mode resource **Global Directives** |
| Stakes-based elicitation behaviour | Mode resource (when YAML has `stakes`) |
| Pre-exit checkpoint | Mode resource (write/refine modes) |
| Trigger-Condition Rules (full set) | Advanced Elicitation Triggers + mode resources |
| Gotchas (generic reminders) | Omit, or one narrow non-obvious correction only |

---

## Completion criteria YAML (design-tier + Sec only)

**Policy:** Do not add completion-criteria YAML to a skill that does not already have one.

| Skills with criteria YAML | File(s) |
| :--- | :--- |
| pm | `brief-completion-criteria.yaml`, `prd-completion-criteria.yaml` |
| ux, arch | `completion-criteria.yaml` |
| sec | `security-categories.yaml` (taxonomy/checklist — not renamed) |

**YAML owns:** `stakes` (where policy applies), `falsifiable`, `good_signal`, `weak_signal`, `applies_when`, `cross_ref`.

**YAML must not own:** elicitation instructions, workflow steps, assumption-format prose.

### Stakes policy

- **`stakes` applies to:** pm, ux, arch, sec only.
- **Does not apply to:** planner, dev, qa, advanced elicitation skills.
- **Behaviour** for each stake level lives in the mode resource **Stakes-based elicitation** section — not in YAML `loading_note`.

---

## Mode resources (`resources/*.md`)

Each mode file is the **sole execution script** for the session:

- Additional context load order
- Global Directives (persona method + governance)
- Stakes-based elicitation (only when criteria YAML defines `stakes`)
- Tasks (progress checklist)
- Definition of Done

Advanced elicitation skills use step resources the same way — core routes to step file; step file executes.

---

## Cross-cutting skills (roundtable, elicit, brainstorming)

- Prefer conversation context; read BMILD memory only when the topic cannot be grounded from chat.
- Step resources load lazy catalogs (`methods.yaml`, `brain-methods.yaml`) — never from core.
- No completion-criteria YAML; no stakes pattern.
