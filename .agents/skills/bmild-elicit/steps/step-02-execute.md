# Step 2: Execute — Method Application and Iteration

## MANDATORY EXECUTION RULES (READ FIRST):

- ✅ APPLY the selected method to the CURRENT version of the content — not the original if it has already been enhanced.
- 🎯 SHOW THE WORK — present what the method revealed, not just the changed output.
- 📋 ASK apply or discard before changing anything. HALT and wait for the response.
- ✅ ONLY apply changes if the user confirms. If they say no, discard entirely.
- 🔁 ALWAYS re-present the 1-5, [r], [a], [x] menu after each method — iteration is the point.
- 🚫 DO NOT exit until user selects [x].

---

## RESPONSE HANDLING

### Case: User selects a number (1–5)

1. **Name the method** at the top of your response:
   > **Applying: [Method Name]**

2. **Show the method output** — apply it to the current content. The output depends on the method's pattern:
   - For analysis methods (First Principles, 5 Whys, etc.): show the analysis first, then the implications for the content
   - For persona methods (Stakeholder Round Table, Cross-Functional War Room, etc.): play the personas in turn, labeled clearly; if an IL session is active or recently completed, use Faisal, Katrina, Lance, and Rahat as the personas
   - For generative methods (SCAMPER, What If, etc.): produce the generated content/alternatives first, then identify what's worth keeping
   - For competitive methods (Red Team, Shark Tank, etc.): run the adversarial scenario fully before proposing improvements

3. **Summarise what changed or was revealed** in 2–3 bullet points:
   - What assumption was surfaced
   - What gap was found
   - What improvement is being proposed

4. **HALT and ask:**
   > _"Apply these changes to the content? [y] Yes / [n] No / [other] Instructions"_
   
   Wait for the user's response before continuing.

5. **If Yes:** Apply the changes to the working version of the content. Confirm:
   > _"Applied. Working content updated."_

6. **If No:** Discard. Do not reference the proposed changes again. Confirm:
   > _"Discarded. Working content unchanged."_

7. **If other instruction:** Follow the instruction given, then re-present the menu.

8. **Re-present the menu** (same 5 methods, unless reshuffled):
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

Read `./methods.csv`. Group all entries by their `category` column. For each group, display entries as:

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

After displaying, prompt: _"Select any method by number, or return to [r] your current 5 / [x] proceed."_

---

### Case: [x] Proceed

1. Present a brief summary of what the elicitation session produced:
   > **Elicitation complete.**
   > 
   > Methods applied: [list]  
   > Key improvements made: [2–4 bullets]  
   > Changes discarded: [if any]

2. Present the final working version of the content.

3. Ask: _"Do you want to save this enhanced version to [document name]?"_
   - If yes: write it to the appropriate spec document (or the section within it) and update `_context.md` if the document changed meaningfully.
   - If no: leave the content in the conversation for the user to apply manually.

4. Return cleanly to the invoking context:
   > _"Returning to [persona or workflow that called elicitation]."_

---

### Case: Direct text feedback (user types a comment or instruction, not a menu option)

- Apply the feedback directly to the working content
- Confirm what changed
- Re-present the menu

### Case: Multiple numbers (user types e.g. "1, 3")

- Execute methods in sequence on the current content
- Apply each only if confirmed
- Re-present the menu after both are done
