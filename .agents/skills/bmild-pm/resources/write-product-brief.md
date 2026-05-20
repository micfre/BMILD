# Write-Product-Brief

Help the user articulate the product vision, capability posture, user value, strategic rationale, and longer-horizon direction. The user owns the vision; Faisal owns making it explicit, coherent, weighted, and durable.

## Additional Context

Load in this order:
- `README.md` at the project root if it exists — anchors product context and audience
- `[plan_folder]/CHARTER.md` if it exists — constrains product vision and competitive positioning (emergent; absent on most projects)
- `[plan_folder]/_system/_rollup.md` if it exists
- `[plan_folder]/<initiative-name>/_context.md` if the initiative is named or inferable
- Confirm no other initiative folders or `## Archived` entries were loaded

If none exist, start fresh.

## Additional Norms

Before accepting any premise, quickly verify the current state of the codebase. Discovery before invention: scan the codebase before accepting a greenfield premise in a brownfield project. Do not invent greenfield solutions in a brownfield environment.

Prefer available code intelligence capabilities over raw filesystem traversal when possible, before falling back to grep/glob/read workflows:
- Use symbol-aware navigation tools (e.g. Serena)
- AST-aware structural analysis (e.g. ast-grep)
- Semantic or hybrid repository search (e.g. ck-search)

Use the highest-signal discovery method appropriate to the task: symbol navigation for known entities, semantic search for behavioural or architectural concepts, and AST-aware analysis for syntax-sensitive pattern matching, migrations, and refactors.

## Tasks

Progress:

- [ ] Step 1: Groundtruth — quickly verify the current state of the codebase before accepting any premise (see Additional Norms).
- [ ] Step 2: Elicit (diverge → synthesize → steer):
  - **Open with the brief contour.** Name the sections you expect to cover and signal that the session is short on consequential framing and dense on inferred-assumption steering — not a serial walk.
  - **Diverge on consequential sections first.** Problem, target users, and at least one measurable success criterion warrant one open question per turn until framed. These shape every downstream artifact.
  - **Synthesize the remainder.** Once consequential sections are framed, draft inferred answers for Solution, Competitive context, Initiative boundary, and 2-3 Year Vision in one compact synthesis block, each tagged with confidence. Present the block and ask the user to redirect, accept, or escalate any item.
  - **Reopen only what the user steers.** If the user pushes back on a synthesized item, or hedges, promote that item to a consequential probe with options. Otherwise lock the synthesis.
  - **Section transitions remain soft.** Use Trigger-Condition Rules for "anything else?" gates and out-of-section captures.
  - Apply all Principles and Global Norms from the core skill.
- [ ] Step 3: Consequence-check — privately verify before writing:
  - Core problem and who feels it is explicit
  - Target users are named, not generic
  - At least one success criterion is measurable
  - Scope is a tight boundary, not a feature list
  - Any unresolved user-owned ambiguity is either resolved live, queued in `user-attention.md`, or documented as a bounded assumption only when low-risk and reversible
- [ ] Step 4: Write — write `[plan_folder]/<initiative-name>/product-brief.md` using `assets/product-brief-template.md`. Substitute `[user_name]` from `.bmild.toml`.
- [ ] Step 5: Distillation gate — `[plan_folder]/CHARTER.md` is not authored by default. Seed or update it only when at least one of the following is true: this initiative's product-brief conflicts with an existing sibling initiative's product-brief; this initiative establishes a project-level invariant (vision, target user model, or competitive positioning) that future unrelated initiatives must align with; the user explicitly asks for project-level vision/positioning to be captured. If the gate fires, write or update `[plan_folder]/CHARTER.md` using `assets/charter-template.md` and append an entry to its Distillation Log. If the gate does not fire, do not write to the canonical tier.
- [ ] Step 6: Register in context memory — open or create `[plan_folder]/<initiative-name>/_context.md` from `assets/context-memory-template.md`. Add `product-brief.md` to `## Live`.
- [ ] Step 7: Close — apply the Exit and Handoff format from the core skill. `Next` should remain with Faisal for Write-PRD mode. Do not hand off to Katrina or Lance yet; downstream design handoff starts only after both `product-brief.md` and `prd.md` are written to standard.

## Definition of Done

- [ ] Problem, target users, competitive context, success criteria, scope, and vision are documented
- [ ] Remaining ambiguity is routed through `user-attention.md`, `spec-patch-queue.md`, or bounded assumptions rather than durable question sections in `product-brief.md`
- [ ] `product-brief.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `CHARTER.md` seeded or updated only if the distillation gate fired (cross-initiative conflict, new project-level invariant, or explicit user request)
- [ ] `_context.md` updated with `product-brief.md` in `## Live`
- [ ] Close message: artifacts written, any queued or deferred governance items, next owner
- [ ] `Next` stays with Faisal for Write-PRD; downstream design handoff blocked until both PM artifacts exist
