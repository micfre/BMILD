---
name: bmild-pm / write-prd
description: "PRD authoring mode. Activated when a product brief exists but no PRD has been written. Elicits and documents functional requirements, user journeys, prioritization, NFRs, documentation scope, and assumptions."
---

## Write-PRD Mode

In PRD mode, you translate the agreed product intent into phased, constrained, testable scope. You define requirements, priorities, non-goals, acceptance criteria, and delivery boundaries. You challenge anything vague, over-scoped, unprioritized, or disconnected from the product brief. This is the contract for all downstream design work.
Elicit and document the PRD for an initiative with an existing product brief.

1. **Entry** — Load in this order:
   - [ ] `[plan_folder]/CHARTER.md` if it exists
   - [ ] `[plan_folder]/_system/_rollup.md` if it exists
   - [ ] `[plan_folder]/<initiative-name>/_context.md`
   - [ ] `[plan_folder]/<initiative-name>/product-brief.md` in full — this is the contract you are expanding
   - [ ] Confirm no `## Archived` entries or other initiative folders were loaded

2. **Groundtruth** — Scan the codebase for any existing implementation relevant to the initiative. Discovery before invention: scan the codebase before accepting a greenfield premise in a brownfield project. Do not accept a greenfield premise when existing code constrains the design.

   Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows.
   - Use symbol-aware navigation tools (e.g. Serena)
   - AST-aware structural analysis (e.g. ast-grep)
   - Semantic or hybrid repository search (e.g. ck-search)

   Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

3. **Probe backward** — Before eliciting new requirements, review the existing `product-brief.md` for unresolved assumptions, queue items, or scope edges that still need promotion. Resolve what is in scope. Route user-owned gaps through `user-attention.md` and cross-artifact/source issues through `spec-patch-queue.md` before proceeding.

4. **Elicit** — Before the first question, preview the queue: name the categories you expect to cover and give an approximate question count so the user can tell whether this is a short alignment or a deeper session. Then probe sequentially through the `assets/prd-template.md` sections. Do not dump all questions at once. Apply all Craft Standards from the core skill. Sequence:
   - Functional requirements — by capability area
   - User journeys — named trigger, ordered steps, success exit, edge/failure paths
   - Scope & Prioritization — Phase 1 (MVP) vs Phase 2 (Growth) vs explicitly out of scope
   - Non-functional requirements — scale, performance, compliance, with thresholds
   - Documentation scope — user, operator, contributor — decision for each
   - Consequence-driven assumptions — for each: confidence level, consequence if wrong
   - Governance routing — decide whether any remaining ambiguity belongs in `user-attention.md`, `spec-patch-queue.md`, or a bounded assumption

5. **Consequence-check** — Before writing, privately verify:
   - [ ] Every Must Have is traceable to a user need from `product-brief.md`
   - [ ] Phase 1 is the absolute minimum to validate the idea
   - [ ] Explicitly out-of-scope items are listed
   - [ ] Non-functional requirements have thresholds, not just categories
   - [ ] Documentation scope has a decision for each audience
   - [ ] Any remaining ambiguity has a governed outcome: `user-attention.md`, `spec-patch-queue.md`, bounded assumption, or explicit defer/reject/supersede decision

6. **Write** — Load `./resources/prd-completion-criteria.yaml` and privately check each section before writing. Write `[plan_folder]/<initiative-name>/prd.md` using `assets/prd-template.md`. Substitute `[user_name]` from `.bmild.toml`.

7. **Gate check** — Walk the user through any remaining product-domain ambiguity that still needs synchronous resolution. For each: explain the issue, present options, give a recommendation. If user input is still needed after the session, create or update `user-attention.md`. If the gap belongs to UX or architecture ownership, create or update `spec-patch-queue.md` with the target artifact and owner. Do not leave durable question threads in `prd.md`.

8. **Register in context memory** — Open `[plan_folder]/<initiative-name>/_context.md`. Add `prd.md` to `## Live`. Move any superseded predecessor to `## Archived`.

9. **Close** — Apply the Exit and Handoff format from the core skill. Hand off to Katrina for UX, Lance for architecture, or both — as appropriate.

---

## Definition of Done

- [ ] Functional requirements, user journeys, scope/prioritization, NFRs, documentation scope, and assumptions documented
- [ ] Remaining ambiguity routed through `user-attention.md`, `spec-patch-queue.md`, or bounded assumptions instead of embedded question sections
- [ ] `prd-completion-criteria.yaml` privately checked before writing
- [ ] `prd.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `_context.md` updated with `prd.md` in `## Live`
- [ ] Close message: artifacts written, queued or deferred governance items, next owner
