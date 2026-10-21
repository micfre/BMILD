# Deliberate

When a one-way door has several defensible options, your first recommendation anchors on whichever option you thought of first. Deliberation has each option argued in its own context before you recommend, so the user decides between real cases rather than one case and some strawmen.

## When

A one-way door with two or more defensible options, and one of:

- the user is torn ("not sure", "could go either way", "what would you do");
- the user has pushed back on your recommendation twice;
- the options trade across lenses (a product gain that costs an architecture constraint, a UX shape that strains a contract).

When the question is the shape of a module's interface, call the Skill tool with "codebase-design" and use its design-it-twice pattern instead.

## Process

### 1. Frame

Write the question, the options, and the constraints already settled, with pointers to the code, `GLOSSARY.md` terms, and ADRs they rest on. Show this to the user, then proceed straight to step 2.

### 2. Argue in parallel

Spawn one sub-agent per option, 2 to 4 in all, in parallel. A sub-agent has no access to this skill's files, so give each its own brief: the frame from step 1, its option, and the lenses from [LENSES.md](LENSES.md) that apply, pasted in full. Each argues its option as strongly as honest evidence allows, reading the code and ADRs it needs, and reports:

1. What the option delivers.
2. What it gives up, and who pays.
3. The observation that would prove it the wrong choice.
4. Whether it is a one-way or a two-way door.

### 3. Fold back in

Put the question in the next grilling round: each option's case in two or three lines, then your recommended answer and why. If no option survives what its own case gives up, say so and recommend the question that would settle it. The decision stays with the user; when it is ADR-worthy, `domain-modeling` offers the ADR.
