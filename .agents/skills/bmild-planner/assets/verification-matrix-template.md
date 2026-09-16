---
type: Verification Matrix
title: "<initiative> outcomes and evidence"
description: "Authorized outcomes, continuation state, and independent acceptance evidence"
timestamp: YYYY-MM-DD
scope: "<initiative-name>"
author: "[user_name] + Sonia / Alex / Rahat"
---

## Outcome: <stable descriptive identifier>

Repeat only for separately authorized outcomes. Preserve previous outcomes and evidence when starting another phase. Link source requirements; no Slice or forecast is required.

- Phase: MVP | Growth | Vision | explicitly authorized named phase
- Authorization: <user request or authoritative scope decision>
- Scope and deferred work: <observable outcome, exclusions, source links>
- Contracts: <relevant source sections; omit absent artifacts>
- Readiness: ready | partially_ready | blocked — <intent, constraints, unresolved dependencies; Sonia or Alex applying the same criteria>
- Status: active | blocked | ready-for-review | done
- Required review axes: functionality/completeness, security applicability, standards/spec fidelity, applicable scalability/maintainability
- qa_status: not_started | ready_for_verification | verified | failed | blocked
- security_status: not_reviewed | review_requested | findings_open | cleared | not_applicable
- code_review_status: not_started | review_requested | findings_open | cleared | not_applicable
- Review independence: pending | established — <reviewer context identity; did not implement reviewed production changes; no inherited development transcript>
- Reviewed state: <code/change and source-contract identity, relevant environment>

### Coverage and evidence

- Requirement: <stable source reference, including relevant NFR/documentation/UX obligations>
  - Proof: <observable check and command/test/manual procedure; missing infrastructure if blocked>
  - Implementation: pending | implemented | blocked — <Alex's evidence>
  - Verification: pending | passed | failed | blocked — <Rahat's independently checked evidence and reviewed state>
  - Applicability: <Rahat's reason only when a review dimension does not apply>

### Continuation and review follow-up

- Current state / next action: <only what another context needs>
- Decisions and dependencies: <source links; commitments versus delegated engineering choices>
- Open obligation or finding: <evidence, consequence, owner, resolution condition>
- Repair: pending | fixed_pending_review — <change and regression evidence; reviewer closes>
- Review transition: <phase/outcome, source links, change identity, commands, issues; no developer reasoning transcript>

Sonia owns readiness and coverage planning; Alex owns implementation and continuation evidence; Rahat owns review verdicts and `done`. A matrix is not proof. Preserve historical review evidence and mark affected proof pending when code/contracts/environment change. Verify completeness directly against the sources. `not_reviewed` is never terminal; justify not-applicable axes. Multiple outcomes remain independent. Keep the matrix live while it supports active work; archive only when all outcomes are terminal and it is no longer needed for continuity.
