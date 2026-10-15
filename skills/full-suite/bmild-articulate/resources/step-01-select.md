# Step 1: Method Selection

## Purpose

Understand the content being articulated, identify the content type and most likely weakness, then select the single best-fit primary method from the registry and apply it. Smart method choice requires reading what's there before picking. Persona-run articulation (`resources/persona-run.md`) uses the same content-type and weakness map below.

## Inputs

- The method catalog, served by the skill-local serving script — `resources/methods.yaml` is the sole registry and is consumed through it, never loaded whole. Entry points: `sh <skill-dir>/scripts/methods.sh <command>` (POSIX hosts) or `powershell -File <skill-dir>\scripts\methods.ps1 <command>` (Windows-native hosts).
- Content to be articulated — from the current conversation context.

Serving commands: `categories` (names + counts only) · `list --category <c> [--category <d>]` (compact index rows: `num`, `category`, `method_name`, `gist`; at most two categories) · `cast` (compact rows of the persona-cast methods) · `show <name-or-num>...` (complete records; at most four per selection round) · `random -n <1-12> --spread [--exclude <name>]...` (fresh-angles draw) · `list --all` (full catalog, only when the user asks to see every method).

## Global Directives

- **Method registry discipline.** All methods come from the served catalog — never from memory. Do not invent method names; unknown names or numbers are reported by the script, not substituted.
- **Context economy.** Before primary-method selection: category discovery first, then `list` for at most two relevant categories (the script rejects a third category and any scoped index above 24 rows), then `show` for at most the chosen primary plus follow-ups. `list --all` only when the user asks to see every method.
- **Context-sensitive selection.** Read and understand content before selecting methods.
- **Start proactively, then follow the user.** Run one best-fit method immediately, then suggest 2–3 follow-ups in plain language. Do not run additional methods until the user chooses.
- **Build on the current version.** Each method applies to the working version, not the original.
- **Domain boundaries.** If refinement crosses into another persona's authority, name the boundary and suggest that persona — do not decide for them.
- **Debate persona integration.** For collaboration methods during an active debate/roundtable context, use Faisal, Katrina, Lance, and Rahat as personas.

## Procedure

Progress:

- [ ] Step 1: **Identify context** — Before selecting methods:
  - State the document, section, or decision being examined (one sentence). If not stated by the user, infer from conversation context.
  - Run `categories` and identify the content type: Requirements/problem framing (favour core, risk, collaboration) / UX design (creative, collaboration, risk) / Architecture (technical, advanced, risk) / Slice decomposition (core, risk, framing) / RCA/diagnosis (core: 5 Whys Deep Dive, First Principles Analysis; technical; risk)
  - Identify the most likely weakness: Vague requirements (Socratic Questioning, First Principles Analysis, Critique and Refine) / Untested assumptions (Pre-mortem Analysis, Challenge from Critical Perspective, Self-Consistency Validation) / Missing perspectives (Stakeholder Round Table, Cross-Functional War Room, User Persona Focus Group) / Complexity/hidden coupling (Tree of Thoughts, Architecture Decision Records, Failure Mode Analysis) / Over-engineered (Occam's Razor Application, Reverse Engineering, First Principles Analysis)

- [ ] Step 2: **Select** — From the served index for the relevant categories (at most two; narrow further or use a spread draw when the index would exceed the bound), choose 1 primary method and 2–3 follow-up methods that address the most likely weaknesses:
  - Primary: strongest single fit for the identified weakness
  - Include at least one core or risk category method across the full set
  - Include at least one follow-up that addresses the identified weakness type from a different angle
  - Spread across at least 2 different categories — do not pick every method from the same category

- [ ] Step 3: **Apply the primary** — Fetch the primary method's complete record with `show` (alone, or together with the follow-ups within the four-record bound) and load `./resources/step-02-execute.md` with the primary method selected.

- [ ] Step 4: **Suggest follow-ups in plain language** — After the primary method is applied, close the turn with one or two sentences naming what the first pass found and the 2–3 follow-up methods, each with a few words on what it would add. Invite a natural reply. Do not render a lettered or numbered menu.

  *Example:* "The pre-mortem surfaced that onboarding success depends on an admin nobody has named. From here I could run a **Stakeholder Round Table** to hear from that admin, a **Self-Consistency Validation** to check the metrics agree with each other, or a **Reverse Engineering** pass from the launch outcome back to today. Which way, or is this enough?"

## Next Step

Load `resources/step-02-execute.md` to interpret the user's reply and run the conversation until they are done. When the user asks for other angles, return here for a fresh context analysis on a new candidate pool.
