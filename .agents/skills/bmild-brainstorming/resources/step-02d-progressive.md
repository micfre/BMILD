# Step 02d — Progressive Flow

## Purpose

Design a natural arc: diverge → recognise patterns → refine → act. Do not skip the early divergent phase to get to "useful" content faster — divergence is the point.

## Inputs

- `resources/brain-methods.yaml` (keys: `category`, `technique_name`, `description`). Load the file; do not pick techniques from memory.
- Category-to-phase mapping: Phase 1 (creative, wild, theatrical_exploration); Phase 2 (deep_analysis, structured_thinking); Phase 3 (structured_thinking, collaborative); Phase 4 (deep_analysis, structured_thinking).

## Procedure

Progress:

- [ ] Step 1: **Explain the journey** — Open with:

   > *"Progressive flow mirrors natural creativity — start wild and broad, then systematically narrow toward action. Four phases:*
   >
   > **Phase 1: Expansive Exploration** — generate without judgment, maximum breadth
   > **Phase 2: Pattern Recognition** — find themes and connections in the chaos
   > **Phase 3: Idea Development** — refine the most promising concepts
   > **Phase 4: Action Planning** — turn the best ideas into concrete next steps"*

- [ ] Step 2: **Select techniques** — Match YAML techniques to phases by `category`:
  - Phase 1 (Expansive Exploration): creative, wild, theatrical_exploration
  - Phase 2 (Pattern Recognition): deep_analysis, structured_thinking
  - Phase 3 (Idea Development): structured_thinking, collaborative
  - Phase 4 (Action Planning): deep_analysis, structured_thinking

   Select one technique per phase. For each, show:

   ```
   **Phase [N] — [technique_name]**
   Why for this phase: [one line connecting its description to the phase goal]
   ```

- [ ] Step 3: **Present the journey map** — Show all four phases together with total time, then ask: *"Does this flow work for your session? You can customise any phase, or I can suggest an alternative for any step."*

   Options: [C] Start / [Customise] adjust phases / [Details] explain a phase or technique / [Back] return to approach selection.

- [ ] Step 4: **Handle customisation** — If the user wants to swap a phase technique, load alternatives from the YAML for that category and let them pick.

## Next Step

- [C] or confirmed → load `resources/step-03-execute.md` carrying all four technique names and their phase order forward.
- [Back] → return to `resources/step-01-setup.md`.
