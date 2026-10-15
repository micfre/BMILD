# Edge-Case Hunter Lens

A mechanical path-tracing method consumed by Code Review and Comprehensive Review. This lens is a pure path tracer: it never judges whether content is good or bad; it lists missing handling. The method is exhaustive path enumeration — walk every branch mechanically, do not hunt by intuition. Report ONLY paths and conditions that lack handling; discard handled ones silently. Do not editorialize or add filler.

## Scope rules

- When the target is a diff, scan only the diff hunks and list boundaries directly reachable from the changed lines that lack an explicit guard in the diff.
- When it is not a diff (full file, function, document), the entire provided content is the scope.
- Ignore the rest of the codebase unless the provided content explicitly references external functions.
- When the launch message names a claims file, do NOT read it before Step 4: path tracing in Steps 1–2 must finish before the narrative is seen, so the narrative cannot steer the trace.

## Step 1: Exhaustive path analysis

Walk every branching path and boundary condition within scope — report only unhandled ones.

- Incorporate any `also_consider` areas provided at launch.
- Walk control flow (conditionals, loops, error handlers, early returns) and domain boundaries (where values, states, or conditions transition). Derive the relevant edge classes from the content itself — missing else/default, unguarded inputs, off-by-one loops, arithmetic overflow, implicit type coercion, race conditions, timeout gaps — not from a fixed checklist.
- **Implicit branches:** the change special-cases or re-handles one or more members of a fixed set — enums, status codes, sentinels, type tags, flags, value ranges. The untouched members of that set are implicit branches (a change to `RED` and `YELLOW` in a `RED/YELLOW/GREEN` enum leaves `GREEN` implicit).
- **Handle lifetime:** when changed code re-checks, re-fetches, or re-validates something it already held — a handle, index, id, pointer — the re-check exists because an intervening call can invalidate it. Identify that call, what it does to the thing held, and what the changed code silently skips when the re-check fails.
- **Call-site/callee contracts:** for each call site the change adds or modifies — in test files as well as production code — read the callee's declaration and check the call against it: argument count, order, types, defaults. Report any mismatch.
- For each path, determine whether the content handles it. Collect only the unhandled paths.

## Step 2: Validate completeness

Revisit every edge class surfaced in Step 1. Add newly found unhandled paths; discard confirmed-handled ones.

## Step 3: Deletion check

Runs only when the change removed or replaced meaningful code (ignore pure renames and whitespace). Subordinate to the path analysis; findings are usually few or none.

For each chunk of removed or replaced code, ask: did it carry behavior or a contract that the change neither re-established nor intentionally retired? Add a finding for any resulting regression, orphaned reference, or newly-dead code. Skip anything already covered by path findings. Add nothing if nothing qualifies.

A deletion finding uses the four standard fields with this reading: `location` — the removed item; `trigger_condition` — the behavior or contract it enforced; `guard_snippet` — where or how to re-establish it; `potential_consequence` — the regression or orphan. Mark it `kind: deletion` with `confidence: high | medium | low` — these are inferences; rate them.

## Step 4: Claims check

Runs only when the launch message named a claims file. Read that file now, for the first time; the tracing is finished and the claims cannot steer it retroactively.

The file holds the change's own narrative — commit messages and stated description. The narrative is testimony, not evidence; a claim repeated in a comment is still a claim. Extract each checkable claim — what the change does, what it preserves, ordering, arithmetic, parity with existing code — then try to falsify each against the code already traced. Where the trace cannot decide, read the code that can: the compared-to function, the actual callee, the state the claim assumes.

A claim finding uses the four standard fields with this reading: `location` — where the code contradicts the claim; `trigger_condition` — the claim, quoted or tightly paraphrased; `guard_snippet` — what the code actually does; `potential_consequence` — what goes wrong for someone who believed the claim. Mark it `kind: claim` with `confidence: high | medium | low`.

Verified claims produce nothing. Add nothing if nothing is falsified.

## Findings shape

Each finding carries exactly these four canonical fields:

- `location` — `file:start-end`, `file:line`, or `file:hunk` when the exact line is unavailable
- `trigger_condition` — one line, max 15 words
- `guard_snippet` — the minimal sketch that closes the gap, single line
- `potential_consequence` — what could actually go wrong, max 15 words

An empty result is valid when nothing is found. Do not assign severity labels, rankings, or priority levels; the parent review verdicts every finding (see `resources/findings-triage.md`).
