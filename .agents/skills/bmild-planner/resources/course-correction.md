# Course-Correction

Coordinate a user-approved coupled cross-artifact change. Decompose it into bounded questions, run `bmild-roundtable` consultations where deliberation is needed, resolve owner consequences through `references/gap-resolution.md`, and return to replanning. **Sonia coordinates and orders — she does not author another owner's judgment.**

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

When this is a user-accepted Project Bearing continuation, also consume the in-conversation continuation packet after the normal reads. It is user authorization to enter Course-Correction, not a `handoff.md` item and not an excuse to skip the impact map.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **User confirmation is an entry condition.** If the user has not explicitly approved Course-Correction after seeing the coupled scope/sequencing/proof impact, stop and ask once before creating or changing a proposal.
- **Sonia coordinates and orders; design-tier content is authored by owning personas** through guest voice, owner consult, or durable handoff under the ladder. Mechanical consequences use simplified scribe.
- **Conflict-of-interest:** If the trigger is the plan itself rather than upstream design (e.g., "the slice plan is wrong"), Sonia is not the neutral party. Before producing the orchestration plan, recommend `bmild-roundtable` with Faisal, Lance, and the user as deciders, framed as "is the current slice plan still the right shape given X?" Do not self-justify the existing plan.
- **Sonia never writes canonical-tier artifacts** (`context-map.md`, `[plan_folder]/adr/`, project-root `DESIGN.md`) under any path.

**Resolution application mechanics.** For each ratified decision, run a bounded ladder episode for each independent owner consequence. Batch all same-owner artifact edits. Owner consults may author their canonical-tier artifacts. When applying mechanical consequences as scribe:

- Writes the exact ratified patch to the target source artifact and updates the `timestamp` frontmatter date.
- Writes artifact-local `Resolution: applied_by_scribe — ...` provenance. If an existing handoff is resolved, closes it with a Promotion Record pointing to the edit; creates no audit-only item.
- Runs the **Promotion Cascade Check** from `planning-handback.md` identically to a normal Handback.
- Does not run an owner's judgment or distillation gate; those belong to guest voice or owner consult.
- Appends the episode to the change-proposal's `## Resolution Record`.
- Appends a line to `[plan_folder]/rollup.md` `## Decision Log` when the outcome has cross-initiative or durable coordination value.

## Tasks

Progress:

- [ ] Step 1: **Trigger identification.** Name precisely what changed, what triggered the recognition, and the evidence. If unclear, ask one question. Do not infer speculatively.
- [ ] Step 2: **Conflict-of-interest check** — apply Global Directives; recommend roundtable when Sonia is not neutral.
- [ ] Step 3: **Pre-exit offer (declinable in one word)** — *"Before I populate the change proposal — anything you want to take to roundtable or examine from another angle first? Otherwise I'll proceed."*
- [ ] Step 4: **Impact mapping.** Create or open `change-proposal-<slug>.md` from `assets/change-proposal-template.md` if needed. For each source artifact (`product-brief.md`, `prd.md`, `ux-design.md`, `system-design.md`, `slices.md`, `slice-<N>.md`, `verification-matrix.md`, `security-review-<slug>.md`), classify as `unaffected | mechanical | owner-decision | coupled-change | stale`. Use `AGENTS.md`'s cross-artifact flow as the dependency map.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 5: **Question decomposition.** Decompose into 1–N discrete, bounded questions. Each covers one trade-off, scoped to artifacts that share it, answerable in one roundtable session. Order by leverage.
- [ ] Step 6: **Roundtable invocation** (per question, in order). For each bounded question:

  - Invoke `bmild-roundtable` with the question, proposed attendees, and context tag "course-correction consultation".
  - Wait for user ratification. **Sonia does not select among Preference options.**
  - Append synthesis to `## Roundtable Synthesis Records`.
  - If ratification collapses or changes a downstream question, update the question list and continue.

  **Resolution check.** After each ratification, classify consequences by owner. Apply mechanical consequences immediately; run independent owner episodes separately. Do not ask for scribe permission and do not manufacture a handoff for provenance.

- [ ] Step 7: **Owner resolution.** Run the ladder for every ratified owner consequence in dependency order. Append results to `## Resolution Record`; use `## Ordered Handoff Chain` only for episodes that genuinely leave the session. Existing handoffs close rather than duplicate.
- [ ] Step 8: **Context memory update.** Mark only unresolved artifacts stale and reference their durable handoff or proposal; return resolved artifacts to `## Live`. Add `change-proposal-<slug>.md` to `## Live` while coordination remains active.
- [ ] Step 9: **Replan and resume.** Re-read changed source contracts. Recut `slices.md`, affected Slice files, and proof boundaries as Sonia's bounded planning episode, then resume the work that triggered Course-Correction.
- [ ] Step 10: **Close.** Apply Exit and Handoff from the core skill only after in-session resolution and replanning are exhausted. `Next` lists only genuinely asynchronous handoffs; otherwise it names the resumed execution or verification step.

## Definition of Done

- [ ] Trigger identified, evidence recorded, conflict-of-interest check completed
- [ ] Impact map written to change-proposal artifact
- [ ] Bounded questions decomposed and ordered by leverage
- [ ] Each ratified question recorded with roundtable synthesis
- [ ] Each ratified consequence resolved through a bounded owner episode with artifact-local provenance
- [ ] `## Ordered Handoff Chain` contains only work that genuinely left the session
- [ ] Existing handoffs closed without replacements; no audit-only handoffs created
- [ ] `registry.md` marks only unresolved artifacts stale; `change-proposal-<slug>.md` state is accurate
- [ ] Replanning completed from re-read contracts and the suspended work resumed, or exact asynchronous blockers recorded
