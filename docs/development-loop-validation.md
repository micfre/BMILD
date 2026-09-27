# Development-path validation

## Development paths — 0.6.0, 2026-09-27

Baseline: `adf4d7a6d4c63eb21c02170d436ab2dce9f51c26`. This implementation edits the BMILD skills as source files; it does not use their persona workflows to implement or accept the refactor. ADR 0012 has an explicit dated amendment in local `plans/adr/`; that memory remains Git-ignored, as before. Version metadata and a dated changelog entry prepare 0.6.0; no tag, push, or publication was performed.

### Changed contracts

- Spec-Dev is the default spec-backed path and includes fresh Comprehensive Review, bounded repairs, and independent re-verification. Implementation-only requests stop at review readiness; historical Slices never override a clear outcome request. The retired displayed mode has no active alias.
- Slice Planning creates optional lightweight OKF records with stable numbering, parent O-###, source links, acceptance boundaries, dependencies, useful guidance, and continuation. Delivery Strategy remains advisory. Slice-Dev handles one named or sole eligible Slice unless a series is explicitly authorized; ambiguity and stale dependency proof cannot be silently bypassed.
- The parent matrix owns scoped evidence. Only Rahat accepts and archives Slices. Partial acceptance leaves the parent active; final acceptance requires current source completeness and integrated proof during the last Slice review.
- Direct-Dev removes duplicate discovery and mandatory classification while preserving conditional memory, local-completion default, and optional independent verification. Governing/tracked context redirects fixes even when discovered mid-session; confirmed diagnosis survives the switch and bounded repairs resume the suspended target.
- Point-of-use review assurance remains identical in five resources; commit preflight/completion now match across seven resources. One invocation retains its baseline, ledger, downgrades, and commit allowance through repairs and series. Commit execution waits for the final eligible boundary; delegated workers cannot create additional commits.

### Checks and source review

Skill validation and all nine skill-creator frontmatter validations passed. The 27 repository contract scripts, shell lint, Markdown lint over the CI globs, and whitespace checks are the reproducible structural gates for this revision. `development-paths-contract.sh` checks routing, lean template shape, evidence ownership, and trial-input integrity; existing lifecycle, review, resource-link, and commit tests cover the shared contracts. These checks do not demonstrate model behavior.

An independent source-only reviewer, without the development transcript and without activating BMILD personas, found two reachable inconsistencies: repeated mode entry could renew commit authority, and governing-contract-only fix routing still encountered tracked-artifact-only entry rules. Both were corrected and guarded. The follow-up source review found no remaining actionable issue in those paths, Slice scope/parent state, or template adoption.

The first contract run passed 25 of 27 scripts. Native parity failed because its executable-bit test mutates a protected source file; a permitted rerun passed. The release metadata guard required the new version's dated changelog entry; adding that entry fixed the failure without publishing. PowerShell is unavailable locally, so Windows-native execution remains unrun here; the repository CI matrix defines that lane. A Linux structural pass does not claim Windows/macOS execution.

### Loaded instruction size and avoidable work

Counts are whitespace-separated words for core + SOUL + selected resource, measured against the baseline above; they exclude source artifacts, taxonomies, and conditional gap references. They are diagnostics, not provider tokens or measured costs.

- Spec-Dev: 4,406 → 4,568.
- Direct-Dev: 3,979 → 4,146.
- Sonia readiness: 2,963 → 3,011.
- Comprehensive Review: 4,392 → 4,548.
- Newly optional paths: Slice-Dev 4,346; Slice Planning 2,993, before templates.
- All skill Markdown: 77,444 → 81,635 words. This includes new optional resources and deliberate point-of-use safety duplication; it is not one invocation's context load.

The selected paths grew modestly because explicit review continuation, Slice scope, and invocation-wide commit safety need instructions. The refactor reduces procedural overhead instead: Direct-Dev has one discovery pass and no classification question; fix transitions retain diagnosis; Spec-Dev states readiness criteria locally without a required sibling-resource read; fix resources use relevant live sources and conditional rollup discovery instead of ordered blanket reads. A private Slice refactor does not trigger Sonia, and in-session owner resolution does not create handoff paperwork. The optional Slice resources and templates are not preloaded by Spec-Dev or Direct-Dev. No arbitrary word budget or weaker acceptance bar was used.

### Behavioral trial coverage and limits

The [trial inputs](../tests/evaluations/outcome-execution-cases.json) now cover 27 scenarios. The additions cover implementation-only boundaries, Slice authoring/numbering, dependency selection, ambiguous candidates, private refactors, boundary replanning, partial acceptance, stale dependency evidence, final source/integration reconciliation, discovered contracts, tracked-context fixes, repair-and-resume, and direct independent review. Existing cases cover deferred phases, unavailable isolation, reviewer-authored repairs, source omissions, and unrelated Git work.

For each supported harness (Codex, Claude Code, OpenCode), run the same starting fixtures with the user-selected capable and workhorse models at matched effort/resources. Use existing tier preferences and explicit dispatch choices; do not infer rankings, change models automatically, or use model identity as authority. Record actual model/version, harness, authority, reads, user questions, handoffs, elapsed time, proof, defects, and implementation/review/rework usage. Compare baseline and revised skills against original requirements and code; repeat representative cases and disclose sample size. Unknown telemetry remains unknown.

Live behavioral trials were **not run** in this implementation: the user excluded BMILD workflows, and isolated comparable application fixtures and model runs were not established. Installed harness executables alone do not establish usable provider access, review isolation, or comparative evidence. No claim is made about cross-harness behavior, workhorse reliability, capable-model quality gains, or time/token savings. The trial inputs and protocol are expanded; results await an explicitly scoped evaluation session.

## Earlier refactor evidence

The remaining sections preserve the original 0.5.0 checkpoint and its subsequent refinements. Their counts and claims are historical, not results of the 0.6.0 validation above.

Implementation: Option C, 0.5.0 · 2026-09-16

## Scope and evidence limits

The refactor changes the shipped skill instructions, evidence template, generated consult defaults, documentation, and deterministic regression guards. BMILD personas were not activated during this task. Source-scenario review predicts behavior from instructions; it is not a live workflow trial or proof of speed/quality improvement.

Baseline revision: `fcc4f93e49a199091a47b4f1c197196fb7b51492`. All 18 baseline contract tests passed before this alignment work. The selected direction, estimator retirement, and original reasoning are recorded in the [discussion plan](development-loop-options.md). Local project memory also records ADR 0012 and supersedes the three estimator ADRs; `plans/` remains excluded from version control by repository policy.

## Completed implementation

- At the 0.5.0 checkpoint, outcome execution became the primary spec-backed mode. Authorized phase/outcome and source contracts determine work, including when several legacy Slices exist.
- Sonia assesses sufficient meaning, coverage, and proof; requested delivery strategy remains available without mandatory decomposition.
- The verification matrix carries separate outcome scope, continuation state, implementation evidence, and independent acceptance. Other outcomes and historical evidence survive updates.
- Review requires a fresh context that did not implement the production changes or inherit the developer transcript. Reviewer-authored fixes need another independent reviewer. Security not-reviewed, omitted axes, stale evidence, and unrun required proof do not close work.
- MVP/Growth/Vision boundaries remain binding. Internal implementation strategy and coherent refactors can change without a planning round trip.
- Token estimation, forecasts, calibration state, dedicated scripts/tests/fixtures/CI, and active settings are retired. Historical estimates remain history; obsolete settings are inert.
- All unspecified consult tiers inherit the active model/effort. Explicit dispatch overrides remain binding. Generated packages cover Codex, Claude Code, and OpenCode only.
- Public/data/trust/compatibility contracts remain precise while private implementation choices can be delegated. Existing commit safety and unrelated-work protection remain intact.

### Architecture contract granularity refinement

A subsequent source audit found that execution had become outcome-first more completely than architecture authoring: Lance still consumed the whole PRD as one coverage target, only service contracts carried an explicit committed/delegated split, operational architecture concerns lacked completion criteria, completed architecture still defaulted through Sonia, and Alex's implementation-truth promotion boundary was implicit.

The follow-up refinement keeps one initiative-level `system-design.md` while separating initiative-wide invariants from named outcome/phase contracts. Every new or changed architecture item now carries `Applies to` plus `committed`, `delegated`, `illustrative`, or `observed` disposition. Legacy unlabelled designs require no bulk migration: substantive behavior/data/trust/compatibility/NFR decisions remain binding, clear examples/private sketches remain non-binding, and ambiguous authority applies Lance's criteria. Conditional completion criteria cover system/trust boundaries, quality attributes, failure and consistency behavior, operability, rollout, compatibility, and evolution without requiring irrelevant sections. Later phases remain non-binding context. Completed architecture routes directly to Alex when implementation is next; Sonia remains conditional on a real readiness, coverage, coordination, or requested strategy need. Alex may record implementation-confirmed observations with provenance, but only Lance's criteria and required user decisions can create or change commitments. Planner and reviewer consumers apply the same disposition semantics.

## Regression checks

Validation result at the original 0.5.0 checkpoint: all 16 contract scripts, skill validation, ShellCheck, Markdown lint, and the local release-package integrity check passed. The subsequent architecture refinement adds a seventeenth contract script; current validation results are reported from the working tree rather than retroactively attributed to the earlier checkpoint. These checks establish source and packaging consistency, not comparative model performance.

Run from the repository root:

```sh
bash scripts/validate-skills.sh
bash scripts/lint.sh
for test in tests/*-contract.sh; do bash "$test"; done
```

The 0.5.0 suite had 16 contract scripts: two estimator-specific contracts were removed and `outcome-execution-contract.sh` was added. Architecture and product/UX outcome refinements added two more, bringing the pre-alignment suite to 18. The alignment work adds lifecycle-focused guards; use the repository glob above rather than maintaining another hard-coded current count. Estimator-only golden/equivalence runners were retired with the calculator. Keep the distinction between source-contract guards and executable tests: marker checks do not demonstrate that an LLM follows a rule. Generator tests parse generated TOML and check inherited defaults; commit tests exercise isolated Git fixtures with unrelated state and hook failures.

`outcome-execution-contract.sh` checks primary entry/phase/evidence requirements, byte-identical acceptance blocks at point of use in all five review modes, fixer independence, estimator surface removal, and literal skill-local resource references. `architecture-contract-granularity-contract.sh` protects architecture outcome scoping, disposition semantics, conditional system concerns, direct post-design routing, and the observation-to-commitment promotion boundary. Existing tests retain shared gap/promotion/session/commit/Fix Election identity and authority boundaries.

ShellCheck and Markdown lint cover the changed sources. The local package check builds with `CI=1` to avoid tag/push operations, opens the archive, parses generated roles, checks absence of estimators, and verifies that each generated skill path resolves inside the archive. This found and corrected an existing absolute-temporary-path leak in release-generated consult definitions. No tag, push, or release publication is part of this refactor.

## Source-scenario review

An independent source reviewer read the baseline through immutable Git objects, then inspected the revised skill text without activating personas. Its revised pass surfaced two residual conflicts: QA fix instructions still allowed self-approval after proof, and old Slice-scope routes still sent authorized internal repairs back to Sonia. Both were corrected in the fix resources, with regression guards. The reviewer's revised pass ended at a tool usage limit; it was not a completed independent behavioral trial. The remaining source reconciliation and deterministic checks were completed locally.

The checked source scenarios now have these intended dispositions:

- Approved MVP with no Slices: primary outcome execution; Growth/Vision remain deferred.
- Two legacy Slices and a necessary shared helper: no artificial Slice selection or recut; verify the authorized whole.
- Fresh-window review with an omitted matrix requirement: inspect original sources, add the obligation, and require proof.
- Different active model: no exact-model eligibility gate; explicit model-specific requests still matter.
- QA/code clear but security not-reviewed: acceptance remains pending.
- Old estimator keys with no telemetry: no calculator, forecast, or blocking migration.
- Reviewer-authored repair: different fresh reviewer accepts it.
- Multiple outcome records: no unrelated closure, overwrite, or premature matrix archival.
- Changed source/code/environment: affected proof becomes pending; history and unaffected evidence remain.
- Review-only request: no production edits.

## Source-size measurements

Whitespace-separated words, measured before and after this refactor (diagnostics, not token/cost measurements):

- Alex core + SOUL + primary development resource: 3,963 → approximately 3,950.
- Sonia core + SOUL + readiness resource: 3,180 → approximately 2,644.
- Rahat core + SOUL + comprehensive review: 3,949 → approximately 4,039; explicit independence and quality obligations account for the added guidance.
- All skill Markdown at the measurement checkpoint: 72,608 → 65,101 words, including copies that are not all loaded in one session.
- Retired estimator implementations and their six dedicated test/runners: 1,910 lines, before fixtures, CI, configuration, and instruction references.

Small subsequent reconciliation edits can change these counts. Fewer words on disk is not proof of runtime savings. The main change removes mandatory prediction, artifacts, routing branches, and execution constraints; independent assurance is intentionally retained.

## Reproducible behavioral trials

[Scenario inputs](../tests/evaluations/outcome-execution-cases.json) define realistic requests, setup facts, and observable checks. These are trial inputs, not a claim of executed tests. Use representative application repositories as well as BMILD itself; text-only compliance cannot establish code quality.

For each selected case, prepare matching isolated starting repositories and approved specs. Compare baseline BMILD at the revision above, the new skills, and a minimal spec/native-executor/independent-review baseline. Keep task, model/version/effort, tools, authority, and resource limits comparable. Record the native harness and its actual ability to isolate review context. Evaluate at least one supported weaker model and one current stronger model; exercise Codex, Claude Code, and OpenCode before making first-class behavioral portability claims. Repeat representative cases and disclose sample size rather than treating one successful run as reliable evidence.

Capture elapsed time to independently verified completion, user interventions, implementation/review/rework usage, defects, missed requirements, phase drift, security evidence, scaling limits, and maintainability. Separate actual provider input/output/cache/cost and peak-context signals when available; unknown telemetry stays unknown. Assess both quality at matched resources and resources at matched quality. Grade from the original spec and code, ideally blinded to workflow; include user judgment of fit where tests cannot establish it.

Require no false completion with unmet mandatory obligations, applicable security gaps, or stale proof. Establish weaker-model non-regression margins and spending limits before the trials. Investigate meaningful loss against the minimal native baseline. Do not add fallback machinery based solely on a speculative failure; demonstrate the failure and compare a simpler remedy first.

**Not yet demonstrated:** comparative latency/token savings, stronger-model quality gains, weaker-model non-regression, and live independent-review behavior across all three harnesses. Deterministic checks and source review support the refactor's internal consistency; those empirical outcomes require the trials above.
