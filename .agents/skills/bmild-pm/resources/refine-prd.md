# Refine-PRD

Revisit and improve an existing PRD. Probe what changed, challenge stale requirements, and update `prd.md`. Existing content is a starting point to challenge, not a contract to preserve.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full (source contract for requirement traceability)
- `[plan_folder]/<initiative-name>/prd.md` in full
- Confirm no `## Archived` entries or other initiative folders were loaded

Also load before writing:
- `./resources/prd-completion-criteria.yaml`

## Additional Directives

When refinement depends on existing behaviour, verify current codebase reality before accepting the old artifact as true. Discovery before invention: scan the codebase before accepting a greenfield premise in a brownfield project.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows:
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

Documentation scope decisions — apply a decision for each audience when PRD content is being updated:
- *User documentation:* required when shipped behaviour changes what an end user must discover, understand, configure, troubleshoot, or trust.
- *Operator documentation:* required when the initiative changes deployment, configuration, monitoring, support, recovery, data handling, or operational risk.
- *Contributor documentation:* required when future maintainers need new setup, architecture, workflow, testing, or extension knowledge.

## Tasks

Progress:

- [ ] Step 1: Determine what changed in requirements and delivery contract. If the user has not specified, ask one question. Typical triggers: capability scope shifted, journey changed, priority moved across phases, new NFR threshold, or documentation obligations changed.
- [ ] Step 2: If any brainstorming session preceded this artifact, load it and cross-reference ideas against the current `prd.md`. Identify silently dropped ideas that should now affect functional requirements, journeys, or scope boundaries. Present findings and ask whether any should be incorporated before proceeding.
- [ ] Step 3: Groundtruth and challenge — treat existing PRD content as a starting point. Probe what was assumed versus validated. Surface unresolved PM-owned handoff items that touch `prd.md`. Apply all Principles and Global Directives from the core skill.
- [ ] Step 4: Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session.
- [ ] Step 5: Elicit refinements — probe the specific PRD sections requiring change with the same depth and rigor as initial authoring. Do not skip elicitation because upstream work already exists.
- [ ] Step 6: Write — privately check `prd-completion-criteria.yaml` before writing. Update `[plan_folder]/<initiative-name>/prd.md` using `assets/prd-template.md` as the structural reference. Preserve sections not being changed. Update the `updated` frontmatter date.
- [ ] Step 7: Gate check — walk the user through any remaining product ambiguity that still needs live resolution. For each: explain the issue, present options, give a recommendation. Keep user-owned gaps in chat unless async owner-to-owner continuity truly requires a governed handoff. Route UX or architecture gaps through `handoff.md` rather than durable handoff sections in PM artifacts.
- [ ] Step 8: Register in context memory — open `[plan_folder]/<initiative-name>/registry.md`. Confirm `prd.md` remains in `## Live`. Move any superseded predecessor to `## Archived` if applicable.
- [ ] Step 9: Close — apply the Exit and Handoff format from the core skill. Downstream design handoff is allowed when both PM artifacts are now coherent.

## Definition of Done

- [ ] Brainstorming ideas reconciled (if applicable)
- [ ] Refinement target identified and relevant PRD sections updated
- [ ] Existing PRD content challenged, not merely preserved
- [ ] Relevant `handoff.md` items targeting `prd.md` resolved, deferred, rejected, superseded, or kept open with a clear next owner
- [ ] Remaining user-owned ambiguity resolved in chat or handled as bounded assumptions when safe
- [ ] `prd-completion-criteria.yaml` privately checked before writing
- [ ] `prd.md` written with current `updated` date
- [ ] `registry.md` reflects current PRD state
- [ ] Close message: what changed, queued or deferred governance items, next owner
- [ ] Downstream design handoff is explicit in `Next` when PM artifacts are coherent
