# Sec-Handback

Resolve security-owned governance items raised by other personas. Promote accepted changes into source artifacts so the handoff does not become shadow memory.

For new security reviews use Architecture-Security-Review, PR-Security-Review, or Slice-Security-Review.

## Additional Context

Load in this order:

- `[plan_folder]/<initiative-name>/registry.md`
- The referenced `security-review-<slug>.md` in full
- `[plan_folder]/<initiative-name>/handoff.md`
- Originating artifact or queue context (typically Alex fix against open finding, or Lance/Katrina design change resolving design-level finding)
- Upstream design artifacts (`system-design.md`, `ux-design.md`) when re-verifying design-level findings
- Confirm no `## Archived` entries or other initiative folders were loaded

## Global Directives

- **Scope and confidence discipline.** Re-verify only affected boundaries; >80% confidence before closing a finding.
- **Handoff-artifact discipline.** Coordination state is not security closure — close only when finding is confirmed resolved and re-verified.

**Promotion Cascade Check.** After each accepted closure affecting security posture, classify downstream consumers as `unaffected | minor-update | stale`:
- **0 stale owners** → no cascade action.
- **1 stale owner** → auto-enqueue one `H-###` per stale artifact; close follows verbatim-invocation rule.
- **≥2 stale owners** → mark artifacts in `registry.md ## Stale`; route to Sonia Course-Correction; append `Downstream Cascade: <summary>`. Cycle prevention: do not enqueue if `Supersedes` chain includes this handoff item.

## Semantic Memory

When resolved findings stabilize trust-model or security terminology:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms. Follow the authoring rules in `.agents/skills/bmild-pm/assets/context-template.md`.
- Update `[plan_folder]/context-map.md` when a security boundary establishes, modifies, or conflicts with a cross-initiative semantic boundary.

## Tasks

Progress:

- [ ] Step 1: Read each handoff item targeting Zach — most are re-verification requests for open findings.
- [ ] Step 2: Re-run security assessment on each affected boundary.
- [ ] Step 3: For resolved findings — update `security-review-<slug>.md` with closure evidence; update `Owner Disposition` and `Promotion Record`; run Promotion Cascade Check.
- [ ] Step 4: Note residual or newly-introduced findings.
- [ ] Step 5: For findings still open — keep open with updated next owner (Alex implementation, Lance/Katrina design); route handoff item; mark original deferred, rejected, or superseded as appropriate.
- [ ] Step 6: Persist changes; update `timestamp` frontmatter.
- [ ] Step 7: Semantic distillation gate — apply Semantic Memory rules when triggered.
- [ ] Step 8: Close — apply Exit and Handoff from the core skill. Zach remains terminal by default.

## Definition of Done

- [ ] Every security-owned handoff item assessed and re-verified-closed, deferred, rejected, or superseded
- [ ] Closure evidence recorded for resolved findings
- [ ] Residual or new findings recorded with next owner
- [ ] `context.md` and/or `context-map.md` updated only if the semantic distillation gate fired
- [ ] Close message: findings closed, findings still open, next owner
