# Readiness-Verification

Assess whether upstream design is coherent enough to plan safely. Stop at readiness findings and hand back the precise blocking question — do not author Slices if readiness fails.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- Relevant ADRs in `[plan_folder]/adr/` if they constrain the initiative
- Project-root `DESIGN.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` — any that exist
- `handoff.md` if it exists
- `slices.md` if it exists
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Accepted handoff items are not truth until promoted** in the source artifact. Verify owning artifacts reflect resolutions — do not treat handoff status alone as authoritative.
- **Readiness blocks decomposition.** If any check fails, record findings and hand back one precise question — do not write Slice entries.
- **Source defects route through `handoff.md`.** User-owned clarification stays in chat unless async continuity requires a governed handoff.

## Routing heuristics

- *Either `product-brief.md` or `prd.md` missing* → block; route to Faisal with one precise question.
- *`context-map.md` conflicts with initiative semantics* → block; route to Faisal for semantic reconciliation.
- *Initiative introduces or changes a cross-initiative semantic boundary* → flag for Faisal to update `context-map.md` before closing.
- *`Must Have` lacks downstream coverage* → block; one blocking `source_defect` handoff item per gap.
- *Downstream design contradicts a `Must Have`* → block; route to Faisal for scope resolution.
- *Blocking `handoff.md` items unresolved* → readiness fails until each blocking item is applied, closed, deferred, rejected, or superseded.

## Tasks

Progress:

- [ ] Step 1: Upstream artifact check — confirm `product-brief.md` and `prd.md` exist (see Routing heuristics).
- [ ] Step 2: Context-map coherence check — apply priority order from Routing heuristics; skip silently when n/a.
- [ ] Step 3: Cross-artifact alignment — map each `Must Have` to downstream design coverage; record `pass`, gap, or contradiction.
- [ ] Step 4: Governance closure check — inspect `handoff.md`; readiness passes only when blocking items are closed per Routing heuristics.
- [ ] Step 5: Nyquist matrix — create `verification-matrix.md` when proof boundaries matter for implementation; use `assets/verification-matrix-template.md`. Route source-artifact repairs through `handoff.md`, not the matrix.
- [ ] Step 6: Record findings — write readiness verdict to `## Readiness` in `slices.md` (create from `assets/slices-template.md` if needed). If verdict is not pass on all checks, do not write Slice entries.
- [ ] Step 7: Register — open or create `registry.md` from `.agents/skills/bmild-pm/assets/registry-template.md`. Add `slices.md` and `verification-matrix.md` (if created) to `## Live`.
- [ ] Step 8: Close — apply Exit and Handoff from the core skill. If readiness passes, offer Phase-Scoped or Full-Initiative planning as `Next`.

## Definition of Done

- [ ] Upstream artifact check recorded
- [ ] Context-map coherence check recorded (or "n/a — no cross-initiative semantic conflict")
- [ ] Cross-artifact alignment and governance closure recorded
- [ ] `## Readiness` section written in `slices.md`
- [ ] `verification-matrix.md` created when appropriate
- [ ] `registry.md` updated
- [ ] Close message: readiness verdict, blocking questions or next mode
