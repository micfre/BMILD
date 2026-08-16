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
- Create an item only when work genuinely leaves the session under `references/gap-resolution.md`: unavailable/rejected capability, required user input, declined in-session authority, or asynchronous ownership.
- In-session scribe, guest, and consult resolutions record provenance beside the authoritative edit and create no item for audit history. When they resolve an existing item, close it and point `Promotion Record` at that edit; never create a replacement.

## Items

### H-001

- Status: proposed | accepted | applied | closed | rejected | deferred | superseded
- Target Artifact: `product-brief.md | prd.md | ux-design.md | system-design.md | slices.md | slice-<N>.md | verification-matrix.md | rca-<slug>.md | security-review-<slug>.md | context-map.md | DESIGN.md | adr/<NNNN-slug>.md`
- Target Owner: Faisal | Katrina | Lance | Sonia | Alex | Rahat | Zach
- Raised By: [persona or user]
- Type: source_defect | cross_artifact_conflict | promotion_request
- Blocking: yes | no
- Blocked By: none | H-###
- Why It Matters: [what becomes wrong, unsafe, or stale]
- Requested Change: [specific requested source update]
- Discovered During: [optional mode, artifact, or implementation context]
- Resolution Blocker: [missing capability/user input/declined authority/asynchronous ownership; rejected model + effort and harness error when applicable]
- Resume Condition: [exact evidence or artifact change that resumes the suspended mode step]
- Promotion Record: pending | [authoritative artifact section, resolution provenance, date, short summary]
- Cascade: none | independent episodes: <owners> | user-approved `change-proposal-<slug>.md` | unresolved <H-IDs>
- Supersedes: none | H-###
- Superseded By: none | H-###
