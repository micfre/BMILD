---
type: Verification Matrix
title: "<initiative> outcomes and evidence"
description: "Authorized outcomes, continuation state, and independent acceptance evidence"
timestamp: YYYY-MM-DD
scope: "<initiative-name>"
author: "[user_name] + Sonia / Alex / Rahat"
---

## Outcome Index

- O-001 — <descriptive title>
  - Phase: MVP | Growth | Vision | explicitly authorized named phase
  - Status: active | blocked | ready_for_review | done
  - Last evidence: YYYY-MM-DD

The index is the lookup surface, not a second source of truth. Update its title, phase, status, and last-evidence date whenever the corresponding outcome record changes.

## O-001 — <descriptive title>

Repeat only for separately authorized outcomes. Mint the next unused initiative-local `O-###` in numeric order; never reuse an ID. The ID remains immutable when the descriptive title changes, and every matrix, RCA, security-review, handoff, and cross-session reference uses the ID. Preserve previous outcomes and evidence when starting another phase. Link source requirements; no Slice or forecast is required.

- Phase: MVP | Growth | Vision | explicitly authorized named phase
- Authorization: <user request or authoritative scope decision>
- Scope and deferred work: <observable outcome, exclusions, source links>
- Contracts: <relevant committed source sections and delegated constraint envelopes; omit illustrative/observed content unless it is evidence>
- Readiness: ready | partially_ready | blocked — <intent, constraints, unresolved dependencies; Sonia or Alex applying the same criteria>
- Status: active | blocked | ready_for_review | done
- Required review axes: functionality/completeness, security applicability, standards/spec fidelity, applicable scalability/maintainability
- qa_status: not_reviewed | review_requested | verified | failed | blocked
- security_status: not_reviewed | review_requested | findings_open | cleared | not_applicable
- code_review_status: not_reviewed | review_requested | findings_open | cleared | not_applicable
- Review independence: pending | established — <reviewer context identity; did not implement reviewed production changes; no inherited development transcript>
- Reviewed state: <code/change and source-contract identity, relevant environment>

### Coverage and evidence

- Requirement: <stable source reference, including relevant NFR/documentation/UX obligations>
  - Proof: <observable check and command/test/manual procedure; missing infrastructure if blocked>
  - Implementation: pending | implemented | blocked — <Alex's evidence>
  - Verification: pending | passed | failed | blocked — <Rahat's independently checked evidence and reviewed state>
  - Applicability: <Rahat's reason only when a review dimension does not apply>

### Slice evidence (only when Slices are used)

- Slice: [Slice <N>](slice-<N>.md) — <acceptance boundary and source references>
  - Implementation status: todo | in_progress | blocked | ready_for_review | done
  - Implementation evidence: <actual changes, commands/results, documentation>
  - Review axes: <qa_status, security_status, code_review_status using the parent vocabulary; initially not_reviewed>
  - Review independence and reviewed state: <fresh reviewer identity, code/source/environment identity>
  - Findings / remaining proof: <scope-specific obligations; changes invalidate affected proof>
  - Continuation: <next action or review link>
- Integrated outcome verification: pending | passed | failed | blocked — <current source coverage and cross-Slice integration evidence>

Slice status and registries project this evidence. Only Rahat writes Slice `done`; partial acceptance does not set parent readiness or verdicts. Do not create an outcome merely for each Slice. The last Slice review also checks whole-outcome source coverage and integrated verification; passing every Slice alone cannot close the outcome.

### Continuation and review follow-up

- Current state / next action: <only what another context needs>
- Decisions and dependencies: <source links; committed constraints versus delegated choices; observations used only as evidence>
- Open obligation or finding: <evidence, consequence, owner, resolution condition>
- Repair: pending | fixed_pending_review — <change and regression evidence; reviewer closes>
- Review transition: <phase/outcome, source links, change identity, commands, issues; no developer reasoning transcript>

Sonia owns readiness and coverage planning; Alex owns implementation and continuation evidence; Rahat owns review verdicts, `done`, and the final archival decision. A matrix is not proof. Preserve historical review evidence and mark affected proof pending when code/contracts/environment change. Verify completeness directly against the sources. `not_reviewed` is never terminal; justify not-applicable axes. Multiple outcomes remain independent. Rahat moves the matrix from registry `## Live` to `## Archived` only after every outcome is `done` and no open handoff, RCA, security-review, or continuation obligation still depends on it; otherwise it stays live.
