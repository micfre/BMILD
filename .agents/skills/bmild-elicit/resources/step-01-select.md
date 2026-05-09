## Method Selection

Read the content being elicited before selecting methods — smart selection requires understanding what's there. Run the single most salient method first, then present 2–3 follow-up methods as a numbered menu. Do not run more than one method before the user selects a follow-up. If a debate session is active, the debate Leads (Faisal, Katrina, Lance, Rahat) may be named as personas within collaboration methods.

Load `./methods.yaml` (keys: `num, category, method_name, description, output_pattern`) and read the full file before selecting or displaying any methods.

> **Interchangeable with BMAD source:** `_bmad/core/workflows/advanced-elicitation/methods.csv` uses the same format. Drop in a new file to update the method set — no changes to skill logic required.

1. **Identify context** — Before selecting methods:
   - [ ] State the document, section, or decision being examined (one sentence). If not stated by the user, infer from conversation context.
   - [ ] Identify the content type: Requirements/problem framing (favour core, risk, collaboration) / UX design (creative, collaboration, risk) / Architecture (technical, advanced, risk) / Slice decomposition (core, risk, structural) / RCA/diagnosis (core: 5 Whys, First Principles; technical; risk)
   - [ ] Identify the most likely weakness: Vague requirements (Socratic Questioning, First Principles, Critique and Refine) / Untested assumptions (Pre-mortem, Challenge from Critical Perspective, Self-Consistency Validation) / Missing perspectives (Stakeholder Round Table, Cross-Functional War Room, User Persona Focus Group) / Complexity/hidden coupling (Tree of Thoughts, Architecture Decision Records, Failure Mode Analysis) / Over-engineered (Occam's Razor, Reverse Engineering, First Principles)

2. **Select** — From the YAML, choose 1 primary method and 2–3 follow-up methods that address the most likely weaknesses:
   - Primary: strongest single fit for the identified weakness
   - Include at least one core or risk category method across the full set
   - Include at least one follow-up that addresses the identified weakness type from a different angle
   - Spread across at least 2 different categories — do not pick every method from the same category

3. **Execute primary** — Load `./resources/step-02-execute.md` with the primary method selected.

4. **Present follow-up menu** — After the primary method is applied, present the follow-up choice. Use the native structured question tool when available; otherwise use this text format:

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

   Then load `./resources/step-02-execute.md` to handle the response.
