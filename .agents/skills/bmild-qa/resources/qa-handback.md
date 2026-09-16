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
- **No reviewer ping-pong.** Rahat owns QA, security, and code-review closure. Re-run the affected proof here and reconcile the outcome directly; never create or retain a handoff whose only purpose is to ask Rahat to close Rahat-owned state.

**Promotion Cascade Check.** After each accepted item that changes a QA artifact, classify downstream consumers as `unaffected | minor-update | stale`:
- **Mechanical consequences** → scribe authoritative QA results into derivative artifacts without transferring evidence ownership.
- **Independent owner decisions** → run separate gap-resolution episodes.
- **Coupled scope/sequencing/proof choices** → offer Sonia Course-Correction once and wait for user confirmation. Mark only unresolved artifacts stale; do not create replacement handoffs for in-session resolutions.

<!-- outcome-assurance:start -->
### Independent acceptance

Resolve the authorized phase/outcome from the request, live source contracts, and `verification-matrix.md`; read those sources independently from disk. A named legacy Slice or explicit PR/diff/branch/commit/file set is also a valid target. For current changes include staged, unstaged, and untracked work. Ask only when scope remains genuinely ambiguous, not because multiple old Slices exist. If the matrix is absent, create its outcome record from Sonia's template using settled scope; no planner invocation is required. Direct changes without an initiative may keep evidence in the requested review output; do not invent an initiative or spec.

Independent acceptance requires a fresh reviewer context that did not implement the reviewed production changes and did not inherit the development transcript. A separate new window or an isolated reviewer worker qualifies; renaming a persona or forking full history does not. Read the original spec and actual code; the implementer's summary only helps navigation. If independence is unavailable, report useful advisory findings, leave acceptance pending, and prepare a fresh-window transition. A reviewer-authored production fix needs a different independent reviewer.

Record code/change identity, source-contract identity, and relevant environment with evidence. Changes make affected proof pending; preserve unaffected current evidence and historical results. A final pass checks current state still matches reviewed state. Do not clear findings or publish accepted status from stale evidence.

Rahat alone writes `qa_status: verified | failed | blocked`, `security_status: findings_open | cleared`, and `code_review_status: findings_open | cleared`. Explicit not-applicable dispositions require a scope-specific rationale from Rahat. `not_reviewed`, missing fields, unrun required proof, and an omitted axis are never terminal. Targeted review cannot stand in for other required axes.

Set outcome `status: done` only with established independence, current evidence for every required source obligation and review axis, no unresolved required finding, and verified phase scope. Otherwise preserve `ready_for_review` or the actual blocked state. The matrix remains live while any outcome needs it. When setting the final outstanding outcome to `done`, Rahat moves `verification-matrix.md` from registry `## Live` to `## Archived` only if every outcome is `done` and no open handoff, RCA, security-review, or continuation obligation depends on it; otherwise keep it live and record the reason. On archival, also sync the initiative's `[plan_folder]/rollup.md` registry entry (`Status: complete`, `Last updated`) as a mechanical scribe update. For a named legacy Slice, mirror only accepted scope covered by this review into `slices.md` and move `slice-<N>.md` to registry `## Archived` only after its own status is done. Never archive unrelated outcomes or reopen historical completed Slices merely to normalize fields. Reconcile closure in this pass; do not hand back to Rahat merely for closure.
<!-- outcome-assurance:end -->

## Tasks

Progress:

- [ ] Step 1: Assess each handoff item targeting Rahat or a Rahat-owned security-review artifact — classify it as QA proof, security re-verification, code-review evidence, or a source-owner decision.
- [ ] Step 2: Resolve accepted items — update `verification-matrix.md`, `rca-<slug>.md`, `security-review-<slug>.md`, and/or the outcome review follow-up; re-run named proof or affected-boundary security trace when required; update `Owner Disposition` and `Promotion Record`; run Promotion Cascade Check. Reconcile linked `qa_status`, `security_status`, and `code_review_status` in the same pass so no stage stays open past its evidence.
- [ ] Step 3: Defer items needing design or implementation input — name missing constraint; route with one precise handoff item when another owner must act.
- [ ] Step 4: Write and restore liveness — persist QA changes; update `timestamp` frontmatter. After successful source promotion, remove each repaired QA-owned artifact from registry `## Stale` and add it to `## Live`; leave only unresolved artifacts stale with their governing handoff/proposal reference.
- [ ] Step 5: Reconcile outcome acceptance under the embedded contract; mirror and archive a named legacy Slice only when its scope meets the same bar. If this pass sets the final outstanding outcome to `done`, evaluate matrix archival and move `verification-matrix.md` from registry `## Live` to `## Archived` only when no open handoff, RCA, security-review, or continuation obligation depends on it; on archival, also sync the initiative's `[plan_folder]/rollup.md` registry entry (`Status: complete`, `Last updated`) as a mechanical scribe update. Never create a Rahat-to-Rahat closure handoff.
- [ ] Step 6: Close — apply Exit and Handoff from the core skill. Route only unresolved implementation/design work to its actual owner.

## Definition of Done

- [ ] Every Rahat-owned handoff item assessed and routed or resolved with reason
- [ ] QA, security, code-review, or RCA changes written with evidence
- [ ] Outcome review statuses updated if outcomes changed
- [ ] Outcome closure reconciled without a self-handoff
- [ ] Repaired QA artifacts returned from registry `## Stale` to `## Live`; matrix archival evaluated at final outcome closure
- [ ] Close message: items resolved, deferred items, next owner
