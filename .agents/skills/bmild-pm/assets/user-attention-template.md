---
scope: "<initiative-name>"
updated: YYYY-MM-DD
---

## Queue Policy

- This queue is initiative-local and non-authoritative.
- `answered` captures user input but does not change project truth on its own.
- The `Target Owner` must translate the answer into the target artifact before the item is treated as resolved.

## User Attention Items

### UA-001

- Status: open | answered | applied | closed | rejected | deferred | superseded
- Promotion Target Artifact: `product-brief.md | prd.md | ux-design.md | system-design.md | slices.md | slice-<N>.md | verification-matrix.md | dev-note-<slug>.md | rca-<slug>.md | security-review-<slug>.md`
- Target Owner: Faisal | Katrina | Lance | Sonia | Alex | Rahat | Zach
- Raised By: [persona or user]
- Blocking: yes | no
- Context: [Enough context for async answerability without chat reconstruction]
- Prompt: [One discrete question]
- Answer Mode: freeform | single-choice | multi-choice | approval
- Options: [Only when structured choices are helpful]
- Recommendation: [Suggested answer or framing]
- User Response: pending | [captured response]
- Promotion Record: [target artifact section updated, date, and brief summary] | pending
- Supersedes: none | UA-###
- Superseded By: none | UA-###
