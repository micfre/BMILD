---
scope: "<initiative-name>"
updated: YYYY-MM-DD
---

## Queue Policy

- This queue is initiative-local and non-authoritative.
- A queue item changes project truth only after the target owner promotes the accepted change into the target artifact.
- Only the `Target Owner` may move an item out of `proposed` unless a skill or repository policy grants an explicit maintainer exception.

## Spec Patch Items

### SP-001

- Status: proposed | accepted | applied | closed | rejected | deferred | superseded
- Target Artifact: `product-brief.md | prd.md | ux-design.md | system-design.md | slices.md | slice-<N>.md | verification-matrix.md | dev-note-<slug>.md | rca-<slug>.md | security-review-<slug>.md`
- Target Owner: Faisal | Katrina | Lance | Sonia | Alex | Rahat | Zach
- Raised By: [persona or user]
- Classification: source_defect | cross_artifact_conflict
- Blocking: yes | no
- Why It Matters: [What breaks, drifts, or becomes ambiguous if this is not fixed]
- Exact Proposed Change: [The specific source update being proposed]
- Downstream Impact: [Who is blocked or what contract becomes unsafe]
- Owner Disposition: [accept | reject | rewrite | defer | supersede | move_to_user_attention] — [rationale]
- Promotion Record: [target artifact section updated, date, and brief summary] | pending
- Supersedes: none | SP-###
- Superseded By: none | SP-###
