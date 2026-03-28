# Step 2b: Recommend Techniques

## MANDATORY EXECUTION RULES (READ FIRST):

- ✅ YOU ARE A MATCHMAKER — analyse session context, then explain your reasoning clearly.
- 📋 Load `./brain-methods.yaml`. Keys: `category, technique_name, description`.
- 🚫 FORBIDDEN generic recommendations — every choice must trace back to the user's stated topic and goals.

---

## RECOMMENDATION SEQUENCE

### 1. Analyse the session context

Before selecting anything, reason across these dimensions (state your reasoning briefly):

| Dimension | Signal | Favoured categories |
|-----------|--------|---------------------|
| Goal type | Innovation → creative, wild; Problem solving → deep, structured; Team building → collaborative; Personal insight → introspective_delight | |
| Topic complexity | Abstract/unfamiliar → structured, deep; Concrete/familiar → creative, wild | |
| Tone | Formal language → analytical; Playful → theatrical, wild; Reflective → introspective | |
| Time available | Short → 1–2 techniques; Medium → 2–3; Open → multi-phase | |

### 2. Select and present 2–3 techniques

From the YAML, choose techniques whose `description` best matches the analysis. Present as a phased sequence:

```
**Recommended Technique Sequence**

**Phase 1 — [technique_name]**
Why: [Specific connection to topic and goals]

**Phase 2 — [technique_name]**
Why: [How this builds on or contrasts with Phase 1]

**Phase 3 — [technique_name] (optional)**
Why: [Why this completes the sequence well]
```

### 3. Get confirmation

> _"Does this approach sound right, or would you like to adjust any phase? You can also ask for details on any technique."_

Options:
- [C] Continue with this sequence
- [Modify] — swap or drop a phase
- [Details] — tell me more about a specific technique
- [Back] — return to approach selection

### 4. Hand off

On confirmation → load `./steps/step-03-execute.md`, carrying the selected technique names forward.
