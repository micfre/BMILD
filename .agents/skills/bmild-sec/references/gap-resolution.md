# Gap resolution

> Shared runtime contract for all standard personas (`bmild-{pm,ux,arch,planner,dev,qa,sec}`). Each skill ships an identical local copy. Load this skill's copy whenever the active mode finds a gap owned by another persona or a downstream consequence outside the active persona's authority.

## Purpose

Resolve ownership gaps without ending useful work prematurely. The active persona suspends the current mode at the exact blocked step, runs the cheapest eligible resolution episode, re-reads changed contracts, absorbs mechanical fallout, and resumes the suspended step.

A **bounded episode** is one causal decision and all same-owner consequences of that decision. It may update several artifacts owned by that persona. It is not artificially split by file or patch, and it never creates a recursive handoff back to the same owner.

## Configuration

Read `.bmild.toml` before using the ladder.

- `gap_resolution` accepts `"auto"` (default), `"ask-consult"`, or `"handoff-only"`.
  - `auto`: run every eligible in-session rung without asking.
  - `ask-consult`: scribe and eligible guest voice remain automatic; ask once immediately before an owner consult. A decline persists one durable handoff.
  - `handoff-only`: mechanical scribing remains available, but skip guest voice and consult; persist one durable handoff when owner judgment is required.
- Intelligence tiers are `design` (Faisal, Katrina, Lance), `planning` (Sonia), `implementation` (Alex), and `reviewer` (Rahat, Zach).
- Claude Code reads `[intelligence.claude_code.<tier>]`; Codex reads `[intelligence.codex.<tier>]`. Each configured tier uses native `model` and `effort` string values.
- Missing Claude Code or Codex `design` / `planning` settings use the release-pinned pair carried by the generated consult definition: Claude Code `opus` / `max`; Codex `gpt-5.6-sol` / `ultra`.
- Missing `implementation` / `reviewer` settings inherit the active session pair. OpenCode always inherits its user-configured harness model and variant for every tier; ignore BMILD tier overrides and do not mutate or synchronize OpenCode configuration.

Legacy keys are a hard configuration error. If `consult`, `consult_model`, or `consult_effort` appears, stop BMILD configuration resolution and report:

`Legacy consult configuration is unsupported in BMILD 0.4.0. Remove consult, consult_model, and consult_effort; use gap_resolution and [intelligence.<harness>.<tier>] instead.`

Do not map, interpret, preserve, or combine legacy values with the new configuration.

An explicit model/effort pair that the harness rejects is not a fallback opportunity. Report the exact pair and harness error, do not retry or substitute, persist one durable handoff for the affected episode, and stop only that episode. Unaffected independent work may continue.

## Resolution ladder

Run these rungs in order. Stop at the first completed resolution.

- [ ] Step 1: **Simplified scribe.** Apply a settled, reversible fact or already-authoritative status mechanically.
- [ ] Step 2: **Capability-gated guest voice.** Author one bounded single-owner episode only when the current harness attests that the active model and effort exactly match the target owner's resolved intelligence tier.
- [ ] Step 3: **Owner consult.** Dispatch the owning persona's leaf consult agent for an eligible single-owner episode.
- [ ] Step 4: **Durable inter-agent handoff.** Persist one `H-###` only when work genuinely leaves the session.
- [ ] Step 5: **User-approved Course-Correction.** Offer Sonia only for coupled choices that materially change scope, sequencing, or proof boundaries; wait for explicit user confirmation before entering it.
- [ ] Step 6: **Rejoin.** Re-read authoritative edits, classify downstream impact, scribe mechanical consequences, and resume the suspended mode and step.

Independent consequences owned by different personas are separate ladder episodes. Do not escalate them to Course-Correction merely because there is more than one owner. Use Course-Correction only when the decisions are coupled and cannot be resolved independently without jointly changing scope, sequence, or proof.

## Simplified scribe

Scribing is transcription, not guest authorship. Do not load the target owner's `SOUL.md`.

All conditions must hold:

- The source is already authoritative: repository fact with direct evidence, explicit in-session user decision, ratified decision, or status written by its authorized owner.
- The target edit is reversible and mechanical: terminology propagation, link/reference repair, status mirroring, registry/matrix/roadmap synchronization, or an equivalent no-judgment update.
- The edit does not originate evidence, weigh a trade-off, interpret an unresolved preference, alter a consequential contract section, or write a canonical-tier artifact (`context-map.md`, `[plan_folder]/adr/`, project-root `DESIGN.md`).
- Ownership independence remains intact. Alex may propagate completion state but never QA/security approval; only Rahat authors QA evidence/outcomes and only Zach authors security clearance.

Write beside the authoritative edit:

`Resolution: applied_by_scribe — owner: <owner>; scribe: <active persona>; source: <authoritative evidence>; <date>`

Do not create an `H-###` for audit history. If an existing handoff described the now-resolved fact, close that item and point its Promotion Record at the authoritative edit; never create a replacement.

## Capability-gated guest voice

Guest voice lets the active session speak with one owner's authority for a bounded causal episode. All conditions must hold:

- Exactly one owner controls the decision and every authored consequence in the episode.
- The harness positively attests that the active model and reasoning effort equal the target owner's resolved tier. Missing or ambiguous attestation means use consult, not guest voice.
- Load the target owner's `SOUL.md`, the applicable artifact template/contract, current authoritative artifact sections, and their completion criteria before deciding.
- The target is owned by that persona but is not canonical-tier. Consequential sections are eligible when the other conditions hold.
- No unresolved user preference, conflict of interest, review-self-approval, or coupled multi-owner choice exists.

Batch all same-owner consequences across owned artifacts before returning. Do not invoke another persona, recurse into the ladder, or hand off to the same owner while acting as guest. Return any different-owner consequences to the presiding persona as an impact list for separate episodes.

Write beside each authoritative edit, or once in a shared decision block covering the batch:

`Resolution: authored_by_guest — owner: <owner>; guest: <active persona>; episode: <bounded cause>; model: <model>; effort: <effort>; <date>`

## Owner consult

Consult is the normal authorship rung when guest voice is ineligible and in-session dispatch is available. The episode must have exactly one owner. Unlike scribe and guest voice, the owner consult may update anything it canonically owns, including project-root `DESIGN.md`, `context-map.md`, and ADRs.

Dispatch the owner with:

- presiding persona, suspended mode/resource/step, and initiative;
- one bounded causal question and why it blocks progress;
- required reads and exact owned artifacts/sections that may change;
- resolved target model/effort and harness attestation request;
- existing `H-###` reference when the consult is resolving queued work;
- expected return: decision, edits, provenance, downstream impact list, and remaining user input.

The consult agent is a leaf: it cannot dispatch, invoke guest voice, run Course-Correction, or create follow-up handoffs. It loads its own `SKILL.md`, `SOUL.md`, this reference, relevant artifact contracts, and completion criteria; authors the whole same-owner episode; records:

`Resolution: authored_by_consult — owner: <owner>; consult-of: <presiding persona>; episode: <bounded cause>; model: <model>; effort: <effort>; <date>`

No new handoff is created solely because a consult occurred. If an existing handoff is resolved, the consult closes it with a Promotion Record pointing at the authoritative edit. Different-owner consequences return as an impact list to the presiding persona.

## Durable handoff

Create or retain one `H-###` only when resolution genuinely leaves the session because:

- the harness lacks required dispatch, model, effort, edit, or read capability;
- explicit configured model/effort was rejected;
- required user input cannot be obtained in-session;
- the user declines consult authority or selects `handoff-only`;
- ownership must be resolved asynchronously.

Persist the question, evidence, target owner/artifact, blocked mode step, exact resumption condition, and rejected model/effort plus harness error when applicable. Reuse an existing relevant handoff and update its status instead of duplicating it. The active persona may continue unaffected work, but stops the affected episode.

## Course-Correction boundary

Course-Correction is not the default multi-owner branch. Resolve independent owner consequences in separate episodes. Offer Course-Correction once only when choices are causally coupled and would materially alter scope, Slice sequencing, or proof boundaries. Name the coupled decisions and impact before asking. Enter only after explicit user confirmation; a decline leaves one durable coordination item rather than a hidden partial rewrite.

## Rejoin and impact

After scribe, guest, or consult resolution:

- Re-read every changed authoritative section and any completion criteria that govern it.
- Verify provenance is artifact-local and any pre-existing handoff is closed without a replacement.
- Classify each downstream consumer `unaffected | mechanical | owner-decision | stale`.
- Apply `mechanical` consequences through simplified scribe.
- Run separate ladder episodes for independent `owner-decision` consequences.
- Mark artifacts stale only for unresolved consequences; do not leave resolved in-session work stale.
- Re-evaluate the suspended mode's scope, acceptance, and proof boundaries. A bounded Sonia planning consult may recut affected delivery artifacts as its own episode; it is not a special recursive exception.
- Resume the exact suspended mode step. Do not emit an Exit block, new Opening Stance, or ask the user to reinvoke the active persona merely because a gap was resolved.

## Review independence

- Alex may author implementation-complete and `qa_status: ready_for_verification`; Alex never authors `qa_status: verified`, security clearance, or approval evidence.
- Rahat alone authors QA evidence, `qa_status: verified | failed | blocked`, and the verified `status: done` transition when security is terminal.
- Zach alone authors security findings and `security_status: findings_open | cleared`.
- Any persona may scribe those already-authoritative outcomes into derivative registries, matrices, rollups, or roadmap records without acquiring approval authority.

## Examples

- **Before:** Rahat verifies a Slice, then an `H-###` asks Sonia to copy the status into planning records. **After:** Rahat's outcome is authoritative; the active persona scribes it into derivative registries/matrices with `applied_by_scribe`, creates no handoff, and resumes.
- **Dev-time API gap:** Alex suspends Spec-Dev at the contract-dependent step. Lance's owner consult authors the API contract in `system-design.md` with `authored_by_consult`. Alex re-reads it, classifies the Slice/proof impact, runs one bounded Sonia planning consult to recut affected delivery artifacts, then resumes implementation without a new opening or user relay.
- **Same-owner batch:** A Katrina episode changes both `ux-design.md` and project-root `DESIGN.md`. Guest voice is ineligible because `DESIGN.md` is canonical-tier, so one Katrina consult owns both consequences; the work is not split into two consultations.
- **Canonical ADR:** A bounded architecture trade-off passes the ADR gate. Lance's owner consult may author both `system-design.md` and the ADR; a non-owner scribe or guest may not.
- **Independent owners:** A settled product requirement independently requires one Faisal episode and one Katrina episode. Run them separately; multiple owners alone do not justify Course-Correction.
- **Coupled change:** A product choice and architecture constraint jointly alter scope, Slice order, and proof boundaries. Name the coupled impact, ask once, and enter Course-Correction only on user approval.
- **Rejected pair:** Codex rejects configured `design = bad-model/max`. Record that exact pair and harness error, create or reuse one Lance handoff, do not retry with the release default, and continue only unaffected work.
- **Existing queue item:** An owner consult resolves `H-014`. Close `H-014` with a pointer to the authoritative provenance; do not create `H-015` to record the consult.
