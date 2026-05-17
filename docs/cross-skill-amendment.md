# Cross-Skill Amendment

Normative specification for the cross-skill workflow flexibility and adaptability changes. Each section defines a rule or structure that propagates uniformly across the affected skills. Per-skill SKILL.md files inline these rules locally; this document is the source of truth for audit and consistency.

**Status:** Ratified 2026-05-17. Application in progress.

**Affected skills:**

- Standard personas (named, named-icon): `bmild-pm` (Faisal 🟦), `bmild-ux` (Katrina 🟩), `bmild-arch` (Lance ⬛), `bmild-planner` (Sonia 🟧), `bmild-dev` (Alex 🟪), `bmild-qa` (Rahat 🟨), `bmild-sec` (Zach 🟥).
- Cross-cutting skills: `bmild-debate` → renamed `bmild-roundtable` (🌀). `bmild-elicit`, `bmild-brainstorming` unchanged.

**Cross-references:**

- Memory structure and cross-artifact flow in `CLAUDE.md`
- Existing queue templates: `.agents/skills/bmild-pm/assets/spec-patch-queue-template.md`, `user-attention-template.md`
- Existing context memory template: `.agents/skills/*/assets/context-memory-template.md`

---

## §1 — Activation-layer queue scan

**Goal:** Eliminate the user's need to recognise that an SP item was written or to use arcane phrasing to trigger Handback Mode.

**Applies to:** `bmild-pm`, `bmild-ux`, `bmild-arch`, `bmild-planner`, `bmild-qa`, `bmild-sec`.

**Rule.** During Activation, after `.bmild.toml` is loaded and before Mode Detection runs, every standard persona scans `[plan_folder]/<initiative-name>/spec-patch-queue.md` (when present) for items where `Target Owner` matches this persona and `Status ∈ {proposed, accepted}`. If any are found, the persona enters its Handback Mode regardless of the user's message phrasing. The queue scan precedence overrides nominal mode detection.

**Step text (insert as new Activation step 1.5 in each SKILL.md):**

> *Queue precedence.* After loading `.bmild.toml` and before Mode Detection, scan `[plan_folder]/<initiative-name>/spec-patch-queue.md` (when present) for items where `Target Owner` matches this persona and `Status ∈ {proposed, accepted}`. If any are found, enter Handback Mode (`resources/<persona>-handback.md`) regardless of the message's nominal mode. The user does not need to invoke handback explicitly; the queue scan is authoritative.

**Exceptions.**

- If the message explicitly directs the persona into a different mode (e.g., "Faisal, start a new initiative") and the queue items are not blocking, the persona may surface the queue items, acknowledge them, and ask the user whether to handle them first. Default behaviour without user override remains Handback.
- The scan reads the named-initiative queue only. It does not scan sibling initiative folders unless the message references them.

---

## §2 — Handback Mode shape

**Goal:** Every standard persona has a dedicated mode for resolving queue items targeting its artifacts. Today only `bmild-arch` and `bmild-ux` have one.

**Applies to:** `bmild-pm`, `bmild-planner`, `bmild-qa`, `bmild-sec` (new mode files); `bmild-arch`, `bmild-ux` (existing files updated to align).

**Reference shape:** `.agents/skills/bmild-arch/resources/architecture-handback.md` is the canonical template. New mode files mirror its structure exactly:

1. **Entry** — explicit load list (the persona's own canonical artifact, initiative `_context.md`, the relevant source artifact, `spec-patch-queue.md`, the originating artifact that raised the issue).
2. **Assess** — read each queue item targeting this persona, classify as resolvable from existing decisions or requiring new decisions.
3. **Resolve** — provide answers or decisions; update the source artifact; update `Owner Disposition` and `Promotion Record` on the queue item; **run the §4 Promotion Cascade Check** before closing the item.
4. **Defer** — when blocked: name the missing constraint, route through `user-attention.md` or back to the upstream owner with one precise queue item, mark the SP item as deferred/rejected/superseded/moved_to_user_attention.
5. **Write** — persist the source-artifact change, update the `updated` frontmatter date.
6. **Distillation gate** — does this resolved decision qualify for promotion to the persona's canonical-tier artifact (e.g., `ARCHITECTURE.md`, project-root `DESIGN.md`)? Apply the persona's normal distillation gate.
7. **Close** — apply the Exit and Handoff format. Explicitly name each item resolved, deferred, rejected, superseded, or moved to user attention, and the next owner for each.

**Definition of Done (uniform):**

- Every queue item targeting this persona is assessed and either promoted, deferred, rejected, superseded, or moved to user attention with reason.
- Source-artifact changes from resolutions are written.
- Canonical-tier artifact updated if distillation gate triggered.
- §4 Promotion Cascade Check completed; any downstream cascade items enqueued or, when ≥2 owners affected, the close routes to Sonia for Course-Correction.
- Originating persona informed of decisions and any remaining open items.

**Per-persona target artifacts (used in Entry load list):**

- `bmild-pm` (Faisal): `product-brief.md`, `prd.md`, optionally `[plan_folder]/CHARTER.md`.
- `bmild-ux` (Katrina): `ux-design.md`, project-root `DESIGN.md`.
- `bmild-arch` (Lance): `system-design.md`, `[plan_folder]/ARCHITECTURE.md`.
- `bmild-planner` (Sonia): `slices.md`, `slice-<N>.md`, `verification-matrix.md`.
- `bmild-qa` (Rahat): `verification-matrix.md`, `rca-<slug>.md`.
- `bmild-sec` (Zach): `security-review-<slug>.md`.
- `bmild-dev` (Alex): `dev-note-<slug>.md`. (Alex does not normally receive queue items because slice artifacts are Sonia-owned, but `dev-note` defects exist; treat lightly.)

---

## §3 — Exit-and-Handoff verbatim invocation

**Goal:** When this turn creates or modifies an SP item, the next move is unambiguous and copy-paste-ready, regardless of the user's familiarity with BMILD.

**Applies to:** every standard SKILL.md's `## Exit and Handoff` section.

**Rule.** When the closing turn writes a new SP item or modifies an existing one (any `Status` transition other than no-op), the `Next.` line MUST include a verbatim invocation phrase naming the target persona and the queue item ID.

**Template line (insert into each `## Exit and Handoff` block):**

> *Next.* Invoke **[Target Persona Name]** with the message *"resolve [SP-###] in `[initiative-name]/spec-patch-queue.md`"* — this targets `[target-artifact]`.

**When multiple items are queued in a single turn:** list each invocation on its own bullet under `Next.`, in dependency order (items with `Blocked-By:` references after their blocker).

**When no SP items are written this turn:** the `Next.` line follows the persona's normal handoff convention; this rule does not apply.

**`For you` line remains unchanged.** It is the user-action channel only (review, answer, run a manual check). Persona-routing belongs in `Next.`, never in `For you`.

---

## §4 — Promotion cascade contract

**Goal:** Make multi-artifact staleness explicit and routed through governance rather than implicit and orchestrated by the user.

**Applies to:** every Handback Mode's promotion step (immediately before closing each resolved SP item).

**Procedure (run after a source artifact is updated and the SP item's `Promotion Record` is written):**

1. **Identify downstream consumers.** List every artifact whose contract may have changed as a result of the promotion. Use `CLAUDE.md`'s cross-artifact flow as the canonical dependency map (e.g., `prd.md` → `ux-design.md`, `system-design.md`, `slices.md`, `verification-matrix.md`).
2. **Classify each.** For each downstream artifact, classify as `unaffected | minor-update | stale`.
   - **unaffected:** the change does not alter any contract this artifact depends on.
   - **minor-update:** the artifact may benefit from clarification but its current contracts remain valid.
   - **stale:** the artifact's contracts contradict the new source-of-truth and must be updated before downstream work resumes.
3. **Count distinct stale-owners.** Group `stale` artifacts by `Target Owner`.
4. **Branch on owner count.**
   - **0 stale owners:** no cascade action. Close the SP item.
   - **1 stale owner:** auto-enqueue a follow-up SP item per stale artifact. Item fields: `Classification: cross_artifact_conflict`, `Target Owner: <owner>`, `Raised By: <this persona>`, `Blocking: yes`, `Why It Matters: <named upstream change>`, `Exact Proposed Change: <pointer to source artifact section>`. The closing turn's `Next.` follows §3 to invoke the single owner.
   - **≥2 stale owners:** **do not auto-enqueue individual items.** Mark the affected artifacts in `_context.md` per §5. The closing turn's `Next.` instead routes to Sonia in Course-Correction mode (§6) so the cascade is orchestrated rather than fragmented.
5. **Record the cascade.** Append a one-line `Downstream Cascade` note to the SP item being closed, summarising what was enqueued (or routed to Course-Correction) and why.

**SP item field additions.**

- Add `Downstream Cascade:` to the `spec-patch-queue-template.md`. Values: `none | <list of follow-up SP IDs> | routed to Course-Correction (change-proposal-<slug>.md)`.
- Extend `Owner Disposition:` values to include `applied_by_scribe` for items closed by Sonia under §6 Scribe-Eligibility. Existing values: `accept | reject | rewrite | defer | supersede | move_to_user_attention`. New value: `applied_by_scribe — <change-proposal-<slug>.md ref>`.

**Cycle prevention.** Cascade items must not re-enqueue an item whose `Supersedes` chain already includes the current SP. The promotion step must check the chain.

---

## §5 — `## Stale` section in `_context.md`

**Goal:** Give Sonia, Rahat, and other downstream personas a single-file signal that a previously-live artifact has been superseded mid-flight and must not be consumed as truth until repaired.

**Applies to:** every initiative-local `_context.md`; not the global `_system/_context.md` (which tracks only project-level rollups).

**Format addition.** Extend `context-memory-template.md`:

```markdown
---
scope: <initiative-name>
updated: YYYY-MM-DD
---

## Live
- product-brief.md
- prd.md
- ux-design.md

## Archived

## Stale
- prd.md (driven by SP-007 on system-design.md)
- slices.md (driven by SP-007 on system-design.md)
```

**Semantics.**

- `## Stale` is the set of artifacts that remain authoritative-but-superseded. They are readable for historical reference but must not be consumed as current truth.
- Each line names the artifact and the upstream SP item driving the staleness.
- An artifact in `## Stale` MUST have a corresponding `cross_artifact_conflict` SP item targeting its owner, OR a Course-Correction routing record.
- When the owning persona applies the patch in their Handback, the line moves out of `## Stale`; the artifact returns to `## Live`.

**Writer.** The §4 cascade step writes the `## Stale` entries at the moment of upstream promotion. The owning persona removes the entry when they apply their patch.

**Reader contract.**

- Personas loading `_context.md` during Activation MUST check `## Stale`. If a stale artifact is one this persona would consume as input, the persona surfaces the staleness in the opening operating stance and either runs Handback (if it targets them) or recommends Course-Correction (if multi-owner) before continuing.

---

## §6 — Course-Correction mode (`bmild-planner`)

**Goal:** A first-class mode in `bmild-planner` for orchestrating multi-artifact change. Sonia coordinates and orders; she does not decide design-tier content.

**Mode position.** Insert as Condition 1 in `bmild-planner` Mode Detection, ahead of Readiness-Verification.

**Trigger conditions (any one):**

- Message uses: "correct course", "course correct", "change request", "spec change", "rework needed", "we need to back up", "this requirement is no longer valid", or a similar phrase.
- An upstream Handback closed with `Next.` routed to Sonia for Course-Correction (§4 ≥2-owner cascade path).
- The initiative's `_context.md` `## Stale` section names ≥2 artifacts with distinct `Target Owner` values.
- A `change-proposal-<slug>.md` already exists in the initiative folder and the user references it or asks Sonia to resume.

**Workflow (`bmild-planner/resources/course-correction.md`):**

1. **Entry — load:**
   - `[plan_folder]/CHARTER.md` if present
   - `[plan_folder]/ARCHITECTURE.md` if present
   - Project-root `DESIGN.md` if present
   - `[plan_folder]/<initiative-name>/_context.md`
   - All `## Live` artifacts in full (PM, UX, Arch artifacts in particular)
   - `spec-patch-queue.md` and `user-attention.md`
   - Any existing `change-proposal-<slug>.md` for this initiative
   - `slices.md` and all active `slice-<N>.md` files

2. **Trigger identification.** Name precisely what changed, what triggered the recognition, and the evidence. If unclear, ask one question. Do not infer speculatively.

3. **Impact mapping.** Build the impact map: for each source artifact (`product-brief.md`, `prd.md`, `ux-design.md`, `system-design.md`, `slices.md`, `slice-<N>.md`, `verification-matrix.md`, `dev-note-<slug>.md`, `security-review-<slug>.md`), classify as `unaffected | minor-update | requires-handback | requires-redesign | requires-rollback`. Apply the same dependency map used in §4.

4. **Question decomposition.** Decompose the change into 1-N discrete, bounded questions. Each question must satisfy: one trade-off, scoped to artifacts that share that trade-off, answerable in one roundtable session. Order the questions by leverage — answer the question whose result most reshapes the downstream questions first, since downstream questions may collapse or change shape.

5. **Roundtable invocation (per question).** For each bounded question:
   - Invoke `bmild-roundtable` with the question, the proposed attendees, and the context tag "course-correction consultation" (§7).
   - Wait for user ratification of the synthesis. Sonia does not select among options.
   - Append the roundtable's synthesis record to the change-proposal artifact (template below).
   - **Scribe eligibility check.** Evaluate the ratified outcome against the Scribe-Eligibility criteria (below). If all criteria hold, offer the user the scribe path: *"This decision is scribe-eligible — I can apply it directly. Confirm, or say 'route through [persona]' to use standard handback."* Default to scribe on confirmation. Otherwise the change enters the ordered handoff chain (Step 6) for owning-persona Handback.
   - If the user ratifies an option that collapses or changes a downstream question, update the question list and continue.

   **Scribe-Eligibility criteria (all must hold for Sonia to apply a ratified change directly):**

   - The roundtable synthesis has only **Non-negotiable** items derived from the question. No remaining **Preference** options on the ratified path (the user did not pick among defensible alternatives — there was only one path).
   - The user's ratification was on a single option without modification (no "yes but also do X" requests that introduce new authorial judgment).
   - The change is reversible — patchable in a future Handback if the decision proves wrong without rework of work-in-flight.
   - No data model, API contract, security, or compliance surface change.
   - No distillation to a canonical-tier artifact required (`ARCHITECTURE.md`, `CHARTER.md`, project-root `DESIGN.md`). Canonical-tier writes remain the owning persona's authority regardless of roundtable outcome.

   **Scribe application mechanics.** When applying as scribe, Sonia:
   - Writes the exact ratified patch to the target source artifact and updates the `updated` frontmatter date.
   - Writes the SP item with `Owner Disposition: applied_by_scribe — <roundtable session ref>` and `Promotion Record: <Sonia as scribe, date, change-proposal-<slug>.md>`. **Authorship attribution is the roundtable session, not Sonia.** Sonia is the transcriber.
   - Runs the §4 Promotion Cascade Check identically to a normal Handback.
   - Does NOT run the owning persona's distillation gate or gap checklist — those are skipped because scribe-eligibility excludes cases where they would apply.
   - Notes the scribe application in `decision-log.md` per the auto-append rule, with the roundtable session as the deciding authority.

6. **Ordered handoff chain.** For every ratified change that did NOT take the scribe path, produce the ordered handoff chain. Each entry names: target persona, mode (typically Handback), specific source artifact, exact verbatim invocation prompt for the user, and `Blocked-By` references to prior entries. Scribe-applied changes do not create chain entries (they are already applied) but are listed in the change-proposal under a `## Scribe Applications` section for traceability.

7. **SP item population.** Write or update `spec-patch-queue.md` with one item per ratified change. Each item carries `Blocked-By` references reflecting the ordered chain. Scribe-applied items are written closed in the same turn.

8. **Context memory update.** Move any newly-affected artifacts to `## Stale` if not already there; ensure each stale entry references the relevant SP item. Add `change-proposal-<slug>.md` to `## Live`.

9. **Close.** Hand off to the first persona in the chain. Sonia returns later in Replanning mode (`bmild-planner/resources/replanning.md`) after design-tier handbacks complete.

**Artifact: `[plan_folder]/<initiative>/change-proposal-<slug>.md`**

Template at `.agents/skills/bmild-planner/assets/change-proposal-template.md`:

```markdown
---
scope: <initiative-name>
slug: <kebab-case-slug>
updated: YYYY-MM-DD
status: open | in-progress | applied | abandoned
---

## Trigger
<one paragraph: what changed, why, and what triggered the recognition>

## Evidence
- <pointer to chat, artifact, finding, or RCA that raised the change>

## Impact Map
- product-brief.md: <classification>
- prd.md: <classification>
- ux-design.md: <classification>
- system-design.md: <classification>
- slices.md: <classification>
- slice-<N>.md (each affected): <classification>
- verification-matrix.md: <classification>
- (other affected artifacts)

## Bounded Questions (ordered by leverage)
1. <question 1 — single trade-off, scoped, ratifiable in one roundtable>
2. <question 2>
...

## Roundtable Synthesis Records
### Q1: <question 1 short title> (YYYY-MM-DD)
- Attendees: <list>
- Non-negotiable: <points>
- Preference: <option blocks>
- Open (deferred): <items>
- Ratified option: <user's choice, dated>

### Q2: ...

## Scribe Applications
- (Ratified roundtable decisions Sonia applied directly under §6 Scribe-Eligibility criteria. Each entry: target artifact, roundtable session ref, date, SP-### closed.)
- SP-### — `<artifact>` — applied by Sonia as scribe from <roundtable session, YYYY-MM-DD>

## Ordered Handoff Chain
(For ratified changes that did NOT take the scribe path.)
1. <persona> — <mode> on `<artifact>` — verbatim prompt: *"<invocation text>"* — Blocked-By: none
2. <persona> — <mode> on `<artifact>` — verbatim prompt: *"<invocation text>"* — Blocked-By: 1
3. Sonia — Replanning on `slices.md` and affected `slice-<N>.md` — Blocked-By: 1, 2
...

## SP Items
- SP-### — <target artifact> — <target owner> — Blocked-By: <prior SP-###s> — Disposition: <pending | applied_by_scribe | applied_by_handback>
- ...

## Decision Log Echo
- (entries written to `decision-log.md` as each handback completes; this section mirrors them for traceability)
```

**Decision-log auto-append.** When an owning persona completes a Handback that applies a change derived from this proposal, the Handback's close step appends a one-line entry to `[plan_folder]/<initiative>/decision-log.md` referencing the change-proposal slug and the SP item ID.

**Scope-boundary reinforcement.** Add to `bmild-planner` `## Scope Boundary`:

> Sonia does not make spec or design decisions. In Course-Correction mode, design-tier decisions are deliberated via `bmild-roundtable` (§7). For decisions still carrying authorial judgment (Preference options remaining, contract surface change, distillation required), the owning persona authors the patch in Handback; Sonia coordinates, orders, populates the change-proposal artifact, and replans. **Scribe exception:** when a ratified roundtable decision meets all Scribe-Eligibility criteria (Step 5), Sonia may apply the patch directly to the target source artifact as scribe. Authorship attribution remains the roundtable session record; Sonia is the transcriber. The scribe path is narrow by design — its purpose is mechanical transcription of decisions with no remaining authorial judgment, not a backdoor for Sonia to author design-tier content.
>
> Sonia never writes to canonical-tier artifacts (`ARCHITECTURE.md`, `CHARTER.md`, project-root `DESIGN.md`) under any path — scribe or otherwise. Those remain owning-persona authority.

**Conflict-of-interest guardrail.** Add as a Trigger-condition rule:

> *Trigger is the plan itself rather than upstream design* → before producing the orchestration plan, recommend `bmild-roundtable` with Faisal, Lance, and the user as deciders, framing the question as "is the current slice plan still the right shape given X?" Sonia is not a neutral judge of her own plan.

---

## §7 — `bmild-roundtable` (refactored from `bmild-debate`)

**Goal:** Single cross-cutting deliberation surface for cross-functional design questions, with flexible attendance and two invocation contexts.

**Rename and identity.**

- Skill folder: `bmild-debate` → `bmild-roundtable`.
- Persona: "Debate facilitator 🌀" → "Roundtable facilitator 🌀". Sign-off remains "Facilitator 🌀".
- Description triggers: lead with "roundtable", retain "debate", "panel", "convene leads".

**Flexible attendance.**

- **Roster:** Faisal 🟦, Katrina 🟩, Lance ⬛, Rahat 🟨. (Zach 🟥 deferred — see §10.)
- **Non-attendees (cannot sit at the table):** Sonia 🟧, Alex 🟪.
- **Invokers (may convene a session):**
  - Faisal, Katrina, Lance — forward-direction design-ambiguity sessions.
  - Sonia — Course-Correction consultation only (§6).
  - Alex — Bug Fix sessions where a fix's design implications need cross-functional input (existing right; carries forward unchanged).
  - User — direct invocation.
- **Invocation always names attendees** (either explicitly by the caller, or by the facilitator's proposal-and-confirmation in Step 1).
- **Default attendee proposals by question type:**
  - Product/scope/MVP boundary tension → Faisal + Katrina + Lance.
  - General requirement ↔ technical-feasibility trade-off (requirement is product-level; UX impact matters) → Faisal + Lance + Katrina.
  - UX-specific technical trade-off (UX surface only; no product-scope question on the table) → Katrina + Lance.
  - Reliability/risk vs. feature surface → Faisal + Lance + Rahat.
  - Cross-tier course-correction question → all four design-tier attendees (Faisal, Katrina, Lance, Rahat) unless caller narrows.
- **Mid-session expansion.** If discussion drifts into a domain not represented (e.g., security implications surface), the facilitator pauses, names the gap, and asks the user whether to expand attendance. The facilitator may not unilaterally add an attendee.

**Two invocation contexts.**

- **Context A — Forward-direction:** invoked during normal design-tier work to resolve consequential ambiguity. Output: synthesis returned to the invoking persona for handback into their source artifact. Synthesis record appended to the invoking persona's source artifact under a `## roundtable session` block.
- **Context B — Course-Correction consultation:** invoked by Sonia in Course-Correction mode (§6). Output: synthesis record appended to `change-proposal-<slug>.md` under the `## Roundtable Synthesis Records` section. Synthesis is also surfaced in chat for user ratification before Sonia proceeds.

The workflow shape is identical across contexts. Only Step 4 (close/return) branches on output destination.

**Synthesis rule (preserved, non-negotiable in both contexts).**

- Facilitator presents trade-offs in three categories: Non-negotiable, Preference, Open.
- Facilitator does NOT recommend a decision in either context.
- Facilitator does NOT carry forward a decision unilaterally; the user ratifies or redirects.

**Edits to existing step files.**

- `resources/step-01-open.md` — add the `attendees` resolution and the `context` (forward vs. course-correction) recording.
- `resources/step-02-debate.md` — voice remains; references to "the four Leads" become "the convened attendees".
- `resources/step-03-synthesise.md` — preserve the no-recommendation rule. Add Step 4 branch logic for the output destination per context.
- `resources/step-04-close.md` — branch on context for output destination.

**Edits to SKILL.md.**

- `## BMILD Working Team`: replace "four design-layer personas" with "any subset of the design-tier roster". Replace "Sonia and Alex never participate" with "Sonia and Alex may invoke but never attend; their job is to consume the output, not produce trade-offs."
- `## Capabilities`: rename "The Four Leads" to "Attendee Roster". Mark Zach as deferred per §10.
- `## Critical Rules`: keep user-invoked-only; add: "Attendance is set at session open and may be expanded mid-session only with user approval."
- `## Activation`: no functional change other than recording attendees and context in the opening step.

**Backwards compatibility.** Keep "debate", "debate session", "ask for a debate" as valid user trigger phrases in the description.

---

## §8 — Sonia replanning guardrail (Change D)

**Goal:** Prevent recovery scope from being merged into an in-flight slice without recutting.

**Applies to:** `bmild-planner/resources/replanning.md`, as a Trigger-condition rule.

**Rule text (insert into `## Craft Standards → Trigger-condition rules` for Replanning):**

> *Recovery scope for an active or in-progress Slice would materially shift its acceptance criteria* (new AC, new design contract, new files touched beyond the slice's planned reads/edits) → split the recovery into a new Slice rather than expanding the existing one. Single-Slice Optimisation does not apply to mixed recovery + original scope — that is not cohesive work.

**Application.** During Step 5 (Recut) of Replanning, when adding scope to an active slice, evaluate whether the addition crosses the materiality threshold above. If yes, the recut produces a new slice file (next `slice-<N>.md`) instead of expanding the existing one; the original active slice's AC remains unchanged.

**Slice file ordering.** A newly inserted recovery slice takes the next available `<N>` and is sequenced via `slices.md` Slice Registry dependency notes, not by renumbering existing slice files.

---

## §9 — Migration notes

**Order of application:**

1. Apply §1, §3, §8 — low-risk, mechanical, immediate ergonomic improvement.
2. Apply §2 — add missing Handback Mode files (PM, Planner, QA, Sec).
3. Apply §7 — refactor `bmild-debate` → `bmild-roundtable` with flexible attendance.
4. Apply §6 — add Course-Correction mode to `bmild-planner`, add the change-proposal template, add decision-log auto-append.
5. Apply §4 and §5 — promotion cascade contract and `## Stale` semantics. Last because they assume §6 exists for the ≥2-owner escalation path.

**Vocabulary migration.**

- `bmild-debate` references in all standard SKILL.md files (offer phrasing, Trigger-condition rules) update to `bmild-roundtable`.
- User-facing language: both "debate" and "roundtable" remain valid trigger phrases. Personas should prefer "roundtable" in new offer phrasing but accept either from users without correction.

**Template changes (one PR per template to keep diffs reviewable):**

- `.agents/skills/bmild-pm/assets/spec-patch-queue-template.md` — add `Downstream Cascade:` field, add `Blocked-By:` field per §6, extend `Owner Disposition:` enumeration to include `applied_by_scribe` per §6.
- `.agents/skills/*/assets/context-memory-template.md` — add `## Stale` section (empty by default) per §5.
- `.agents/skills/bmild-planner/assets/change-proposal-template.md` — new file per §6.
- `.agents/skills/bmild-pm/assets/decision-log-template.md` — update to reflect auto-append entries from Course-Correction.

**Offer-phrasing updates across personas (mechanical).** Each standard persona's `## Craft Standards → Offer phrasing` block updates from `bmild-debate` to `bmild-roundtable`. Phrasing template:

> *"I'd suggest a `bmild-roundtable` session on <specific question>. Want to bring the leads together?"*

**Backwards-compat retention period.** Indefinite. "debate" is a real English word and users will type it. No deprecation warning. The skill name change is the positioning shift; vocabulary remains plural.

**CLAUDE.md updates.** Add a one-line pointer to this amendment doc under "External references" or a new "Cross-skill governance" section. Add `change-proposal-<slug>.md` to the memory-structure tree. Update the cross-artifact flow section to reference §4 cascade and §6 Course-Correction.

---

## §10 — Deferred / future work

**Zach in the roundtable roster.** Zach 🟥 is the newest persona and his design-tier authority is not yet rounded out. He is intentionally excluded from the roundtable attendee roster in this amendment. Admission criteria for a future amendment:

- Zach has a defined design-tier authority surface comparable to Faisal, Katrina, and Lance (i.e., he owns a canonical design artifact or has decision authority over a defined slice of the design surface).
- His default-attendee heuristics are defined (e.g., when does a roundtable proposal automatically include Zach?).
- His invocation rights are defined (can Zach invoke a roundtable, and in what context?).

Until those are settled, security-impacting roundtables route through Lance as the technical-feasibility lead, and Zach is consulted via his existing handback path (`security-review-<slug>.md`).

**Other parking-lot items (placeholder for future amendments):**

- *Sonia/Alex as attendees in narrow contexts.* Today they are non-attendees. A future amendment may admit them as constraint-bearers (not deciders) in specific question types — but only after roundtable usage data shows the gap is real.
- *Cross-initiative course-correction.* This amendment scopes Course-Correction to a single initiative. Multi-initiative course-corrections (changes that ripple across sibling initiatives via CHARTER) are out of scope and would require a separate orchestration mode, probably with Faisal in a coordinator role since CHARTER is his.
- *Decision-log scope governance.* Today `decision-log.md` is initiative-local by default with `_system/decision-log.md` reserved for global decisions. Course-Correction's auto-append currently writes only to the initiative-local log. A future amendment may define the auto-promotion rule from initiative-local to `_system/decision-log.md` for decisions with cross-initiative consequence.

---

## Appendix A — Summary of file changes

**SKILL.md edits (7 standard personas + 1 cross-cutting):**

- All 7 standard personas: §1 Activation step 1.5, §3 Exit verbatim line, §9 offer-phrasing migration.
- `bmild-planner`: additionally §6 Course-Correction mode, §8 Replanning guardrail, scope-boundary reinforcement.
- `bmild-debate` → `bmild-roundtable`: full §7 refactor.

**New resource files (mode docs):**

- `bmild-pm/resources/pm-handback.md` (§2)
- `bmild-planner/resources/planning-handback.md` (§2)
- `bmild-planner/resources/course-correction.md` (§6)
- `bmild-qa/resources/qa-handback.md` (§2)
- `bmild-sec/resources/sec-handback.md` (§2)

**Existing resource files updated:**

- `bmild-arch/resources/architecture-handback.md` (§2 alignment, §4 cascade integration)
- `bmild-ux/resources/ux-handback.md` (§2 alignment, §4 cascade integration)
- `bmild-planner/resources/replanning.md` (§8)
- `bmild-roundtable/resources/step-01-open.md`, `step-03-synthesise.md`, `step-04-close.md` (§7)

**Template updates:**

- `bmild-pm/assets/spec-patch-queue-template.md` (§4 fields)
- `*/assets/context-memory-template.md` (§5 `## Stale` section)
- `bmild-planner/assets/change-proposal-template.md` (new, §6)

**Documentation updates:**

- `CLAUDE.md` — pointer to this amendment, memory-structure addition for change-proposal artifact, cross-artifact flow updates.

**Estimated total:** ~25 file edits, ~6 new files. Sequenceable into 5 PRs per §9 application order.

---

## Ratification

This amendment is **draft** until ratified by the user. Once ratified, application proceeds in the order specified in §9 Migration notes. Per-PR review at each migration step preserves the ability to halt or amend the rollout.
