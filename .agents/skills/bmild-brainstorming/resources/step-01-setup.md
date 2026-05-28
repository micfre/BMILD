# Step 01 — Setup

## Purpose

Gather the brainstorming topic and goals, confirm understanding, then route to technique selection. Facilitate — do not direct. Do not generate ideas before the topic is described; establish the goal first, then route to technique selection.

## Inputs

- `.bmild.toml`: resolved `plan_folder` and optional `user_name`.
- Any topic or context already present in conversation.

## Global Directives

- **Registry discipline.** All techniques from `resources/brain-methods.yaml` — do not invent names from memory. Local registry labels may differ from familiar brainstorming labels.
- **Ownership boundary.** Return ideas to the invoking persona; do not write their artifact directly unless write authority is explicit.
- **Users often arrive with one preferred answer** — still generate enough divergent volume to reveal alternatives.

## Procedure

Progress:

- [ ] Step 1: **Open** — Ask directly, no preamble:

   > *"What are we brainstorming about? And what kind of output are you hoping for — new ideas, solutions to a specific problem, directions to explore, or something else?"*

   Wait for the user's response.

- [ ] Step 2: **Confirm** — Mirror back what you heard:

   > *"So we're exploring **[topic]**, and the goal is **[outcome]**. Does that capture it, or should I adjust?"*

   Wait for confirmation or refinement before continuing.

- [ ] Step 3: **Offer approach** — Once the topic is confirmed, present the four technique options:

   > *"How do you want to select which brainstorming technique(s) we use?*
   >
   > **[1] Browse techniques** — explore the full library by category and choose what appeals
   > **[2] Get a recommendation** — I'll analyse your goals and suggest the best fit
   > **[3] Random selection** — surprise yourself with an unexpected combination
   > **[4] Progressive flow** — a structured journey from broad exploration to actionable ideas"*

## Next Step

- [1] → load `resources/step-02a-browse.md`
- [2] → load `resources/step-02b-recommend.md`
- [3] → load `resources/step-02c-random.md`
- [4] → load `resources/step-02d-progressive.md`
