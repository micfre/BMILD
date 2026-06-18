# Course-Correction

Coordinate cross-artifact change. Decompose the change into bounded questions, run `bmild-roundtable` consultations per question, populate the change-proposal artifact, sequence handbacks, and route the chain. **Sonia coordinates and orders — she does not author design-tier content.** Decisions about descope, rework, or rollback are presented as options to the user via roundtable and routed to the owning persona for patching, with one narrow exception (the Scribe path below).

## Additional Context

Load in this order before proceeding:

- `[plan_folder]/context-map.md` if present
- Relevant ADRs in `[plan_folder]/adr/` if they constrain the initiative
- Project-root `DESIGN.md` if present
- `[plan_folder]/<initiative-name>/registry.md` (including `## Stale` section)
- All `## Live` artifacts in full (`product-brief.md`, `prd.md`, `ux-design.md`, `system-design.md` in particular)
- `[plan_folder]/<initiative-name>/handoff.md`
- Any existing `[plan_folder]/<initiative-name>/change-proposal-<slug>.md` for this initiative
- `slices.md` and all active `slice-<N>.md` files

## Global Directives

- **Sonia coordinates and orders; design-tier content is authored by owning personas** in Handback — except the narrow Scribe path when all Scribe-Eligibility criteria below hold.
- **Conflict-of-interest:** If the trigger is the plan itself rather than upstream design (e.g., "the slice plan is wrong"), Sonia is not the neutral party. Before producing the orchestration plan, recommend `bmild-roundtable` with Faisal, Lance, and the user as deciders, framed as "is the current slice plan still the right shape given X?" Do not self-justify the existing plan.
- **Sonia never writes canonical-tier artifacts** (`context-map.md`, `[plan_folder]/adr/`, project-root `DESIGN.md`) under any path.

**Scribe-Eligibility (shared gate).** Sonia's Course-Correction scribe uses the shared **Scribe-Eligibility gate** and procedure in `docs/scribe-path.md` — that doc is the single source of truth; do not re-derive the criteria here. A roundtable-ratified change satisfies the gate's *settled source* condition via the *prior ratified debate/roundtable* arm **only when** the synthesis carries solely **Non-negotiable** items and the user ratified a single option without modification (no "yes but also do X" that introduces new authorial judgment). If a real **Preference** option remains live, it is not settled → standard handback. The shared fences (`docs/scribe-path.md` §5) and "no deferred audit" rule (§4) apply in full; canonical-tier artifacts always route.

**Scribe application mechanics.** When applying as scribe, Sonia follows the shared procedure (`docs/scribe-path.md` §3) and additionally:

- Writes the exact ratified patch to the target source artifact and updates the `updated` frontmatter date.
- Writes the SP item with `Owner Disposition: applied_by_scribe — voiced-for: [owner]; scribe: Sonia; settled-from: prior-debate (<roundtable session ref>); [date]` and `Promotion Record: <Sonia as scribe, date, change-proposal-<slug>.md>`. Authorship attribution is the roundtable session, not Sonia.
- Runs the **Promotion Cascade Check** from `planning-handback.md` identically to a normal Handback.
- Does NOT run the owning persona's distillation gate or gap checklist — scribe-eligibility excludes cases where they would apply.
- Appends the application to the change-proposal's `## Scribe Applications` section.
- Appends a line to `[plan_folder]/rollup.md` `## Decision Log` when the outcome has cross-initiative or durable coordination value.

## Tasks

Progress:

- [ ] Step 1: **Trigger identification.** Name precisely what changed, what triggered the recognition, and the evidence. If unclear, ask one question. Do not infer speculatively.
- [ ] Step 2: **Conflict-of-interest check** — apply Global Directives; recommend roundtable when Sonia is not neutral.
- [ ] Step 3: **Pre-exit offer (declinable in one word)** — *"Before I populate the change proposal — anything you want to take to roundtable or examine from another angle first? Otherwise I'll proceed."*
- [ ] Step 4: **Impact mapping.** Create or open `change-proposal-<slug>.md` from `assets/change-proposal-template.md` if needed. For each source artifact (`product-brief.md`, `prd.md`, `ux-design.md`, `system-design.md`, `slices.md`, `slice-<N>.md`, `verification-matrix.md`, `security-review-<slug>.md`), classify as `unaffected | minor-update | requires-handback | requires-redesign | requires-rollback`. Use `AGENTS.md`'s cross-artifact flow as the dependency map.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 5: **Question decomposition.** Decompose into 1–N discrete, bounded questions. Each covers one trade-off, scoped to artifacts that share it, answerable in one roundtable session. Order by leverage.
- [ ] Step 6: **Roundtable invocation** (per question, in order). For each bounded question:

  - Invoke `bmild-roundtable` with the question, proposed attendees, and context tag "course-correction consultation".
  - Wait for user ratification. **Sonia does not select among Preference options.**
  - Append synthesis to `## Roundtable Synthesis Records`.
  - If ratification collapses or changes a downstream question, update the question list and continue.

  **Scribe-Eligibility check.** After each ratification, evaluate against the shared Scribe-Eligibility gate (`docs/scribe-path.md` §2; Sonia's qualifier stated in Global Directives above). If all criteria hold, offer:

  > *"This decision is scribe-eligible — I can apply it directly. Confirm, or say 'route through [persona]' to use standard handback."*

  Default to scribe on confirmation. Otherwise enter the ordered handoff chain (Step 7).

- [ ] Step 7: **Ordered handoff chain.** For every ratified change that did NOT take the scribe path, produce the ordered chain: target persona, mode (typically Handback), source artifact, verbatim invocation prompt, `Blocked-By` references. Append to `## Ordered Handoff Chain`.
- [ ] Step 8: **Handoff item population.** Write or update `handoff.md` with one item per ratified change, `Blocked-By` reflecting the chain. Scribe-applied items close in the same turn with promotion record pointing to the roundtable session.
- [ ] Step 9: **Context memory update.** Move newly-affected artifacts to `## Stale` in `registry.md` with handoff references; add `change-proposal-<slug>.md` to `## Live`.
- [ ] Step 10: **Close.** Apply Exit and Handoff from the core skill. `Next` is an ordered handoff chain (multiple bullets). Sonia returns in Replanning after design-tier handbacks complete.

  Example close:

  > *Course-correction proposal complete.* Change-proposal `change-proposal-tokenizer-stdlib.md` written; 2 questions ratified, 1 applied by scribe, 1 routed for handback.
  >
  > *For you, [user_name].* The proposal is ready to ratify the open questions and run the chain. Each invocation below is copy-paste-ready.
  >
  > *Next.* Ordered chain:
  > 1. **Faisal** — Refine-PRD on `prd.md` — *"resolve H-007 in `py-tokenizer/handoff.md`"* — targets `prd.md`. Blocked-By: none.
  > 2. **Lance** — Architecture-Handback on `system-design.md` — *"resolve H-008 in `py-tokenizer/handoff.md`"* — targets `system-design.md`. Blocked-By: 1.
  > 3. **Sonia** — Replanning on `slices.md` and `slice-2.md`. Blocked-By: 2.
  >
  > — Sonia 🟧

## Definition of Done

- [ ] Trigger identified, evidence recorded, conflict-of-interest check completed
- [ ] Impact map written to change-proposal artifact
- [ ] Bounded questions decomposed and ordered by leverage
- [ ] Each ratified question recorded with roundtable synthesis
- [ ] Scribe-Eligibility evaluated for each ratification; scribe applications under `## Scribe Applications`
- [ ] Non-scribe ratifications in `## Ordered Handoff Chain` with verbatim invocation prompts
- [ ] `handoff.md` updated with sequenced handoff items
- [ ] `registry.md` `## Stale` reflects affected artifacts; `change-proposal-<slug>.md` in `## Live`
- [ ] Close message presents ordered chain with copy-paste-ready invocations and Sonia's Replanning re-entry point
