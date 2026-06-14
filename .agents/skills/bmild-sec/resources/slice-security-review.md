# Slice-Security-Review

Review a completed Slice implementation for security vulnerabilities. Focus ONLY on security implications newly added by this Slice's code changes.

## Additional Context

Load in this order:

- `[plan_folder]/adr/` entries relevant to the Slice's security model
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/context.md` if it exists
- `[plan_folder]/<initiative-name>/system-design.md` if it exists
- `[plan_folder]/<initiative-name>/prd.md` and `product-brief.md` if they exist
- `[plan_folder]/<initiative-name>/slice-<N>.md` — the Slice being reviewed
- `./resources/security-categories.yaml`

## Stakes-based elicitation

Per-category `stakes` in `security-categories.yaml` sets review depth. When `stakes_note` is present, it overrides pacing for that category.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | Full data-flow trace from untrusted input to sensitive sink. Document exploit scenario, impact, and remediation before flagging. Offer roundtable when multiple defensible remediations exist. |
| **medium** | Pattern match against codebase secure conventions; trace only when deviation introduces credible exploit path. Apply `stakes_note` elevation when triggered. |
| **low** | N/A at category level — apply filtering threshold and hard exclusions only. |

**Review pacing:** Assess consequential categories first (`input_validation`, `authentication_authorization`, `crypto_secrets`, `injection_code_execution`). Then medium categories (`data_exposure`, respecting `stakes_note`). Apply `filtering` rules throughout — confidence ≥ 0.8 required to report.

## Global Directives

- **Identify context before flagging.** Map existing security frameworks, sanitization patterns, and threat model before flagging deviations.
- **Scope discipline.** Review only newly introduced or materially changed attack surfaces. Pre-existing untouched code is out of scope.
- **Confidence threshold.** Flag only issues with >80% confidence of actual exploitability per YAML filtering.
- When reviewing a fix for an existing `security-review-<slug>.md`, update the existing artifact — do not create a duplicate.

## Routing heuristics

- *Vulnerability candidate* → record file/contract, exploit scenario, impact, confidence, remediation direction.
- *Design-level gap* (missing auth contract, untrusted boundary, threat model violation) → Lance (or Katrina for UX trust-boundary issues).
- *Implementation error* (contract violated in code) → Alex.
- *Clean review* → state explicitly scope and categories checked. Silence is not "no findings."
- *Hard exclusions* → do NOT report (see YAML `filtering.hard_exclusions`).

## Tasks

Progress:

- [ ] Step 1: Research repository security context per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 2: Compare Slice new code against established secure patterns; flag deviations and new attack surfaces only within Slice scope.
- [ ] Step 3: Examine implementation files — trace data flow per Stakes-based elicitation and YAML categories.
- [ ] Step 4: Pre-exit offer (declinable in one word) — *"Before I finalise these findings — anything you want to stress-test first? Otherwise I'll write up the review."* Omit when no findings to write.
- [ ] Step 5: Write `security-review-<slug>.md` using `assets/security-review-template.md` if vulnerabilities found. Reference `handoff.md` path for source-artifact defects. No artifact for clean review.
- [ ] Step 6: Register — add `security-review-<slug>.md` to `## Live` in `registry.md` when written.
- [ ] Step 7: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Repository security context researched before flagging
- [ ] `security-categories.yaml` applied for scope, stakes pacing, and false-positive filtering
- [ ] Only High or Medium severity issues with credible exploitability reported
- [ ] `security-review-<slug>.md` written if vulnerabilities found; no artifact for clean review
- [ ] `registry.md` updated if artifact written
- [ ] Close message: scope and categories checked, findings summary, next owner
