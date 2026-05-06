## Dev Note

Write `[plan_folder]/<initiative-name>/dev-note-<slug>.md` when Prototype or Bug Fix Mode produces durable behaviour, reusable code, future-spec facts, or follow-up work.

Use `[plan_folder]/_system/dev-note-<slug>.md` only for genuinely global work with no initiative, Slice, or initiative `_context.md` owner.

Durable means code, tests, scripts, config, docs, schema, or user-visible behaviour remains in the repo after handoff.

```markdown
---
scope: <initiative-name> | _system
slug: <slug>
mode: prototype | bug-fix
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: Alex
status: live | archived
next_owner: Faisal | Katrina | Lance | Sonia | Rahat | Zach | none
---

## Request
What the user asked Alex to build, test, prototype, or fix.

## Scope
- Entry mode: prototype | bug-fix
- Initiative: <name or none>
- Slice: <N or none>
- Boundaries: what was intentionally left out

## Files Changed
- `path/to/file`: what changed and why

## Behaviour Changed
- Durable behaviour: yes | no
- Summary: observable behaviour or prototype result

## Evidence
- Command: `<command>`
- Result: pass | fail | blocked | not run
- Notes: relevant output or manual check

## Documentation Impact
- Status: none | updated | deferred
- Details: docs changed, why none were needed, or what remains deferred and owner

## Follow-Up
- Next owner: Faisal | Katrina | Lance | Sonia | Rahat | Zach | none
- Required action: decision, planning, QA verification, security review, or none

## Notes for Future Spec or Planning
- Facts future specs, slices, RCA, or reviews should not lose
```

**File rules:**

- Prototype with durable behaviour or reusable code → write or update a Dev note.
- Prototype removed before handoff with no future relevance → no Dev note required.
- Bug fix with visible behaviour change, regression proof, or non-obvious cause → write or update a Dev note unless an RCA/security artifact already owns the record.
- Trivial typo or local obvious fix with no future relevance → Dev note optional.
- Existing RCA/security artifact exists → update that artifact first; create a Dev note only for broader implementation notes.
