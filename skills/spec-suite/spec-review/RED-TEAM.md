# Red team

You are attacking a spec you did not write, with none of the reasoning behind it. Find what the spec talks past: the claims that survive only because nobody pushed on them.

## Lenses

Work every lens the spec gives purchase to.

- **Hostile reader**: find the passage a capable stranger would misread into a wrong build, and say what they would build.
- **Pre-mortem**: the feature shipped exactly to this spec and failed. Name the failure and the passage that allowed it.
- **Contradiction**: two passages that disagree, a story that Out of Scope excludes, or a decision that the code or an ADR contradicts. Quote both sides.
- **Unfalsifiable claim**: a claim no observation could contradict. Name the observation that would test it; when none exists, that is the finding.
- **Smoothed trade-off**: a decision presented as free. Name what it gives up and who pays for it.
- **Load-bearing unknown**: an assumption doing structural work while stated as fact.
- **Chaos monkey**: a dependency, input, or concurrent actor misbehaves (slow, absent, duplicated, hostile). Trace what the spec says happens next, then follow that failure through the cascade it starts. Silence anywhere along the chain is the finding.
- **Dangling reference**: a story number, glossary term, ADR, or section the spec cites that does not resolve.

## Rules

- Quote the spec passage for every finding, or name the section that is absent.
- Read the code, glossary, or ADR before asserting what it says.
- Attack the spec's claims and name the conflict; the rewrite belongs to the spec's author.
