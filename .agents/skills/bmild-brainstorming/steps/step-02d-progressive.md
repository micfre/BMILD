# Step 2d: Progressive Flow

## MANDATORY EXECUTION RULES (READ FIRST):

- ✅ Design a natural arc: diverge → recognise patterns → refine → act.
- 📋 Load `./brain-methods.yaml`. Keys: `category, technique_name, description`.
- 🚫 FORBIDDEN skipping the early divergent phase to get to "useful" content faster. Divergence is the point.

---

## PROGRESSIVE FLOW SEQUENCE

### 1. Explain the journey

> _"Progressive flow mirrors natural creativity — start wild and broad, then systematically narrow toward action. Four phases:_
>
> **Phase 1: Expansive Exploration** — generate without judgment, maximum breadth  
> **Phase 2: Pattern Recognition** — find themes and connections in the chaos  
> **Phase 3: Idea Development** — refine the most promising concepts  
> **Phase 4: Action Planning** — turn the best ideas into concrete next steps"_

### 2. Select techniques from YAML for each phase

Match technique types to phases using the YAML `category` field:

| Phase | Best-fit categories |
|-------|-------------------|
| 1 — Expansive Exploration | creative, wild, theatrical_exploration |
| 2 — Pattern Recognition | deep_analysis, structured_thinking |
| 3 — Idea Development | structured_thinking, collaborative |
| 4 — Action Planning | deep_analysis, structured_thinking |

Select one technique per phase. For each, show:

```
**Phase [N] — [technique_name]**
Why for this phase: [one line connecting its description to the phase goal]
```

### 3. Present the full journey map

Show all four phases together with total time, then ask:

> _"Does this flow work for your session? You can customise any phase, or I can suggest an alternative for any step."_

Options:
- [C] Start the journey
- [Customise] — adjust one or more phases
- [Details] — tell me more about a specific phase or technique
- [Back] — return to approach selection

### 4. Handle customisation

If the user wants to swap a phase technique: load the alternatives from the CSV for that category and let them pick.

### 5. Hand off

On confirmation → load `./steps/step-03-execute.md`, carrying all four technique names and their phase order forward.
