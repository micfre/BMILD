# Step 3: Synthesise — Consolidate and Decide

## MANDATORY EXECUTION RULES (READ FIRST):

- ✅ YOU ARE THE SYNTHESISER — played by the facilitator, not by any Lead.
- 🎯 DO NOT FLATTEN TENSIONS — name them honestly. The user deserves to know what is genuinely unresolved.
- 📋 THREE CATEGORIES ONLY — non-negotiable, preference, open. Do not create a fourth.
- 🚫 DO NOT recommend a decision for the user — surface the trade-offs and let them decide.
- ✅ OFFER TO APPEND synthesis to the relevant spec document after user confirms.

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
| Option | Who favours it | Why | Cost |
|--------|---------------|-----|------|
| A | Katrina, Faisal | [reason] | [cost] |
| B | Lance | [reason] | [cost] |

**Open** — genuinely unresolved; requires a decision before design can proceed:
- [Open question 1] — implication if unresolved: [impact]
- [Open question 2] — implication if unresolved: [impact]

---

## ELICITATION (if Open items remain)

If there are open items, do not let the synthesis end there. Run targeted elicitation immediately:

> _"There are [N] open questions. Let me ask them directly:_
> 
> 1. [Question 1 — tightest possible phrasing]
> 2. [Question 2]"_

Wait for the user to answer. Then either:
- **Update the synthesis** with the resolved answers (move items from Open to Non-negotiable or Preference), or
- **Trigger another debate round** if the answers reveal new tensions (load `./steps/step-02-debate.md`)

---

## DOCUMENT OFFER

After synthesis (and after any open items are resolved or deferred), ask:

> _"Do you want me to append this synthesis to [most relevant spec document — e.g. `system-design.md`, `ux-design.md`, or `spec.md`]?"_

If confirmed, append under this heading:

```markdown
## IL Session: <question summary> (<YYYY-MM-DD>)

### Non-negotiable
...

### Preference
...

### Open (deferred)
...
```

Update `_context.md` if the document was newly created or significantly changed.

---

## NEXT STEP

After synthesis and document offer, ask:

> _"Do you want to keep the session open for another question, or shall we close?"_

- Another question → load `./steps/step-01-open.md` (new question, same context)
- Done → load `./steps/step-04-close.md`
