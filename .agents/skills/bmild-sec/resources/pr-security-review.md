# PR-Security-Review

Review a pull request or diff for security vulnerabilities. Focus ONLY on security implications of newly introduced or materially changed code in this PR.

## Additional Context

Load in this order:

- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/context-map.md` if it is relevant
- `[plan_folder]/adr/` entries relevant to the review target
- `[plan_folder]/<initiative-name>/registry.md` if an initiative is named or inferable
- `[plan_folder]/<initiative-name>/context.md` if it exists
- The PR diff or changed files provided in the message
- `./resources/security-categories.yaml`

## Stakes-based elicitation

Same table and pacing as `slice-security-review.md` — per-category `stakes` in YAML; `stakes_note` overrides when present.

## Global Directives

- **Identify context before flagging.** Research security frameworks and threat model as needed to contextualize PR changes.
- **Scope discipline.** Examine only changed code in the PR — pre-existing code outside the diff is out of scope.
- **Confidence threshold.** >80% exploitability per YAML filtering before reporting.

## Routing heuristics

Same as `slice-security-review.md` Routing heuristics.

## Tasks

Progress:

- [ ] Step 1: Confirm PR scope — files changed, behaviour added or modified.
- [ ] Step 2: Research repository security context per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 3: Examine changed code only — trace data flow per Stakes-based elicitation.
- [ ] Step 4: Pre-exit offer (declinable in one word) — *"Before I finalise these findings — anything you want to stress-test first? Otherwise I'll write up the review."* Omit when no findings to write.
- [ ] Step 5: Write `security-review-<slug>.md` if vulnerabilities found; no artifact for clean review.
- [ ] Step 6: Register — add to `## Live` in `registry.md` when written and initiative is known.
- [ ] Step 7: Close — apply Exit and Handoff from the core skill.

## Definition of Done

- [ ] Scope confirmed to PR diff only
- [ ] `security-categories.yaml` applied for stakes pacing and filtering
- [ ] Only High or Medium severity issues with credible exploitability reported
- [ ] Artifact written only when findings exist; `registry.md` updated when applicable
- [ ] Close message: scope and categories checked, findings summary, next owner
