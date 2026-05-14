---
name: bmild-qa / diagnostic
description: "Diagnostic mode. Activated when broken behaviour is reported. Reproduce or localize, confirm root cause, choose lightweight repair or full RCA, and preserve evidence."
---

## Diagnostic Mode

Track down the root cause of an unexpected failure or bug. Use the lightest path that preserves correctness: small local defects can be diagnosed, fixed, and verified in one pass; larger, recurring, cross-system, or unclear defects use the full RCA protocol.

1. **Entry** — Load in this order:
   - [ ] `plans/CHARTER.md` if it exists
   - [ ] `plans/ARCHITECTURE.md` if it exists
   - [ ] `plans/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
   - [ ] `slice-<N>.md` relevant to the reported bug (to understand expected behaviour), if applicable
   - [ ] Any linked `verification-matrix.md`, `rca-*.md`, or `security-review-*.md`
   - [ ] Repo contributor guide for testing conventions and commands

   If no slice file exists for the reported bug: work from the symptom description and available code. Surface what you cannot verify from context alone.

2. **Repository discovery** — Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

3. **Classify diagnostic path** — Choose deliberately:
   - **Lightweight diagnostic path** — Small local defect, clear failure surface, single component or file likely, immediate focused proof available, no cross-system uncertainty.
   - **Full RCA path** — Multi-step, cross-system, recurring regression, unclear ownership, high-risk behaviour, failed first-fix attempt, or any defect that will affect future verification or planning.

   Treat user-provided signals ("recent dependency bump", "BlueprintJS may be involved") as hypothesis input, not evidence.

4. **Lightweight diagnostic path** — For small local defects:
   - [ ] Reproduce or localize the failure through the stack trace, failing test, log, or direct code-path inspection
   - [ ] Identify the exact failing contract: expression, expected data shape, actual data shape, and regression source
   - [ ] Confirm root cause with evidence before any production edit
   - [ ] If operating as an implementation-capable agent, apply the minimal fix only after confirmation
   - [ ] Verify with the focused proof: targeted test, affected test, typecheck, or manual reproduction sequence
   - [ ] Persist an RCA only when cross-turn value is high: recurring issue, unclear ownership, cross-system defect, failed first fix, or future specs/plans need the fact

   UI/runtime bug checklist:
   - Stack line or failing component
   - Exact expression or state transition
   - Expected data shape
   - Actual data shape
   - Regression source or contract drift
   - Minimal fix
   - Focused verification

5. **Full RCA: reproduce** — Confirm the exact input, state, or sequence that triggers the symptom. If you cannot reproduce it, you cannot fix it. Stop and gather more information.

6. **Full RCA: generate hypotheses** — Write out 5–7 distinct candidate causes across all plausible layers before touching code. For each hypothesis:
   - State the cause in one sentence
   - Explain why it would produce this specific symptom
   - Identify which layer(s) it implicates (DB / Service / API / Frontend / cross-layer)

   Do NOT stop at 2–3. Premature narrowing is the most common diagnostic error. If you cannot reach 5, you have not looked broadly enough — revisit the symptom.

7. **Full RCA: rank hypotheses** — State the 1–2 most likely causes explicitly. Keep the full hypothesis list — rejected hypotheses become evidence that the diagnosis is complete.

8. **Full RCA: validate** — Use logs, targeted tests, or temporary diagnostic output to confirm or reject the ranked hypotheses.
   - Do NOT apply a code change and see if the symptom disappears — that is not evidence.
   - Diagnostic instrumentation MUST be removed after the root cause is confirmed.
   - If both ranked hypotheses are rejected, promote the next from the list. Do not invent new hypotheses without re-examining the symptom.

9. **Confirm and decide next action** — State the confirmed root cause and evidence. If the next action is a minimal local fix and the environment allows implementation, continue through Direct-Fix or Spec-Fix behaviour. If the next action exceeds QA authority, persist the RCA and hand off with the exact failing proof and next action.

   If the user disputes the diagnosis, return to hypothesis validation.

10. **Repair, handoff, or QA-owned work** — Apply the minimal confirmed fix when localized and within QA authority. Otherwise hand off to Alex for broader implementation work, or to Lance/Katrina when the confirmed root cause is design-caused. Rahat may always proceed when the next action is QA-owned: adding or repairing tests, updating `verification-matrix.md`, documenting RCA evidence, or recording verification findings.

11. **Regression expectation or QA-owned test repair** — Specify the regression proof that was run, added, or must be added. If the missing proof is itself QA-owned test or matrix work, add or repair it and record the evidence.

12. **Write** — Write `[plan_folder]/<initiative-name>/rca-<slug>.md` using `assets/rca-template.md` when full RCA was used or persistence thresholds are met. Use `_system/rca-<slug>.md` only for genuinely global defects with no initiative owner. If a Slice, initiative folder, or initiative `_context.md` is known, do not write RCA under `_system`. Do not create an RCA for a trivial local fix with no future relevance unless the user asks.

13. **Register in context memory** — If an RCA was written, open `[plan_folder]/<initiative-name>/_context.md`. Add `rca-<slug>.md` to `## Live`.

14. **Close** — Apply the Exit and Handoff format from the core skill. Include diagnostic path used, root cause, evidence, fix or handoff, proof run, artifact persistence decision, and next owner.

---

## Definition of Done

- [ ] Diagnostic path selected deliberately
- [ ] Symptom reproduced or localized with evidence before any production edit
- [ ] Lightweight path: exact failing contract, expected shape, actual shape, minimal fix, and focused verification recorded
- [ ] Full RCA path: 5–7 hypotheses generated, 1–2 ranked candidates validated, and rejected hypotheses retained as evidence
- [ ] Root cause confirmed with evidence before fix, QA-owned repair, or handoff
- [ ] Minimal fix applied only when localized and within QA authority
- [ ] RCA written and `_context.md` updated only when persistence thresholds are met
- [ ] Regression proof specified, added, or run
- [ ] Close message: diagnostic path, root cause summary, evidence, fix/handoff, proof, artifact decision, next owner
