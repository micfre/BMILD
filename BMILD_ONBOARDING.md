# Getting Started with BMILD

You will generally enter BMILD with one of the design-tier agents: PM, UX or Arch. BMILD will read any existing context from the plans\ folder if it exists, so you can start from a blank idea or drop into a half-built project.

## Your first 30 seconds

1. Copy `.agents/skills/` into your project (or relocate to your IDE's expected path -- see [README](README.md)).
2. Open your AI coding agent.
3. Say something like:

> *Faisal, I want to build a notification system that aggregates alerts from multiple sources into a single feed.*

Faisal will push back. He'll ask who the users are, what problem exists today, what success looks like, what's out of scope. He'll probably challenge your answer. This is the point, the spec gets stronger before anyone draws a screen or writes a schema.

When he's done, he'll tell you who should engage next (usually Katrina or Lance).

## Pick your entry point

| Where you are | Who to call | What to say |
| :--- | :--- | :--- |
| I have an idea | **Faisal** 🟦 | `Faisal, help me frame a feature for [idea].` |
| I know what to build, need the UX | **Katrina** 🟩 | `Katrina, design the user experience for [feature].` |
| I need backend contracts | **Lance** 🟥 | `Lance, design the API and data model for [feature].` |
| Design is done, need implementation plan | **Sonia** 🟧 | `Sonia, check readiness and decompose into slices.` |
| I have a slice ready to build | **Alex** 🟪 | `Alex, implement slice 3.` |
| Something is broken | **Rahat** 🟨 | `Rahat, diagnose this failure.` |

You can also enter mid-conversation with any persona. They read `plans/` to pick up where you, or another persona, left off:

- `Katrina, continue the UX design for [feature].`
- `Sonia, what slice should happen next?`
- `Alex, continue with slice 4.`

## What the personas will do

Every persona follows the same activation pattern:

1. Read the relevant live context from `plans/`
2. Tell you what stage or gap appears current
3. Ask only the next unresolved question, or take the next action

When they're done with their stage, they'll tell you:
- What's now complete
- What artifact was written or updated
- Who should engage next and why

You don't need to memorize the workflow. They route it.

## Speeding up or slowing down

The design personas (Faisal, Katrina, Lance) are deliberate. They probe and challenge because vague specs produce bad code. The payoff comes downstream when Alex builds against contracts that are actually clear.

If you want to push a design output further, you have two tools:

- **Elicit** -- Say `elicit this` to stress-test whatever was just produced. Works on requirements, UX designs, architecture decisions, anything. 20+ structured methods to find what's missing.
- **Debate** -- Say `debate this` to get Faisal, Katrina, Lance, and Rahat arguing across perspectives. Real disagreement, not polite consensus. Useful when a decision has more than one defensible answer.

The execution personas (Sonia, Alex, Rahat) are deliberately fast. They activate lean and get to the work. Sonia sizes slices to context windows. Alex matches existing code patterns before writing new ones. Rahat diagnoses before fixing. Minimal ceremony, maximum signal.

## Coming from BMAD

If you've used BMAD, the transition is straightforward. BMILD doesn't try to replicate BMAD persona-for-persona -- it consolidates.

What's the same:
- Spec-driven approach
- Interactive modes (Party Mode -> Debate, Advanced Elicitation, Brainstorming)
- Context-aware persona handoffs
- Structured output artifacts

What's different:
- 6 personas covering the full lifecycle instead of 12+
- No `npx install` -- just copy the skill folders
- Features and Slices replace Epics and Stories
- Slices are sized to context windows (~170K tokens), not story points
- No orchestrator -- personas manage their own memory in `plans/`
- No IDE-specific tooling -- works anywhere that reads skill folders

What's intentionally missing:
- Scrum ceremony (sprints, burndown, velocity)
- A help agent (personas route each other)
- Multiple planning personas -- Sonia handles readiness, sequencing, status, and rerouting

## The plans/ directory

BMILD personas read and write a `plans/` directory at your project root. You don't manage this — they do. The structure is:

```
plans/
├── platform/              # For greenfield or large refactors
│   ├── _context.md        # What's live vs. archived
│   ├── spec.md            # PM output
│   ├── ux-design.md       # UX output
│   ├── system-design.md   # Arch output
│   └── slices.md          # Planner output
└── features/
    └── <feature-name>/    # One per feature
        ├── _context.md
        ├── spec.md
        ├── ux-design.md
        ├── system-design.md
        ├── slices.md
        ├── slice-<N>.md
        └── rca-<slug>.md
```

`_context.md` is the entry point. Personas load only what's live and relevant -- they don't re-read the entire history every time.

## Backing out

Remove the `bmild-*` folders from your skills directory. That's it. The `plans/` files stay in your project unless you choose to delete them -- they're just markdown.
