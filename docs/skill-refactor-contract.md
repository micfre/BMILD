# BMILD Skill Refactor Contract

Golden reference: `.agents/skills/bmild-pm/` (v0.2.6+).

This document is the migration checklist for rolling the PM skill architecture across the suite. It prioritizes **context window efficiency**: the harness always loads `SKILL.md`; everything else loads lazily per mode.

---

## Runtime loading contract

Every skill invocation:

1. **Always load:** `SKILL.md` only (~100–130 lines target).
2. **After mode match:** one `resources/<mode>.md` file.
3. **Before write/verify (when applicable):** one criteria YAML file **if the skill already has one** — never preload other mode resources, assets, or catalogs.

Add to each migrated `SKILL.md` under Mode Lookup:

> Load only the matched mode resource and its criteria file (when the skill defines one). Do not preload other mode resources, assets, or YAML catalogs.

---

## Layer responsibilities

| Layer | Owns | Must not own |
| :--- | :--- | :--- |
| **`SKILL.md`** | Role, NON-NEGOTIABLES, Context Reads, Mode Lookup (incl. handback precedence), Advanced Elicitation Triggers, Scope Boundary, Exit and Handoff | Workflow checklists, stakes behaviour, task steps, consequence-check detail, Gotchas that restate rules |
| **`resources/<mode>.md`** | Additional context load order, Global Directives (method), **Stakes-based elicitation** (when YAML stakes exist), Tasks, DoD, mode-local routing/pre-exit | Duplicate code-intelligence blocks (belongs in core NON-NEGOTIABLES where applicable) |
| **Criteria YAML** | Per-section `stakes` (where policy applies), `falsifiable`, `good_signal`, `weak_signal`, `applies_when`, `cross_ref` | Elicitation instructions, workflow steps, assumption format prose |

---

## Completion-criteria YAML policy

**Do not add `completion-criteria.yaml` (or equivalent) to a skill that does not already have one.**

| Skill | Criteria file | Action on refactor |
| :--- | :--- | :--- |
| **bmild-pm** | `brief-completion-criteria.yaml`, `prd-completion-criteria.yaml` | Done (reference) |
| **bmild-ux** | `completion-criteria.yaml` | Extend in place (add stakes, trim loading_note, rename `governance_routing` → `ambiguity_disposition`) |
| **bmild-arch** | `completion-criteria.yaml` | Same as UX |
| **bmild-sec** | `security-categories.yaml` | Extend in place only — **not** renamed to completion-criteria; keep taxonomy/checklist role |
| **bmild-planner** | — | **No YAML.** Mode resources carry method and routing. |
| **bmild-dev** | — | **No YAML.** |
| **bmild-qa** | — | **No YAML.** |
| **bmild-roundtable**, **bmild-elicit**, **bmild-brainstorming** | `methods.yaml` / `brain-methods.yaml` | Keep as lazy-loaded step catalogs; **do not** add completion-criteria files |

---

## Stakes policy

**`stakes` / `stakes_note` apply only to:**

- **Design-tier artifact skills:** `bmild-pm`, `bmild-ux`, `bmild-arch`
- **Security review:** `bmild-sec` (on applicable entries in `security-categories.yaml`)

**Stakes do not apply to:** `bmild-planner`, `bmild-dev`, `bmild-qa`, or advanced elicitation skills.

### Where stakes live

- **YAML:** categorization only (`consequential` | `medium` | `low`; optional `stakes_note` override).
- **Mode resource:** **Stakes-based elicitation** section — behaviour table and session pacing (diverge → synthesize → reopen on steer).

Skills **without** criteria YAML use mode-resource **Global Directives** for method (evidence discipline, reproduction-first, slice boundaries, etc.) — **not** a Stakes-based elicitation section tied to YAML.

### Option A (UX / Arch)

Define section stakes in the **same PR** as the skill refactor. Do not ship placeholder `stakes: medium` on every section.

Suggested consequential sections (review during migration):

- **UX:** `information_architecture`, `user_flows`, `interaction_model`, `fr_coverage`
- **Arch:** `api_contracts`, `database_schema`, `fr_coverage`, `architecture_decisions` (when applies)

---

## `SKILL.md` refactor checklist

### Keep / add

- NON-NEGOTIABLES early: **first-person voice + session wrappers** as an adjacent pair; then **code intelligence + discovery-before-invention** for personas that groundtruth repos (PM, UX, Arch, Dev, QA diagnostic paths).
- Mode Lookup as **sole authority** — fold handback scan into Mode 1 with **precedence** (scan wins; do not evaluate lower modes when queue matches).
- **Advanced Elicitation Triggers** (facilitator offers: roundtable, elicit, brainstorming) — replaces generic Trigger-Condition Rules in core.
- Brief vs PRD (or persona-specific) **disambiguation** rules where ambiguous user intent is common.
- Scope Boundary, Exit and Handoff.

### Remove / thin

- Separate **Handoff Resolution** H3 (merge into Mode Lookup).
- **Workflow** progress checklist (execution lives in mode resources).
- **Global Directives** method and stakes detail (move to mode resources).
- **Trigger-Condition Rules** in core (split: facilitators → Advanced Elicitation; blocking/routing → mode resources or short **Routing heuristics** in core for Dev/QA only).
- **Gotchas** unless genuinely non-obvious — no reminders, no restated rules.
- **Pre-exit** in core (move to write/refine mode resources; conditional on consequential changes for refine).

---

## Mode resource refactor checklist

- **Global Directives** (persona method + artifact-authority discipline).
- **Stakes-based elicitation** — **only** when the skill has criteria YAML with `stakes` fields.
- Unified **Tasks** + **Definition of Done**.
- **Consequence-check** step referencing YAML falsifiability (not duplicating good/weak prose).
- **Pre-exit:** unconditional before initial artifact write; **conditional** before refine write when consequential sections change materially.
- Remove duplicate code-intelligence blocks (point to core NON-NEGOTIABLES).

---

## YAML refactor checklist (PM, UX, Arch, Sec only)

- Trim `loading_note` to coverage/completeness only — point behavioural rules to mode resource Stakes-based elicitation.
- Add or preserve `stakes` per section (Option A editorial pass for UX/Arch).
- Rename `governance_routing` → **`ambiguity_disposition`** (PM done; UX/Arch pending).
- Do **not** embed elicitation pacing, assumption format, or workflow steps in YAML.

---

## Migration phases

```
Phase 0  This contract + update docs/std-core-skill-sections.md     ✓
Phase 1  bmild-ux ∥ bmild-arch   (stakes in YAML + skill thin)      ✓
Phase 2  bmild-planner            (no YAML, no stakes)              ✓
Phase 3  bmild-qa → bmild-sec     (no new YAML; Sec gets stakes on categories) ✓
Phase 4  bmild-dev                (no YAML, no stakes)              ✓
Phase 5  roundtable, elicit, brainstorming  (thin SKILL only)        ✓
```

**One skill per PR / agent session** to avoid context saturation during migration.

---

## Per-skill exception matrix

| Skill | Stakes | Criteria YAML | Core keeps Routing heuristics? | Notes |
| :--- | :---: | :--- | :---: | :--- |
| pm | ✓ | existing | — | Golden reference |
| ux | ✓ | existing | — | DESIGN.md distillation in mode resources |
| arch | ✓ | existing | — | adr/ promotion in mode resources |
| sec | ✓ | `security-categories.yaml` only | — | Taxonomy file, not completion-criteria shape |
| planner | — | none | partial | CC exception stays in Mode Lookup; slice budget in Context Reads |
| qa | — | none | in resources | Evidence-before-action in mode resources |
| dev | — | none | short block OK | No handback mode |
| advanced | — | step catalogs only | — | Step resources are execution script |

---

## Acceptance grep (per migrated skill)

```bash
# Should return no matches in SKILL.md (except intentional references):
rg -n 'Handoff Resolution|^## Workflow|Trigger-Condition|^## Gotchas' .agents/skills/bmild-<skill>/SKILL.md

# Should not appear in criteria YAML loading_note:
rg -n 'Probe consequential|synthesize-and-steer|Craft Standards' .agents/skills/bmild-<skill>/resources/*.yaml

# Planner/dev/qa should not have completion-criteria.yaml:
test ! -f .agents/skills/bmild-planner/resources/completion-criteria.yaml
```
