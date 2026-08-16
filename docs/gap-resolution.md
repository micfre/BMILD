# Gap resolution — maintainer note

> Runtime copies live under each standard persona skill. Do not treat this `docs/` file as the procedure agents load.

## Runtime location

Seven byte-identical copies ship at `.agents/skills/bmild-<persona>/references/gap-resolution.md` for PM, UX, Arch, Planner, Dev, QA, and Sec. An active standard persona loads its own relative copy only when a mode encounters another owner's gap or downstream consequence.

The unified contract replaces the former `scribe-path.md` and `consult-path.md` references. It owns configuration migration, intelligence tiers, simplified scribing, capability-gated guest voice, leaf consults, durable handoff criteria, Course-Correction consent, rejoin behavior, and review independence.

## Editing

1. Edit one runtime copy.
2. Sync the other six byte-for-byte.
3. Update all affected mode resources, consult-agent definitions, generated harness shapes, and promotion rules together.
4. Run `bash tests/gap-resolution-contract.sh` and `bash scripts/validate-skills.sh`.

Core `SKILL.md` scope boundaries and every standard mode resource must point at `references/gap-resolution.md`, never at this maintainer note or another skill's tree.
