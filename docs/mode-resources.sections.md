# BMILD Mode Assets Sections

This document defines the go-forward structure for BMILD mode instruction files in each skill's `assets` folder.

Mode assets are loaded only after the core `SKILL.md` has selected a mode. They contain the mode-specific context, norms, ordered tasks, and completion bar. They should not repeat the persona identity, team model, activation sequence, mode lookup, global scope boundary, or exit format from the core skill.

The design goal is progressive disclosure: the core skill routes; the mode asset executes.

## File Contract

Asset files are ordinary Markdown instruction files.

Requirements:

- Do not use YAML frontmatter in `assets/*.md`.
- Start with a single H1 naming the mode.
- Use these H2 sections in order: `Additional Context`, `Additional Norms`, `Tasks`, `Definition of Done`.
- Use `Progress:` plus `- [ ] Step N: ...` for ordered mode work.
- Avoid markdown tables unless the target artifact genuinely requires them.

Design guidance:

- An asset file should be complete enough that, once loaded, the persona can finish that mode without hunting through unrelated mode files.
- An asset file should be narrow enough that it does not teach tasks belonging to sibling modes.
- Prefer precise paths, artifact names, and defaults over broad reminders.

## Additional Context

Ensures the persona loads or discovers any context required only for this mode.

Contains:

- Mode-specific artifact reads.
- Mode-specific repo or source-grounding reads.
- Existing script, asset, or template paths needed by this mode.
- Reduced-fidelity behaviour when an expected artifact is missing.

Forbidden:

- Reads already required by core `Entry and Activation`.
- General BMILD memory policy.
- Context needed only by another mode.

Design guidance:

- Order reads by authority: canonical constraints before consuming artifacts, live context before archived context, exact initiative paths before broad search.
- Load only sections or files needed for the mode unless the whole artifact is the contract.
- Name what to do if a required context file is missing: block, ask one question, operate at reduced fidelity, or route.

Example shape:

```markdown
## Additional Context

- Load `[plan_folder]/<initiative>/slice-<N>.md` in full.
- Load relevant `verification-matrix.md` entries when present.
- Read contributor guidance (`AGENTS.md`, `CONTRIBUTING.md`, or equivalent) before edits.
- If `slice-<N>.md` is missing, stop and route to Sonia unless the user explicitly asks for reduced-fidelity direct work.
```

## Additional Norms

Provides mode-specific steering that narrows or intensifies the core `Global Norms`.

Contains:

- Tools, scripts, or assets used in this mode.
- Evidence standards unique to this mode.
- Authority rules that matter especially in this mode.
- Validation loops or repo-discovery defaults.
- One or two deliberate reminders from `Global Norms` when the mode is especially prone to failure.

Forbidden:

- General persona principles already covered in core.
- Mode tasks that belong in `Tasks`.
- Duplicated exit format.

Design guidance:

- Use this section for how to think while doing the mode, not what ordered step to do next.
- Move repeated "Repository discovery" or "Proof discipline" blocks here when they apply across most tasks within the mode.
- If the norm applies equally to every mode, move it up to core `Global Norms`.

## Tasks

Specifies the ordered workflow for completing the mode.

Use `Progress:` and checklist steps:

```markdown
## Tasks

Progress:

- [ ] Step 1: <first action>
- [ ] Step 2: <next action>
- [ ] Step 3: <validation or artifact write>
- [ ] Step 4: <handoff preparation>
```

Contains:

- Ordered task steps.
- Mode-specific artifact creation or updates.
- Mode-specific decision points and retry loops.
- Proof commands or script invocations when known.
- Routing when the workflow reveals a blocker outside the persona's authority.
- The exact point to run any pre-exit checkpoint for this mode.

Forbidden:

- Duplicate activation steps from core.
- Duplicate global rules from core.
- Steps that require returning to `Entry and Activation`.

Design guidance:

- Use steps for true sequence. Use prose or ordinary bullets for non-sequential guidance.
- Keep each step outcome-oriented: "Update `slice-<N>.md` with checked AC and implementation notes" is better than "Think about the slice."
- Include validation loops where failure is likely and self-correction is possible.
- State handoff-impacting artifact updates in the task sequence, not only in DoD.

## Definition of Done

Defines the completion bar for this mode.

Use a checklist:

```markdown
## Definition of Done

- [ ] <mode-specific completion condition>
- [ ] <evidence or gate condition>
- [ ] <artifact update condition>
- [ ] <handoff readiness condition>
```

Contains:

- Mode-specific success criteria.
- Evidence and validation thresholds.
- Required artifact updates.
- Required user-facing or downstream-handoff readiness.
- Conditions that must be explicitly deferred with owner and reason if incomplete.

Forbidden:

- Items already handled by core `Exit and Handoff` shape.
- Generic "follow the workflow" statements.
- Completion conditions belonging only to another mode.

Design guidance:

- DoD should let the persona audit whether the mode is complete before closing.
- Include observable evidence, not only intention.
- If a condition can be skipped, say what must be recorded: reason, consequence, and next owner.
- Keep DoD mode-specific. Universal close-message rules belong in core.
