# <Context Name>

<One or two sentences describing what this initiative context is and why it exists.>

## Language

**Term**:
<One or two sentence definition. Define what it is, not implementation detail.>
*Avoid*: <aliases or overloaded terms to avoid>

## Flagged Ambiguities

- <Ambiguous term or boundary> -> <resolution>

## Relationships

- **Concept A -> Concept B**: <short relationship statement>

## Example Scenarios

- <Short scenario or dialogue snippet showing how terms are used correctly>

---

## Authoring Rules

`context.md` is a glossary and nothing else — a record of what terms mean in this initiative, not a spec, scratch pad, or repository for implementation decisions.

- **Be opinionated.** When several words name the same concept, pick one canonical term and list the others under *Avoid*.
- **Keep definitions tight.** One or two sentences. Define what a thing IS, not what it does or how it is built.
- **No implementation detail.** Schemas, API shapes, algorithms, and library choices belong in `system-design.md`. If a line reads like a spec, it does not belong here.
- **Only initiative-specific terms.** General programming concepts (timeout, retry, error type, utility helper) do not belong even if the project uses them. Ask: is this concept unique to this initiative's language?
- **Flag conflicts explicitly.** If a term is used ambiguously, record the resolution under *Flagged Ambiguities* rather than silently picking one reading.
- **Show relationships.** Use the *Relationships* section to express boundaries and cardinality between concepts.
- **Group when natural.** Cluster related terms under subheadings; a flat list is fine when no clusters emerge.
- **Keep the example scenario.** A short dialogue or snippet that shows the terms interacting clarifies boundaries better than definitions alone.
