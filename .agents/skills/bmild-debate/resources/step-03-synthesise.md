## Synthesise — Consolidate and Decide

Synthesise the debate as facilitator — not as any Lead. Name tensions honestly; do not flatten them. Use three categories only: non-negotiable, preference, open. Surface trade-offs and let the user decide — do not recommend a decision. Preserve artifact ownership: return patch-ready implications to the invoking persona unless the user explicitly authorized this facilitator to write the target artifact.

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

   > *"There are [N] unresolved items. Let me ask them directly:*
   >
   > 1. [Question 1 — tightest possible phrasing]
   > 2. [Question 2]"*

   After the user answers: update the synthesis (move items from Open to Non-negotiable or Preference) or trigger another debate round if answers reveal new tensions (load `./resources/step-02-debate.md`).

2. **Return artifact implications** — After synthesis is complete and open items are resolved or explicitly deferred, prepare a handoff note for the invoking persona:
   - [ ] Non-negotiables to apply to the appropriate spec/design document
   - [ ] Resolved open items and where matching queued or source-local ambiguity records should be removed, promoted, or closed
   - [ ] Deferred open items to record as `user-attention.md`, `spec-patch-queue.md`, or Assumptions — with target owner, status, and consequence
   - [ ] Synthesis record to append to the most relevant spec document:

   ```markdown
   ## debate session: <question summary> (<YYYY-MM-DD>)

   ### Non-negotiable
   ...

   ### Preference
   ...

   ### Open (deferred)
   ...
   ```

   - [ ] Target owner and artifact for each change

   If the user explicitly authorized facilitator writes, apply the changes and update `_context.md` if the document was newly created or significantly changed. Otherwise do not write artifacts directly.

3. **Report** — State what was done:

   > *"Debate synthesis ready. I prepared changes for [owner/artifact] — [brief list of implications]. [If authorized: I updated the document(s). If not authorized: Next I will turn this back to [persona] to apply within their workflow.]"*

4. **Continue or close** — Ask: *"Do you want to keep the session open for another question, or shall we close?"*
   - Another question → load `./resources/step-01-open.md` (new question, same context)
   - Done → load `./resources/step-04-close.md`
