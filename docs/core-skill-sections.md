# BMILD Core Skill Sections

This document defines the go-forward structure for BMILD core `SKILL.md` files.

The core skill is the stable shell: identity, team position, activation, mode routing, global governance, scope boundary, and handoff shape. It should stay compact enough to load on every invocation. Mode-specific reads, task details, gates, and artifact-writing instructions belong in `assets/*.md` files so each session loads only the instructions it needs.

The design goal is progressive disclosure with preserved behaviour: refactor format, remove repetition, and improve maintainability without changing what the persona is allowed or expected to do.

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

## Role

Defines who the persona is, how it contributes to BMILD, and how it collaborates with the rest of the suite.

This section replaces the former floating `Role` paragraph and the separate `## BMILD Working Team` section. By the end of this section, the model should know who it is emulating, what value it contributes, who depends on it, and how to refer to teammates.

### Your Role

Contains:

- Persona name, icon, role, and scope boundary.
- Domain perspective and decision authority.
- Voice and communication posture.
- A clear statement of what the persona protects from downstream drift.

Authoring guidance:

- Use a compact, vivid operating identity rather than a generic job description.
- Do not use repeated "Always prefix" instructions. Identity is expressed through the opening operating stance and final sign-off.
- Name the persona's authority positively before stating what it does not own.

### Your Working Team

Contains:

- The persona's place in the BMILD value chain.
- Which teammates depend on this persona's output, and why.
- Why interactivity matters for this persona's work.
- When to suggest advanced team tools: `bmild-roundtable`, `bmild-elicit`, or `bmild-brainstorming`.
- The persona-name rule: refer to teammates by persona name in chat, never by skill name.

Design guidance:

- This subsection should teach collaboration flow, not repeat the artifact map in full.
- Mention only teammate dependencies that affect this persona's work or handoff quality.
- Advanced tools are suggestions unless the active mode explicitly makes them part of the workflow.

## Entry and Activation

Defines the one-way entry sequence for a skill invocation: resolve environment, load the minimal shared context, handle prerequisite queues, choose exactly one mode, then begin.

Once the persona leaves this section, it should not need to return to it. If an instruction must be checked later, place it in `Workflow`, `Global Norms`, or the relevant mode asset instead.

### Context Reads

Contains shared context required before mode selection.

Required baseline for standard personas:

- Read `.bmild.toml` at the project root.
- Resolve `plan_folder` relative to the project root; default to `plans/`.
- Normalize trailing slashes and verify the folder exists before broad searches.
- Read `user_name` when present for conversational and artifact placeholders.
- Read persona-specific global settings when present, such as Sonia's `slice_target`.
- If the prompt names an initiative, check `[plan_folder]/<initiative-name>/` directly before broad searches.
- If the initiative folder is absent, consult `[plan_folder]/_system/_rollup.md` before treating the initiative as new.
- Load only live context needed for mode selection. Mode-specific artifact reads belong in the selected asset file.

Cross-cutting skills:

- Prefer current conversation context.
- Read BMILD memory only when the question cannot be grounded from chat.
- Load only live artifacts directly relevant to the question.

Design guidance:

- Fresh-window resilience belongs here; task execution detail does not.
- Do not front-load every possible artifact. The core skill should route accurately, then delegate detail to the selected mode file.

### Queue Resolution

Contains activation-time branches that must win before ordinary mode lookup.

Use for:

- Handback items targeting this persona's owned artifacts.
- Blocking user-attention or source-defect states that make normal execution unsafe.
- Course-Correction precedence and exceptions where a broader cascade should override ordinary handback.

Design guidance:

- Queue resolution should be deterministic and early.
- Keep routing narrow: state the queue path, target owner, statuses, and the mode that wins.
- Do not resolve queue content here. The selected handback or correction resource owns that workflow.

### Mode Lookup

Maps user intent and artifact state to one mode and one `assets/*.md` instruction file.

Requirements:

- Read conditions top to bottom.
- Stop at the first matching row.
- Make the final row a clear catch-all only when that is safe for the persona.
- Ask one direct clarification when two modes match or none can be chosen safely.
- Name the mode and asset file together.

Recommended shape:

- `Condition 1: <trigger and artifact state> -> <Mode Name> (assets/<mode>.md) - <short purpose>.`
- `Condition 2: ...`
- `Condition N (default): ...`

Design guidance:

- Mode names describe user intent, entry condition, or artifact state. Avoid names that only describe internal mechanics or effort level.
- Mode lookup is the only place the core skill chooses the asset file.
- Mode-specific reads do not appear here except as artifact-existence checks required to choose the mode.

## Workflow

Defines the persona-level execution flow for every invocation after mode selection.

This section is intentionally high-level. The selected `assets/*.md` file supplies mode-specific tasks, artifact writes, and DoD.

### Execution Order

Use a `Progress:` checklist for true ordered work.

Required baseline:

- [ ] Step 1: Emit the compact operating stance line.
- [ ] Step 2: Load the selected mode asset.
- [ ] Step 3: Follow the mode asset as the session script.
- [ ] Step 4: Apply `Global Norms` throughout the work.
- [ ] Step 5: Complete the mode asset's `Definition of Done`.
- [ ] Step 6: Run the `Pre-exit checkpoint` when the active workflow calls for one.
- [ ] Step 7: Close through `Exit and Handoff`.

Opening stance for standard personas:

`[Name] [icon] - <Mode Name>. Scope: <scope>. <boundary statement>.`

Examples:

- `Faisal 🟦 - Write-PRD. Scope: checkout-redesign. I'll work on product requirements, not UX or architecture.`
- `Alex 🟪 - Spec-Dev. Scope: slice-3. I'll work on implementation against the Slice contract.`

Design guidance:

- The opening stance belongs here, not in activation, because it starts persona-visible work after mode selection.
- Keep the checklist stable across personas. Persona-specific variants should be minimal and justified.

### Principles

Contains global execution principles that apply across all modes for this persona.

Use for:

- Coaching posture and interaction style.
- Authority boundaries that must remain active during work.
- Source-of-truth rules.
- Quality floor rules lower-tier models must not miss.
- Freedom rules that keep high-tier models from being over-constrained.

Design guidance:

- Explain why the principle exists when misunderstanding would cause predictable failure.
- Prefer defaults over menus. Give escape hatches only where they matter.
- Do not include mode-specific task steps here.

### Trigger-Condition Rules

Contains reactive routing and interruption rules that can arise during any mode.

Use for:

- Conditions that require handoff to another persona.
- Conditions that require `spec-patch-queue.md`, `user-attention.md`, or a bounded assumption.
- Conditions that should trigger a suggestion for Roundtable, Elicit, or Brainstorming.
- Conditions that make a workflow unsafe to continue.

Design guidance:

- Phrase as heuristics with clear routing, not theatrical gates.
- Route only when scope or uncertainty genuinely exceeds the persona's authority.
- Avoid duplicating the selected mode's detailed tasks.

### Pre-exit Checkpoint

Contains the persona's one final opportunity, when appropriate, to let the user steer before artifact finalization or handoff.

Use for:

- Step-completion review before writing a major artifact.
- A one-off offer to debate, brainstorm, or stress-test before locking a decision.
- A short confirmation that can be declined in one word.

Design guidance:

- This is the renamed form of the former `Pre-artifact checkpoint`.
- Use at most once per session.
- Do not use it for internal bookkeeping, persona routing, or generic "anything else?" filler.
- If the active mode has no artifact-locking or decision-locking moment, omit the checkpoint.

## Global Norms

Contains the persona's durable craft rules, capabilities, and governance norms across all modes.

This section replaces the former `Capabilities` and `Craft Standards` sections. It should not contain mode-specific tasks or branching instructions of the form "if Mode X, do Y"; those belong in the relevant mode asset.

Use for:

- Shared tools and reusable techniques.
- Craft standards that govern all mode work.
- Evidence and artifact-authority discipline.
- Validation patterns that are universal to the persona.
- Collaboration norms that prevent downstream drift.

Design guidance:

- Bias global emphasis to the common baseline across modes.
- If one mode needs stronger emphasis, put the extra detail in that mode's `Additional Norms`.
- Keep high-tier LLMs free to exercise judgment by stating purposes and boundaries, not over-prescribing obvious mechanics.
- Protect lower-tier LLMs with concrete defaults, named paths, and explicit routing when mistakes are costly.

## Scope Boundary

States what the persona explicitly does not do and where that work routes instead.

Contains:

- Out-of-scope decisions, artifacts, or workflows.
- Correct persona or workflow for each boundary.
- Any absolute prohibition that prevents ownership drift.

Design guidance:

- Do not restate every positive instruction in negative form.
- Keep boundaries specific to this persona.
- Include canonical artifact ownership boundaries where mistaken writes would corrupt BMILD memory.

## Exit and Handoff

Defines closing shape, handoff obligations, and the distinction between user action and workflow orchestration.

The closing message is the persona speaking, not a form. It must make the completed work and next clean move clear without turning internal bookkeeping into user work.

Required shape for standard personas:

```markdown
> *<completion statement>.* <what was completed, evidence, artifacts updated>
>
> *For you, [user_name].* <only a meaningful user action with expected result and pass criteria; omit if none>
>
> *Next.* <clean workflow move, next persona, or terminal state>
>
> - [Name] [icon]
```

Rules:

- `For you` is only for a real step-completion action the user can take now.
- `Next` is the orchestration move after this step.
- Keep `For you` and `Next` separate even when the user action is optional.
- Do not use `For you` for internal bookkeeping, context-memory status, or persona routing.
- If a turn creates or modifies `spec-patch-queue.md`, include copy-paste-ready invocation wording for the target persona when the relevant mode requires it.
- Exit is a terminus. If there is doubt that objectives are complete, resolve it before entering this section.

Design guidance:

- Mode assets specify artifact content and gates; this section specifies close shape and voice.
- Keep sign-off identity here instead of repeating persona labels throughout the skill.

## Gotchas

Contains narrow corrections for ambiguous, surprising, or historically error-prone cases.

Use for:

- Facts that defy reasonable assumptions.
- Edge cases found in real execution traces.
- Clarifications for apparently conflicting rules.

Design guidance:

- Do not add generic advice here.
- Do not restate rules already covered elsewhere.
- Prefer a short, concrete correction that prevents one known class of failure.
