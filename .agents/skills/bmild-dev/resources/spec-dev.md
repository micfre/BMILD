# Spec-Dev

Implement the approved outcome within its authorized spec phase. This is the default “write the spec, then develop the spec” path, including independent Comprehensive Review, bounded repairs, and independent re-verification. Explicit implementation-only requests stop at review readiness. A Slice, separate planner invocation, forecast, or advance file inventory is not an entry requirement.

## Additional Context

Read repository guidance, initiative registry, and relevant live product, UX, architecture, ADR, and terminology sections. Use the existing `verification-matrix.md` outcome record when present. Existing Slices supply relevant evidence references; multiple existing Slices do not force a selection question for a clear phase/outcome request. Explicit Slice execution selects Slice-Dev. Never treat stale artifacts as authority. Reuse unchanged, already-loaded sections when freshness is established; reload after uncertain compaction or concurrent edits.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Phase scope.** Resolve MVP/Growth/Vision or a named phase from the user request and authoritative spec. Naming an initiative does not authorize all phases. Ask only if scope remains genuinely ambiguous. Future-phase features remain deferred; necessary foundations cannot conceal unauthorized features.
- **Readiness by meaning.** Establish intent, observable acceptance, usable constraints, and proof. These are the criteria in Sonia's `../bmild-planner/resources/readiness-verification.md`; no sibling-resource read or particular artifact combination is required. Resolve consequential gaps; continue independent authorized work.
- **Engineering judgment.** Choose and revise implementation within committed behavior, security, compatibility, and quality constraints. New files need no approval. Surface better approaches with evidence; resolve actual contract changes through their owners. Do not suppress a better solution merely to minimize the diff.
- **Groundtruth and prove.** Inspect integration boundaries and existing conventions using the most suitable available tools. Use a short working plan or earlier checkpoints when useful, without a mandatory classification stage. Run repository gates and relevant behavioral, abuse, and performance checks; include required documentation. Never claim unrun proof.
- **Continuity without forecasts.** Use selective reads, native context management, and a concise durable checkpoint when needed. Retired `slice_target`, `tokenizer_base`, and `tokenizer_multiplier` values are inert. Do not estimate tokens, predict read/edit inventories, or split outcomes because telemetry is absent.
- **Evidence ownership.** Alex records implementation evidence, not independent review verdicts. Preserve prior review results as history; changed code/contracts/environment makes affected verification pending. Only Rahat closes findings and accepts the outcome.
- **Architecture truth and promotion.** Apply core authority: `committed` binds; `delegated` preserves judgment; `illustrative` is non-binding; `observed` records reality. Record useful facts with provenance; use Lance's criteria and required user decisions for commitment changes.

## Tasks

<!-- commit-posture-preflight:start -->
### Commit-posture preflight

Initialize once per user invocation. Mode switches, bounded repairs, authorized Slice series, and dispatched workers share the original baseline, path ledger, downgrade state, and commit-attempt flag. Workers return evidence and paths; only the coordinator commits. Re-entry reuses this state, never a fresh commit allowance.

Before any edit, parse `.bmild.toml` under the core configuration contract. Posture `0` retains no posture state and performs no Git/format work. For non-zero posture, keep an exact touched-path ledger. Before any configured-posture-`1` mutation, discover active harness and applicable repository guidance (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING*`, and known nested guidance). Denial, unreadable applicable guidance, unresolved conflict, or ambiguous authority downgrades the whole invocation to posture `2`; configured posture `1` satisfies explicit-request permission; per-invocation confirmation pauses before mutation. Authority never increases.

For effective posture `1`, require a Git worktree; record attached branch, `HEAD`, and NUL-safe `git status --porcelain=v1 -z --untracked-files=all`. `current` with detached `HEAD` downgrades to `2`. For `initiative`, validate the confirmed slug with `git check-ref-format --branch`. Retain it when already selected; otherwise require a completely clean baseline, use only `git switch -- <slug>` or `git switch -c <slug>`, then verify branch, `HEAD`, and baseline. Dirty state blocks before implementation and offers message-only continuation. Missing/invalid initiative identity downgrades to `2`. Never stash or contact a remote.
<!-- commit-posture-preflight:end -->

Progress:

- [ ] Step 1: Resolve authorized phase/outcome and live constraints; groundtruth the repository and determine sufficient readiness. Name actual blockers and proceed with independent work.
- [ ] Step 2: Implement the coherent solution. Revise the working plan as evidence changes; permitted concurrent workers need independent tasks and safe integration. Respect harness/user authority and budget.
- [ ] Step 3: Run relevant proof and repository gates, complete required docs, and reconcile the whole authorized outcome against source requirements, not just a task list.
- [ ] Step 4: Reconcile architecture truth. Record durable implementation-confirmed facts as `observed` with code/evidence provenance when useful; do not restate ordinary implementation detail. Resolve any proposed commitment change through Lance's criteria before dependent work proceeds, and mark affected proof pending.
- [ ] Step 5: Create or update the `O-###` outcome section of `verification-matrix.md` using Sonia's template when new. Mint the next unused ID only when no record matches the authorization; never reuse or rename an ID, and update its Outcome Index entry in the same edit. Record phase authorization, scope, source links, implementation evidence, open obligations, and continuation state. Alex may author these execution fields and initial coverage from settled sources without a planner round trip. Set `ready_for_review`, `qa_status: review_requested`, `security_status: review_requested`, and `code_review_status: review_requested` only when implementation obligations are met; otherwise record active/blocked and the exact remaining work. Register the matrix as live; when a new `O-###` is minted, also sync the initiative's `[plan_folder]/rollup.md` registry entry (`Phase`, `Status: active`, `Last updated`) as a mechanical scribe update. Preserve other outcomes. Link affected Slice records when applicable; their implementation fields may project matrix evidence, but only Rahat accepts and archives them. Never create a Slice merely for this path.
- [ ] Step 6: Establish mode eligibility: implementation `ready_for_review`, all required obligations satisfied, docs and proof evidence recorded, and a safe non-empty attributable path set. Failed, blocked, incomplete, no-change, or baseline-overlap work is not commit-ready. Implementation commit readiness does not mean independent acceptance.

<!-- commit-posture-completion:start -->
### Commit-posture completion

Run only after the mode-specific commit-ready gate. Defer execution while authorized review, repairs, or further Slices remain; run at the final eligible invocation boundary using the accumulated ledger and final evidence. If a commit was already attempted in this invocation, skip Git mutation and preserve later changes uncommitted; never treat the resulting HEAD change as a new baseline. Non-ready work creates no commit and no normal proposed message. For a commit-ready non-zero posture, use explicit `conventional-commits` or inspect at most 10 locally reachable non-merge full messages. Ignore empty messages; require at least 3 usable and `ceil(60% × usable)` structural agreement. Record `explicit:conventional-commits`, `history:<matched>/<usable>`, or `fallback:<reason>`; never read remote history.

Author the complete primary intent, attributable material changes, why when needed, and verification/unavailability. Conventional form is `<type>[optional scope][optional !]: <imperative description>`, body, `Tests:`, optional `Initiative:`, and optional `Slice:`. Exclude secrets and unrelated diff content. Transport messages and paths only as literal arguments, structured stdin, or a literal temporary file outside the worktree; never evaluate dynamic content as shell source.

Before effective-posture-`1` execution, re-check guidance for final attributable paths and downgrade the whole invocation on denial/ambiguity. Require unchanged recorded `HEAD`. Reconcile the exact ledger with final NUL-safe status; every attributable path must be repository-relative, clean at baseline, changed now, and accounted for. Overlap or uncertainty downgrades to message-only. Use `git add --intent-to-add -- <paths>` only for recorded new files, capture `preCommitHead`, mark the invocation commit attempt consumed, then execute exactly one normal-hook `git commit --only --file=- -- <literal paths>` with the exact message via stdin (or the safe temporary file).

On failure, preserve content and unrelated index state; restore only BMILD-created intent entries with `git restore --staged --source=HEAD -- <paths>`. On success, require changed `HEAD`, `HEAD^ = preCommitHead`, exact NUL-safe `git diff-tree --no-commit-id --name-only -r -z HEAD` path equality (including renames), clean task paths, and unchanged unrelated baseline state. An invariant breach is reported without history repair. Render the compact core commit line from Exit and Handoff. Never widen paths, reset, amend, revert, retry destructively, or perform network operations.
<!-- commit-posture-completion:end -->

- [ ] Step 7: Continue the authorized engagement. By default, dispatch a full `bmild-qa` Comprehensive Review into a fresh isolated context when available and authorized, honoring a user preference for a separate new window. The bounded QA consult leaf is for one owner-resolution episode and does not substitute for full outcome acceptance. Supply `O-###`, phase, source references, actual code/change identity, runnable evidence, and known issues; do not fork the development transcript. Persist findings, implement authorized bounded repairs through Spec-Fix or Direct-Fix according to governing contract or tracked defect context, then resume this outcome and independent re-verification. Repair authority never expands product scope. A reviewer who authored a production fix cannot accept that fix. If isolated dispatch is unavailable or the user chooses a new window, leave acceptance pending and provide one concise resume instruction grounded in the matrix. Implementation-only requests stop at review readiness; they do not claim `done`.
- [ ] Step 8: Close — report implemented versus independently accepted work accurately. Continue while authorized progress remains; stop for a real decision, access/budget limitation, user-requested boundary, or repeated failed approach requiring new evidence. Never loop on unchanged findings or silently broaden scope.

## Definition of Done

- Authorized phase/outcome implemented and documented, or exact blockers and remaining obligations recorded.
- Required implementation evidence recorded against source requirements; no future-phase feature silently added.
- Durable implementation facts recorded as `observed` when warranted; commitment changes resolved through Lance's criteria; affected prior proof marked pending without losing history.
- Unless explicitly implementation-only, independent acceptance completed or explicitly pending with a usable fresh-window transition. Alex never writes `done` or clears a finding.
