# Refine-PRD

Revisit and improve existing PM artifacts. Probe what changed, challenge stale content, and update. Existing specs are a starting point to challenge, not a contract to honour.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full
- `[plan_folder]/<initiative-name>/prd.md` in full (if it exists)
- Confirm no `## Archived` entries or other initiative folders were loaded

Also load before writing:
- `./resources/brief-completion-criteria.yaml`
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

- [ ] Step 1: Determine what has changed or what is being challenged. If the user has not specified, ask one question. Possible triggers: scope shifted since the brief was written; user needs or competitive context changed; downstream personas (Katrina, Lance) surfaced gaps requiring product decisions; user wants to stress-test or improve existing content.
- [ ] Step 2: If any brainstorming session preceded this artifact, load it and cross-reference its ideas against the current `product-brief.md` and `prd.md`. Identify ideas that were silently dropped — especially soft or qualitative ideas (interaction feel, tone, personality, coaching approach, "what should this feel like") that don't map cleanly to functional requirements. Present findings and ask whether any should be incorporated before proceeding.
- [ ] Step 3: Groundtruth and challenge — treat all existing content as a starting point. Probe what was assumed vs. what has been validated. Surface any unresolved handoff items or assumptions that have not been tested. Apply all Principles and Global Directives from the core skill. If live `handoff.md` items target `product-brief.md` or `prd.md`, resolve them in this refinement or explicitly defer, reject, supersede, or keep them open with a clear next owner.
- [ ] Step 4: Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session.
- [ ] Step 5: Elicit refinements — probe the specific sections requiring change with the same depth and rigour as initial authoring. Do not skip elicitation because upstream work already exists.
- [ ] Step 6: Write — privately check `brief-completion-criteria.yaml` and `prd-completion-criteria.yaml` before writing. Update the relevant artifacts using `assets/product-brief-template.md` and `assets/prd-template.md` as structural references. Preserve sections not being changed. Update the `updated` frontmatter date.
- [ ] Step 7: Gate check — walk the user through any remaining product ambiguity that still needs live resolution. For each: explain the issue, present options, give a recommendation. Keep user-owned gaps in chat unless async owner-to-owner continuity truly requires a governed handoff. Route UX or architecture gaps through `handoff.md` rather than durable handoff sections in PM artifacts.
- [ ] Step 8: Semantic distillation gate — update initiative `context.md` when refined product/domain meaning becomes stable and `context-map.md` when the refinement introduces or changes a cross-initiative semantic boundary.
- [ ] Step 9: Register in context memory — open `[plan_folder]/<initiative-name>/registry.md`. Move any superseded predecessor to `## Archived`. Confirm `product-brief.md` remains in `## Live`. If `prd.md` exists or was written in this pass, confirm it is also in `## Live`.
- [ ] Step 10: Close — apply the Exit and Handoff format from the core skill. If `prd.md` is still missing after this refinement, `Next` stays with Faisal for PRD authoring. Otherwise downstream design handoff is allowed.

## Definition of Done

- [ ] Brainstorming ideas reconciled (if applicable)
- [ ] Refinement target identified and all relevant sections updated
- [ ] Existing content challenged, not just preserved
- [ ] Relevant `handoff.md` items targeting PM-owned artifacts resolved, deferred, rejected, superseded, or kept open with a clear next owner
- [ ] Remaining user-owned ambiguity resolved in chat or handled as bounded assumptions when safe
- [ ] Updated artifacts written; `updated` date current
- [ ] `context.md` or `context-map.md` updated only if the semantic distillation gate fired
- [ ] `registry.md` reflects current artifact state
- [ ] Close message: what changed, queued or deferred governance items, next owner
- [ ] Downstream design handoff blocked until both `product-brief.md` and `prd.md` meet the bar; if `prd.md` is still missing, `Next` stays with Faisal
