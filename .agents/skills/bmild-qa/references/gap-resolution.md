# Gap resolution

> Shared runtime contract for all six standard personas. Load the local copy for an actual owner judgment outside the active role, not for ordinary implementation choices.

## Purpose

Resolve missing contracts while preserving the authorized phase/outcome and useful execution context. Roles supply specialist criteria and accountability; they do not impose an automatic process boundary. A bounded episode is one causal decision and its owned consequences, not one file or patch.

## Configuration

- `gap_resolution`: `auto` (default), `ask-consult`, or `handoff-only`. Auto resolves eligible episodes in-session. Ask-consult asks once before dispatch, not before settled mechanical propagation. Handoff-only permits scribing but routes unresolved owner judgment asynchronously.
- Intelligence tiers: design (Faisal/Katrina/Lance), planning (Sonia), implementation (Alex), reviewer (Rahat). All unspecified tiers inherit the user's active harness model and effort; there are no release-pinned model defaults.
- Claude Code and Codex accept explicit `[intelligence.<harness>.<tier>]` model/effort overrides for owner dispatch. Honor explicit pairs; never invent capability rankings or require exact-model attestation for ordinary authorized in-session work. If the user specifically requires another model's judgment, dispatch that model rather than impersonating it. OpenCode always inherits its user-configured model/variant and does not synchronize tier overrides.
- If an explicit pair is rejected, report the exact pair and harness error; do not retry or substitute. Preserve one durable handoff for the affected episode and continue unaffected work.
- Retired `slice_target`, `tokenizer_base`, and `tokenizer_multiplier` settings are inert. Their presence does not block work or trigger estimation.

Legacy `consult`, `consult_model`, and `consult_effort` remain unsupported. Report:

`Legacy consult configuration is unsupported in BMILD 0.4.2. Remove consult, consult_model, and consult_effort; use gap_resolution and [intelligence.<harness>.<tier>] instead.`

Do not map, interpret, preserve, or combine legacy values with the new configuration.

## Resolution ladder

Use the cheapest eligible resolution and resume the suspended work. Do not walk every rung when no gap exists.

- **Simplified scribe:** propagate a settled reversible fact or authoritative status mechanically. Do not load another owner's SOUL or originate a judgment. Record concise source provenance beside the edit. No audit-only handoff.
- **Authorized owner voice:** for a bounded owner decision within existing authority, apply that owner's relevant criteria, source contracts, and completion bar in the current context. Load its SOUL only when actually adopting that voice. No exact model/effort equality test. Canonical artifacts (`DESIGN.md`, `context-map.md`, ADRs) require the owner's substantive criteria, including ADR eligibility; their filename alone does not force dispatch. Never use this path for implementer self-approval, unresolved user preferences, or to bypass an explicitly requested independent/model-specific judgment.
- **Owner consult:** dispatch when independent specialist reasoning is useful/required, an explicit model choice requires it, or the current context cannot resolve the episode. Send the question, scope, relevant sources, owned edit boundaries, and expected evidence/decision. The consult is a leaf: no recursive dispatch, guest authorship, Course-Correction, or follow-up handoff creation. Return different-owner consequences to the presiding session. For review, send source/code/evidence references without the developer transcript and require fresh context.
- **Durable handoff:** persist or update one `H-###` only when the resolution actually leaves the session: missing capability, rejected explicit model, unavailable user decision, declined authority, or asynchronous ownership. State the blocker, source references, next owner, and resumption condition. Do not create a closed item merely to log an in-session resolution.
- **User-approved Course-Correction:** use for coupled changes to phase scope, committed contracts, real sequencing constraints, or proof obligations. Independent owner consequences are separate episodes. Routine internal planning and new-file discovery are not triggers. Name the consequential impact and wait for explicit user confirmation unless the existing request already authorizes that exact change.

Batch same-owner consequences. Record `Resolution: applied_by_scribe | authored_by_guest | authored_by_consult — owner; source/decision; date` beside authoritative edits; record actual model identity only when available, never fabricate attestation. Close existing handoffs with a source pointer; do not create replacements for audit history.

## Rejoin and impact

Re-read changed authoritative contracts, classify downstream impact as `unaffected | mechanical | owner-decision | stale`, and apply mechanical consequences. Resolve independent owner questions separately; mark only unresolved consumers stale. A material source/code/environment change invalidates affected proof while preserving history and unrelated current evidence. Source promotion, not a handoff's accepted state, establishes truth. Resume the suspended work without a new opening, sign-off, or user reinvocation.

## Review independence

Alex may author implementation-complete and review-requested states and propagate already-authoritative verdicts mechanically, but never independently approve its own work. Rahat alone authors QA evidence and verdicts, security findings and clearance, code-review outcomes, and the accepted `done` transition. This requires a fresh context that did not implement the reviewed production changes and did not inherit their development transcript. A role change or full-history fork is insufficient. Reviewer-authored production repairs need a different independent reviewer before acceptance. When isolated dispatch is unavailable or the user chooses it, persist a concise transition for a separate new window and leave acceptance pending.

## Examples

- An unplanned internal helper preserving committed behavior needs no owner episode or new Slice; Alex implements and tests it.
- An API contract change uses Lance's criteria and the required user decision; record the contract update and invalidate affected proof before continuing.
- A source requirement omitted from a matrix is still binding. Add the obligation from the source and obtain its proof; never rewrite the spec to conceal an implementation miss.
- A verified outcome's status can be mirrored mechanically into its legacy Slice registry without a Sonia handoff.
- A configured consult pair rejected by the harness leaves that episode pending; no silent model downgrade.
