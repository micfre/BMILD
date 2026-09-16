# BMILD development loop: manage the floor, leave the ceiling open

Implementation reference · 2026-09-16 · Option C and estimator retirement authorized

This evaluates the current skills as product source, without activating BMILD personas. The user selected Option C and clarified the constraints recorded below. The user subsequently authorized execution. The source findings below describe baseline revision `fcc4f93e49a199091a47b4f1c197196fb7b51492`; retrieve historical sources with `git show <revision>:<path>`. Current implementation and validation are recorded in [development-loop-validation.md](development-loop-validation.md).

## 1. Selected direction

**Selected: Option C — execute against an approved outcome and independently verify the result.** This becomes BMILD's primary development workflow, including activation, context loading, artifacts, execution, and review. It replaces the Slice-centered execution contract; it is not an extra mode bolted onto that contract. Decomposition remains an engineering technique the executor can use when helpful.

Codex, Claude Code, and OpenCode are the first-class design and validation targets. Other harnesses may work through compatibility, without additional BMILD design effort. Native execution remains an evaluation baseline, not a competing product direction. Options A, B, and D below are retained as the record of alternatives considered.

The selected direction respects the spec's MVP/Growth/Vision phases and supports independent review in a separate, new context window. The revised recommendation is to retire token estimation entirely, including its optional/fallback path. The user authorized the revised plan, including retirement, before implementation.

Do not make “fewer Slices” the final objective. A single mandatory Slice can still carry the same predictive paperwork, ownership boundaries, and restricted judgment. The objective is a shorter path from user intent to a demonstrably good result, with more room for capable models to improve that result.

The strongest justified conclusion from this source audit is that BMILD contains explicit constraints that can limit capable execution. Their actual performance cost, and the benefit of removing each, remain to be measured. This proposal does not claim benchmark results for Astra or any other model. The user's account of BMILD's original model assumptions motivates re-evaluation; it is not a performance measurement.

## 2. What “full capability” should mean

BMILD should allow the executor to use its best available reasoning, tools, context management, experimentation, implementation strategy, and verification methods within the user's actual authority and constraints. A better model should improve the attainable result without first requiring a BMILD release that recognizes its name.

That includes the ability to:

- Understand the whole authorized outcome and optimize across artificial task boundaries.
- Choose a cohesive change, a sequence of changes, or concurrent independent work when the harness and user permit it. Design explicitly for Codex, Claude Code, and OpenCode; support other harnesses only as existing compatibility allows, without additional design effort.
- Discover an unexpectedly better design, demonstrate the benefit, and obtain any consequential decision without losing the implementation context.
- Spend additional reasoning or tool effort where it improves user value, security, maintainability, or performance within the agreed budget.
- Change its internal plan as the code teaches it something, without treating each revision as a change to the user's requirements.
- Continue through implementation, review, authorized remediation, and re-verification without making the user operate a persona relay. Continuity of the engagement must support a separate, new review context window; it does not require continuity of the developer's conversation context.
- Identify where the written spec underserves the user's vision and present an improvement rather than either silently changing scope or silently delivering an inferior result.

Full capability does not mean unlimited scope, automatic spending on multiple agents, or trusting self-reported confidence. Neither does it mean maximum autonomy on every task. The user may choose collaboration, tighter control, or a smaller budget. Those are user preferences, not limitations imposed by a persona's fictional job description.

The spec's MVP/Growth/Vision boundaries remain binding. Execution freedom applies inside the authorized phase and outcome; it does not authorize future-phase features because they seem useful or convenient. A genuine need to change phase scope is a product decision, recorded in the source spec before dependent implementation proceeds.

**Design principle:** Keep durable requirements, important constraints, truthful evidence, and consequential user decisions explicit. Let execution strategy remain revisable. Increase support when evidence shows a need; do not lower the quality bar when support decreases.

## 3. Findings from the current source

### 3.1 The normal spec-backed entry point is a Slice

Alex's routing (`.agents/skills/bmild-dev/SKILL.md` at the baseline revision) selects Spec-Dev from a named existing Slice or exactly one eligible Slice. Multiple candidate Slices trigger a selection question. Direct-Dev already supports bounded work without a Slice, including durable changes and conditional memory loading, so BMILD does not universally prohibit development without planning.

“Implement this approved initiative outcome” becomes the primary development mode, bounded by its authorized spec phase. Core routing, persona instructions, context loading, completion state, and review all start from that contract. Existing Slice artifacts supply historical or transitional context without remaining a hidden prerequisite. Direct fixes and exploratory work keep appropriate entry points, but outcome execution is neither a Slice exemption nor a special case of Direct-Dev.

### 3.2 Planning predicts implementation details before implementation discovers them

Phase-scoped planning (`.agents/skills/bmild-planner/resources/phase-scoped-planning.md` at the baseline revision) requires vertical decomposition, budgeting for each Slice, coverage mapping, artifact registration, and a one-Slice-at-a-time handoff. The Slice template (`.agents/skills/bmild-planner/assets/slice-template.md` at the baseline revision) contains 16 second-level sections, including predicted reads, predicted edits, new-file estimates, a reads checklist, estimator output, and planning notes.

Useful discovered entry points can help a constrained model or a fresh worker. Mandatory forecasts go further: they require Sonia to explore a codebase that Alex must subsequently groundtruth. The likely costs are duplicated discovery, stale predictions, and attention spent maintaining a model of the work rather than improving the work. Remove predicted read/edit inventories as required artifacts. An executor can keep useful navigation notes without classifying files for a budget calculation or maintaining a complete advance inventory.

### 3.3 An acknowledged estimate becomes a hard execution boundary

The estimator identifies itself as an `informed_guess`; its implementation (`.agents/skills/bmild-planner/scripts/run-budget-slice.sh` at the baseline revision) uses fixed byte/token, symbol-read, symbol-edit, item-overhead, and turn-reserve assumptions. Planning nevertheless requires splitting, recutting, or handing back when the result exceeds the target.

**Revised recommendation: remove the estimator from the shipped Option C workflow, rather than retain it as optional diagnostics or a fallback.** The user's experience is that it is heavy and inaccurate. This source audit establishes the predictive assumptions and maintenance footprint, but has not measured prediction error. There is no demonstrated benefit here sufficient to justify preserving it by default.

The two estimator implementations contain 883 lines. Their golden, equivalence, telemetry-contract, and parallel-run tests add 1,027 lines, before fixtures, CI, configuration, documentation, and skill instructions. These are maintenance-size counts, not runtime token costs. The runtime cost also includes deciding whether to estimate, predicting inputs, interpreting the output, and keeping forecasts current. Making it optional retains those concepts and a selection branch; it does not make their cost disappear.

More fundamentally, the estimator predicts occupancy for a preconstructed implementation Slice. Option C delegates how to execute an outcome to the agent and harness, including continuation across contexts. A forecast based on an advance file inventory is poorly matched to that decision. The case for removal does not depend on every supported model having a particular advertised context size or on assuming large windows have perfect attention.

Retain ordinary context discipline: selective reads, durable decisions and unresolved obligations, native context management, and a concise continuation checkpoint when needed. Use actual harness signals when available; their absence does not trigger a BMILD calculator, a mandatory preflight probe, or a guessed context limit. Context exhaustion or attention loss calls for restoring the working context or changing the execution approach, without automatically changing product scope.

Retire the scripts, estimator-only tests/fixtures/CI jobs, budget fields, estimator-calibration Actuals, and the `slice_target`, `tokenizer_base`, and `tokenizer_multiplier` settings. Preserve historical artifacts and their estimates as history. Document obsolete settings as inert and remove them from active configuration guidance; do not introduce an estimator compatibility mode or block work on their presence. Keep measured resource usage in the evaluation harness when available, not as compulsory per-outcome bookkeeping.

Reintroducing estimation would require a demonstrated failure that simpler context handling does not address, evidence that an estimator improves end-to-end outcomes after accounting for its own overhead, and validation across relevant models and harnesses. Prior investment and hypothetical fallback value are insufficient reasons to keep it.

### 3.4 Implementation strategy is too easily treated as governed scope

Spec-Dev (`.agents/skills/bmild-dev/resources/spec-dev.md` at the baseline revision) says to work acceptance criteria one by one and to put a better architectural approach in notes rather than detour. Replanning (`.agents/skills/bmild-planner/resources/replanning.md` at the baseline revision) permits at most one recut pass, freezes active work unless fundamentally invalid, and requires a new Slice for materially shifted recovery scope; new files beyond planned reads/edits appear among its triggers.

Preserving completed evidence and controlling product scope are valuable. Requiring a planning episode to change an implementation boundary is often avoidable. File discovery, task ordering, and recovery work can change while the authorized outcome remains identical. A fixed one-pass limit also substitutes a process constant for a judgment about progress and cost.

### 3.5 Readiness sometimes tests document shape instead of sufficient meaning

Readiness verification (`.agents/skills/bmild-planner/resources/readiness-verification.md` at the baseline revision) permits a complete architecture-only or UX-only initiative with no PM artifacts, but blocks when both design artifacts exist without PM artifacts. A brief without a PRD also blocks.

Those shapes may reveal missing product intent, but they do not establish its absence. Adding a useful UX document to a sufficient architecture-only contract should not automatically make the same work unready. Check whether purpose, scope, behavior, constraints, and proof are sufficiently established for the authorized work. Keep high-quality spec authoring; allow an explicit record of where the needed content lives instead of requiring redundant documents purely for eligibility.

There is also a routing inconsistency: planner core (`.agents/skills/bmild-planner/SKILL.md` at the baseline revision) defaults to full-initiative planning when scope is not phase-named, while the full-initiative resource (`.agents/skills/bmild-planner/resources/full-initiative-planning.md` at the baseline revision) says to use it only on explicit request. Removing accidental broad planning is a small, immediately useful correction.

### 3.6 Model identity is used as a proxy for permission and capability

The gap-resolution contract (`.agents/skills/bmild-dev/references/gap-resolution.md` at the baseline revision) allows guest authorship only when the harness attests an exact match to the target owner's model and effort. Its release-pinned Codex design/planning default is `gpt-5.6-sol` / `ultra`. A different active model fails this equality test regardless of its ability. Canonical-tier artifacts require an owner consult even when the session otherwise qualifies.

The existing ladder already makes useful progress: automatic in-session resolution, same-owner batching, mechanical propagation, and asynchronous handoffs only when genuinely needed. Preserve those benefits. Replace identity-based authorship eligibility with an explicit authority policy, relevant specialist criteria, and evidence appropriate to the decision. A persona's ownership should determine the criteria and accountability for an artifact, not automatically force a new process boundary.

Respect explicit user model choices. For unspecified tiers, inherited user-selected execution is a better candidate default than an aging release pin. Do not substitute an invented “greater than or equal capability” ranking; model strength is task-dependent. Test specialist dispatch against in-session application of specialist criteria. Keep independent verification distinct from implementer self-approval.

### 3.7 Persona prose can impose a quality ceiling

Alex's SOUL (`.agents/skills/bmild-dev/SOUL.md` at the baseline revision) defines minimum viable change as the smallest diff and says everything else is another PR. It also contains “Simplicity beats completeness; completeness is a form of procrastination.” Sonia's SOUL (`.agents/skills/bmild-planner/SOUL.md` at the baseline revision) declares zero tolerance for input ambiguity and describes planning from drafts as never cheaper than waiting.

These are understandable reactions to scope creep and weak planning. They are unsafe absolutes when interpreted as execution policy. A capable agent may improve maintainability by changing more code, or resolve technical uncertainty cheaply through a reversible experiment. Smaller diffs and complete advance certainty are not universal proxies for user value.

Keep the personas' recognizable perspectives, but remove instructions that glorify incomplete outcomes or discourage justified exploration. Prefer the smallest coherent solution that fully meets the intended quality bar, including a larger refactor when the evidence supports it.

### 3.8 Upstream design can also overdetermine execution

Architecture completion (`.agents/skills/bmild-arch/resources/architecture-design.md` at the baseline revision) asks for enough detail to implement without architectural choices. Its criteria (`.agents/skills/bmild-arch/resources/completion-criteria.yaml` at the baseline revision) include specifying each internal service method's signature and errors.

Public APIs, security boundaries, persistent data, compatibility, and consequential trade-offs benefit from precise contracts. Private method structure often benefits from implementation-time judgment. Lance should distinguish committed constraints from illustrative designs and delegated engineering choices. Otherwise deleting Slices simply moves implementation micromanagement upstream.

This is a boundary refinement to preserve and improve spec quality, not a proposal to weaken Faisal, Katrina, or Lance.

### 3.9 The review foundation is strong, but needs decoupling and a clearer security obligation

Comprehensive review (`.agents/skills/bmild-qa/resources/comprehensive-review.md` at the baseline revision) already loads shared context once and checks function, security, standards, and spec separately. It accepts bounded diffs and direct changes. Keep this foundation, including verification of source requirements rather than trusting the planner's matrix.

However, verification (`.agents/skills/bmild-qa/resources/verification.md` at the baseline revision) and code review (`.agents/skills/bmild-qa/resources/code-review.md` at the baseline revision) can close a Slice with `security_status: not_reviewed`. Comprehensive review requires `cleared`, so the behavior depends on the path taken. “Done” is therefore not universally evidence of security review today.

Proposed rule: every completed production outcome gets explicit security applicability and required review. An applicable review must run; a justified not-applicable decision is evidence, whereas not-reviewed remains incomplete. Scalability and maintainability also need explicit, context-appropriate evidence beyond a passing test suite or a code-smell checklist.

### 3.10 Instruction volume and tests deserve an outcomes audit

Measured by whitespace-separated words, Alex's core, SOUL, and Spec-Dev resource total **3,963 words**, before repository guidance, specs, code, or the **1,802-word** gap reference when triggered. These are source-size measurements, not runtime token counts or proof of waste. Disk duplication across skills is also not automatically multiplied runtime cost because loading is progressive.

The [quality-review contract test](../tests/quality-review-contract.sh) and [gap-resolution test](../tests/gap-resolution-contract.sh) protect valuable wiring, identity, and literal instructions. Their scenario assertions largely check text presence; that does not demonstrate that a model follows the instruction or achieves the desired result. The [CI configuration](../.github/workflows/ci.yml) supplies structural and script checks, but does not establish comparative model performance on the development loop.

Keep deterministic guards and the safety rationale in [ADR 0011](../plans/adr/0011-mode-local-instructions-over-shared-drift-resources.md). Do not move critical rules behind unreliable loading simply to reduce line count. Add behavioral evaluations so tests protect the intended result rather than permanently freezing the current ceremony.

## 4. Four options, from obvious to daring

Decision record: Option C is selected. The other options describe alternatives considered, not additional modes to implement or choices to present on every invocation.

### Option A — Keep Slices, remove compulsory paperwork

- Make read/edit forecasts and token estimation conditional; shorten Slice records to purpose, constraints, dependencies, and acceptance evidence.
- Remove unconditional pre-exit offers and resolve routine routing without questions.
- Permit batch execution of authorized Slices and automatic continuation into requested review/remediation.
- Fix model-equality and security-closure issues; resolve inconsistent planning defaults.
- Retain Sonia's decomposition and existing lifecycle as the normal path.

**Best case:** meaningful savings with limited migration. **Limitation:** still asks a planner to predefine execution units; scope boundaries may continue suppressing implementation judgment. This is a useful cleanup or comparison baseline, but not my recommended destination for “full capability.”

### Option B — Plan only as far ahead as useful

- Sonia keeps initiative-level coverage, risks, and genuine dependency constraints.
- Alex defines and revises the next useful work increment from live code; future work stays as coarse outcomes until needed.
- Create durable work records only for restart, delegation, review, external coordination, or user-requested milestones.
- Trigger additional scaffolding from observed misses, uncertainty, review burden, or context difficulty.

**Best case:** less speculative planning while retaining clear checkpoints and support for weaker models. **Risk:** rolling planning becomes the same Slice ceremony repeated more frequently. Avoid requiring a new document or approval for every internal increment.

### Option C — Execute the approved outcome; prove completion

- The authoritative specs, MVP/Growth/Vision phase, and explicit user scope define the work. Sonia checks coherence, completeness, risk, and required evidence without manufacturing a mandatory execution plan.
- Alex owns implementation strategy inside those constraints: decomposition, sequencing, experiments, cohesive refactors, and permitted delegation.
- The execution plan is revisable working state. A concise durable record supports continuation and evidence; it does not prescribe future file lists.
- Rahat independently checks the whole approved outcome and its integration effects against source requirements, security obligations, and quality expectations. A separate, new review context window is a first-class execution path.
- A requested build-and-verify engagement continues through authorized repairs until verified completion or a genuine decision/blocker. Review-only requests stay review-only.

**Best case:** the development loop adapts to model and harness ability while keeping strong specifications and independent acceptance. **Risk:** under-scaffolding weak executors, postponing discovery of incomplete work, or overloading review. Counter those with relevant early risk probes, observable coverage, and useful checkpoints. Short working plans are available within this primary mode; do not introduce a separate planning-mode selection mechanism merely to enable them.

**Selected:** make this the primary execution contract throughout the skills. “Outcome” may be one bounded feature or a larger coherent body of work within authorized phase scope; it does not mean the whole project must fit into one uninterrupted context window. Comparative evaluation informs the implementation and support needed, rather than reopening the selected direction.

### Option D — Let the harness own development; BMILD owns intent and assurance

- Faisal, Katrina, and Lance produce the durable specification and decision constraints.
- Sonia exposes readiness, unresolved obligations, and coverage. Rahat supplies independent acceptance and assurance.
- The user's preferred native coding agent performs implementation using those contracts. Alex becomes a small adapter or an optional guided executor rather than a mandatory development persona.
- BMILD persists only what must survive sessions and tools: scope, decisions, changed state, open obligations, and evidence. Native task lists and execution plans remain native.

**Best case:** BMILD benefits from harness improvements without recreating their orchestration. **Risks:** uneven harness capabilities, implicit state loss, and inconsistent constraint adherence. Require a small, portable contract/evidence interface and retain a sequential guided fallback. Avoid creating a new orchestration platform just to remove the old one.

**Disposition:** not selected. A minimal native executor remains useful as a measurement baseline for unnecessary overhead; replacing Alex with Option D is outside this refactor's direction.

## 5. Proposed operating contract for Option C

### Durable intent and sufficient readiness

Retain the existing spec corpus and source-of-truth rules. Separate commitments from recommendations:

- **Committed:** authorized MVP/Growth/Vision phase and outcome, user behavior, data semantics, trust boundaries, compatibility promises, required UX states, accepted NFRs, and consequential decisions.
- **Delegated:** internal decomposition, private structure, code navigation, tool ordering, and equivalent implementation choices that preserve committed contracts.
- **Open:** unresolved consequential preferences or contradictions; identify the affected work and obtain the decision. Continue unrelated authorized work.

Sonia checks meaning and evidence sufficiency. Readiness may be local: work with settled prerequisites can begin while an independent question remains open. A technical uncertainty may call for a short experiment, not a complete design rewrite. Intent and commitments are still established before depending on them.

Resolve phase scope from the user's request and current authoritative spec. Do not select all phases simply because the user names an initiative. Ask a bounded scope question only if authorization remains genuinely ambiguous. A documented future Growth or Vision feature is not automatically approved for present execution. Necessary foundations for the current phase may be implemented, but cannot be used to hide delivery of deferred features. Moving work between phases requires the relevant product decision and source update; rearranging implementation inside the authorized phase does not.

### Adaptive execution with a constant quality bar

The minimal always-present support is: authorized outcome, relevant constraints, known risks, demonstrable completion criteria, and a continuity/evidence record. More prescriptive support is available through examples, short task lists, discovery prompts, and nearer review checkpoints.

Add support when an executor repeatedly misses requirements, cannot identify an integration boundary, produces contradictory plans, fails a risk probe, or loses essential context. Relax it when independent evidence shows reliable progress. Do not choose support solely from a model name, benchmark rank, or its assertion that it is capable. The user can request more or less structure.

These are responses to observed work, not a mandatory capability-classification stage or a new support-profile state machine. Do not run token estimation or invent context forecasts to decide how much structure to use. Prefer the agent's ordinary working plan and native harness facilities; persist only what a successor or reviewer needs.

Decompose when it materially helps dependency coordination, risk isolation, independent validation, user-visible milestones, or available execution capacity. A database migration followed by a compatibility rollout may need strict sequencing. An atomic cross-layer repair may be worse when split. Vertical Slices remain useful; their shape is not a universal rule.

### Drift control without routine owner relays

- The executor may change implementation strategy without requesting a product decision.
- Settled implementation facts update the appropriate durable source with concise provenance.
- A proposed contract improvement names the evidence, benefit, affected obligations, and consequences. Use the relevant owner's criteria in-session when authorized; consult when independent expertise or a separately configured agent is useful or required.
- Obtain user decisions for changed intent, consequential trade-offs, expanded authority, or genuinely unresolved preferences. Choosing another file or internal task order is not itself such a decision.
- Treat specs and evidence as versioned together. A material contract or code change invalidates the affected proof, not every unrelated proof. Preserve the original requirement and decision history so rewriting the spec cannot conceal a failed implementation.

### Independent assurance and completion

Sonia owns readiness and completeness reasoning; Rahat owns verification judgments. Alex runs tests and records implementation evidence but cannot certify its own final acceptance.

For a completed production outcome, establish:

- **Correctness:** observable behavior, error/edge cases, and relevant regression tests.
- **Completeness:** all required behaviors and documentation traced to the authoritative spec, including requirements absent from Alex's task list or Sonia's initial matrix.
- **Security:** applicable trust boundaries, abuse cases, sensitive data handling, and credible exploit analysis; explicit reasons for inapplicable areas.
- **Scalability:** workload and resource assumptions, algorithmic/query behavior, and relevant load or performance evidence. Do not claim arbitrary scale from unit tests; report unverified limits.
- **Maintainability and code quality:** cohesion, complexity, dependency fit, failure handling, operability, and repository standards. Reward a simpler coherent implementation, not merely the smaller diff.
- **User fit:** relevant user journeys or demonstrations against success criteria. Where success is subjective, preserve a meaningful user review rather than declaring that tests prove satisfaction.

Support a separate, new context window for Rahat as a first-class path. An automatically dispatched reviewer qualifies when it starts with isolated context; a new user-opened session also qualifies and must be able to continue from the durable artifacts without reconstructing the developer's chat. The user can choose that fresh-window boundary even when automatic dispatch is available. A conversation fork carrying the developer's full reasoning is not equivalent to a fresh review context.

Supply the reviewer with the authorized phase/outcome, authoritative spec and applicable decisions, code/change identity, runnable evidence, and known open issues. The reviewer reads the sources independently and can inspect the necessary repository context; the implementer's summary is navigation help, not the verdict or the only evidence. This separation reduces shared-context bias without claiming that a second context guarantees error-free review.

Automatic continuation means coordinating authorized work across context boundaries, not retaining one reasoning history for every role. Findings can return to the development session for repair, then to the independent reviewer for re-verification. If Rahat authors a production fix, independent acceptance of that change belongs to a reviewer context that did not implement it. When the harness cannot create isolated context, prepare the concise durable transition for a new review window and leave independent acceptance pending. Never collapse the review into a persona rename to claim an uninterrupted finish.

Reviews can checkpoint large or risky changes without requiring delivery Slices. Every required axis has its own disposition; strength on one cannot offset failure on another. Evidence records enough code/spec/environment identity to determine whether it remains applicable. Record this automatically where possible rather than asking the user to choose Git coordinates.

### Minimal persistent execution state

Prefer extending the existing verification artifact to adding a mandatory new file type. Persist only what a successor or reviewer needs:

- Approved phase/outcome and governing spec references.
- Unmet obligations, blockers, and genuine dependencies.
- Current implementation/checkpoint state and material decisions.
- Evidence, review findings, and which code/spec state they cover.
- A next action only when work will continue later.

Do not copy full requirements into several competing documents. Artifact existence is justified by a consumer, not by the completion of a mode. Existing Slice records remain readable and preserve their history during migration.

The same record must make both development resumption and independent review possible in a new context. It need not contain the development transcript, speculative reasoning, predicted file inventory, or token estimates.

## 6. Concrete before/after

**Scenario:** the user has approved the MVP of a tenant-invitation feature and asks to implement and verify it. Bulk invitations remain in Growth. During implementation, a shared authorization helper proves necessary for a secure, maintainable result.

**Current likely path:** Sonia predicts reads/edits, budgets and authors Slices; Alex implements one Slice. Discovery beyond its boundary can trigger a Lance decision, Sonia recut, and recovery Slice, then further implementation and separate review invocation. Automatic gap resolution already reduces manual handoffs, but the planning artifacts still need maintenance.

**Proposed path:** Sonia checks MVP invitation behavior, tenant isolation, expiry, and completion evidence. Alex discovers the helper, chooses a cohesive implementation, and exercises cross-tenant abuse tests early. If the helper preserves agreed behavior and architecture constraints, Alex proceeds and records durable technical facts. If it changes a public authorization contract, that specific decision is resolved and the source is updated. Bulk invitations stay deferred even if the implementation could conveniently support them. Rahat starts in a separate review context and independently checks the MVP and integration effects, including omitted requirements. Authorized repairs return to development and then independent re-verification, without a new Slice or requiring the user to relay information already recorded in artifacts.

For a weaker executor, the same task may use a short guided sequence with early feedback on tenant isolation. The acceptance bar is identical. For a stronger executor, that sequence does not prevent a better cohesive implementation.

## 7. How to test whether this improves BMILD

### Comparators

Use the same approved specs, starting repositories, task requests, tools, user authority, and comparable budgets for:

1. Current BMILD.
2. A minimal spec + native coding agent + independent review baseline.
3. The selected Option C redesign.

Where a result is ambiguous, compare individual changes through ablation using the old workflow as a measurement comparator: remove predictive file budgeting, relax decomposition, or simplify ownership independently. Test concise working plans where observed misses call for support. This does not retain an estimator branch in the shipped design or reopen the choice of Option C. Do not require every model/harness combination before learning anything.

Include at least one supported weaker model and one current high-capability model, with recorded versions and reasoning settings. Test Codex, Claude Code, and OpenCode before claiming first-class portability; distinguish unavailable harness features from model failures. Other harnesses create no additional design or validation obligation. Repeat representative cases because a single good run is not reliable evidence.

### Representative scenarios

- A bounded spec-backed feature with no existing Slice.
- A primary outcome invocation with legacy Slice artifacts present, proving it does not fall back into Slice-first routing or budgeting.
- MVP execution beside specified Growth/Vision features, including a tempting but unauthorized future-phase addition.
- A coherent cross-layer change whose best solution crosses a predicted file boundary.
- A significant integration or migration with genuine ordering constraints.
- Missing product intent versus harmless missing implementation detail.
- A superior technical approach discovered after work begins.
- A requirement omitted from the planner's matrix and implementer's tests.
- An introduced security flaw and a workload-dependent scalability defect.
- A mid-run spec change that invalidates only part of the evidence.
- A compaction or fresh-session resumption with an unresolved obligation.
- Independent review in a new context window, supplied only with durable scope/spec/code/evidence references rather than the development conversation.
- Remediation returned to development, followed by independent review of the changed code; review-authored fixes cannot self-certify.
- A review-only request, and a build-and-verify request with authorized repair.
- A harness lacking agent dispatch, model attestation, or context telemetry.
- Old estimator keys and historical token estimates present, with no calculator invocation, scope split, or configuration blocker.
- A dirty worktree containing unrelated user changes.

Include a BMILD self-hosting change for relevance, but also application-code tasks; skill-text contract tests alone cannot demonstrate application quality.

### Measurements

Measure end-to-end time **to a verified result**, user interventions, implementation/review/rework cost, actual provider token usage where available, defects, missed requirements, spec drift, security findings, performance limits, and maintainability. Separate cached input, uncached input, output, peak context, and monetary cost where the provider exposes them; missing telemetry is unknown, not zero. Estimated source size is not measured token burn.

Assess two complementary questions:

- **Equal resource budget:** can the stronger model deliver a better result, more complete scope, or stronger proof within the same time/cost budget?
- **Equal quality target:** can the framework reach the required result with less elapsed time, process work, and user intervention?

Also compare within each model: does the redesign preserve or improve weaker-model reliability while allowing stronger-model gains? A modestly longer run can be preferable if it demonstrably improves the user's outcome. Cheapest completion is not the sole objective.

Use independent grading from the original specs and code, preferably blinded to the workflow, plus user assessment of fit and maintainability where judgment matters. Process wording, artifact count, and checklist completion are diagnostics, not quality scores.

### Proposed adoption conditions

- No completion claims with unmet mandatory requirements, known applicable security gaps, or stale required evidence in the evaluation cases.
- Authorized phase boundaries hold, and independent acceptance remains pending until the separate reviewer context has completed its required checks.
- Weaker-model completion and defect results remain within an agreed non-regression margin; repeat enough cases to disclose uncertainty.
- Stronger-model results show reduced overhead at matched quality and/or improved quality at matched resources, relative to current BMILD.
- Investigate any material loss relative to the minimal native baseline; BMILD must demonstrate what its extra work buys.
- The user experiences fewer procedural interventions and no loss of consequential control.

Set numerical margins and spending limits before trials, informed by a small baseline run. Do not invent a percentage speedup or disguise a small sample as statistical proof.

## 8. Refactor plan for the selected direction

This is a provisional dependency order, not a new mandatory Slice system. Each step produces something reviewable; independent work can be combined or overlapped where useful.

1. **Finish the operating contract.** Option C, the three target harnesses, phase respect, primary-mode integration, and fresh-window review support are settled. Refine delegated judgment, the independent review/repair transition, and the indispensable evidence. Confirm estimator retirement as the proposed simplification. Establish one common quality floor; avoid a large configuration menu.
2. **Capture a small baseline.** Run representative current-BMILD and native-baseline tasks, record actual overhead and failure modes, and freeze comparable starting fixtures. Inspect traces to distinguish useful reasoning from maintenance of the framework.
3. **Prototype the primary workflow.** Rework core activation, context loading, execution state, and review around phase-bounded outcomes in an isolated branch/package. Keep current Slices readable as transitional inputs; do not put an outcome facade over Slice-first internals. Introduce only the minimum durable state necessary for continuation and acceptance; do not migrate historical artifacts yet.
4. **Remove estimation and refine authority.** Retire the calculator and its fallback-selection mechanism, predicted inventory requirements, calibration fields, active config keys, and dedicated test/CI footprint. Let the executor choose decomposition when useful. Distinguish committed contracts from delegated implementation, replace exact model-match eligibility, and respond to observed needs with ordinary working guidance. Preserve explicit model choices and user authority. Adjust SOUL prose that contradicts the new contract.
5. **Strengthen and connect assurance.** Decouple review from Slice identity, make security applicability explicit, verify phase-bounded outcome completeness and integration, and support new-window review and authorized repair/re-verification across contexts. Preserve separate per-axis evidence and keep acceptance independent of whoever implemented a change.
6. **Evaluate and simplify.** Compare Option C with current BMILD and the native baseline. Add concise support where weaker models demonstrably need it. Remove instructions that add neither reliability nor result quality. Use measurements to improve Option C rather than maintaining multiple competing execution workflows.
7. **Ship the chosen behavior coherently.** Update affected standard skills, templates, shared references, consult generators, documentation, configuration, release metadata, and tests together. Preserve old records; document retired estimation settings as inert without a compatibility mode or blocking migration ritual. Reassess affected ADRs explicitly rather than silently violating their rationale.

Primary change surfaces are planner core/resources/templates, Alex core/SOUL/development modes, Rahat review modes and evidence storage, the six synchronized gap references, generated consult definitions, and the PM/UX/architecture boundaries that distinguish intent from implementation detail. Estimator retirement also removes both platform scripts and their dedicated golden/equivalence/parallel/telemetry tests and CI jobs; remove fixtures only after checking for other consumers. Supporting changes include README, AGENTS, CHANGELOG, active configuration and examples, skill-format docs, lifecycle/quality/gap tests, and new behavioral evaluations. Existing commit safety and protection of unrelated work stay intact.

Avoid broad persona rewrites. Change the development contract and only the adjacent design/review interfaces that must support it. Keep the named design specialists and their high-quality elicitation; they are an asset the user explicitly wants preserved.

## 9. Keeping pace with models and harnesses

- Re-run a compact representative evaluation set when adding a new model generation, changing a harness integration, or revising a major execution rule.
- Design and validate for Codex, Claude Code, and OpenCode. Treat native capabilities as available tools, not requirements to emulate on every platform; other harnesses rely on incidental compatibility without additional design effort. Give unavailable essential capabilities a truthful continuation path, such as a separate review window.
- Give each substantial mandatory procedure a reason, a demonstrated failure it prevents, and a condition for reassessment. Remove it when evidence no longer supports its cost.
- Audit ceilings explicitly: unnecessary decomposition, forced ordering, premature stopping, over-specific design, repeated reloads, unneeded dispatch, and missed opportunities to improve the solution.
- Use freshness checks and changed-section reads where trustworthy; after uncertain compaction or concurrent edits, reload the necessary source. Never trade stale governing context for a token-count target.
- Keep knowledge and final evidence portable across development and independent review windows. Keep transient planning and orchestration as close to the harness as practical; do not add a replacement context-budget calculator.

## 10. Decision state and remaining refinement

Settled by the user's selection and comments:

- Option C is the primary development workflow, integrated throughout execution rather than bolted on.
- Codex, Claude Code, and OpenCode are the first-class targets; other compatibility requires no additional BMILD design effort.
- The spec's MVP/Growth/Vision phases remain authoritative scope boundaries.
- The workflow must support a separate, new review context window and preserve independence from the development session.

Revised recommendation:

- Retire token estimation entirely, including optional/fallback selection, prediction bookkeeping, dedicated code/test/CI maintenance, and active configuration. Retain ordinary context continuity and optional evaluation measurements. The burden of proof is on reintroduction, not on keeping a speculative fallback alive.

Remaining design refinement concerns how delegated engineering judgment and cross-context review/remediation operate on the three target harnesses. Resolve those details within Option C without reopening the selected direction or introducing a new mandatory planning layer. Implementation is authorized; the validation record distinguishes completed checks from unrun comparative trials.
