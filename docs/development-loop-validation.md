# Outcome execution validation

Implementation: Option C, 0.5.0 · 2026-09-16

## Scope and evidence limits

The refactor changes the shipped skill instructions, evidence template, generated consult defaults, documentation, and deterministic regression guards. BMILD personas were not activated during this task. Source-scenario review predicts behavior from instructions; it is not a live workflow trial or proof of speed/quality improvement.

Baseline revision: `fcc4f93e49a199091a47b4f1c197196fb7b51492`. All 17 baseline contract tests passed before editing. The selected direction, estimator retirement, and original reasoning are recorded in the [discussion plan](development-loop-options.md). Local project memory also records ADR 0012 and supersedes the three estimator ADRs; `plans/` remains excluded from version control by repository policy.

## Completed implementation

- Outcome Development is the primary spec-backed mode. Authorized phase/outcome and source contracts determine work, including when several legacy Slices exist.
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

The 0.5.0 suite had 16 contract scripts: two estimator-specific contracts were removed and `outcome-execution-contract.sh` was added. The architecture refinement adds `architecture-contract-granularity-contract.sh`, bringing the current suite to 17. Estimator-only golden/equivalence runners were retired with the calculator. Keep the distinction between source-contract guards and executable tests: marker checks do not demonstrate that an LLM follows a rule. Generator tests parse generated TOML and check inherited defaults; commit tests exercise isolated Git fixtures with unrelated state and hook failures.

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

[Scenario inputs](../tests/evaluations/outcome-execution-cases.json) define 14 realistic requests, setup facts, and observable checks. These are trial inputs, not a claim of executed tests. Use representative application repositories as well as BMILD itself; text-only compliance cannot establish code quality.

For each selected case, prepare matching isolated starting repositories and approved specs. Compare baseline BMILD at the revision above, the new skills, and a minimal spec/native-executor/independent-review baseline. Keep task, model/version/effort, tools, authority, and resource limits comparable. Record the native harness and its actual ability to isolate review context. Evaluate at least one supported weaker model and one current stronger model; exercise Codex, Claude Code, and OpenCode before making first-class behavioral portability claims. Repeat representative cases and disclose sample size rather than treating one successful run as reliable evidence.

Capture elapsed time to independently verified completion, user interventions, implementation/review/rework usage, defects, missed requirements, phase drift, security evidence, scaling limits, and maintainability. Separate actual provider input/output/cache/cost and peak-context signals when available; unknown telemetry stays unknown. Assess both quality at matched resources and resources at matched quality. Grade from the original spec and code, ideally blinded to workflow; include user judgment of fit where tests cannot establish it.

Require no false completion with unmet mandatory obligations, applicable security gaps, or stale proof. Establish weaker-model non-regression margins and spending limits before the trials. Investigate meaningful loss against the minimal native baseline. Do not add fallback machinery based solely on a speculative failure; demonstrate the failure and compare a simpler remedy first.

**Not yet demonstrated:** comparative latency/token savings, stronger-model quality gains, weaker-model non-regression, and live independent-review behavior across all three harnesses. Deterministic checks and source review support the refactor's internal consistency; those empirical outcomes require the trials above.
