# Findings Triage

The parent-review discipline for verdicting reviewer and lens output during Code Review, Comprehensive Review, and Targeted Verification. Findings arrive unverified and often severity-labeled by their source; triage converts them into verdicted, root-cause-grouped, routable findings — or refutes them with evidence.

## Verify before verdict

- Verify each claim **and its reachable consequence** before assigning any verdict. A loud failure on a situation never shown reachable is correct behavior, not a defect — reachability is part of the finding, not an optional extra.
- Disregard reviewer-supplied severity. Severity from whoever shouted it is noise; the verdict and its weight are assigned here, after verification, by the parent review context.
- A claim you cannot verify is not verified: verdict it `maybe-false` with the evidence gap, or drop it — never promote it on the reviewer's confidence.

## Verdict vocabulary

Each reviewed claim receives exactly one verdict from `high | medium | low | false | maybe-false`, with evidence supporting that verdict:

- `high` — verified claim with a verified reachable consequence of high impact
- `medium` — verified claim with a verified reachable consequence of moderate impact
- `low` — verified claim with a verified reachable consequence of minor impact
- `false` — disproved claim, with the refuting evidence
- `maybe-false` — claim that cannot be verified in this context, with the evidence gap named

`false` and `maybe-false` survive in the detailed report with their evidence; the compact summary carries only their counts. A reviewer or operator can inspect every disproved and uncertain claim — rejection is documented, never silent.

## Grouping and routing

- Group surviving findings (`high | medium | low`) only by shared root cause, not by file, function, or reviewer. Two symptoms of one cause are one group with one fix; the fix for a group may span several locations.
- Route each group to its owner through the normal ownership rules — remediation enters the existing outcome evidence and remediation flow. Routing is reporting; it never authorizes production edits from a review-only session.
- Reject any finding whose proposed fix edits the specification under review from the review session itself. Specification changes belong to the owning persona under normal authority rules; surface the conflict instead.

## Failed-layer warning

- If any required review layer or lens failed, was skipped for cause, or could not run, name it before announcing results.
- With failed layers present, issue an incomplete-review warning even when zero findings survive — never a clean result. A clean result certifies only the layers that actually completed.

## Output shape

- Detailed report: every claim with its verdict, supporting evidence, group (when surviving), and routing disposition.
- Compact summary: verdict counts by category, surviving high/medium groups with one-line consequences, failed layers if any, and the detailed report location.
