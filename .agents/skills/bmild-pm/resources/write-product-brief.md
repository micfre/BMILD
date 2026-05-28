# Write-Product-Brief

Help the user articulate the product vision, capability posture, user value, strategic rationale, and longer-horizon direction. The user owns the vision; Faisal owns making it explicit, coherent, weighted, and durable.

## Additional Context

Load in this order:
- `README.md` at the project root if it exists — anchors product context and audience
- `[plan_folder]/context-map.md` if it exists — constrains shared terminology and cross-initiative semantic boundaries
- `[plan_folder]/rollup.md` if it exists
- `[plan_folder]/<initiative-name>/registry.md` if the initiative is named or inferable
- `./resources/brief-completion-criteria.yaml`
- Confirm no other initiative folders or `## Archived` entries were loaded

If none exist, start fresh.

## Stakes-based elicitation

Per-section `stakes` in `brief-completion-criteria.yaml` sets elicitation depth. Use those values — do not re-derive stakes ad hoc. When `stakes_note` is present, it overrides `stakes` for pacing.

| `stakes` | Behaviour |
| :--- | :--- |
| **consequential** | One open question at a time. Options with pros/cons/consequences and a conditional recommendation. Pushback or hedging keeps the section here. |
| **medium** | Recommendation plus one-line reaction request. Expand to options only on pushback. |
| **low** | Batch in one synthesis block. Ask the user to *steer*, not *approve*. Tag each item: `Assumption` → `Confidence` → `Consequence if wrong`. |

**Session pacing:** After loading YAML, partition in-scope sections by effective stakes. **Diverge** on consequential sections first (`problem`, `target_users`, `success_criteria`). **Synthesize** medium sections (`solution`, `competitive_context`, `scope`, `vision`, `project_context` when applicable) and low sections (`governance_routing` when applicable) in one compact block. **Reopen** any synthesized section the user steers back to consequential pacing.

## Global Directives

- **Diverge before converging.** Consequential sections from YAML first; medium and low sections synthesized for steering.
- **Problem framing precedes features.** Capture full vision and a tight initiative boundary in the brief. Defer MVP-vs-Growth bucketing and documentation scope to PRD mode.
- **Naked assumptions are forbidden in artifacts.** Every documented assumption, deferral, and open question carries `Assumption` → `Confidence` → `Consequence if wrong`.
- **Artifact-authority discipline.** `handoff.md` is for source-artifact defects, cross-artifact conflicts, and promotion requests that require another owner's action. Live user elicitation stays in chat unless async continuity truly requires a governed handoff. Bounded assumptions are only valid when low-risk and reversible.

## Semantic Memory

When product/domain meaning becomes stable during this session:
- Update `[plan_folder]/<initiative-name>/context.md` for initiative-local terms, boundaries, relationships, and resolved ambiguities.
- Update `[plan_folder]/context-map.md` when this initiative establishes or changes a cross-initiative semantic boundary.
- Do not create a separate project-strategy artifact.

## Tasks

Progress:

- [ ] Step 1: Groundtruth — verify repository reality per core NON-NEGOTIABLES before accepting any premise.
- [ ] Step 2: Elicit (diverge → synthesize → steer) — apply Stakes-based elicitation:
  - **Open with the brief contour.** Name in-scope sections grouped by YAML `stakes` and signal that consequential sections get depth and medium/low sections will be synthesized — not a serial walk.
  - **Diverge on consequential sections.** Work `problem`, `target_users`, and `success_criteria` one question per turn until each passes its YAML weak_signal check.
  - **Synthesize medium and low sections.** Draft inferred answers for remaining in-scope sections in one compact block, each tagged with confidence. Ask the user to redirect, accept, or escalate any item.
  - **Reopen only what the user steers.** Pushback or hedging promotes that section to consequential pacing; otherwise lock the synthesis.
  - **Capture tangents in chat.** Fold out-of-band input into the next probe or synthesis block.
- [ ] Step 3: Consequence-check — privately verify before writing:
  - Core problem and who feels it is explicit
  - Target users are named, not generic
  - At least one success criterion is measurable
  - Scope is a tight boundary, not a feature list
  - Any unresolved user-owned ambiguity is resolved live, routed through `handoff.md` only when async owner-to-owner continuity is required, or documented as a bounded assumption only when low-risk and reversible
  - Every in-scope section in `brief-completion-criteria.yaml` passes falsifiable / good_signal / weak_signal
- [ ] Step 4: Pre-exit offer (declinable in one word) — *"Before I write the brief — anything you want to take to roundtable or stress-test first? Otherwise I'll proceed."* Offer advanced facilitator skills per core Advanced Elicitation Triggers when trade-offs are still open.
- [ ] Step 5: Write — write `[plan_folder]/<initiative-name>/product-brief.md` using `assets/product-brief-template.md`. Substitute `[user_name]` from `.bmild.toml`.
- [ ] Step 6: Semantic distillation gate — apply Semantic Memory rules when triggered.
- [ ] Step 7: Register — open or create `[plan_folder]/<initiative-name>/registry.md` from `assets/registry-template.md`. Add `product-brief.md` to `## Live`.
- [ ] Step 8: Close — apply Exit and Handoff from the core skill. `Next` stays with Faisal for Write-PRD; do not hand off to Katrina or Lance until both `product-brief.md` and `prd.md` meet completion criteria.

## Definition of Done

- [ ] Problem, target users, competitive context, success criteria, scope, and vision are documented
- [ ] `brief-completion-criteria.yaml` verified for all in-scope sections
- [ ] Remaining ambiguity routed through `handoff.md` or bounded assumptions — not durable question sections in `product-brief.md`
- [ ] `product-brief.md` written to `[plan_folder]/<initiative-name>/`
- [ ] `context.md` and `context-map.md` updated only if the semantic distillation gate fired
- [ ] `registry.md` updated with `product-brief.md` in `## Live`
- [ ] Close message: artifacts written, any queued or deferred governance items, next owner
- [ ] `Next` stays with Faisal for Write-PRD; downstream design handoff blocked until both PM artifacts exist
