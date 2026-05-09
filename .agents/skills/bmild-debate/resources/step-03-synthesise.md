## Synthesise — Consolidate and Decide

Synthesise the debate as facilitator — not as any Lead. Name tensions honestly; do not flatten them. Use three categories only: non-negotiable, preference, open. Surface trade-offs and let the user decide — do not recommend a decision. Apply agreed changes to relevant spec documents and append the synthesis record without asking permission — apply and report.

Present the synthesis under this structure:

---

**Non-negotiable** — what all four Leads agree on, or what is constrained by existing platform decisions:
- [Point 1]
- [Point 2]

**Preference** — where Leads differed, but the trade-off is low-stakes or reversible:
- Option 1:
  - Favoured by: Katrina, Faisal
  - Why: [reason]
  - Cost: [cost]
- Option 2:
  - Favoured by: Lance
  - Why: [reason]
  - Cost: [cost]

**Open** — genuinely unresolved; requires a decision before design can proceed:
- [Open question 1] — implication if unresolved: [impact]
- [Open question 2] — implication if unresolved: [impact]

---

1. **Elicit open items** — If there are open items, run targeted elicitation immediately — do not let the synthesis stall:

   > *"There are [N] open questions. Let me ask them directly:*
   >
   > 1. [Question 1 — tightest possible phrasing]
   > 2. [Question 2]"*

   After the user answers: update the synthesis (move items from Open to Non-negotiable or Preference) or trigger another debate round if answers reveal new tensions (load `./resources/step-02-debate.md`).

2. **Apply to documents** — After synthesis is complete and open items are resolved or explicitly deferred, apply changes without asking permission:
   - [ ] Apply non-negotiables to the appropriate spec/design document — if a non-negotiable contradicts existing content, update to match
   - [ ] Apply resolved open items in the appropriate artifact section; remove or mark `resolved` in matching Open Question or Handoff Question
   - [ ] Record deferred open items explicitly as user-owned Open Questions, persona-owned Handoff Questions, or Assumptions — with target responder, status, and consequence
   - [ ] Append the synthesis record to the most relevant spec document:

   ```markdown
   ## debate session: <question summary> (<YYYY-MM-DD>)

   ### Non-negotiable
   ...

   ### Preference
   ...

   ### Open (deferred)
   ...
   ```

   - [ ] Update `_context.md` if the document was newly created or significantly changed

3. **Report** — State what was done:

   > *"I've updated `[document(s)]` to reflect the agreed decisions — [brief list of what changed]. The synthesis record has been appended."*

4. **Continue or close** — Ask: *"Do you want to keep the session open for another question, or shall we close?"*
   - Another question → load `./resources/step-01-open.md` (new question, same context)
   - Done → load `./resources/step-04-close.md`
