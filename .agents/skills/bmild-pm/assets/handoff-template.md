---
type: Handoff
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name>"
---

## Policy

- This file is initiative-local and non-authoritative.
- Project truth changes only when the target owner promotes the accepted change into the target artifact.
- A scribe-applied item (see `references/scribe-path.md`) is written and **closed in the same turn** with `Promotion Record: applied_by_scribe — …`; this is passive provenance (traceability), not a deferred audit — nothing requires the voiced owner to act later.

## Items

### H-001

- Status: proposed | accepted | applied | closed | rejected | deferred | superseded
- Target Artifact: `product-brief.md | prd.md | ux-design.md | system-design.md | slices.md | slice-<N>.md | verification-matrix.md | rca-<slug>.md | security-review-<slug>.md`
- Target Owner: Faisal | Katrina | Lance | Sonia | Alex | Rahat | Zach
- Raised By: [persona or user]
- Type: source_defect | cross_artifact_conflict | promotion_request
- Blocking: yes | no
- Blocked By: none | H-###
- Why It Matters: [what becomes wrong, unsafe, or stale]
- Requested Change: [specific requested source update]
- Discovered During: [optional mode, artifact, or implementation context]
- Promotion Record: pending | [artifact section, date, short summary] | applied_by_scribe — voiced-for: [owner]; scribe: [presiding persona]; settled-from: [code-truth | in-session | prior-debate | obvious]; [date]
- Cascade: none | <follow-up H-IDs> | routed to `change-proposal-<slug>.md`
- Supersedes: none | H-###
- Superseded By: none | H-###
