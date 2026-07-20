# Step 2: Execute — Method Application and Iteration

## Purpose

Apply the selected method to the current working content, assess whether to apply or surface for user choice, re-present the iteration menu, and loop until the user exits. This step is the active session loop — do not exit until the user selects `[x]`.

## Inputs

- Selected primary method (carried from `step-01-select.md`).
- 2–3 follow-up methods (carried from `step-01-select.md`).
- Current working version of the content (use this version, not the original if already enhanced).
- `./methods.yaml` — required for `[a] List all`.
- Convener identity and suspended session state from `step-01-select.md` when persona-convened.

## Global Directives

- **Apply with judgment.** After each method, assess whether output is a clear improvement consistent with the user's direction. Apply and report when yes. When competing alternatives or ambiguous direction: `[y] apply / [n] discard / [other] instructions`. User can say "undo" to revert.
- **Loop until `[x]`.** After the first method, use a compact continuation prompt with the 2–3 follow-up methods and `[x]`; show the full menu again only on `[r]` or `[a]`. Do not exit until user selects `[x]`.
- **Provocative alternatives** require user choice before application — do not auto-apply.
- **Artifact writes.** Pause for user confirmation before writing any artifact not owned by the active caller.
- **Roundtable suggestion.** Structured multi-persona deliberation needed → suggest `bmild-roundtable`; do not convene autonomously.

## Procedure

Apply the selected method to the current version of the content — not the original if it has already been enhanced. Show the work — present what the method revealed, not just the changed output. Apply clear improvements consistent with the user's stated direction and report what was applied. Halt and ask only when the method produces competing alternatives or genuinely ambiguous direction. After the first iteration, continue compactly with the follow-up methods and `[x]`; expand back to the full menu only on `[r]` or `[a]`. Do not exit until the user selects `[x]`.

1. **Number selection (1–3)** — When the user picks a numbered method:
   - [ ] Name the method at the top of your response: *"Applying: [Method Name]"*
   - [ ] Show the method output applied to the current content. Format depends on the method's pattern:
     - Analysis methods (First Principles, 5 Whys, etc.): show the analysis first, then implications for the content
     - Persona methods (Stakeholder Round Table, Expert Panel Review, Cross-Functional War Room, Security Audit Personas, and any method playing named BMILD personas): load each active persona's whole `<persona-skill-dir>/SOUL.md`, resolved relative to that persona's own skill directory, before speaking. The loaded SOUL is the sole voice source; do not add facilitator-authored impressions. If a debate session is active, use Faisal, Katrina, Lance, Rahat, and Zach. Label a speaker only when the speaker changes — do not repeat icon and name on every paragraph from the same speaker.
     - Generative methods (SCAMPER, What If, etc.): produce the generated content or alternatives first, then identify what's worth keeping
     - Competitive methods (Red Team, Shark Tank, etc.): run the adversarial scenario fully before proposing improvements
   - [ ] Summarise what changed or was revealed in 2–3 bullets: what assumption was surfaced, what gap was found, what improvement is proposed
   - [ ] Apply or ask based on clarity:

     If the method produces a clear improvement consistent with the user's direction — apply immediately and confirm:
     > *"Applied. Working content updated — [one-line summary of what changed]. Say 'undo' to revert."*

     If the method produces competing alternatives or genuinely ambiguous direction — surface the choice and halt:
     > *"[Brief description of the tension or alternatives]. Which direction? [y] Apply first option / [n] Discard / [other] Instructions"*
     Wait for the user's response before continuing.

   - [ ] Continue after the first iteration with this compact prompt (use the full menu only on `[r]` or `[a]`):

     ```
     Continue:
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

4. **[x] Proceed** — Close the elicitation session:

   - State methods applied, key improvements, changes discarded if any.
   - Present final working version of the content.
   - If invoked from a named persona workflow, produce a handoff note (target owner, artifact/section, patch-ready changes, open decisions) rather than writing their artifact.
   - Save only when user invoked with explicit write authority or caller owns the target; update `registry.md` if document changed meaningfully.
   - **Ratification→Promotion gate.** When the session ends with a user-ratified durable-contract change (not merely method output the user has not ratified as a decision), load this skill's `references/promotion-protocol.md` and evaluate the trigger triad. If it holds: inventory with action classes, ask once, apply only scribe-eligible lines when the user explicitly authorizes facilitator scribe, otherwise close `ratified_pending_authorization` and resume the convener. Preserve the stricter default: without facilitator-write authorization, return a handoff note. Name the close state when the gate fires: `ratified_and_promoted` | `ratified_and_routed` | `ratified_pending_authorization` | `ratified_with_documentation_deferred`.
   - Sign off with a **branch-aware close** — never *"I will turn this back to [persona]"*, because your turn ends at sign-off and you cannot resume another persona on the user's behalf. Use the convener identity and suspended session state carried from step-01:
     - **Persona convened** → *"Facilitator ⚡ closing. Refined content is ready. [If gate fired: Close state: [state].] Resume **[convener name] [icon]** with the message \"continue `[initiative-name]` [mode/resource] from [artifact section in progress] with the [facilitator output] above.\""*
     - **You convened** → *"Facilitator ⚡ closing. [If gate fired: Close state: [state].] For you, [user_name]: [only a real step-completion action — omit if there is none]. Next: invoke the persona who owns the next artifact when ready, or tell me what's next."*
     - `For you` appears only when a genuine user-facing step-completion action exists; keep `For you` and `Next` separate. Sign off as `— Facilitator ⚡`.

5. **Direct text feedback** — Apply the feedback directly to the working content, confirm what changed, and re-present the menu.

6. **Multiple numbers (e.g. "1, 3")** — Treat as a request to choose, not permission to run a batch. Ask which one to run first. Re-present the menu after the user chooses.

## Next Step

- **Number selection or direct feedback** → complete the method, re-present the menu, remain in this resource.
- **`[r]`** → load `resources/step-01-select.md` carrying current working content forward.
- **`[x]`** → close per item 4 above (Exit and Return rules).

## Definition of Done

- The user has selected `[x]`.
- The final working version of the content is presented.
- A handoff note is produced if artifact ownership requires it.
- The session closes with `— Facilitator ⚡` sign-off and a branch-aware close: the convener persona resumes with the refined content, or the user gets a `For you`/`Next` routing step.
