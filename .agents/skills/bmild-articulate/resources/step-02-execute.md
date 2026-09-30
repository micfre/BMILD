# Step 2: Execute — Method Application and Conversation

## Purpose

Apply the selected method to the current working content, decide whether to apply the result or ask, then read the user's plain-language reply and continue until they are done. This step is the active session. Do not close until the user signals they are finished.

## Inputs

- Selected primary method (carried from `step-01-select.md`).
- 2–3 follow-up methods (carried from `step-01-select.md`).
- Current working version of the content (use this version, not the original if already enhanced).
- The method catalog serving script (`scripts/methods.sh` on POSIX hosts, `scripts/methods.ps1` on Windows-native hosts), used for fresh-angle draws and for listing every method on request. The catalog is never loaded whole except through an explicit `list --all`.

## Global Directives

- **Apply with judgment.** After each method, assess whether output is a clear improvement consistent with the user's direction. Apply and report when yes. When it produces competing alternatives or ambiguous direction, describe the tension and ask which way to go. The user can say "undo" to revert.
- **Natural-language turns.** No lettered or numbered menus. Suggest next angles in a sentence and interpret the reply by intent; the user should never need to learn option codes.
- **Continue until the user is done.** Closing after one method loses the value the user came for. If a reply might mean "done" or might be a comment, ask once.
- **Provocative alternatives** require user choice before application — do not auto-apply.
- **Artifact writes.** Pause for user confirmation before writing any artifact not owned by the active caller.
- **Roundtable suggestion.** Structured multi-persona deliberation needed → suggest `bmild-roundtable`; do not convene autonomously.

## Procedure

Apply the selected method to the current version of the content — not the original if it has already been enhanced. Show the work: present what the method revealed, not just the changed output. Apply clear improvements consistent with the user's stated direction and report what was applied. Halt and ask only when the method produces competing alternatives or genuinely ambiguous direction.

**Applying a method:**

- [ ] Name the method at the top of your response: *"Applying: [Method Name]"*
- [ ] Show the method output applied to the current content. Format depends on the method's pattern:
  - Analysis methods (First Principles Analysis, 5 Whys Deep Dive, etc.): show the analysis first, then implications for the content
  - Persona methods (Stakeholder Round Table, Expert Panel Review, Cross-Functional War Room, Security Audit Personas, and any method marked persona-cast — `cast` lists them all): load each active persona's whole `<persona-skill-dir>/SOUL.md`, resolved relative to that persona's own skill directory, before speaking. The loaded SOUL is the sole voice source; do not add facilitator-authored impressions. If a debate session is active, use Faisal, Katrina, Lance, and Rahat. Label a speaker only when the speaker changes — do not repeat icon and name on every paragraph from the same speaker.
  - Generative methods (SCAMPER Method, What If Scenarios, etc.): produce the generated content or alternatives first, then identify what's worth keeping
  - Competitive methods (Red Team vs Blue Team, Shark Tank Pitch, etc.): run the adversarial scenario fully before proposing improvements
- [ ] Summarise what changed or was revealed in 2–3 bullets: what assumption was surfaced, what gap was found, what improvement is proposed
- [ ] Apply or ask based on clarity:
  - Clear improvement consistent with the user's direction → apply immediately: *"Applied. Working content updated — [one-line summary of what changed]. Say 'undo' to revert."*
  - Competing alternatives or genuinely ambiguous direction → describe the tension in a sentence, ask which way to go, and wait for the reply.
- [ ] Close the turn with a short plain-language suggestion of the remaining follow-ups (as in step-01 Step 4). Do not re-render a full list.

**Reading the reply** — interpret by intent, not by keyword:

1. **Chooses a method** (by name, number, or description, e.g. "try the pre-mortem") → apply it as above.
2. **Asks for other angles** ("anything else?", "show me different options") → draw a fresh candidate pool with `random -n 12 --spread --exclude <method names already offered this session>...` (a request above 12 is rejected by design; the pool excludes prior offers, draws distinct categories until diversity is exhausted, and clamps to the remaining eligible pool). Rank the candidates against the current weakness — strongest fit, at least one core or risk method, at least one different-angle follow-up, at least two categories — then `show` only the two or three you will suggest, and return to `./resources/step-01-select.md` for a fresh context analysis on the new pool. If the script returns `# insufficient_diversity`, say so plainly and let the user pick from earlier suggestions, reset exclusions, see every method, or finish. If serving fails outright, stop selecting and offer a full-catalog fallback only with the user's explicit approval.
3. **Asks to see every method** → run `list --all` (the only catalog interaction that returns every method). Group the rows by `category` under `### [Category]` headings as `[num]. [method_name] — [gist]`, then invite the user to name any of them or return to the current suggestions.
4. **Gives direct feedback** → apply it to the working content, confirm what changed, and suggest next angles.
5. **Names several methods at once** → treat it as a choice, not permission to run a batch. Ask which one to run first.
6. **Signals they are done** ("that's enough", "let's move on", "good, proceed") → close as below.

**Closing:**

- State methods applied, key improvements, changes discarded if any.
- Present the final working version of the content.
- Save only when the user invoked with explicit write authority or the caller owns the target; update `registry.md` if the document changed meaningfully. Otherwise produce a handoff note for the owning persona (target owner, artifact/section, patch-ready changes, open decisions).
- **Ratification→Promotion gate.** When the session ends with a user-ratified durable-contract change, load `references/promotion-protocol.md`. Inventory, ask once, apply only explicitly authorized mechanical lines, return independent owner episodes through the standard ladder, and offer Course-Correction once for coupled fallout. Without facilitator-write authorization, return the inventory to the user. Name the close state when the gate fires: `ratified_and_promoted` | `ratified_and_routed` | `ratified_pending_authorization` | `ratified_with_documentation_deferred`.
- Sign off: *"Facilitator ⚡ closing. [If gate fired: Close state: [state].] For you, [user_name]: [only a real step-completion action — omit if there is none]. Next: invoke the persona who owns the next artifact when ready, or tell me what's next."* `For you` appears only when a genuine user-facing step-completion action exists; keep `For you` and `Next` separate. Never promise to hand work back to a persona you are not continuing in this turn. Sign off as `— Facilitator ⚡`.

## Definition of Done

- The user has signalled they are done.
- The final working version of the content is presented.
- A handoff note is produced if artifact ownership requires it.
- The session closes with `— Facilitator ⚡` and a `For you`/`Next` routing step.
