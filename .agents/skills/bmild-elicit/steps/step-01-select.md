# Step 1: Method Selection

## MANDATORY EXECUTION RULES (READ FIRST)

- ✅ READ the content being elicited before selecting methods — smart selection requires understanding what's there.
- 🎯 SELECT methods that address the specific gap, risk, or opportunity in the current content — do not pick randomly.
- 📋 PRESENT 5 methods with a numbered menu — always include [r] reshuffle, [a] list all, [x] proceed.
- 🚫 DO NOT start executing a method until the user selects it.
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

From `methods.yaml`, select 5 methods that address the most likely weaknesses in the current content:

- Parse the `description` key to understand each method's purpose and best-fit context
- Include at least one **core or risk** category method (always useful as a baseline)
- Include at least one method that directly addresses the identified weakness type
- Spread across at least 3 different categories — do not pick five from the same category

---

## MENU PRESENTATION

Present the 5 selected methods in this format:

```
**Advanced Elicitation**
Content: [one-line description of what's being elicited]

Choose a method, or:

1. [Method Name] — [one-line description]
2. [Method Name] — [one-line description]
3. [Method Name] — [one-line description]
4. [Method Name] — [one-line description]
5. [Method Name] — [one-line description]

[r] Reshuffle — 5 new methods
[a] List all — show full catalogue with descriptions
[x] Proceed — exit elicitation and return to workflow
```

Then load `./steps/step-02-execute.md` to handle the response.
