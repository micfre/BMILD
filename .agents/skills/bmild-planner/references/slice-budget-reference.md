# Slice Budget Reference

## What This Reference Is For
Use this reference when Sonia needs to estimate whether a candidate Slice is likely to fit within one implementation session.

This reference is for maintainers and planner authors. It explains the budgeting method behind Slice sizing.

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
1. Collect the required-read floor plus any discretionary likely reads.
2. Measure each selected file by line count.
3. Bucket each file into a lightweight token bracket.
4. Estimate task text tokens by character count divided by 4.
5. Add the fixed planning overhead.
6. Apply the context-accumulation multiplier for sequential reads.
7. Compare the expected total to the `170K` target.

## Worked Example
This example is illustrative, not normative. It shows the shape of the method without adding a second rule set.

If Sonia is sizing a Slice that updates one skill file, one adjacent pattern file, one test file, and the Slice document itself:
- include the Slice file
- include the cited design contract
- include the adjacent skill or pattern file if Alex is likely to mirror it
- include the relevant test only if it expresses behavior Alex is likely to preserve or extend

The output of this process is not a telemetry report. Sonia records only the likely-required file hints in the Slice handoff.
