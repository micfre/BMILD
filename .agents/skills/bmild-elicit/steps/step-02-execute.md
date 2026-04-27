# Step 2: Execute — Method Application and Iteration

## MANDATORY EXECUTION RULES (READ FIRST)

- ✅ APPLY the selected method to the CURRENT version of the content — not the original if it has already been enhanced.
- 🎯 SHOW THE WORK — present what the method revealed, not just the changed output.
- 📋 APPLY clear improvements consistent with the user’s stated direction — report what was applied. HALT and ask only when the method produces competing alternatives or genuinely ambiguous direction.
- ✅ The user can always say "undo" or "revert" to reverse an applied change. Do not pre-interrupt forward progress with approval gates for non-ambiguous improvements.
- 🔁 ALWAYS re-present the 1-5, [r], [a], [x] menu after each method — iteration is the point.
- 🚫 DO NOT exit until user selects [x].

---

## RESPONSE HANDLING

### Case: User selects a number (1–5)

1. **Name the method** at the top of your response:
   > **Applying: [Method Name]**

2. **Show the method output** — apply it to the current content. The output depends on the method's pattern:
   - For analysis methods (First Principles, 5 Whys, etc.): show the analysis first, then the implications for the content
   - For persona methods (Stakeholder Round Table, Cross-Functional War Room, etc.): play the personas in turn, labeled clearly; if a debate session is active or recently completed, use Faisal@bmild-pm, Katrina@bmild-ux, Lance@bmild-arch, and Rahat@bmild-qa as the personas
   - For generative methods (SCAMPER, What If, etc.): produce the generated content/alternatives first, then identify what's worth keeping
   - For competitive methods (Red Team, Shark Tank, etc.): run the adversarial scenario fully before proposing improvements

3. **Summarise what changed or was revealed** in 2–3 bullet points:
   - What assumption was surfaced
   - What gap was found
   - What improvement is being proposed

4. **Apply or ask — based on clarity:**

   **If the method produces a clear improvement consistent with the user’s stated direction:**
   Apply the changes to the working content immediately, then confirm:
   > *"Applied. Working content updated — [one-line summary of what changed]. Say 'undo' to revert."*

   **If the method produces competing alternatives or genuinely ambiguous direction:**
   Surface the choice and halt:
   > *"[Brief description of the tension or alternatives]. Which direction? [y] Apply first option / [n] Discard / [other] Instructions"*
   Wait for the user’s response before continuing.

5. **Re-present the menu** after applying or resolving:

   ```
   Continue elicitation:
   1. [Method Name]
   2. [Method Name]
   3. [Method Name]
   4. [Method Name]
   5. [Method Name]
   [r] Reshuffle  [a] List all  [x] Proceed
   ```

---

### Case: [r] Reshuffle

- Return to `./steps/step-01-select.md` and perform a fresh context analysis and method selection
- Prioritise methods NOT yet used in this session
- Aim for diversity across categories
- Re-present the menu with 5 new selections

---

### Case: [a] List All

Read `./methods.yaml`. Group all entries by their `category` key. For each group, display entries as:

```
[num]. [method_name] — [first sentence of description]
```

Format:

```
## All Elicitation Methods

### [Category]
[num]. [method_name] — [one-line]
...

### [Category]
...
```

After displaying, prompt: *"Select any method by number, or return to [r] your current 5 / [x] proceed."*

---

### Case: [x] Proceed

1. Present a brief summary of what the elicitation session produced:
   > **Elicitation complete.**
   >
   > Methods applied: [list]  
   > Key improvements made: [2–4 bullets]  
   > Changes discarded: [if any]

2. Present the final working version of the content.

3. Ask: *"Do you want to save this enhanced version to [document name]?"*
   - If yes: write it to the appropriate spec document (or the section within it) and update `_context.md` if the document changed meaningfully.
   - If no: leave the content in the conversation for the user to apply manually.

4. Return cleanly to the invoking context:
   > *"Returning to [persona or workflow that called elicitation]."*

---

### Case: Direct text feedback (user types a comment or instruction, not a menu option)

- Apply the feedback directly to the working content
- Confirm what changed
- Re-present the menu

### Case: Multiple numbers (user types e.g. "1, 3")

- Execute methods in sequence on the current content
- Apply each using the same judgment rule: clear improvement → apply and report; ambiguous direction → halt and ask
- Re-present the menu after both are done
