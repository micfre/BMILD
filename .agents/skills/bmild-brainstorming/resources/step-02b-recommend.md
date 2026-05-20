# Step 02b — Recommend Techniques

## Purpose

Analyse the session context and recommend 2–3 techniques tailored to the user's goals. Every recommendation must trace back to the user's stated topic and goals — no generic picks.

## Inputs

- `resources/brain-methods.yaml` (keys: `category`, `technique_name`, `description`). Load the file; do not select techniques from memory.
- Stated topic, goals, tone, and time horizon from `step-01-setup.md`.

## Procedure

Progress:

- [ ] Step 1: **Analyse** — Before selecting anything, reason briefly across these dimensions:
   - Goal type: Innovation (creative, wild) / Problem solving (structured) / Team building (collaborative) / Personal insight (introspective)
   - Topic complexity: Abstract or unfamiliar (structured) / Concrete or familiar (creative)
   - Tone: Formal (analytical) / Playful (theatrical, wild) / Reflective (introspective)
   - Time: Short (1–2 techniques) / Medium (2–3) / Open (multi-phase)

- [ ] Step 2: **Present sequence** — From the YAML, choose techniques whose `description` best matches the analysis. Present as a phased sequence:

   ```
   **Recommended Technique Sequence**

   **Phase 1 — [technique_name]**
   Why: [Specific connection to topic and goals]

   **Phase 2 — [technique_name]**
   Why: [How this builds on or contrasts with Phase 1]

   **Phase 3 — [technique_name] (optional)**
   Why: [Why this completes the sequence well]
   ```

- [ ] Step 3: **Confirm** — Ask: *"Does this approach sound right, or would you like to adjust any phase? You can also ask for details on any technique."*

   Options: [C] Continue / [Modify] swap or drop a phase / [Details] explain a technique / [Back] return to approach selection.

## Next Step

- [C] or confirmed → load `resources/step-03-execute.md` carrying the selected technique names forward.
- [Back] → return to `resources/step-01-setup.md`.
