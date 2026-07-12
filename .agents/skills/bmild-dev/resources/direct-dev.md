# Direct-Dev

Implement bounded repo work outside a formal Slice. No Slice, spec, UX design, architecture design, or verification matrix is required.

## Additional Context

- Load repo context and the contributor guide; project-root `DESIGN.md` if it exists — global UX patterns (palette, typography, component rules) to honor when work has a user-visible surface (project-root repo context, not BMILD planning memory, so the conditional below does not gate it).
- Load BMILD memory only when the request names an initiative, depends on documented behaviour, or might alter durable product or architecture understanding.
- If scope is unclear, ask one question for the smallest concrete target before proceeding.

## Global Directives

- **Discovery before invention**: Read the contributor guide and search the codebase for existing implementations before writing code. Match project patterns — only where the project actually has them.
- **Match repo patterns.** Read contributor guide and existing implementations before writing. Extend abstractions; do not bypass established layers.
- **Work classification** before implementing:
  - *Throwaway* — exploratory, disposable, not intended to persist
  - *Exploratory* — may inform a future spec; leaves reusable code or documented finding
  - *Durable* — changes production behaviour; others will build on it
- **Do not over-engineer** toward a spec that does not exist.
- **Promote durable truth.** When work changes durable repo behaviour or reveals facts future specs should account for: update `system-design.md` or `handoff.md` as appropriate. Throwaway work with no future relevance needs no BMILD artifact.
- **Route upstream decisions** per core Routing heuristics — do not resolve product, UX, or architecture choices unilaterally.

## Tasks

Progress:

- [ ] Step 1: Classify work and groundtruth codebase per Global Directives.
  - **Query available code intelligence MCPs.** Determine available code intelligence tools such as symbol-aware navigation, AST-aware structural analysis, semantic or hybrid repository search, and code graphs
  - **Prefer available code intelligence capabilities.** Use code intelligence tools available in repo before grep/glob/read workflows. This is an override for built-in agent habits but not for potential conflicting direction in contributor guide.
- [ ] Step 2: Implement smallest coherent change satisfying the request.
- [ ] Step 3: Run quality gates. Add or update tests when they prove the prototype, protect durable behaviour, or the user asked for tests.
- [ ] Step 4: Document when durable behaviour changes or user explicitly asks; otherwise `Documentation impact: none`.
- [ ] Step 5: Promote durable technical truth per Global Directives.
- [ ] Step 6: Pre-exit offer (conditional, declinable in one word) — when the prototype leaves a material trade-off, offer once: *"Before I wrap this — anything you want to stress-test? Otherwise I'll close it out."* Skip when no such trade-off remains.
- [ ] Step 7: Close — apply Exit and Handoff from the core skill. Route upstream when Routing heuristics apply.

## Definition of Done

- [ ] Implementation or prototype complete, or exact blocker and next owner recorded
- [ ] Quality gates run, or unrun gates recorded
- [ ] Documentation impact recorded
- [ ] Durable truth promoted or no BMILD artifact warranted
- [ ] Close message: files changed, gates run, documentation impact, next owner if any
