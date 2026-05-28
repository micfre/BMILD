# Step 1: Method Selection

## Purpose

Understand the content being elicited, identify the content type and most likely weakness, then select the single best-fit primary method from the registry and hand off to execution. This step protects context-sensitive method selection — smart method choice requires reading what's there before picking.

## Inputs

- `./methods.yaml` — full method registry (keys: `num, category, method_name, description, output_pattern`). Load and read the full file before selecting or displaying any methods.
- Content to be elicited — from the current conversation context.

> **Interchangeable with BMAD source:** `_bmad/core/workflows/advanced-elicitation/methods.csv` uses the same format. Drop in a new file to update the method set — no changes to skill logic required.

## Global Directives

- **Method registry discipline.** All methods from `./methods.yaml` — keys: `num, category, method_name, description, output_pattern`. Do not use methods from memory.
- **Context-sensitive selection.** Read and understand content before selecting methods.
- **Start proactively, then choose interactively.** Run one best-fit method immediately; then offer 2–3 follow-ups — do not run multiple additional methods without user selection.
- **Build on the current version.** Each method applies to the working version, not the original.
- **Domain boundaries.** If refinement crosses into another persona's authority, name the boundary and suggest that persona — do not decide for them.
- **Debate persona integration.** For collaboration methods during an active debate/roundtable context, use Faisal, Katrina, Lance, and Rahat as personas.

## Procedure

Progress:

- [ ] Step 1: **Identify context** — Before selecting methods:
  - State the document, section, or decision being examined (one sentence). If not stated by the user, infer from conversation context.
  - Identify the content type: Requirements/problem framing (favour core, risk, collaboration) / UX design (creative, collaboration, risk) / Architecture (technical, advanced, risk) / Slice decomposition (core, risk, structural) / RCA/diagnosis (core: 5 Whys, First Principles; technical; risk)
  - Identify the most likely weakness: Vague requirements (Socratic Questioning, First Principles, Critique and Refine) / Untested assumptions (Pre-mortem, Challenge from Critical Perspective, Self-Consistency Validation) / Missing perspectives (Stakeholder Round Table, Cross-Functional War Room, User Persona Focus Group) / Complexity/hidden coupling (Tree of Thoughts, Architecture Decision Records, Failure Mode Analysis) / Over-engineered (Occam's Razor, Reverse Engineering, First Principles)

- [ ] Step 2: **Select** — From the YAML, choose 1 primary method and 2–3 follow-up methods that address the most likely weaknesses:
  - Primary: strongest single fit for the identified weakness
  - Include at least one core or risk category method across the full set
  - Include at least one follow-up that addresses the identified weakness type from a different angle
  - Spread across at least 2 different categories — do not pick every method from the same category

- [ ] Step 3: **Execute primary** — Load `./resources/step-02-execute.md` with the primary method selected.

- [ ] Step 4: **Present follow-up menu** — After the primary method is applied, present the follow-up choice. Use the native structured question tool when available; otherwise use this text format:

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

## Next Step

Load `resources/step-02-execute.md` to handle the follow-up response and iteration loop. If the user selects `[r]`, return to this resource for a fresh context analysis and method selection.
