# BMILD Skill Best-Practices Evaluation

Source: `docs/agent-skills-best-practices.md`

## Summary

BMILD is strongest where it encodes real lifecycle expertise, artifact handoffs, and role boundaries. The main gaps found during the May 2026 dogfooding pass were context-loading waste, hidden design decisions, over-slicing, fragile table output, and missing persistent verification records. The current skill updates address those gaps directly.

## Evaluation

- Start from real expertise: mostly compliant.
  - BMILD is grounded in SDLC roles and real execution traces. Continue feeding failed or surprising runs into `## Gotchas`.
- Extract from a hands-on task: mostly compliant.
  - The Arch, Planner, Dev, and QA updates are based on real E2E feedback. Add future trace-derived corrections as small deltas.
- Synthesize from existing project artifacts: mostly compliant.
  - Skills read `spec.md`, `ux-design.md`, `system-design.md`, `slices.md`, and QA/Sec artifacts. Cross-artifact creator/consumer/validator roles are now explicit.
- Refine with real execution: partially compliant.
  - This pass improves compliance. Future releases should add example prompts or lightweight regression scenarios for critical persona behavior.
- Spend context wisely: partially compliant.
  - Conditional loading is now clearer for UX, Arch, and advanced modes. Planner, QA, and Sec intentionally reload because stale context is riskier than token cost.
- Add what the agent lacks, omit what it knows: partially compliant.
  - The new structure keeps BMILD-specific rules and removes some ambiguous mode framing. Continue trimming generic role prose when it does not affect behavior.
- Design coherent units: mostly compliant.
  - Persona boundaries are coherent. Interactive modes now return to the calling context instead of becoming parallel workflows.
- Aim for moderate detail: partially compliant.
  - Planner and QA remain dense because their tasks are fragile. The added section structure should make that density easier to follow.
- Progressive disclosure: mostly compliant.
  - Advanced modes already use step files. Standard personas still keep core workflow in `SKILL.md`, which is appropriate because the rules are always relevant.
- Match specificity to fragility: mostly compliant.
  - Context loading, artifact writing, QA documentation, and Slice budgeting are now prescriptive. Design-tier decision interaction now prefers labelled options and native response-picker tools for constrained choices while keeping explanations conversational.
- Provide defaults, not menus: mostly compliant.
  - Labelled decision option blocks are now default for competing options; Debate/Elicit are recommended only when the local persona should not resolve alone.
- Favor procedures over declarations: mostly compliant.
  - Modes are now workflow variants and "begin" behavior routes into process rather than artifact generation.
- Gotchas sections: compliant.
  - All 10 skills now include gotchas focused on facts that defy reasonable assumptions, such as stale chat-only defects, ambiguous phase boundaries, deprecated prior art, and matrix debt.
- Templates for output format: mostly compliant.
  - Persistent artifact templates exist and table-heavy sections were converted to bullet structures.
- Checklists for multi-step workflows: compliant.
  - Ordered persona workflows, handoff mechanics, and step-file task flows use `Progress:` checklists with `- [ ] Step N: ...`. Guidelines remain prose or ordinary bullets.
- Validation loops: partially compliant.
  - Completion criteria exist for PM, UX, and Arch; Planner/Dev/QA validation loops are stronger after this pass. `scripts/validate-skills.sh` now covers required skill sections, frontmatter names, description length, workflow checklists, sequence-file checklist markers, cross-flow artifact markers, and accidental table rows.
- Plan-validate-execute: mostly compliant.
  - Planner readiness, Nyquist matrix authoring, Slice budgeting, Dev gates, and QA verification now form a clearer plan-validate-execute chain.
