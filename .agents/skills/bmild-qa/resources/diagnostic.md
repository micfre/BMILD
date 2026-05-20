# Diagnostic

Track down the root cause of an unexpected failure or bug. Use the lightest path that preserves correctness: small local defects can be diagnosed, fixed, and verified in one pass; larger, recurring, cross-system, or unclear defects use the full RCA protocol.

## Additional Context

Load in this order:
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/context-map.md` if it is relevant
- `[plan_folder]/adr/` entries relevant to the failure surface
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `slice-<N>.md` relevant to the reported bug (to understand expected behaviour), if applicable
- Any linked `verification-matrix.md`, `rca-*.md`, or `security-review-*.md`
- Repo contributor guide for testing conventions and commands

If no slice file exists for the reported bug: work from the symptom description and available code. Surface what you cannot verify from context alone.

## Additional Norms

**Repository discovery.** Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

**Path selection criteria.** Choose deliberately before any code inspection:
- **Lightweight diagnostic path** — Small local defect, clear failure surface, single component or file likely, immediate focused proof available, no cross-system uncertainty.
- **Full RCA path** — Multi-step, cross-system, recurring regression, unclear ownership, high-risk behaviour, failed first-fix attempt, or any defect that will affect future verification or planning.

Treat user-provided signals ("recent dependency bump", "BlueprintJS may be involved") as hypothesis input, not evidence.

**UI/runtime bug checklist (lightweight path reference):**
- Stack line or failing component
- Exact expression or state transition
- Expected data shape
- Actual data shape
- Regression source or contract drift
- Minimal fix
- Focused verification

## Tasks

Progress:

- [ ] Step 1: Classify diagnostic path — lightweight or full RCA (criteria in Additional Norms).
- [ ] Step 2 (Lightweight — for small local defects): Reproduce or localize the failure through the stack trace, failing test, log, or direct code-path inspection. Identify the exact failing contract: expression, expected data shape, actual data shape, and regression source. Confirm root cause with evidence before any production edit. If operating as an implementation-capable agent, apply the minimal fix only after confirmation. Verify with the focused proof: targeted test, affected test, typecheck, or manual reproduction sequence. Persist an RCA only when cross-turn value is high: recurring issue, unclear ownership, cross-system defect, failed first fix, or future specs/plans need the fact.
- [ ] Step 3 (Full RCA — Reproduce): Confirm the exact input, state, or sequence that triggers the symptom. If you cannot reproduce it, you cannot fix it — stop and gather more information.
- [ ] Step 4 (Full RCA — Hypothesize): Write out 5–7 distinct candidate causes across all plausible layers before touching code. For each hypothesis: state the cause in one sentence, explain why it would produce this specific symptom, identify which layer(s) it implicates (DB / Service / API / Frontend / cross-layer). Do NOT stop at 2–3 — premature narrowing is the most common diagnostic error. If you cannot reach 5, revisit the symptom.
- [ ] Step 5 (Full RCA — Rank): State the 1–2 most likely causes explicitly. Retain the full hypothesis list — rejected hypotheses become evidence that the diagnosis is complete.
- [ ] Step 6 (Full RCA — Validate): Use logs, targeted tests, or temporary diagnostic output to confirm or reject the ranked hypotheses. Do NOT apply a code change and see if the symptom disappears — that is not evidence. Remove all diagnostic instrumentation after the root cause is confirmed. If both ranked hypotheses are rejected, promote the next from the list; do not invent new hypotheses without re-examining the symptom.
- [ ] Step 7: State the confirmed root cause and evidence. If the user disputes the diagnosis, return to hypothesis validation.
- [ ] Step 8: Repair, handoff, or QA-owned work. Apply the minimal confirmed fix when localized and within QA authority. Otherwise hand off to Alex for broader implementation, or to Lance/Katrina when the confirmed root cause is design-caused. Rahat may proceed when the next action is QA-owned: adding or repairing tests, updating `verification-matrix.md`, documenting RCA evidence, or recording verification findings.
- [ ] Step 9: Specify the regression proof that was run, added, or must be added. If the missing proof is itself QA-owned test or matrix work, add or repair it and record the evidence.
- [ ] Step 10: Write `[plan_folder]/<initiative-name>/rca-<slug>.md` using `assets/rca-template.md` when full RCA was used or persistence thresholds are met. Use an initiative folder whenever an initiative owner exists. Do not create an RCA for a trivial local fix with no future relevance unless the user asks.
- [ ] Step 11: If an RCA was written, open `[plan_folder]/<initiative-name>/registry.md` and add `rca-<slug>.md` to `## Live`.
- [ ] Step 12: Run the Pre-exit Checkpoint from the core skill before finalizing the RCA or handoff decision.
- [ ] Step 13: Close — apply the Exit and Handoff format from the core skill. Include: diagnostic path used, root cause, evidence, fix or handoff, proof run, artifact persistence decision, and next owner.

## Definition of Done

- [ ] Diagnostic path selected deliberately
- [ ] Symptom reproduced or localized with evidence before any production edit
- [ ] Lightweight path: exact failing contract, expected shape, actual shape, minimal fix, and focused verification recorded
- [ ] Full RCA path: 5–7 hypotheses generated, 1–2 ranked candidates validated, and rejected hypotheses retained as evidence
- [ ] Root cause confirmed with evidence before fix, QA-owned repair, or handoff
- [ ] Minimal fix applied only when localized and within QA authority
- [ ] RCA written and `registry.md` updated only when persistence thresholds are met
- [ ] Regression proof specified, added, or run
- [ ] Close message: diagnostic path, root cause summary, evidence, fix/handoff, proof, artifact decision, next owner
