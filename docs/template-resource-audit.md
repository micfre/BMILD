# BMILD Template & Resource Audit

- **Audit date:** 2026-09-22
- **BMILD source identity:** `spec-sharpening` working tree at 2026-09-22, base commit `b00beef7370a4bf47a6b5a00a947aae60005a773` (`main`), including the FR1–FR12 sharpenings landed by this initiative.
- **Prior-art identity:** BMAD-METHOD `6.13.0-next` (module manifests), local snapshot under `external_references/bmad-method/` (ignored, read-only).
- **BMILD practice baseline:** `docs/best-practices/agent-skills-specification.md`, `agent-skills-best-practices.md`, `agent-skills-optimizing-descriptions.md`, `agent-skills-using-scripts.md` (live-site snapshots in this repository).
- **Inventory denominator:** 70 files — every `assets/` and `resources/` file present in the nine in-scope skills at audit time (PM 14, UX 6, Arch 6, Planner 10, Dev 4, QA 15, Brainstorming 8, Elicit 3, Roundtable 4). Added or removed files change the denominator, not this report.
- **Status:** complete. Every inventoried file has an entry below; every candidate has a verdict and rank. No entry is `incomplete`.

## Method

Each inventory entry names its comparison sources (BMAD 6.13 counterparts and/or the applicable BMILD best-practice documents) and records a concrete gap or an evidence-based no-gap disposition. `no counterpart` means no BMAD file serves the same purpose; the best-practice comparison still proceeds. This report is an assessment only: auditing a file does not authorize editing it, and no candidate has been implemented by this audit (PRD §Scope, SM2 counter-metric).

Prior-art stances that apply across many entries, stated once:

- BMAD's `uv`-based customization/resolver/memlog machinery (`customize.toml` merges, `resolve_*.py`, `memlog.py`, `render_skill.py`) requires an installed runtime. BMILD's install-less constraint ([ADR 0013](../plans/adr/0013-install-less-agent-skills-native-execution.md)) rejects that machinery as prior art for BMILD structure; persona-level ideas carried by those files are still assessed on content.
- BMAD review/UX validation tooling (word metrics, structure models, HTML validation reports) conflicts with BMILD's review-depth fixed baseline and the install-less constraint; content-level review ideas are assessed separately.
- BMILD mode resources are loaded per engaged mode. This matches the progressive-disclosure guidance in `agent-skills-best-practices.md`; mode-resource files therefore need no BMAD counterpart to be no-gap on structure.

## PM — bmild-pm (14 files)

- `assets/prd-template.md` — vs `bmad-prd/assets/prd-template.md`. Gap closed this MVP: protagonist/context/climax/failure/evidence journey shape and counter-metric section now present (FR1–FR4). Residual gaps: BMAD's journey scope dial (§2.3 lighter/heavier) and glossary discipline (§3 verbatim terms) are not mirrored → C-01, C-02.
- `assets/product-brief-template.md` — vs `bmad-product-brief/assets/brief-template.md`. Gap closed this MVP: counter-metric pairing (FR4). Residual: BMAD's Executive Summary section → C-03 (rejected; see verdict).
- `assets/context-template.md` — no BMAD counterpart (BMAD keeps glossaries inside the PRD). No gap: serves the PRD §3 Glossary purpose at initiative scope with BMILD's semantic-memory rules; progressive disclosure per best practices.
- `assets/context-map-template.md` — no counterpart (BMAD has no cross-initiative semantic map; `bmad-project-context` targets AGENTS.md authoring, a different artifact). No gap.
- `assets/handoff-template.md` — no counterpart (BMAD change proposals handle cross-artifact impact; async owner queues are BMILD-specific). No gap; consistent with gap-resolution ladder.
- `assets/registry-template.md` — no counterpart (BMAD has no liveness registry; the memlog serves session continuity only). No gap.
- `resources/prd-completion-criteria.yaml` — vs `bmad-prd/assets/prd-validation-checklist.md`. Gap closed this MVP: journey evidence, climax/failure, counter-metric weak signals (FR1–FR4). Residual: BMAD's per-FR testable-consequence bullets → C-04 (rejected); richer validation checklist content → C-17 (rejected; closed `prd-v1` ruleset by design).
- `resources/brief-completion-criteria.yaml` — vs `bmad-product-brief` SKILL.md. No gap beyond C-03: stakes-driven criteria exceed the BMAD brief skill's guidance; counter-metric signal added this MVP.
- `resources/write-prd.md` — vs `bmad-prd` SKILL.md + `references/validate.md`. Gap closed this MVP: captured-not-authored elicitation and evidence-gap reuse (FR1–FR2). Residual: journey scope dial and glossary discipline → C-01, C-02.
- `resources/refine-prd.md` — vs `bmad-prd` (update path via same-slug folder). No gap: candidate/promotion flow with deterministic lint exceeds BMAD's in-place update; journey-evidence survival added this MVP.
- `resources/write-product-brief.md` — vs `bmad-product-brief` SKILL.md. No gap beyond C-03.
- `resources/refine-brief.md` — no direct counterpart (BMAD updates briefs through the same authoring skill). No gap: challenge-don't-preserve plus downstream impact ladder present.
- `resources/project-bearing.md` — no counterpart (BMAD has no project-level bearing concept). No gap; guarded by `tests/project-bearing-contract.sh`.
- `resources/pm-handback.md` — no counterpart (session wrapper is BMILD-specific). No gap; guarded by `tests/session-wrapper-contract.sh`.

## UX — bmild-ux (6 files)

- `assets/ux-design-template.md` — vs `bmad-ux` SKILL.md + `assets/key-screens.md`, `design-directions.md`. Gap closed this MVP: source-journey evidence, surface closure, token/component/state blocks (FR5–FR12). Residual: BMAD ships worked design examples and directions for multiple aesthetics → C-11.
- `assets/design-md-template.md` — vs `bmad-ux/references/design-md-spec.md`. Partial gap: token format matches, but BMAD's common patterns (platform `note` inheritance, UI-system delta-only inheritance, light/dark token strategies) are absent → C-10.
- `resources/completion-criteria.yaml` — vs `bmad-ux/references/validate.md`. Gap closed this MVP: token_contract, component_contract, bidirectional closure, five-state walk, judgment-pass weak signals (FR5–FR12). No residual gap; two-pass shape matches BMAD's Pass 1 coverage / Pass 2 judgment structure.
- `resources/ux-design.md` — vs `bmad-ux` SKILL.md. Gap closed this MVP: two-pass validation directive, closure, token/component/state rules. Residual: BMAD's optional reviewer-gate lens menu is present in BMILD as Sonia's Artifact Reviewer Gate (separate skill) — no gap.
- `resources/ux-refinement.md` — no direct counterpart (BMAD updates in place). No gap: evidence/reference preservation added this MVP.
- `resources/ux-handback.md` — no counterpart. No gap; session-wrapper guarded.

## Arch — bmild-arch (6 files)

- `assets/adr-template.md` — vs `bmad-architecture/assets/spine-template.md` §Invariants & Rules (Binds/Prevents/Rule). Gap closed this MVP: `Prevents` field with tautology rejection (FR7). Residual: BMAD ADs carry stable IDs (AD-N) and Binds/Rule fields inside the living design → C-06.
- `assets/system-design-template.md` — vs `bmad-architecture/assets/spine-template.md`. Gap closed this MVP: structural dimension sweep incl. operational envelope (FR8). Residual: consistency-conventions table and diagram conventions → C-08, C-07.
- `resources/completion-criteria.yaml` — vs `bmad-architecture` SKILL.md + spine guidance. No residual gap beyond C-06/C-08: dimension_sweep and Prevents criteria added this MVP; disposition granularity exceeds BMAD.
- `resources/architecture-design.md` — vs `bmad-agent-architect` (Winston) + `bmad-architecture` SKILL.md. No residual gap beyond C-06/C-08: sweep directive and Prevents gate added this MVP; BMAD's uv activation machinery rejected per ADR 0013.
- `resources/architecture-refinement.md` — no direct counterpart. No gap: ADR `Prevents` refresh and sweep reopening added this MVP.
- `resources/architecture-handback.md` — no counterpart. No gap; session-wrapper guarded.

## Planner — bmild-planner (10 files)

- `assets/verification-matrix-template.md` — vs `bmad-spec/assets/spec-template.md` (success signal + stories) and `bmad-create-epics-and-stories`. No gap: outcome/evidence/proof model with independence semantics exceeds BMAD's story ACs; BMAD's epic/story decomposition is deliberately not mirrored (token estimation retired; outcome-based delivery).
- `assets/rollup-template.md` — no counterpart (BMAD has no project-level initiative index; `resolve_config.py` config only). No gap.
- `assets/change-proposal-template.md` — vs `bmad-correct-course` SKILL.md. No gap: impact map + bounded questions + ordered handoff chain cover BMAD's sprint change proposal; gap-resolution close states are more precise.
- `assets/artifact-review/rubric-walker.md` — vs `bmad-ux/references/validate.md` (Pass 1 coverage walker). No gap: ported with BMILD vocabulary by `review-depth`; canonical finding shape identical.
- `assets/artifact-review/adversarial-lens.md` — vs `bmad-review/references/lens-adversarial.md`. No gap: same canonical fields (`location`/`trigger_condition`/`guard_snippet`/`potential_consequence`), zero-findings re-check rule, no severity.
- `resources/readiness-verification.md` — vs `bmad-spec` (spec kernel validation). No gap: readiness-by-meaning deliberately replaces filename gates; BMAD's five-field kernel lightweight path → C-16 (rejected; Direct modes cover it).
- `resources/course-correction.md` — vs `bmad-correct-course/checklist.md`. Partial gap: BMAD's explicit HALT conditions (no trigger, no evidence → stop) and issue-type taxonomy are sharper than BMILD's entry conditions → C-15.
- `resources/delivery-strategy.md` — vs `bmad-sprint-planning`. No gap: sequencing advice without sprint ceremony; consistent with outcome-based delivery.
- `resources/artifact-review.md` — vs `bmad-ux` reviewer gate. No gap: fixed baseline + independence semantics + close states; guarded by `tests/review-depth-contract.sh`.
- `resources/planning-handback.md` — no counterpart. No gap; session-wrapper guarded.

## Dev — bmild-dev (4 files)

- `resources/spec-dev.md` — vs `bmad-agent-dev` (Amelia) test-first stance. Partial gap: BMILD proves after implementing; Amelia's red-green-refactor discipline for code-bearing outcomes → C-09.
- `resources/spec-fix.md` — no counterpart (BMAD has no RCA-linked fix path). No gap: Fix Election and evidence rules present; guarded by `tests/fix-election-contract.sh`.
- `resources/direct-dev.md` — vs `bmad-build` (small-change path). No gap: same small-change intent without BMAD's story scaffolding; C-09 applies here too.
- `resources/direct-fix.md` — no counterpart. No gap.

## QA — bmild-qa (15 files)

- `resources/lens-edge-case-hunter.md` — vs `bmad-review/references/lens-edge-case-hunter.md` and `bmad-code-review/review-prompts/edge-case-hunter.md`. No gap: canonical shape, no severity, report-only semantics match.
- `resources/lens-verification-gap.md` — vs `bmad-review/references/lens-verification-gap.md`. No gap: same classification contract (`regression-gap | missing-adoption-gap | broken-verification-gap`).
- `resources/findings-triage.md` — vs `bmad-code-review/step-03-triage.md`. No gap: verdict vocabulary (`high | medium | low | false | maybe-false`) disregards reviewer severity; covers BMAD's claims-check intent (`references/claims-check.md`) by verifying every claim.
- `resources/code-review.md` — vs `bmad-code-review/workflow.md`. No gap: lens wiring and triage match; BMAD's parallel-subagent dispatch maps to BMILD's isolated-context requirement.
- `resources/comprehensive-review.md` — vs `bmad-review` SKILL.md. No gap: coverage axes (functionality, security, standards, scalability/maintainability) exceed BMAD's editorial lenses; deletion effects covered by Edge-Case Hunter (covers `bmad-code-review/references/deletion-check.md` intent).
- `resources/verification.md` — vs `bmad-spec` validate + `bmad-review` validate. No gap: evidence-led acceptance with independence; `not_reviewed` never terminal.
- `resources/security-review.md` + `resources/security-categories.yaml` — no counterpart (BMAD has no dedicated security review skill). No gap: exploitable-findings flow with remediation verification; `tests/quality-review-contract.sh` guarded.
- `resources/code-review-categories.yaml` — vs `bmad-code-review` step-02 lens prompts. No gap: category coverage matches plus repository-standards axis.
- `resources/direct-fix.md`, `resources/spec-fix.md` — no counterpart. No gap: Fix Election contract guarded.
- `resources/nyquist.md` — no counterpart. No gap: BMILD-specific review-cadence rationale.
- `resources/qa-handback.md` — no counterpart. No gap.
- `assets/rca-template.md` — no counterpart (BMAD has no RCA artifact). No gap: root-cause → Fix Election → close loop present.
- `assets/security-review-template.md` — no counterpart. No gap.

## Facilitators — bmild-brainstorming (8), bmild-elicit (3), bmild-roundtable (4)

- bmild-brainstorming `resources/brain-methods.yaml` + `step-01-setup.md` … `step-04-organise.md` — vs `bmad-brainstorming` SKILL.md + `references/mode-*.md`, `converge.md`, `finalize.md`, `resume.md`, `assets/brain-methods.csv`. Gaps exist (three-stance model, aim-past-100 framing, memlog continuity, resume flow, in-chat techniques) but the interaction flows are owned by `elicitation-refine` → C-14 (rejected here for ownership, evidence recorded for that initiative).
- bmild-elicit `resources/methods.yaml`, `step-01-select.md`, `step-02-execute.md` — vs `bmad-advanced-elicitation` SKILL.md + `assets/methods.csv`. No structural gap: bounded projections mirror BMAD's never-whole-catalog rule (`pick_methods.py categories/list/show/random` ≈ BMILD's categories/index/show/spread draws); method numbering intentionally tracks BMAD 6.13. Interaction-flow refinements owned by `elicitation-refine` → C-14.
- bmild-roundtable `resources/step-01-open.md` … `step-04-close.md` — vs `bmad-party-mode` SKILL.md + `references/*`. Gaps exist (roster groups, scene/open-cast, party memory, "keep it a party" craft rules) but interaction flows are owned by `elicitation-refine` → C-14.

## Improvement candidates (fit verdicts)

- **C-01 — Journey scope dial (adapt).** Add a lighter/heavier scale to PRD journey obligations (single-sentence journey for solo/hobby outcomes; full shape for UX/architecture-feeding journeys). Evidence: `bmad-prd/assets/prd-template.md` §2.3 scope dial. Owner: Faisal (`prd-completion-criteria.yaml`, `write-prd.md`, `prd-template.md`). Fit: adapts BMAD's proportionality to BMILD's applicability rules without weakening the evidence discipline. Boundary: applicability note in criteria + template guidance; no new section, no flow change.
- **C-02 — PRD glossary discipline (adapt).** PRD journeys/FRs use `context.md` terms verbatim; a new domain noun is promoted to `context.md` in the same pass; synonyms are a weak signal. Evidence: `bmad-prd` §3 Glossary. Owner: Faisal. Fit: reuses the existing semantic-memory artifact instead of a PRD-local glossary; keeps authority in `context.md`. Boundary: directive in `write-prd.md`/`refine-prd.md` + criteria signal; no new artifact.
- **C-03 — Executive Summary brief section (reject-with-rationale).** BMILD briefs are compact persona inputs with title/description frontmatter; an executive audience section adds ceremony without a consumer. Evidence: `bmad-product-brief/assets/brief-template.md`. Revisit if BMILD ever targets human-executive brief distribution.
- **C-04 — Per-FR testable consequence blocks (reject-with-rationale).** BMILD FR falsifiability is enforced at criteria level and proof lives in the verification matrix; duplicating test bullets per FR bloats PRDs and duplicates the matrix's Coverage rows. Evidence: `bmad-prd` §4 FR blocks.
- **C-05 — Inline `[ASSUMPTION]` tags + assumptions index (reject-with-rationale).** Conflicts with BMILD's artifact-authority discipline: assumptions are governed (Assumption → Confidence → Consequence, ambiguity_disposition), not scattered inline; BMILD PRDs are re-linted artifacts, not living documents edited in place. Evidence: `bmad-prd` §4/§9.
- **C-06 — Stable decision IDs in system-design §2 (adapt).** Give each Key Decision a stable initiative-local ID (e.g. `D-001`) so Alex/Rahat/matrix references are precise, and carry the ID into the ADR when the gate fires. Evidence: `bmad-architecture/assets/spine-template.md` AD-N ids with Binds/Prevents/Rule. Owner: Lance (`system-design-template.md` §2, `adr-template.md`, criteria). Fit: BMILD already commits to stable IDs elsewhere (FR, J, O, H); this closes the reference-precision gap without adopting the spine artifact. Boundary: §2 template + numbering rule + ADR cross-reference; no artifact-type change, no bulk migration of legacy designs.
- **C-07 — Mandatory mermaid structural diagrams (reject-with-rationale).** BMAD treats a dependency-direction diagram as a rule. BMILD's prose boundary fields carry the same content and survive weaker-model rendering; mandatory diagrams add a staleness surface. Revisit if a harness proves diagram-native review. Evidence: spine-template §Invariants/§Structural Seed.
- **C-08 — Consistency conventions section (adapt).** Optional system-design section for defaults that bind independent builders where they would drift (naming, id/date/error shapes, cross-cutting state handling), with an applies_when gate. Evidence: spine-template §Consistency Conventions. Owner: Lance. Fit: fills a real comprehensiveness gap (multi-outcome brownfield repos have no home for these); disposition vocabulary keeps it proportionate. Boundary: template section + criteria entry; delegated when a single builder owns the outcome.
- **C-09 — Test-first discipline for code-bearing outcomes (adapt).** Amelia's red-green-refactor stance becomes an Alex directive for outcomes whose deliverable is production code: write/extend the failing test before the fix where the change is testable, and show it. Owner: Alex (`spec-dev.md`, `direct-dev.md`). Fit: strengthens "Groundtruth and prove" without a new gate; doc-only outcomes unaffected. Boundary: two directive sentences; no mode restructuring.
- **C-10 — DESIGN.md inheritance patterns (adapt).** Add platform `note` inheritance, UI-system delta-only inheritance, and light/dark token strategies to `design-md-template.md` guidance. Evidence: `bmad-ux/references/design-md-spec.md` §Common patterns. Owner: Katrina. Fit: pure template enrichment aligned with the token contract landed in this MVP. Boundary: guidance prose in the template; no flow change.
- **C-11 — Worked UX design example asset (adapt).** Ship one compact worked example (an excerpt-level `ux-design.md` + `DESIGN.md` pair) as an optional asset for mid-strength models, mirroring BMAD's `design-example-*.md`/`design-directions.md`. Owner: Katrina. Fit: best-practices guidance favors examples; keeps BMILD's two-template shape. Boundary: one optional asset, referenced as illustrative only.
- **C-12 — Headless/programmatic invocation contracts (reject-with-rationale).** JSON error contracts and TTY detection serve BMAD's pipeline use; BMILD personas are conversational-first across three harnesses, and the deterministic surface is the closed `prd-v1` gate. Evidence: `bmad-spec` headless, `bmad-prd/references/headless.md`.
- **C-13 — Customization/persona-config machinery (reject-with-rationale).** Requires `uv` runtime and layered TOML resolution; violates ADR 0013 install-less execution and BMILD's portability lane. Persona embodiment is already served by `SOUL.md`. Evidence: `bmad-agent-*` SKILL.md activation steps.
- **C-14 — Facilitator interaction-flow adoptions (reject-with-rationale — ownership).** Brainstorming stances/memlog/resume, party roster/memory, elicitation menu refinements: real prior art, but those flows are explicitly owned by `elicitation-refine` and out of scope for this audit's implementable backlog. Evidence recorded here for that initiative: `bmad-brainstorming` SKILL.md + `references/`, `bmad-party-mode` SKILL.md + `references/`, `bmad-advanced-elicitation` SKILL.md.
- **C-15 — Course-Correction halt conditions and issue taxonomy (adapt).** Add explicit stop conditions (no identifiable trigger, no concrete evidence → halt and ask) and a compact issue-type taxonomy to the Course-Correction entry. Evidence: `bmad-correct-course/checklist.md` §1 halt-conditions and categorization. Owner: Sonia (`course-correction.md`). Fit: sharpens an existing flow's entry gate; guarded vocabulary stays intact (`tests/course-correction-contract.sh` must be updated in the same change). Boundary: entry-step additions only.
- **C-16 — Lightweight spec-kernel entry path (reject-with-rationale).** BMILD's Direct-Dev/Direct-Fix modes and readiness-by-meaning already provide the small-change path; a SPEC.md kernel would add a competing artifact type. Evidence: `bmad-spec` SKILL.md.
- **C-17 — Richer PRD validation checklist (reject-with-rationale).** The `prd-v1` ruleset is closed by design; extension requires a new bounded ruleset identifier and fixtures per AGENTS.md. Content-level checks live in the completion criteria, which this MVP sharpened. Evidence: `bmad-prd/assets/prd-validation-checklist.md`.
- **C-18 — Analyst persona (reject-with-rationale).** Market/competitive research obligations are already carried by brief criteria (`competitive_context`); a ninth standard persona adds coordination cost without a load-bearing gap. Evidence: `bmad-agent-analyst`.
- **C-19 — Review word-metrics/structure tooling (reject-with-rationale).** Scripted metrics require a runtime; BMILD's review depth is a fixed judgment baseline by `review-depth` design and ADR 0013. Evidence: `bmad-review/scripts/`, `bmad-review/references/structure-models.md`.

## Ranked backlog (by downstream consequence)

1. **C-08 consistency conventions** — affects every independent builder on brownfield outcomes; drift here surfaces as integration defects long after authoring. Owners: Lance (author), Alex/Rahat (consumers).
2. **C-06 stable decision IDs** — affects cross-artifact reference precision (system-design ↔ ADR ↔ verification matrix); wrong references corrupt acceptance evidence. Owners: Lance, Sonia, Rahat.
3. **C-09 test-first for code outcomes** — affects defect-escape rate for every implemented outcome; cheap to land. Owners: Alex, Rahat.
4. **C-15 Course-Correction halts** — prevents unscoped impact analysis from running on vibes; low cost, guarded by an existing contract test. Owner: Sonia.
5. **C-02 glossary discipline** — reduces term drift between PRD and downstream UX/arch artifacts; medium blast radius, low ceremony. Owner: Faisal.
6. **C-01 journey scope dial** — proportionality for small products; prevents the journey shape becoming ceremony. Owner: Faisal.
7. **C-10 DESIGN.md inheritance patterns** — matters only once consuming projects use platform/UI-system inheritance; template-only. Owner: Katrina.
8. **C-11 worked UX example** — quality lift for mid-strength models; optional asset. Owner: Katrina.
9. Rejected (C-03, C-04, C-05, C-07, C-12, C-13, C-16, C-17, C-18, C-19) — rationale recorded above; revisit triggers noted where a future condition could reopen them.
10. **C-14 facilitator flows** — evidence bank for `elicitation-refine`; not implementable from this backlog.

## Completeness

- 70 of 70 inventoried files dispositioned; denominator reconciles with the frozen list above.
- All comparison sources were read from the local `external_references/bmad-method` snapshot on 2026-09-22; no network access was used.
- No `incomplete` entries. Two comparison families are recorded as `no counterpart` with the best-practice comparison proceeding: BMILD-specific governance artifacts (registry, rollup, handback, matrix, RCA, security-review templates) and session-wrapper resources.
