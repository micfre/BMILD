# Write-PRD

Translate the agreed product intent into phased, constrained, testable scope. Define requirements, priorities, non-goals, acceptance criteria, and delivery boundaries. Challenge anything vague, over-scoped, unprioritized, or disconnected from the product brief. This is the contract for all downstream design work.

## Additional Context

Load in this order:
- `[plan_folder]/context-map.md` if it exists
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md`
- `[plan_folder]/<initiative-name>/product-brief.md` in full — this is the contract you are expanding
- Confirm no `## Archived` entries or other initiative folders were loaded

Also load before writing:
- `./resources/prd-completion-criteria.yaml`

## Additional Norms

Scan the codebase for any existing implementation relevant to the initiative before accepting any premise. Discovery before invention: do not accept a greenfield premise when existing code constrains the design.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows:
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

Documentation scope decisions — apply a decision for each audience:
- *User documentation:* required when shipped behaviour changes what an end user must discover, understand, configure, troubleshoot, or trust.
- *Operator documentation:* required when the initiative changes deployment, configuration, monitoring, support, recovery, data handling, or operational risk.
- *Contributor documentation:* required when future maintainers need new setup, architecture, workflow, testing, or extension knowledge.

Regulated NFRs and compliance obligations are consequential by default — probe, do not synthesize.

## Tasks

Progress:

- [ ] Step 1: Groundtruth — scan the codebase for any existing implementation relevant to the initiative (see Additional Norms).
- [ ] Step 2: Probe backward — review the existing `product-brief.md` for unresolved assumptions, handoff items, or scope edges that still need promotion. Route cross-artifact/source issues through `handoff.md` before proceeding; keep live user elicitation in chat unless async owner-to-owner continuity truly requires a governed handoff.
- [ ] Step 3: Elicit (diverge → synthesize → steer):
  - **Open with the PRD contour.** Name the sections and signal that consequential items earn depth and the rest will be synthesized for steering.
  - **Diverge on consequential sections.** Probe one open question at a time: functional requirements (by capability area), user journeys (named trigger, ordered steps, success exit, edge/failure paths), scope & prioritization (Phase 1 MVP vs Phase 2 Growth vs explicitly out of scope).
  - **Synthesize the remainder.** Once consequential sections are framed, draft inferred answers in one compact block: NFRs (scale, performance, compliance, with proposed thresholds for applicable categories only), documentation scope (user/operator/contributor), consequence-driven assumptions (each with confidence and consequence if wrong). Present the block and ask the user to redirect, accept, or escalate any item.
  - **Reopen only what the user steers.** Hedging or pushback promotes an item back to a probed decision with options.
  - **Governance routing.** Decide whether any remaining ambiguity belongs in `handoff.md` or a bounded assumption, with live user elicitation staying in chat unless async continuity is required.
  - Apply all Principles and Global Norms from the core skill.
- [ ] Step 4: Consequence-check — privately verify before writing:
  - Every Must Have is traceable to a user need from `product-brief.md`
  - Phase 1 is the absolute minimum to validate the idea
  - Explicitly out-of-scope items are listed
  - Non-functional requirements have thresholds, not just categories
  - Documentation scope has a decision for each audience
  - Any remaining ambiguity has a governed outcome: `handoff.md`, bounded assumption, or explicit defer/reject/supersede decision
- [ ] Step 5: Write — privately check `prd-completion-criteria.yaml` before writing. Write `[plan_folder]/<initiative-name>/prd.md` using `assets/prd-template.md`. Substitute `[user_name]` from `.bmild.toml`.
- [ ] Step 6: Gate check — walk the user through any remaining product-domain ambiguity that still needs synchronous resolution. For each: explain the issue, present options, give a recommendation. Keep user-owned resolution in chat unless async owner-to-owner continuity truly requires a governed handoff. If the gap belongs to UX or architecture ownership, create or update `handoff.md` with the target artifact and owner. Do not leave durable question threads in `prd.md`.
- [ ] Step 7: Register in context memory — open `[plan_folder]/<initiative-name>/registry.md`. Add `prd.md` to `## Live`. Move any superseded predecessor to `## Archived`.
- [ ] Step 8: Close — apply the Exit and Handoff format from the core skill. Downstream design handoff is now allowed because both PM artifacts exist. `Next` should point to Katrina, Lance, or both as appropriate to the initiative.

## Definition of Done

- [ ] Functional requirements, user journeys, scope/prioritization, NFRs, documentation scope, and assumptions documented
- [ ] Remaining ambiguity routed through `handoff.md` or bounded assumptions instead of embedded question sections
- [ ] `prd-completion-criteria.yaml` privately checked before writing
- [ ] `prd.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `registry.md` updated with `prd.md` in `## Live`
- [ ] Close message: artifacts written, queued or deferred governance items, next owner
- [ ] Both `product-brief.md` and `prd.md` now exist; downstream design handoff to Katrina and/or Lance is unblocked
