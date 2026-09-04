# QA-Handback

Resolve Rahat-owned QA, security, and code-review governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

For new reviews use Verification, Security Review, Code Review, or Comprehensive Review. For new defect work use Spec-Fix (tracked entry context) or Direct-Fix (outside tracked context).

## Additional Context

Load in this order:
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/verification-matrix.md` in full (if it exists)
- Any referenced `rca-<slug>.md` files
- Any referenced `security-review-<slug>.md` files
- `[plan_folder]/<initiative-name>/handoff.md`
- Originating artifact or queue context (`slice-<N>.md`, `system-design.md`, changed code, upstream design artifacts when proof or trust-boundary defects implicate them)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Evidence before action.** Root cause before fix recommendation; conclusions require evidence.
- **Handoff-artifact discipline.** `accepted` is pending until promoted into the governed source artifact.
- **Lightest persistent artifact** preserving the next action.
- **No reviewer ping-pong.** Rahat owns QA, security, and code-review closure. Re-run the affected proof here and reconcile the Slice directly; never create or retain a handoff whose only purpose is to ask Rahat to close Rahat-owned state.

**Promotion Cascade Check.** After each accepted item that changes a QA artifact, classify downstream consumers as `unaffected | minor-update | stale`:
- **Mechanical consequences** → scribe authoritative QA results into derivative artifacts without transferring evidence ownership.
- **Independent owner decisions** → run separate gap-resolution episodes.
- **Coupled scope/sequencing/proof choices** → offer Sonia Course-Correction once and wait for user confirmation. Mark only unresolved artifacts stale; do not create replacement handoffs for in-session resolutions.

## Tasks

Progress:

- [ ] Step 1: Assess each handoff item targeting Rahat or a Rahat-owned security-review artifact — classify it as QA proof, security re-verification, code-review evidence, or a source-owner decision.
- [ ] Step 2: Resolve accepted items — update `verification-matrix.md`, `rca-<slug>.md`, `security-review-<slug>.md`, and/or Slice `## Review Follow-up`; re-run named proof or affected-boundary security trace when required; update `Owner Disposition` and `Promotion Record`; run Promotion Cascade Check. Reconcile linked `qa_status`, `security_status`, and `code_review_status` in the same pass so no stage stays open past its evidence.
- [ ] Step 3: Defer items needing design or implementation input — name missing constraint; route with one precise handoff item when another owner must act.
- [ ] Step 4: Write — persist QA changes; update `timestamp` frontmatter.
- [ ] Step 5: Reconcile Slice closure. Set `status: done`, update `slices.md`, and move `slice-<N>.md` from registry `## Live` to `## Archived` only when `qa_status: verified`, `security_status` is terminal (`cleared`, `not_applicable`, or `not_reviewed`), `code_review_status` is terminal (`cleared` or `not_applicable`), and no review finding remains open. Otherwise keep `ready-for-review`; never create a Rahat-to-Rahat closure handoff.
- [ ] Step 6: Close — apply Exit and Handoff from the core skill. Route only unresolved implementation/design work to its actual owner.

## Definition of Done

- [ ] Every Rahat-owned handoff item assessed and routed or resolved with reason
- [ ] QA, security, code-review, or RCA changes written with evidence
- [ ] Slice review statuses updated if outcomes changed
- [ ] Slice closure reconciled without a self-handoff
- [ ] Close message: items resolved, deferred items, next owner
