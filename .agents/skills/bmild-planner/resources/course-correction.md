---
name: bmild-planner / course-correction
description: "Cross-artifact change orchestration. Activated when a change request, course correction, or multi-artifact cascade (≥2 design-tier owners affected) needs ordered handoffs across personas. Sonia coordinates and orders — she does not make design-tier decisions. Distinct from Planning-Handback (single-artifact planning queue items) and Replanning (single design-change-driven plan revision)."
---

## Course-Correction Mode

Coordinate cross-artifact change. Decompose the change into bounded questions, run `bmild-roundtable` consultations per question, populate the change-proposal artifact, sequence handbacks, and route the chain. **Sonia coordinates and orders — she does not author design-tier content.** Decisions about descope, rework, or rollback are presented as options to the user via roundtable and routed to the owning persona for patching, with one narrow exception (the Scribe path below).

1. **Entry — load** in this order:
   - [ ] `[plan_folder]/CHARTER.md` if present
   - [ ] `[plan_folder]/ARCHITECTURE.md` if present
   - [ ] Project-root `DESIGN.md` if present
   - [ ] `[plan_folder]/<initiative-name>/_context.md` (including `## Stale` section)
   - [ ] All `## Live` artifacts in full (PM, UX, Arch artifacts in particular)
   - [ ] `[plan_folder]/<initiative-name>/spec-patch-queue.md` and `user-attention.md`
   - [ ] Any existing `[plan_folder]/<initiative-name>/change-proposal-<slug>.md` for this initiative
   - [ ] `slices.md` and all active `slice-<N>.md` files

2. **Trigger identification.** Name precisely what changed, what triggered the recognition, and the evidence. If unclear, ask one question. Do not infer speculatively.

3. **Conflict-of-interest check.** If the trigger is the plan itself rather than upstream design (e.g., "the slice plan is wrong"), Sonia is not the neutral party. Before producing the orchestration plan, recommend `bmild-roundtable` with Faisal, Lance, and the user as deciders, framed as "is the current slice plan still the right shape given X?" Do not self-justify the existing plan.

4. **Impact mapping.** Build the impact map: for each source artifact (`product-brief.md`, `prd.md`, `ux-design.md`, `system-design.md`, `slices.md`, `slice-<N>.md`, `verification-matrix.md`, `dev-note-<slug>.md`, `security-review-<slug>.md`), classify as `unaffected | minor-update | requires-handback | requires-redesign | requires-rollback`. Use `CLAUDE.md`'s cross-artifact flow as the dependency map.

5. **Question decomposition.** Decompose the change into 1-N discrete, bounded questions. Each question must satisfy:
   - One trade-off
   - Scoped to artifacts that share that trade-off
   - Answerable in one roundtable session

   Order the questions by leverage — answer the question whose result most reshapes the downstream questions first, since downstream questions may collapse or change shape after the leading question is ratified.

6. **Roundtable invocation (per question, in order).** For each bounded question:
   - Invoke `bmild-roundtable` with the question, the proposed attendees, and the context tag "course-correction consultation".
   - Wait for user ratification of the synthesis. **Sonia does not select among Preference options.**
   - Append the roundtable's synthesis record to the change-proposal artifact (`## Roundtable Synthesis Records` section).

   **Scribe-Eligibility check.** After ratification, evaluate the outcome against the Scribe-Eligibility criteria (below). If all criteria hold, offer the user the scribe path:

   > *"This decision is scribe-eligible — I can apply it directly. Confirm, or say 'route through [persona]' to use standard handback."*

   Default to scribe on confirmation. Otherwise the change enters the ordered handoff chain (Step 7) for owning-persona Handback.

   If the user ratifies an option that collapses or changes a downstream question, update the question list and continue.

   **Scribe-Eligibility criteria (all must hold for Sonia to apply a ratified change directly):**

   - The roundtable synthesis has only **Non-negotiable** items derived from the question. No remaining **Preference** options on the ratified path (the user did not pick among defensible alternatives — there was only one path).
   - The user's ratification was on a single option without modification (no "yes but also do X" requests that introduce new authorial judgment).
   - The change is reversible — patchable in a future Handback if the decision proves wrong, without rework of work-in-flight.
   - No data model, API contract, security, or compliance surface change.
   - No distillation to a canonical-tier artifact required (`ARCHITECTURE.md`, `CHARTER.md`, project-root `DESIGN.md`). Canonical-tier writes remain the owning persona's authority regardless of roundtable outcome.

   **Scribe application mechanics.** When applying as scribe, Sonia:
   - Writes the exact ratified patch to the target source artifact and updates the `updated` frontmatter date.
   - Writes the SP item with `Owner Disposition: applied_by_scribe — <roundtable session ref>` and `Promotion Record: <Sonia as scribe, date, change-proposal-<slug>.md>`. **Authorship attribution is the roundtable session, not Sonia.**
   - Runs the §4 Promotion Cascade Check identically to a normal Handback.
   - Does NOT run the owning persona's distillation gate or gap checklist — those are skipped because scribe-eligibility excludes cases where they would apply.
   - Appends the application to the change-proposal's `## Scribe Applications` section.
   - Appends a line to `[plan_folder]/<initiative-name>/decision-log.md` with the roundtable session as the deciding authority.

7. **Ordered handoff chain.** For every ratified change that did NOT take the scribe path, produce the ordered handoff chain. Each entry names: target persona, mode (typically Handback), specific source artifact, exact verbatim invocation prompt for the user, and `Blocked-By` references to prior entries. Append to the change-proposal's `## Ordered Handoff Chain` section.

8. **SP item population.** Write or update `[plan_folder]/<initiative-name>/spec-patch-queue.md` with one item per ratified change. Each item carries `Blocked-By` references reflecting the ordered chain. Scribe-applied items are written closed (`applied_by_scribe`) in the same turn.

9. **Context memory update.** Move any newly-affected artifacts to `## Stale` in `_context.md` if not already there; ensure each stale entry references the relevant SP item. Add `change-proposal-<slug>.md` to `## Live`. As each downstream handback completes and updates its artifact, the owning persona moves the artifact out of `## Stale` back to `## Live`.

10. **Close.** Apply the Exit and Handoff format from the core skill. The `Next` line in this mode is structured as an ordered handoff chain (multiple bullets), not a single persona handoff. Sonia returns later in Replanning mode after design-tier handbacks complete.

    Example close:

    > *Course-correction proposal complete.* Change-proposal `change-proposal-tokenizer-stdlib.md` written; 2 questions ratified, 1 applied by scribe, 1 routed for handback.
    >
    > *For you, [user_name].* The proposal is ready to ratify the open questions and run the chain. Each invocation below is copy-paste-ready.
    >
    > *Next.* Ordered chain:
    > 1. **Faisal** — Refine-PRD on `prd.md` — *"resolve SP-007 in `py-tokenizer/spec-patch-queue.md`"* — targets `prd.md`. Blocked-By: none.
    > 2. **Lance** — Architecture-Handback on `system-design.md` — *"resolve SP-008 in `py-tokenizer/spec-patch-queue.md`"* — targets `system-design.md`. Blocked-By: 1.
    > 3. **Sonia** — Replanning on `slices.md` and `slice-2.md`. Blocked-By: 2.
    >
    > — Sonia 🟧

---

## Definition of Done

- [ ] Trigger identified, evidence recorded, conflict-of-interest check completed
- [ ] Impact map written to change-proposal artifact
- [ ] Bounded questions decomposed and ordered by leverage
- [ ] Each ratified question recorded with roundtable synthesis
- [ ] Scribe-Eligibility evaluated for each ratification; scribe applications recorded under `## Scribe Applications`
- [ ] Non-scribe ratifications written to `## Ordered Handoff Chain` with verbatim invocation prompts
- [ ] `spec-patch-queue.md` updated with sequenced SP items
- [ ] `_context.md` `## Stale` reflects affected artifacts with SP item references; `change-proposal-<slug>.md` added to `## Live`
- [ ] Close message presents the ordered chain with copy-paste-ready invocations and identifies Sonia's re-entry point in Replanning mode
