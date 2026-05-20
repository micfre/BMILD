# Step 2: Execute — Method Application and Iteration

## Purpose

Apply the selected method to the current working content, assess whether to apply or surface for user choice, re-present the iteration menu, and loop until the user exits. This step is the active session loop — do not exit until the user selects `[x]`.

## Inputs

- Selected primary method (carried from `step-01-select.md`).
- 2–3 follow-up methods (carried from `step-01-select.md`).
- Current working version of the content (use this version, not the original if already enhanced).
- `./methods.yaml` — required for `[a] List all`.

## Procedure

Apply the selected method to the current version of the content — not the original if it has already been enhanced. Show the work — present what the method revealed, not just the changed output. Apply clear improvements consistent with the user's stated direction and report what was applied. Halt and ask only when the method produces competing alternatives or genuinely ambiguous direction. Always re-present the 1–3, `[r]`, `[a]`, `[x]` menu after each method — iteration is the point. Do not exit until the user selects `[x]`.

1. **Number selection (1–3)** — When the user picks a numbered method:
   - [ ] Name the method at the top of your response: *"Applying: [Method Name]"*
   - [ ] Show the method output applied to the current content. Format depends on the method's pattern:
     - Analysis methods (First Principles, 5 Whys, etc.): show the analysis first, then implications for the content
     - Persona methods (Stakeholder Round Table, Cross-Functional War Room, etc.): play personas in turn, labeled clearly; if a debate session is active, use Faisal, Katrina, Lance, and Rahat. Label a speaker only when the speaker changes — do not repeat icon and name on every paragraph from the same speaker.
     - Generative methods (SCAMPER, What If, etc.): produce the generated content or alternatives first, then identify what's worth keeping
     - Competitive methods (Red Team, Shark Tank, etc.): run the adversarial scenario fully before proposing improvements
   - [ ] Summarise what changed or was revealed in 2–3 bullets: what assumption was surfaced, what gap was found, what improvement is proposed
   - [ ] Apply or ask based on clarity:

     If the method produces a clear improvement consistent with the user's direction — apply immediately and confirm:
     > *"Applied. Working content updated — [one-line summary of what changed]. Say 'undo' to revert."*

     If the method produces competing alternatives or genuinely ambiguous direction — surface the choice and halt:
     > *"[Brief description of the tension or alternatives]. Which direction? [y] Apply first option / [n] Discard / [other] Instructions"*
     Wait for the user's response before continuing.

   - [ ] Re-present the menu:

     ```
     Continue elicitation:
     1. [Method Name]
     2. [Method Name]
     3. [Method Name]
     [r] Reshuffle  [a] List all  [x] Proceed
     ```

2. **[r] Reshuffle** — Return to `./resources/step-01-select.md` for a fresh context analysis and method selection. Prioritise methods not yet used in this session; aim for diversity across categories. Re-present the menu with 2–3 new selections.

3. **[a] List all** — Read `./methods.yaml`. Group all entries by `category`. For each group:

   ```
   ## All Elicitation Methods

   ### [Category]
   [num]. [method_name] — [first sentence of description]
   ...
   ```

   After displaying: *"Select any method by number, or return to [r] your current 3 / [x] proceed."*

4. **[x] Proceed** — Close the elicitation session. See the `Exit and Return` section in `SKILL.md` for the full close shape.

5. **Direct text feedback** — Apply the feedback directly to the working content, confirm what changed, and re-present the menu.

6. **Multiple numbers (e.g. "1, 3")** — Treat as a request to choose, not permission to run a batch. Ask which one to run first. Re-present the menu after the user chooses.

## Next Step

- **Number selection or direct feedback** → complete the method, re-present the menu, remain in this resource.
- **`[r]`** → load `resources/step-01-select.md` carrying current working content forward.
- **`[x]`** → close the session following the `Exit and Return` shape in `SKILL.md`.

## Definition of Done

- The user has selected `[x]`.
- The final working version of the content is presented.
- A handoff note is produced if artifact ownership requires it.
- The session closes with `Facilitator ⚡` sign-off and return to invoking context.
