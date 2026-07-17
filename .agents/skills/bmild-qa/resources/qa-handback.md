# QA-Handback

Resolve QA-owned governance items raised by other personas. Promote accepted changes into source artifacts so the queue does not become shadow memory.

For new defect work use Spec-Fix (tracked entry context) or Direct-Fix (outside tracked context).

## Additional Context

Load in this order:
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/verification-matrix.md` in full (if it exists)
- Any referenced `rca-<slug>.md` files
- `[plan_folder]/<initiative-name>/handoff.md`
- Originating artifact or queue context (`slice-<N>.md`, `system-design.md`, `security-review-<slug>.md`, upstream design artifacts when proof-boundary defects implicate them)
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Evidence before action.** Root cause before fix recommendation; conclusions require evidence.
- **Handoff-artifact discipline.** `accepted` is pending until promoted into the governed source artifact.
- **Lightest persistent artifact** preserving the next action.

**Promotion Cascade Check.** After each accepted item that changes a QA artifact, classify downstream consumers as `unaffected | minor-update | stale`:
- **0 stale owners** → no cascade action.
- **1 stale owner** → auto-enqueue one `H-###` per stale artifact; close follows verbatim-invocation rule.
- **≥2 stale owners** → mark artifacts in `registry.md ## Stale`; route to Sonia Course-Correction; append `Downstream Cascade: <summary>`. Cycle prevention: do not enqueue if `Supersedes` chain includes this SP.

## Tasks

Progress:

- [ ] Step 1: Assess each handoff item targeting Rahat — resolve from evidence vs new verification work.
- [ ] Step 2: Resolve accepted items — update `verification-matrix.md` and/or `rca-<slug>.md`; re-run named proof when required; update `Owner Disposition` and `Promotion Record`; run Promotion Cascade Check.
- [ ] Step 3: Defer items needing design or implementation input — name missing constraint; route with one precise handoff item when another owner must act.
- [ ] Step 4: Write — persist QA changes; update `timestamp` frontmatter.
- [ ] Step 5: Close — apply Exit and Handoff from the core skill. Update Slice `qa_status` if verification outcomes changed.

## Definition of Done

- [ ] Every QA-owned handoff item assessed and routed or resolved with reason
- [ ] Verification or RCA changes written with evidence
- [ ] Slice `qa_status` updated if outcomes changed
- [ ] Close message: items resolved, deferred items, next owner
