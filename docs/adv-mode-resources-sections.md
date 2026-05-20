# BMILD Advanced Resource Sections

This document defines the go-forward structure for BMILD advanced facilitation resource files.

Advanced resource files are not independent mode resources. They are step resources in a self-steering session chain. A step may ask for user input, load a registry, hand off to another step file, loop back, or close the session. The refactor should make these files easier to scan without breaking that control flow.

## File Contract

Resource files are ordinary Markdown instruction files.

Requirements:

- Do not use YAML frontmatter in `resources/*.md`.
- Start with a single H1 naming the step.
- Use these H2 sections in order where they apply: `Purpose`, `Inputs`, `Procedure`, `Next Step`.
- Add `Definition of Done` only for terminal or major completion steps where the step itself must be audited before close.
- Use `Progress:` plus `- [ ] Step N: ...` for ordered step work.
- Preserve explicit user-facing prompts, menu options, loop controls, and resource handoffs.
- Avoid markdown tables unless the target output genuinely requires them.

Design guidance:

- A step resource should be complete enough to execute that step without re-reading unrelated step files.
- It may reference the previous step's carried state and the next step's resource path.
- Do not force every file to have every section if the section would be empty boilerplate.
- Preserve resource chains such as `step-01 -> step-02 -> step-03 -> step-04`; those chains are behaviour.

## Purpose

States what this step accomplishes in the session.

Contains:

- The step goal.
- The facilitator posture for this step.
- The behavioural invariant the step protects.

Examples:

- Setup captures topic and constraints before technique selection.
- Elicitation selection reads the target content before selecting methods.
- Roundtable open sharpens the question and confirms attendees before any attendee speaks.

Forbidden:

- Persona identity already covered by core `Role`.
- Full-session rules already covered by core `Global Norms`, unless repeated as a short operational warning because this step is the failure point.

## Inputs

Lists context, files, registries, or carried state required by this step.

Contains:

- Local registries such as `resources/brain-methods.yaml` or `resources/methods.yaml`.
- Carried state from a prior step: selected techniques, chosen method, attendee list, invocation context, confirmed question, or current working content.
- Specific BMILD artifacts to load only when this step requires them.
- What to do when required input is absent.

Design guidance:

- Keep file paths skill-local and resource-relative where that is how the current skill works.
- Preserve instructions to read YAML registries rather than inventing method names.
- For roundtable, preserve preference for current conversation context and the live-artifact loading boundary.

## Procedure

Specifies the ordered step workflow.

Use:

```markdown
## Procedure

Progress:

- [ ] Step 1: <first action>
- [ ] Step 2: <next action>
- [ ] Step 3: <validation, prompt, or branch>
```

Contains:

- Ordered execution steps.
- User prompts and exact menus.
- Branch handling.
- Retry loops and wait states.
- Registry selection rules.
- Speaker, attendee, or facilitation posture rules that are local to this step.
- Artifact append or patch-preparation rules if this step currently owns them.

Forbidden:

- Duplicate activation setup from core unless the step cannot operate without repeating a specific check.
- Duplicate full-session exit shape from core.
- Silent removal of waits for user confirmation.

Design guidance:

- Convert numbered workflows into `Progress:` checklists only when they are true ordered work.
- Preserve exact options such as `[C]`, `[S]`, `[E]`, `[r]`, `[a]`, `[x]`, `[Back]`, `[Export]`, `[Keep going]`, and `[Done]`.
- Preserve roundtable speaker labelling, cross-talk, moderation, and direct-question pause behaviour.
- Preserve brainstorming's volume, energy checkpoint, anti-clustering, and organise-only-when-ready behaviour.
- Preserve elicitation's one-method-at-a-time loop, apply-or-ask rule, undo note, and final ownership handoff.

## Next Step

States how this resource hands off, loops, waits, or closes.

Contains:

- Exact next resource path when the step continues.
- Conditions that route backward, forward, or to close.
- Whether the facilitator waits for user input.
- What state must be carried to the next step.

Examples:

- `On confirmation, load resources/step-03-execute.md carrying selected technique names forward.`
- `[x] Proceed -> close elicitation and return to the invoking context.`
- `[S] Synthesise -> load resources/step-03-synthesise.md.`

Design guidance:

- This section is the main adaptation from named-persona mode resources. Advanced resources are allowed and expected to hand off to one another.
- Do not replace explicit handoffs with a vague "continue the workflow" instruction.

## Definition of Done

Use only when the step is terminal or has an auditable completion boundary.

Contains:

- Step-specific completion criteria.
- Required output or synthesis shape.
- Required carried state or artifact implication.
- Required return-to-caller condition.

Design guidance:

- Keep full-session DoD in core only if it is genuinely global, or in the terminal close resource if it is produced there.
- Do not add filler DoD to short routing steps.
