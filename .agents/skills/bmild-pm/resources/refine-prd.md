# Refine-PRD

Revisit and improve an existing PRD. Probe what changed, challenge stale requirements, and update `prd.md`. Existing content is a starting point to challenge, not a contract to preserve.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full (traceability contract)
- `[plan_folder]/<initiative-name>/prd.md` in full
- `./resources/prd-completion-criteria.yaml`
- Confirm no `## Archived` entries or other initiative folders were loaded

## Stakes-based elicitation

Per-section `stakes` in `prd-completion-criteria.yaml` sets elicitation depth for changed sections. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing (e.g. `nfr` becomes consequential when regulated or when a hard threshold is named).

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Refinement pacing:** Map each section being changed to its YAML `stakes`. Preview the queue grouped by stakes. Apply consequential pacing only to changed consequential sections; synthesize changed medium/low sections unless the user steers back. Run `coverage_check` during consequence-check when FRs or scope change.

## Global Directives

- **Discovery before invention**: Before accepting a greenfield premise, verify repository reality. Scan the codebase when the initiative may be brownfield or when artifacts claim behaviour that code may already implement. Do not invent greenfield solutions in a brownfield environment.
- **Challenge, do not preserve.** Treat existing PRD content as hypotheses until revalidated. Do not skip elicitation because upstream work already exists.
- **Traceability.** Changed requirements must remain mappable to `product-brief.md`.
- **Artifact-authority discipline.** Live elicitation in chat; route UX/architecture gaps through `handoff.md`. Bounded assumptions only when low-risk and reversible.

## Tasks

Progress:

- [ ] Step 1: Determine what changed. If unspecified, ask one question. Typical triggers: capability scope shifted, journey changed, priority moved across phases, new NFR threshold, or documentation obligations changed.
- [ ] Step 2: If a brainstorming session preceded this artifact, cross-reference it against `prd.md`. Surface silently dropped ideas affecting FRs, journeys, or scope; ask whether any should be incorporated.
- [ ] Step 3: Groundtruth and challenge — verify repository reality per Global Directives when refinement depends on existing behaviour. Surface unresolved PM-owned handoff items touching `prd.md`.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 4: Preview the queue — name changed sections grouped by YAML `stakes` and approximate question count before the first probe.
- [ ] Step 5: Elicit refinements — apply Stakes-based elicitation to changed sections only; unchanged sections skip elicitation.
- [ ] Step 6: Consequence-check — privately verify changed sections and traceability to `product-brief.md`; run `prd-completion-criteria.yaml` for all in-scope sections (including `documentation_scope` when doc obligations may have changed).
- [ ] Step 7: Pre-exit offer (conditional, declinable in one word) — when any **consequential** section (per YAML `stakes`, respecting `stakes_note`) is being materially changed, offer once: *"Before I update the PRD — anything you want to stress-test or take to roundtable? Otherwise I'll proceed."* Offer advanced facilitator skills per core Advanced Elicitation Triggers when trade-offs are still open. Skip when only medium/low sections change or the session is a single-field alignment.
- [ ] Step 8: Write — update `[plan_folder]/<initiative-name>/prd.md` using `assets/prd-template.md`. Preserve unchanged sections. Update `updated` frontmatter.
- [ ] Step 9: Gate check — resolve remaining product ambiguity in chat or route through `handoff.md` for UX/architecture ownership.
- [ ] Step 10: Register — confirm `prd.md` in `## Live`; archive superseded predecessors if applicable.
- [ ] Step 11: Close — apply Exit and Handoff from the core skill. Downstream design handoff is allowed when both PM artifacts are coherent.

## Definition of Done

- [ ] Brainstorming ideas reconciled when applicable
- [ ] Refinement target identified and relevant PRD sections updated
- [ ] Existing PRD content challenged, not merely preserved
- [ ] `prd-completion-criteria.yaml` verified for all in-scope sections
- [ ] Relevant `handoff.md` items targeting `prd.md` resolved, deferred, rejected, superseded, or kept open with a clear next owner
- [ ] `prd.md` written with current `updated` date
- [ ] `registry.md` reflects current PRD state
- [ ] Close message: what changed, queued or deferred governance items, next owner
- [ ] Downstream design handoff explicit in `Next` when PM artifacts are coherent
