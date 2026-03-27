# Vision: True Context Isolation for Interactive Leads (IL)

## Intent & Objective
The objective is to evolve the BMILD "Interactive Leads" (IL) capability from a single-prompt roleplay simulation into a robust, contextually isolated debate engine. In complex feature planning, personas (Product, Architecture, UX, QA) must base their arguments strictly on their domain-specific constraints without being influenced by out-of-bounds knowledge. The intent is to eliminate "context bleed"—where one persona inadvertently adopts the reasoning or constraints of another simply because they share a context window—ensuring higher fidelity, conflict-driven design resolution.

## End State & Northstar
Our northstar is a Multi-Agent Orchestration Architecture for the IL process. 

In this end state:
- **Strict Boundary Execution:** Each persona operates as an independent LLM instance or execution thread.
- **Bespoke Context Spaces:** Context is mounted exclusively based on the persona's domain (e.g., Lance the Architect acts only on `system-design.md`, while Katrina the UX Designer acts only on `ux-design.md`).
- **Turn-Based Synthesis:** A central coordinator agent manages the debate state, passing formulated arguments between the isolated personas. This generates authentic, grounded alignment through structured friction rather than a smoothed-over, monolithic consensus.
- **Context Economy:** Context windows are optimized, preventing token bloat and allowing personas to ingest massive, highly localized documentation without degrading reasoning capabilities.

## Constraints & Technical Challenges
Achieving true context isolation presents significant technical and architectural hurdles, specifically when constrained to dependency-free or orchestrator-less environments:

1. **The Single-Context Bottleneck:** Standard IDE integrations and single-session LLM interactions utilize a monolithic context window. Within a single Transformer attention mechanism, true isolation is mathematically impossible; all loaded tokens attend to one another, resulting in inevitable context bleed.
2. **Pseudo-Isolation Limits:** While "prompt zoning" (tagging contexts) and sequential file reading can simulate isolation locally, they are fundamentally brittle. As the conversation progresses, the context window accumulates the disparate knowledge bases, reintroducing persona bleed in later turns.
3. **Orchestration Requirements:** True isolation demands an external state manager (e.g., a Python orchestrator, Codex CLI workflows, AutoGen, or LangGraph) to spin up parallel LLM calls, handle independent system prompts, and stitch the outputs together. This contradicts the goal of a purely markdown-driven, dependency-free deployment model.
4. **The "Blind Spot" Risk:** If personas are completely isolated, they risk debating in a vacuum. Designing the protocol for *how much* shared context they need (the core `spec.md` problem statement) versus *how much* domain data they isolate is a delicate balancing act to ensure they don't talk past one another.
