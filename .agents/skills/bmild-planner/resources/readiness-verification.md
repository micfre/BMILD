---
name: bmild-planner / readiness-verification
description: "Readiness assessment mode. Activated when design inputs appear insufficient or the user asks 'is this ready'. Assesses upstream artifacts before any Slice is authored."
---

## Readiness-Verification Mode

Assess whether upstream design is coherent enough to plan safely. Stop at readiness findings and hand back the precise blocking question — do not author Slices if readiness fails.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] Project-root `DESIGN.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `product-brief.md`, `prd.md`, `ux-design.md`, and `system-design.md` from the initiative folder — any that exist
   - [ ] `slices.md` if it exists — you may be assessing a partially planned initiative

2. **Upstream artifact check** — Confirm `product-brief.md` and `prd.md` exist. If either is missing: block and route back to Faisal immediately with one precise question. Do not proceed to further checks.

3. **CHARTER coherence check (emergent)** — `plans/CHARTER.md` is an emergent artifact and is often absent. Apply this check in priority order:
   - If `plans/CHARTER.md` exists and the initiative `product-brief.md` conflicts with it → block and route back to Faisal.
   - If `plans/CHARTER.md` exists and the initiative significantly extends a project-level invariant → flag for Faisal to review and update CHARTER before closing the initiative.
   - If `plans/CHARTER.md` does not exist but the initiative conflicts with a sibling initiative's `product-brief.md` → flag for Faisal to seed CHARTER as part of conflict resolution.
   - Otherwise → skip this step silently.

4. **Cross-artifact alignment** — Assess whether each `Must Have` from `prd.md` is addressed in at least one downstream design artifact. Three outcomes:
   - **All addressed** — record `pass` and proceed.
   - **Gap** (a Must Have has no downstream coverage) — route to Katrina or Lance with one precise question per gap. Do not decompose.
   - **Contradiction** (a downstream design decision conflicts with a Must Have) — route to Faisal for scope resolution. Do not decompose.

5. **Question closure check** — Inspect Open Questions and Handoff Questions across all loaded artifacts. Readiness passes only when every question is resolved, explicitly deferred by the user, or routed to a target persona with a documented action. Preserve documented deferral consequences.

6. **Nyquist matrix** — Create a `verification-matrix.md` when the initiative would benefit from explicit proof boundaries. For trivial work, keep it lean; for high-risk or multi-Slice work, make it comprehensive. Write it to `[plan_folder]/<initiative-name>/verification-matrix.md` using `assets/verification-matrix-template.md`.

7. **Record findings** — Write the readiness verdict and findings to the `## Readiness` section of `slices.md` (create using `assets/slices-template.md` if it doesn't exist). Record the outcome of: upstream artifacts, cross-artifact alignment, coverage, and question closure. If the verdict is anything other than passes on all four: do not write Slice entries.

8. **Register in context memory** — Open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `slices.md` and `verification-matrix.md` (if created) to `## Live`.

9. **Close** — Apply the Exit and Handoff format from the core skill. If readiness passes, offer to continue into Phase-Scoped Planning or Full-Initiative Planning. If readiness fails, hand back the precise blocking question.

---

## Definition of Done

- [ ] Upstream artifact check recorded
- [ ] CHARTER coherence check recorded (or noted "n/a — no CHARTER, no cross-initiative conflict")
- [ ] Cross-artifact alignment recorded with outcome
- [ ] Question closure check recorded
- [ ] `## Readiness` section written in `slices.md`
- [ ] `verification-matrix.md` created if appropriate
- [ ] `_context.md` updated
- [ ] Close message: readiness verdict, blocking questions or next mode
