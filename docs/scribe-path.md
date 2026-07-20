# Scribe path — maintainer note

> **Runtime copies live under each standard persona skill.** Do not treat this `docs/` file as the procedure agents load.

## Runtime location

Identical copies ship at:

- `.agents/skills/bmild-pm/references/scribe-path.md`
- `.agents/skills/bmild-ux/references/scribe-path.md`
- `.agents/skills/bmild-arch/references/scribe-path.md`
- `.agents/skills/bmild-planner/references/scribe-path.md`
- `.agents/skills/bmild-dev/references/scribe-path.md`
- `.agents/skills/bmild-qa/references/scribe-path.md`
- `.agents/skills/bmild-sec/references/scribe-path.md`

When a standard persona is active, it loads **its own** `references/scribe-path.md` via a relative path. `docs/` never ships with skills, so this file is invisible to downstream harnesses.

## Editing

1. Edit **one** skill copy (any of the seven).
2. Sync the other six to match byte-for-byte.
3. Run `bash tests/scribe-path-contract.sh` — it fails on drift and on any remaining `docs/scribe-path.md` references under `.agents/skills/`.

Skill `SKILL.md` Scope Boundary paragraphs, Planner Course-Correction, and the PM handoff template must point at `references/scribe-path.md`, never at this file.
