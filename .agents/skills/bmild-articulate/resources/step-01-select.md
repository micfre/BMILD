# Step 1: Method Selection

## Purpose

Understand the content being elicited, identify the content type and most likely weakness, then select the single best-fit primary method from the registry and hand off to execution. This step protects context-sensitive method selection — smart method choice requires reading what's there before picking.

## Inputs

- The method catalog, served by the skill-local serving script — `resources/methods.yaml` is the sole registry and is consumed through it, never loaded whole. Entry points: `sh <skill-dir>/scripts/methods.sh <command>` (POSIX hosts) or `powershell -File <skill-dir>\scripts\methods.ps1 <command>` (Windows-native hosts).
- Content to be elicited — from the current conversation context.
- For a named-persona convener: suspended session state — persona, mode/resource, initiative, artifact section in progress, and pending work.

Serving commands: `categories` (names + counts only) · `list --category <c> [--category <d>]` (compact index rows: `num`, `category`, `method_name`, `gist`; at most two categories) · `cast` (compact rows of the persona-cast methods) · `show <name-or-num>...` (complete records; at most four per selection round) · `random -n <1-12> --spread [--exclude <name>]...` (reshuffle draw) · `list --all` (explicit full-catalog dump only).

## Global Directives

- **Method registry discipline.** All methods come from the served catalog — never from memory. Do not invent method names; unknown names or numbers are reported by the script, not substituted.
- **Context economy.** Before primary-method selection: category discovery first, then `list` for at most two relevant categories (the script rejects a third category and any scoped index above 24 rows), then `show` for at most the chosen primary plus follow-ups. `list --all` only when the user explicitly chooses `[a] List all`.
- **Context-sensitive selection.** Read and understand content before selecting methods.
- **Start proactively, then choose interactively.** Run one best-fit method immediately; then offer 2–3 follow-ups — do not run multiple additional methods without user selection.
- **Build on the current version.** Each method applies to the working version, not the original.
- **Domain boundaries.** If refinement crosses into another persona's authority, name the boundary and suggest that persona — do not decide for them.
- **Debate persona integration.** For collaboration methods during an active debate/roundtable context, use Faisal, Katrina, Lance, and Rahat as personas.
- **Convener continuity.** When a named persona convened this session, record its identity and suspended session state at open; carry it to the close so the persona can resume the exact work point.

## Procedure

Progress:

- [ ] Step 1: **Identify context** — Before selecting methods:
  - Record the convener as `[convener name] [icon]` when a named persona is active, otherwise `user`. For a persona convener, record the suspended session state: persona, mode/resource, initiative, artifact section in progress, and pending work.
  - State the document, section, or decision being examined (one sentence). If not stated by the user, infer from conversation context.
  - Run `categories` and identify the content type: Requirements/problem framing (favour core, risk, collaboration) / UX design (creative, collaboration, risk) / Architecture (technical, advanced, risk) / Slice decomposition (core, risk, structural) / RCA/diagnosis (core: 5 Whys, First Principles; technical; risk)
  - Identify the most likely weakness: Vague requirements (Socratic Questioning, First Principles, Critique and Refine) / Untested assumptions (Pre-mortem, Challenge from Critical Perspective, Self-Consistency Validation) / Missing perspectives (Stakeholder Round Table, Cross-Functional War Room, User Persona Focus Group) / Complexity/hidden coupling (Tree of Thoughts, Architecture Decision Records, Failure Mode Analysis) / Over-engineered (Occam's Razor, Reverse Engineering, First Principles)

- [ ] Step 2: **Select** — From the served index for the relevant categories (at most two; narrow further or use a spread draw when the index would exceed the bound), choose 1 primary method and 2–3 follow-up methods that address the most likely weaknesses:
  - Primary: strongest single fit for the identified weakness
  - Include at least one core or risk category method across the full set
  - Include at least one follow-up that addresses the identified weakness type from a different angle
  - Spread across at least 2 different categories — do not pick every method from the same category

- [ ] Step 3: **Execute primary** — Fetch the primary method's complete record with `show` (alone, or together with the follow-ups within the four-record bound) and load `./resources/step-02-execute.md` with the primary method selected.

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
