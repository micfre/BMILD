# Architecture-Refinement

Extend or update an existing `system-design.md`. Probe what changed, challenge stale decisions, and update the artifact.

## Additional Context

Load in this order:
- Relevant ADRs in `[plan_folder]/adr/` if they exist
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/system-design.md` in full
- `[plan_folder]/<initiative-name>/product-brief.md` and `prd.md`
- `[plan_folder]/<initiative-name>/ux-design.md` if it exists
- `./resources/completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

Per-section `stakes` in `completion-criteria.yaml` sets elicitation depth for **changed** sections. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/costs and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Refinement pacing:** Map each section being changed to its YAML `stakes`. Preview the queue grouped by stakes. Apply consequential pacing only to changed consequential sections; synthesize changed medium/low sections unless the user steers back. Run `fr_coverage` during consequence-check when FRs or contracts change.

## Global Directives

- **Challenge, do not preserve.** Treat existing architecture content as hypotheses until revalidated.
- **Hydrate before eliciting.** Read current PM and UX artifacts; do not reopen settled upstream truth unless the refinement target exposes conflict or stale content.
- **Schema changes flow through code-first migration workflow.** Never hand-written SQL.
- **Naked assumptions are forbidden in artifacts.** Format: `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** Live elicitation in chat; route product/UX gaps through `handoff.md`.

## ADR distillation gate

When refined decisions qualify for `[plan_folder]/adr/` (cross-initiative schema patterns, auth contracts, shared infrastructure), apply the same gate as Architecture-Design mode.

## Tasks

Progress:

- [ ] Step 1: Hydrate — read current PM and UX artifacts; identify what the change affects.
- [ ] Step 2: Identify refinement target — if unspecified, ask one question. Surface bounded assumptions and unresolved handoff items.
- [ ] Step 3: Brainstorm reconciliation — if a brainstorming session preceded this artifact, cross-reference against `system-design.md`; surface silently dropped ideas; ask whether any should be reconsidered.
- [ ] Step 4: Groundtruth — verify codebase reality per core NON-NEGOTIABLES when relevant to the change.
- [ ] Step 5: Preview the queue — name changed sections grouped by YAML `stakes` and approximate question count.
- [ ] Step 6: Elicit refinements — apply Stakes-based elicitation to changed sections only.
- [ ] Step 7: Consequence-check — verify changed sections, traceability to `prd.md`, and in-scope YAML sections.
- [ ] Step 8: Pre-exit offer (conditional, declinable in one word) — when any **consequential** section is being materially changed, offer once: *"Before I update the system design — anything you want to stress-test or take to roundtable? Otherwise I'll proceed."* Skip when only medium/low sections change or the session is a single-field alignment.
- [ ] Step 9: Write — update `[plan_folder]/<initiative-name>/system-design.md` using `assets/system-design-template.md`. Preserve unchanged sections. Update `updated` frontmatter.
- [ ] Step 10: ADR distillation gate — apply ADR distillation rules when triggered.
- [ ] Step 11: Register — confirm `system-design.md` in `## Live`; archive superseded predecessors if applicable.
- [ ] Step 12: Close — apply Exit and Handoff from the core skill. Default `Next` to Sonia; route to Katrina if `ux-design.md` is still missing.

## Definition of Done

- [ ] Brainstorming ideas reconciled when applicable
- [ ] Refinement target identified and affected sections updated
- [ ] Existing decisions challenged, not merely preserved
- [ ] `completion-criteria.yaml` verified for all in-scope sections
- [ ] Relevant `handoff.md` items resolved, deferred, rejected, superseded, or kept open with clear next owner
- [ ] `system-design.md` written with current `updated` date
- [ ] ADRs updated only if distillation gate fired
- [ ] `registry.md` reflects current artifact state
- [ ] Close message: what changed, trade-offs, queued or deferred governance items, next owner
