---
type: Slice
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name> | _system"
slice: <N>
status: todo | active | ready-for-review | done | blocked
qa_status: not_started | blocked | ready_for_verification | verified | failed
security_status: not_reviewed | not_applicable | review_requested | findings_open | cleared
---

## Intent

One sentence: what this Slice accomplishes.

## Concrete Outcome

One concrete outcome advanced by this Slice.

## Scope

- In: ...
- Out of scope for this Slice: ...

## Dependencies

- Slice <N> ...
- Upstream constraint ...

## Design Contracts (must honour)

- [System Design §<section>](./system-design.md) (`./system-design.md`) — <one-line summary of the contract>
- [UX Design §<section>](./ux-design.md) (`./ux-design.md`) — <one-line summary>

## Likely Required Reads

- Slice-local contracts:
  - path/to/file
- Existing implementation boundary:
  - path/to/file
- Upstream domain truth:
  - path/to/file
- Closest prior art:
  - path/to/file
- Quality and proof boundaries:
  - path/to/file

## Likely Planned Edits

- Existing files to modify or extend:
  - path/to/file
- New files expected to be created:
  - path/to/file
- Tests, fixtures, docs, or verification artifacts likely to change:
  - path/to/file

## New File Estimate

- Estimated new file count: <0/N>
- Representative source directory for average size: <path/to/src>
- Why this directory is representative: <one line; prefer the closest stable peer directory for the same artifact type, not a broad mixed tree>

## Likely Required Reads Check

- Existing contract file considered: yes / no / not applicable — [path or reason]
- Existing runner/orchestrator/route/entrypoint considered: yes / no / not applicable — [path or reason]
- Canonical schema/config/manifest/registry considered: yes / no / not applicable — [path or reason]
- Closest prior implementation/prototype/test considered: yes / no / not applicable — [path or reason]
- Verification/comparator/artifact-writer boundary considered: yes / no / not applicable — [path or reason]

## Slice token estimate

- Estimated peak live context: <estimated_peak> tokens / <slice_target> budget (<percent>% of context window), <WITHIN BUDGET | OVER BUDGET>
- Model: peak_live_v2 — informed guess; predicts peak occupancy risk, not cumulative provider tokens or cost
- Raw script values:
  - estimated_peak: <estimated_peak>
  - headroom: <headroom>
  - raw_file_tokens: <raw_file_tokens>
  - full_reads: <full_reads>
  - symbol_reads: <symbol_reads>
  - full_edits: <full_edits>
  - symbol_edits: <symbol_edits>
  - new_file_tokens: <new_file_tokens>
  - item_overhead: <item_overhead>
  - turn_reserve: <turn_reserve>
  - K: <K>
  - tokenizer_base: <tokenizer_base>
  - tokenizer_multiplier: <tokenizer_multiplier>
  - estimate_confidence: informed_guess

## Verifiable End Condition

Specific enough to reuse during backward coverage checking.

## Acceptance Criteria

- [ ] ...

## Planning Notes

- Budgeted full reads: <none/list>.
- Budgeted symbol reads: <none/list>.
- Budgeted full edits: <none/list>.
- Budgeted symbol edits: <none/list>.
- Budgeted new files: <0/N> from <path/to/src or none>.
- Budget skips: skipped reads: <none/list>; skipped new: <none/list>; skipped edits: <none/list>.

## Implementation Notes

## QA / Security Follow-up

- Open QA items: ...
- Open security items: ...
- Resolution notes: ...

## Actuals

Completed by Alex at Slice completion. Sonia/Rahat consume for planning quality and model-deviation tracking. Prefer per-turn peak signals over cumulative provider totals; do not use cached-token aggregates for calibration.

- turns_taken: <integer>
- compaction_count: <integer; 0 if none>
- peak_live_context: <optional, best-effort peak live input tokens in one turn>
- peak_context_pct: <optional, peak_live_context / advertised window as percent>
- unplanned_reads: <none | list of paths opened that were not in Likely Required Reads>
- unexpected_whole_file_source_reads: <none | list of source files loaded whole despite symbol budgeting>
- felt_budget: <optional, qualitative over / about-right / under>
