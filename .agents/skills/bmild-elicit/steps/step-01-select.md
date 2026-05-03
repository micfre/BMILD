# Step 1: Method Selection

## MANDATORY EXECUTION RULES (READ FIRST)

- ✅ READ the content being elicited before selecting methods — smart selection requires understanding what's there.
- 🎯 SELECT methods that address the specific gap, risk, or opportunity in the current content — do not pick randomly.
- 📋 RUN the single most salient method first, then present 2-3 follow-up methods with a numbered menu — always include [r] reshuffle, [a] list all, [x] proceed.
- 🚫 DO NOT run more than one method before the user selects a follow-up.
- ✅ IF an debate session is currently active, the debate Leads (Faisal@bmild-pm, Katrina@bmild-ux, Lance@bmild-arch, Rahat@bmild-qa) may be named as personas within collaboration methods.

---

## CONTEXT IDENTIFICATION

Before selecting methods, identify:

Progress:

- [ ] Step 1: Identify what content is being elicited.
- [ ] Step 2: Identify the content type.
- [ ] Step 3: Identify the most likely weakness.

**Step 1: What content are we eliciting?**

- State the document, section, or decision being examined (one sentence)
- If not explicitly stated by the user, infer from conversation context

**Step 2: What type of content is it?**

- Requirements / problem framing → favour: core, risk, collaboration methods
- UX design / interaction model → favour: creative, collaboration, risk methods
- Architecture / system design → favour: technical, advanced, risk methods
- Slice decomposition / planning → favour: core, risk, structural methods
- RCA / diagnosis → favour: core (5 Whys, First Principles), technical, risk methods

**Step 3: What is the most likely weakness?**

- Vague requirements → Socratic Questioning, First Principles, Critique and Refine
- Untested assumptions → Pre-mortem, Challenge from Critical Perspective, Self-Consistency Validation
- Missing perspectives → Stakeholder Round Table, Cross-Functional War Room, User Persona Focus Group
- Complexity / hidden coupling → Tree of Thoughts, Architecture Decision Records, Failure Mode Analysis
- Over-engineered solution → Occam's Razor, Reverse Engineering, First Principles

---

## METHOD REGISTRY

**Load and parse:** `./methods.yaml` (relative to this skill folder)

YAML keys: `num, category, method_name, description, output_pattern`

Read the full file before selecting or displaying any methods. All selection, display, and execution logic draws exclusively from this file.

> **Interchangeable with BMAD source:** `_bmad/core/workflows/advanced-elicitation/methods.csv` uses the same format. Drop in a new file to update the method set — no changes to skill logic required.

---

## SMART SELECTION

From `methods.yaml`, select 1 primary method and 2-3 follow-up methods that address the most likely weaknesses in the current content:

- Parse the `description` key to understand each method's purpose and best-fit context
- The primary method should be the strongest single fit for the identified weakness
- Include at least one **core or risk** category method across the full set
- Include at least one follow-up method that directly addresses the identified weakness type from a different angle
- Spread across at least 2 different categories — do not pick every method from the same category

---

## MENU PRESENTATION

First run the primary method by loading `./steps/step-02-execute.md` with that method selected.

After the primary method is applied or resolved, present the follow-up choice with the native structured question tool when one is available. If the tool cannot represent method choice plus natural response cleanly, use this text format and append `Tool choice note: <why text was used instead of a structured question>.`

```
**Advanced Elicitation**
Content: [one-line description of what's being elicited]
First pass applied: [Primary Method Name] — [one-line result]

Choose a follow-up method, respond naturally, or:

1. [Method Name] — [one-line description]
2. [Method Name] — [one-line description]
3. [Method Name] — [one-line description]

[r] Reshuffle — 2-3 new methods
[a] List all — show full catalogue with descriptions
[x] Proceed — exit elicitation and return to workflow
```

Then load `./steps/step-02-execute.md` to handle the response.
