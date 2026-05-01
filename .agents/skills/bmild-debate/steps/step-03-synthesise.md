# Step 3: Synthesise — Consolidate and Decide

## MANDATORY EXECUTION RULES (READ FIRST)

- ✅ YOU ARE THE SYNTHESISER — played by the facilitator, not by any Lead.
- 🎯 DO NOT FLATTEN TENSIONS — name them honestly. The user deserves to know what is genuinely unresolved.
- 📋 THREE CATEGORIES ONLY — non-negotiable, preference, open. Do not create a fourth.
- 🚫 DO NOT recommend a decision for the user — surface the trade-offs and let them decide.
- ✅ APPLY agreed changes to the relevant spec documents and APPEND the synthesis record after open items are resolved. Do not ask permission — apply and report what changed.

---

## SYNTHESIS STRUCTURE

Present the synthesis clearly under three headings:

---

### 🔷 Synthesis

**Non-negotiable** — what all four Leads agree on, or what is constrained by existing platform decisions:

- [Point 1]
- [Point 2]
- ...

**Preference** — where Leads differed, but the trade-off is low-stakes or reversible:

- Option A:
  - Favoured by: Katrina@bmild-ux, Faisal@bmild-pm
  - Why: [reason]
  - Cost: [cost]
- Option B:
  - Favoured by: Lance@bmild-arch
  - Why: [reason]
  - Cost: [cost]

**Open** — genuinely unresolved; requires a decision before design can proceed:

- [Open question 1] — implication if unresolved: [impact]
- [Open question 2] — implication if unresolved: [impact]

---

## ELICITATION (if Open items remain)

If there are open items, do not let the synthesis end there. Run targeted elicitation immediately:

> *"There are [N] open questions. Let me ask them directly:*
>
> 1. [Question 1 — tightest possible phrasing]
> 2. [Question 2]"_

Wait for the user to answer. Then either:

- **Update the synthesis** with the resolved answers (move items from Open to Non-negotiable or Preference), or
- **Trigger another debate round** if the answers reveal new tensions (load `./steps/step-02-debate.md`)

---

## DOCUMENT APPLICATION

After synthesis is complete and open items are resolved or explicitly deferred, apply changes to the relevant spec documents. Do not ask for permission — apply and report.

Progress:

- [ ] Step 1: Apply non-negotiables to the appropriate spec/design document.
- [ ] Step 2: Apply resolved open items and remove them from Open Questions if settled.
- [ ] Step 3: Record deferred open items as Open Questions or Assumptions.
- [ ] Step 4: Append the synthesis record.
- [ ] Step 5: Update `_context.md` if a document was newly created or significantly changed.

**What to apply:**

- **Non-negotiables:** ensure each is reflected in the appropriate section of `spec.md`, `ux-design.md`, or `system-design.md`. If a non-negotiable contradicts existing content, update the existing content to match.
- **Resolved open items:** apply the agreed resolution in the appropriate spec section. Remove the item from Open Questions if it is now settled.
- **Deferred open items:** ensure they appear explicitly as Open Questions or Assumptions in the spec — not in the synthesis block alone.

After applying factual changes, append the synthesis record under this heading in the most relevant spec document:

```markdown
## debate session: <question summary> (<YYYY-MM-DD>)

### Non-negotiable
...

### Preference
...

### Open (deferred)
...
```

Then state what was done:

> *"I’ve updated `[document(s)]` to reflect the agreed decisions — [brief list of what changed]. The synthesis record has been appended."*

Update `_context.md` if the document was newly created or significantly changed.

---

## NEXT STEP

After applying document changes, ask:

> *"Do you want to keep the session open for another question, or shall we close?"*

- Another question → load `./steps/step-01-open.md` (new question, same context)
- Done → load `./steps/step-04-close.md`
