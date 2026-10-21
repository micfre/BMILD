# Verification-Gap Lens

A mechanical verification-coverage method consumed by Code Review, Comprehensive Review, and Targeted Verification. One question drives it: **if the behavior this change should produce broke where it's actually used, would verification fail?** Do not hunt for correctness bugs; report genuine problems noticed while tracing verification.

The three gap shapes:

1. **Regression gap** — the changed code regresses where it's used, and no test covering that use would fail.
2. **Missing-adoption gap** — a place that should now use the new behavior doesn't; it handles the same case its own way, or not at all, and no test would flag the omission.
3. **Broken-verification gap** — a test appears to cover the changed behavior but would not protect it: skipped, flaky, not run in the normal verification path, or too weak to observe the regression.

## Evidence rules

- Read a test before claiming what it covers, runs, asserts, or misses.
- Before claiming no test exists, search the whole repository by the symbol under test and by import references; expected file locations are not enough.
- Never assert what you did not verify. A finding that cannot be grounded is dropped, not downgraded.
- In every finding, say what you actually checked — "none of the tests I read cover this" — and record how far you looked: the searches run and their scope. Claim "no test exists anywhere" only when the symbol/import-reference search actually shows that.
- Do not assign severity, confidence, priority, or ranking; the parent review verdicts every finding (see `resources/findings-triage.md`).

## Method

### Step 1: Screen for behavioral change

Check whether the change removes or weakens verification of deterministic behavior; if so, continue — it is eligible for a broken-verification gap even though production behavior is unchanged. Otherwise call it non-behavioral only when the changed code does not alter return values, thrown errors, caller-visible side effects, or observable state (including iteration order and emitted messages), and stop with zero findings. Formatting, comments, whitespace, pure renames, trivial pass-throughs, and type-only changes with no runtime effect are typically non-behavioral.

### Step 2: Find the behavior that changed

Identify what changed versus the previous version: output, side effect, branch, error path, schema/event shape, config default, validation/authorization rule, external contract. Handle each changed behavior separately. Treat broad-impact changes (dependency, toolchain, build/config, data-file) as behavioral even when no single line looks important.

Seek verification of behavior, not literal text of documents. Tests may assert exact content when they execute deterministic construction or transformation and inspect the output; phrase-existence over hand-authored documents is not verification. For model-backed behavior, stop at the inference boundary: deterministic request construction and response handling remain eligible without live inference.

### Step 3: Trace where that behavior is used

Trace the changed behavior to the places that observe it: direct callers, registered entry points (routes, commands, jobs), contract consumers (schemas, events, APIs, data readers). Follow a path only while the changed behavior is reachable and unverified. Stop when a test at that boundary would fail, when the consumer does not observe the changed behavior, or when the next hop is guesswork. Prefer the nearest observable boundary, usually one to three hops away. With more than five similar consumers, check representative paths and group obvious repeats; expand only when a consumer observes the behavior differently.

### Step 4: Qualify the consumer, then check its test

For each consumer, name the smallest realistic regression it would observe — invert the branch, drop the default, omit the field, return the old error, skip the call. This is the Demonstration. If no such regression exists, drop the path; untested downstream code is not a finding.

A missing-adoption gap qualifies only with a **supersession signal**: the change shows the new behavior is meant to replace the local one — stated intent, naming, a replaced sibling site, deleted duplicate logic, or a test defining the new rule — and the local site shares the same observable contract. Without both, it is a refactor suggestion, not a finding.

Find and read the relevant test. Ask whether the Demonstration would make an assertion fail. A test counts only if it runs normally and an assertion observes the changed output, branch, or contract. These do not count: no execution; success/no-throw checks; mock or log-call checks; tests that mock away the integration; pass-through e2e; stale assertions or fixtures (e.g. `expect(x ?? DEFAULT).toBe(DEFAULT)` passes when `x` is missing).

### Step 5: Confirm each finding is real

Before writing a finding, re-open the specific tests or search results it relies on. Verify the Demonstration would not make any checked test fail, or that the absence claim is backed by the recorded symbol/import search. Drop any finding you cannot ground, and explain why the test misses the bug using what the test sets up and checks.

Do not report: compiler/type-checker-enforced cases; behavior already verified by integration, contract, or e2e tests; implementation-detail or mock-only tests; low coverage or a missing test file by itself; legacy untested code the change did not affect. Genuine problems noticed while tracing that are not verification gaps may be reported with `gap_shape: other` — reporting what you already reached, not extra hunting.

## Findings shape

Each finding carries the four canonical fields plus this lens's extras:

- `location` — the changed surface: the exact behavior or contract that changed, `file:line`
- `trigger_condition` — the gap, in one line
- `guard_snippet` — the missing verification: the precise absent assertion or check, optionally with the test shape that would close it, fit to the repository's own way of verifying
- `potential_consequence` — the concrete thing that ships wrong, with why the checked tests would not fail
- `gap_shape` — `regression-gap` | `missing-adoption-gap` | `broken-verification-gap` | `other`
- `consumer` — the impacted consumer or site, named concretely with `file:line`, not "callers of this function"
- `evidence` — what you actually checked: the relevant test and what it asserts with `file:line`, or the symbol/import-reference searches run and their recorded scope; for a broken-verification gap, the apparent test and why it does not count

For `gap_shape: other` the four canonical fields suffice; `consumer` and `evidence` are optional. An empty result is valid when the change is non-behavioral or every changed behavior is verified.
