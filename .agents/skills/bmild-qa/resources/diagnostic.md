---
name: bmild-qa / diagnostic
description: "Root cause analysis mode. Activated when broken behaviour is reported. Reproduce, hypothesize, validate, confirm, and hand off — in that order."
---

## Diagnostic Mode

Track down the root cause of an unexpected failure or bug. Full RCA protocol applies. Mandatory before any fix handoff or QA-owned repair.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] `slice-<N>.md` relevant to the reported bug (to understand expected behaviour), if applicable
   - [ ] Any linked `verification-matrix.md`, `rca-*.md`, or `security-review-*.md`
   - [ ] Repo contributor guide for testing conventions and commands

   If no slice file exists for the reported bug: work from the symptom description and available code. Surface what you cannot verify from context alone.

2. **Reproduce** — Confirm the exact input, state, or sequence that triggers the symptom. If you cannot reproduce it, you cannot fix it. Stop and gather more information.

3. **Generate hypotheses** — Write out 5–7 distinct candidate causes across all plausible layers before touching code. For each hypothesis:
   - State the cause in one sentence
   - Explain why it would produce this specific symptom
   - Identify which layer(s) it implicates (DB / Service / API / Frontend / cross-layer)

   Do NOT stop at 2–3. Premature narrowing is the most common diagnostic error. If you cannot reach 5, you have not looked broadly enough — revisit the symptom.

4. **Rank hypotheses** — State the 1–2 most likely causes explicitly. Keep the full hypothesis list — rejected hypotheses become evidence that the diagnosis is complete.

5. **Validate** — Use logs, targeted tests, or temporary diagnostic output to confirm or reject the ranked hypotheses.
   - Do NOT apply a code change and see if the symptom disappears — that is not evidence.
   - Diagnostic instrumentation MUST be removed after the root cause is confirmed.
   - If both ranked hypotheses are rejected, promote the next from the list. Do not invent new hypotheses without re-examining the symptom.

6. **Confirm and HALT** — State the confirmed root cause and evidence. Ask:
   > "Root cause identified: <one sentence>. Evidence: <brief>. Should I persist the RCA and hand this to Alex, or continue with QA-owned test/matrix repair?"

   Do NOT apply any production fix. If the user disputes the diagnosis, return to step 4.

7. **Handoff or QA-owned repair** — Production fixes belong to Alex. Persist the RCA and hand off with the exact failing proof and next action. Rahat may proceed only when the next action is QA-owned: adding or repairing tests, updating `verification-matrix.md`, documenting RCA evidence, or recording verification findings.

8. **Regression expectation or QA-owned test repair** — If Alex owns the production fix, specify the regression proof Alex must add or run. If the missing proof is itself QA-owned test or matrix work, add or repair it and record the evidence.

9. **Write** — Write `[plan_folder]/<initiative-name>/rca-<slug>.md` using `assets/rca-template.md`. Use `_system/rca-<slug>.md` only for genuinely global defects with no initiative owner. If a Slice, initiative folder, or initiative `_context.md` is known, do not write RCA under `_system`.

10. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Add `rca-<slug>.md` to `## Live`.

11. **Close** — Apply the Exit and Handoff format from the core skill. Route production fixes to Alex; route confirmed design-caused root causes to Lance or Katrina.

---

## Definition of Done
- [ ] Symptom reproduced with exact inputs before any edit
- [ ] 5–7 distinct hypotheses generated across all plausible layers
- [ ] 1–2 ranked most-likely candidates explicitly stated
- [ ] Ranked hypotheses validated with evidence (logs, targeted tests, diagnostic output — not code changes)
- [ ] Root cause confirmed with evidence; user halted before any production fix
- [ ] `rca-<slug>.md` written with confirmed root cause, evidence, and next owner
- [ ] `_context.md` updated with RCA artifact in `## Live`
- [ ] Regression proof specified or QA-owned repair recorded
- [ ] Close message: root cause summary, evidence, artifact written, next owner
