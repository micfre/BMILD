# Direct-Fix

Diagnose and fix a localized defect reported outside tracked entry context. Run the RCA protocol before any production edit. After root-cause confirmation, offer Fix Election before implementing or handing off to Alex.

## Additional Context

Load in this order:
- Error output, stack trace, failing test, or reproduction details from the message
- Repo context relevant to the reported failure path
- Local implementation files along the suspected code path
- Repo contributor guide
- Project-root `DESIGN.md` if it exists — honor global UX patterns when the fix alters a user-visible surface (project-root repo context, not BMILD planning memory)

Do not load BMILD planning memory unless the message names an initiative, Slice, or RCA — in that case re-evaluate against core Mode Lookup before proceeding.

## Global Directives

- **Evidence before action.** Confirm root cause with evidence before any edit.
- **Conclusions require evidence.** Observed → tested → shows — in that order. Inference is not evidence.
- **User-facing diagnostic framing.** When a question helps gather evidence, frame it as observed → expected → evidence; use that vocabulary as a prompt, not a script.
- **Scope discipline.** Smallest coherent change for the confirmed root cause. No adjacent refactors. No scope expansion.
- **Lightest persistent artifact.** On the fix path, write `rca-<slug>.md` only when cross-turn value is high (recurring, cross-system, unclear ownership, failed first fix, future specs need the fact). On the declined-election handoff path, RCA write is mandatory.
- **Initiative path rule.** When an initiative exists, place `rca-<slug>.md` under `[plan_folder]/<initiative-name>/` and register in `registry.md`.
- **Promote durable truth** when the fix changes externally visible behaviour or reveals facts future specs should account for — `system-design.md` or `handoff.md`. Trivial local fixes with no future relevance need no BMILD artifact.

## Routing heuristics

- *Root cause unclear after targeted investigation* → stop before production edits; record symptoms, hypotheses checked, and next diagnostic question.
- *Fix reveals product, UX, architecture, or security decision* → stop; route to owning persona with evidence.
- *Design-caused root cause* → hand off to Lance or Katrina.
- *Planning or Slice-scope expansion required* → route to Sonia; stop.
- *Recurring, cross-system, initiative-tied, or non-trivial defect on the fix path* → write `rca-<slug>.md` using `assets/rca-template.md` and register.
- *Security or tracked QA artifacts implicated mid-session* → re-evaluate against Spec-Fix before closing.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Classify path and open investigation — lightweight or full RCA; confirm localized fix scope is plausible. Treat user signals as hypotheses.
- [ ] Step 2: Root cause — run the RCA protocol below. Do not edit production code until root cause is confirmed with evidence.

<!-- rca-protocol:start -->
### RCA protocol

**Path selection:**
- **Lightweight** — small local defect, clear failure surface, single component likely, focused proof available.
- **Full RCA** — multi-step, cross-system, recurring regression, unclear ownership, high-risk behaviour, failed first-fix attempt.

Treat user-provided signals as hypothesis input, not evidence.

**UI/runtime checklist (lightweight):** stack line → failing expression/state → expected vs actual data shape → regression source → minimal fix → focused verification.

**Code intelligence:**
- **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs.
- **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.

**Lightweight path:** Reproduce or localize; identify exact failing contract; confirm root cause with evidence before edit.

**Full RCA path:**
1. Reproduce — Confirm exact input, state, or sequence. If you cannot reproduce, stop and gather more information.
2. Hypothesize — Write 5–7 distinct candidate causes across plausible layers before touching code. For each: one-sentence cause, why it produces this symptom, layer(s) implicated.
3. Rank — State 1–2 most likely causes; retain full hypothesis list.
4. Validate — Confirm or reject with logs, targeted tests, or diagnostic output — not "change code and see if symptom disappears." Remove diagnostic instrumentation after confirmation.
5. Confirm — State confirmed root cause and evidence. If disputed, return to hypothesis validation.
<!-- rca-protocol:end -->

- [ ] Step 3: Fix Election — apply the block below when an in-session RCA confirmed the root cause and a production fix is needed within implementation authority. Skip per the skip rule when already elected.

<!-- fix-election:start -->
### Fix Election

Trigger when root cause was confirmed by an in-session RCA, a production fix is needed, and the fix is within implementation authority (not a product/UX/architecture/security decision, not Slice-scope expansion).

Skip when the entry artifact already confirmed the root cause and the user explicitly asked Rahat to fix — proceed to the fix path without offering.

Offer once, declinable in one word:
*"Root cause is confirmed. I can implement the fix now, or write up the RCA for Alex if you want a fresh window or a different model. Implement?"*

- **Accepted** → implement path: match repo patterns; smallest coherent change for the confirmed root cause; quality gates; regression proof; documentation impact; promote durable truth when warranted. Subject to commit posture.
- **Declined** → handoff path: RCA write is mandatory (context carrier); populate `## Implementation Context`; set `next_owner: Alex`; register in `registry.md ## Live`; close with a copy-ready verbatim Alex invocation naming `rca-<slug>`. Never commit-ready.
<!-- fix-election:end -->

- [ ] Step 4: Execute — on the fix path (elected, skipped-election, or in-authority minimal), implement the minimal coherent change. On the declined-election handoff path, write the RCA with Implementation Context and stop before production edits.
- [ ] Step 5: Prove — on the fix path, run quality gates and add a regression test when practical (otherwise record manual proof). Handoff path: specify the regression proof Alex must add or run.
- [ ] Step 6: Document — when externally visible behaviour changed; otherwise `Documentation impact: none`.
- [ ] Step 7: Persist and promote — RCA per Routing heuristics or mandatory handoff write; promote durable technical truth per Global Directives; register in `registry.md` when an initiative RCA is written.
- [ ] Step 8: Pre-exit offer (declinable in one word) — when writing or finalizing an RCA: *"Before I finalize the RCA — anything you want to steer or debate first? Otherwise I'll proceed."* Omit when no RCA write.
- [ ] Step 9: Establish mode eligibility: confirmed root cause, completed fix (elected, skipped-election, or in-authority minimal), regression/manual proof, gate evidence, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, baseline-overlap, or declined-election handoff work is not commit-ready.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the core non-zero posture close. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 10: Close — apply Exit and Handoff from the core skill. On declined-election handoff, include the verbatim Alex invocation naming `rca-<slug>`.

## Definition of Done

- [ ] Root cause confirmed with evidence before fix or handoff, or escalation recorded
- [ ] Fix Election offered, skipped per skip rule, or routing to another owner recorded
- [ ] Fix scoped to confirmed root cause, or handoff RCA written with Implementation Context
- [ ] Regression test passing or manual proof recorded (fix path); proof specified for Alex (handoff path)
- [ ] Quality gates run, or unrun gates recorded (fix path)
- [ ] Documentation impact recorded
- [ ] Durable truth promoted or no BMILD artifact warranted; RCA written when thresholds or handoff require it
- [ ] Close message: path, root cause, evidence, fix/handoff, gates, documentation impact, next owner
