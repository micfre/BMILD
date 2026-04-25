# Slice Budget Reference

## What This Reference Is For
Use this reference when Sonia needs to estimate whether a candidate Slice is likely to fit within one implementation session.

This reference is for maintainers and planner authors. It explains the budgeting method behind Slice sizing. The calculation itself lives in `./scripts/budget-slice.sh`.

Alex does not need to understand or validate this method during implementation.

## Required Read Floor
Always include:
- the target `slice-<N>.md`
- any cited design-contract documents
- the contributor guide when Alex is expected to consult it for the Slice

## Likely Reads Sonia May Add
Sonia may add more files only when omitting the file would materially increase the chance that Alex misses:
- an implementation dependency
- a local code or document pattern that should be matched
- a contract needed to complete the Slice cleanly

Typical eligible additions:
- adjacent implementation files
- local pattern-defining files
- tests that express behavior Alex is likely to preserve or extend

## Reads Excluded By Default
Do not include by default:
- QA-only files
- debugging artifacts
- broad exploratory repo reads
- files included only because they might become relevant later

## How To Estimate Expected Tokens
The token budget calculation is performed by `./scripts/budget-slice.sh`. Sonia identifies the files, passes them to the script with the target from `.bmild.toml`'s `slice_target`, and uses the result.

The script applies:
1. Per-file token estimate: character count divided by 4
2. Context-accumulation multiplier (1.1x) for sequential reads
3. Fixed planning overhead (800 tokens)
4. Comparison against the configured target

## Worked Example
This example is illustrative, not normative. It shows the shape of the method without adding a second rule set.

If Sonia is sizing a Slice that updates one skill file, one adjacent pattern file, one test file, and the Slice document itself:
- include the Slice file
- include the cited design contract
- include the adjacent skill or pattern file if Alex is likely to mirror it
- include the relevant test only if it expresses behavior Alex is likely to preserve or extend

The output of this process is not a telemetry report. Sonia records only the likely-required file hints in the Slice handoff.

The script Sonia runs:

    ./scripts/budget-slice.sh --target <slice_target> <file...>

The target value comes from `.bmild.toml`'s `slice_target` field.
