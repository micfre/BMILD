# Diagnostic

Track down the root cause of an unexpected failure or bug. Use the lightest path that preserves correctness: small local defects can be diagnosed, fixed, and verified in one pass; larger, recurring, cross-system, or unclear defects use the full RCA protocol.

## Additional Context

Load in this order:
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/context-map.md` if it is relevant
- `[plan_folder]/adr/` entries relevant to the failure surface
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `slice-<N>.md` relevant to the reported bug, if applicable
- Any linked `verification-matrix.md`, `rca-*.md`, or `security-review-*.md`
- Repo contributor guide for testing conventions and commands

If no slice file exists: work from the symptom description and available code. Surface what you cannot verify from context alone.

## Global Directives

- **Evidence before action.** Confirm root cause before any production edit.
- **Conclusions require evidence.** Observed → tested → shows — in that order. Inference is not evidence.
- **User-facing diagnostic framing.** When a question helps gather evidence, frame it as observed → expected → evidence; use that vocabulary as a prompt, not a script.
- **Lightest persistent artifact.** Write `rca-<slug>.md` only when cross-turn value is high (recurring, cross-system, unclear ownership, failed first fix, future specs need the fact).
- **Initiative path rule.** Initiative-linked QA artifacts go in `[plan_folder]/<initiative-name>/`. Do not invent a global RCA sidecar.

**Path selection:**
- **Lightweight** — small local defect, clear failure surface, single component likely, focused proof available.
- **Full RCA** — multi-step, cross-system, recurring regression, unclear ownership, high-risk behaviour, failed first-fix attempt.

Treat user-provided signals as hypothesis input, not evidence.

**UI/runtime checklist (lightweight):** stack line → failing expression/state → expected vs actual data shape → regression source → minimal fix → focused verification.

## Routing heuristics

- *Root cause confirmed, fix localized and within QA authority* → apply minimal fix, then prove.
- *Fix reveals product, UX, architecture, or security decision* → stop; route to owning persona with evidence.
- *Design-caused root cause* → hand off to Lance or Katrina.
- *Broader implementation scope* → hand off to Alex.
- *Uncertainty after targeted investigation* → stop before production edits; record symptoms, hypotheses checked, and next diagnostic question.

## Tasks

Progress:

- [ ] Step 1: Classify path — lightweight or full RCA per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 2 (Lightweight): Reproduce or localize; identify exact failing contract; confirm root cause with evidence before edit. Apply minimal fix only after confirmation. Verify with focused proof. Persist RCA only when thresholds met.
- [ ] Step 3 (Full RCA — Reproduce): Confirm exact input, state, or sequence. If you cannot reproduce, stop and gather more information.
- [ ] Step 4 (Full RCA — Hypothesize): Write 5–7 distinct candidate causes across plausible layers before touching code. For each: one-sentence cause, why it produces this symptom, layer(s) implicated.
- [ ] Step 5 (Full RCA — Rank): State 1–2 most likely causes; retain full hypothesis list.
- [ ] Step 6 (Full RCA — Validate): Confirm or reject with logs, targeted tests, or diagnostic output — not "change code and see if symptom disappears." Remove diagnostic instrumentation after confirmation.
- [ ] Step 7: State confirmed root cause and evidence. If disputed, return to hypothesis validation.
- [ ] Step 8: Repair, handoff, or QA-owned work per Routing heuristics.
- [ ] Step 9: Specify regression proof run, added, or required.
- [ ] Step 10: Write `rca-<slug>.md` using `assets/rca-template.md` when full RCA used or persistence thresholds met; register in `registry.md ## Live`.
- [ ] Step 11: Pre-exit offer (declinable in one word) — *"Before I finalize the RCA — anything you want to steer or debate first? Otherwise I'll proceed."* Omit when no RCA write.
- [ ] Step 12: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Diagnostic path selected deliberately
- [ ] Symptom reproduced or localized with evidence before production edit
- [ ] Lightweight: failing contract, shapes, minimal fix, focused verification recorded
- [ ] Full RCA: 5–7 hypotheses, 1–2 ranked and validated, rejected hypotheses retained
- [ ] Root cause confirmed before fix, QA-owned repair, or handoff
- [ ] RCA written and registered only when persistence thresholds met
- [ ] Regression proof specified, added, or run
- [ ] Close message: path, root cause, evidence, fix/handoff, proof, artifact decision, next owner
