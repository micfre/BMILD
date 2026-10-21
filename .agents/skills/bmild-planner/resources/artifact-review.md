# Artifact Review

Run the optional Artifact Reviewer Gate over one live design-tier artifact — `prd.md`, `ux-design.md`, or `system-design.md`. The gate challenges the artifact's *quality* with independent reviewers; it never determines outcome readiness, authorizes implementation, or sets Rahat's QA statuses. This resource is explicitly invoked by the operator or accepted from a design persona's finalize-hook offer; it never runs by default.

## Additional Context

Read `.bmild.toml`, the initiative `registry.md` (only a `## Live` artifact is reviewable), the target artifact, and the initiative `context.md` when present. Reviewer prompts live in `assets/artifact-review/` (`rubric-walker.md`, `adversarial-lens.md`). Never treat a `## Stale` artifact as current truth; name the staleness driver instead of reviewing it.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- **Fixed baseline.** Every run executes the artifact-specific rubric walker plus the adversarial lens — both, always. Additional risk lenses (security stakes, cross-team seams, heavy data models) may extend the baseline when the artifact's stakes warrant; nothing may remove or replace the floor.
- **Independence is the product.** Each baseline lens runs in an isolated reviewer context — a subagent worker or a separate fresh session — that did not author the artifact and holds no authoring transcript. A same-context reread, a persona rename, or an owner-run finalize hook is never independent. When isolation is unavailable on the current harness, the result is `incomplete`; no fallback path may produce `clear`.
- **Containment.** Each reviewer writes its full report to the run folder and returns only a compact summary (verdicts, up to five critical/high one-liners, report path). The orchestrating context never holds full reviewer text.
- **Evidence freshness.** Record the artifact's source identity at entry (path, initiative, content hash or exact `HEAD`/timestamp). Recheck identity immediately before consolidation. A material change during the run invalidates the run — report the invalidation, do not issue a current result — and the next run starts a new review identity.
- **Ownership stays with the owner.** Findings return to the artifact owner with an unset disposition per finding: `apply | discuss | defer | ignore`. The owner changes only the contract they own under normal authority rules. I never edit another owner's substantive contract during a review, and a finding whose fix would edit the spec under review from the review session itself is rejected.
- **Result vocabulary.** Overall result is exactly one of `clear | findings_open | incomplete`; findings carry `critical | high | medium | low`; dimensions carry `strong | adequate | thin | broken`. `clear` requires the full fixed baseline completed against the current artifact identity, no unresolved critical/high finding, and every remaining finding dispositioned. These are artifact-review states, not approvals and not `qa_status` values; report them beside, never into, readiness or QA vocabulary.
- **Full-rerun semantics.** After the owner applies changes, a new run repeats the full fixed baseline against the new artifact identity. Targeted remediation checks may close individual findings but can never issue `clear`.

## Tasks

Progress:

- [ ] Step 1: Resolve the live artifact and its owner; confirm the operator's explicit invocation. Record source identity (path, initiative, hash/`HEAD`/timestamp) and create the run folder `[plan_folder]/<initiative>/reviews/artifact-review-<artifact-slug>-<date>-<seq>/`.
- [ ] Step 2: Declare the run: fixed baseline (rubric walker + adversarial lens) plus any stake-warranted additional lenses, each lens's isolation mechanism, and the review identity.
- [ ] Step 3: Dispatch each lens as an isolated reviewer with the artifact (and `context.md` when present) plus its prompt file. Each reviewer writes its full report into the run folder and returns only its compact summary. An unavailable isolation mechanism or a failed baseline lens stops the run at `incomplete`.
- [ ] Step 4: Recheck artifact identity. On a material change, invalidate the run and say so. Otherwise consolidate completed summaries into the run's `report.md`: overall result, per-dimension judgments, severity-consolidated findings with locations, lower-severity counts, and per-finding unset dispositions for the owner.
- [ ] Step 5: Emit the compact result to the operator: overall result, critical/high findings, lower-severity counts, and report locations. On `incomplete`, provide standalone continuation prompts — one per unrun lens — that a fresh session can execute verbatim (artifact path, identity, lens prompt path, report destination).
- [ ] Step 6: Route findings to the artifact owner for disposition; record dispositions beside the findings in `report.md` when returned. Do not modify the artifact, the matrix, or any QA status. A re-review after owner changes is a new run with a new identity and the full baseline.

## Definition of Done

- One artifact reviewed against a completed fixed baseline in isolated contexts, or an honest `incomplete` with usable continuation prompts.
- Result, dimensions, findings, dispositions, and review identity recorded in the run folder; ownership and authority boundaries intact — no readiness, authorization, or QA verdict issued.
