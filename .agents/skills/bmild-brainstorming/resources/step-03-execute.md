## Technique Execution

Facilitate the selected technique(s) as a creative coach — genuine back-and-forth, not a question dispenser. The goal is 100+ ideas before considering organisation; the default is always to keep exploring. Only offer organisation when the user explicitly asks, or when 100+ ideas have been generated and 45+ minutes have elapsed and user energy is clearly depleted. One technique element at a time — go deep before going wide.

Every captured idea uses this format:

> **[Category #N]: [Mnemonic Title]**
> *Concept:* [2–3 sentence description]
> *Novelty:* [What makes this different from the obvious]

1. **Open the technique** — Name the technique and set the coaching frame:

   > *"Let's start with **[Technique Name]**. This isn't a Q&A — we're exploring together. I'll introduce one element at a time and build on what you bring."*

   State the technique's primary goal and energy level from the YAML `facilitation_prompts` and `energy_level` fields.

2. **Facilitate** — Use `facilitation_prompts` from the YAML to drive exploration. Present one prompt, wait for the user's response, then:
   - If the response is brief: dig deeper — *"Tell me more about [specific aspect]. What would that look like in practice?"*
   - If the response is rich: build on it — *"Let's take that further. What if [extension of their idea]?"*
   - If the user seems stuck: offer an angle — *"Here's a starting point: [gentle prompt from the YAML]. Which direction does that pull you?"*

   Before each idea, internally ask: what domain haven't we explored yet? What would make this idea surprising or uncomfortable? Every 10 ideas, consciously shift to an orthogonal domain (UX → business → technical constraints → social impact → edge cases).

3. **Energy checkpoint** (every 4–5 exchanges) — Check in without breaking flow:

   > *"We've generated [N] ideas — good momentum. Want to keep pushing this angle, shift to a fresh element, or switch techniques for a different perspective?"*

   Default: continue exploring unless the user signals otherwise.

4. **Technique transition** — When moving to the next technique (user-initiated or natural completion):

   > *"Good work on [Technique]. Let me capture what we found before we shift:*
   >
   > [List key ideas in idea format above]
   >
   > *Now into **[Next Technique]** — this one will [brief note on what it adds]. Ready?"*

5. **Deep-dive option** — If a promising idea emerges that deserves rigorous treatment, offer:

   > *"This idea is strong enough to stress-test. Want to run a quick elicitation on it? Invoke `bmild-elicit` and point it at this concept."*

   Do not invoke `bmild-elicit` autonomously — suggest it and wait for confirmation.

6. **Completion check** — Only offer to move to organisation when the user explicitly requests it, or when 100+ ideas have been generated and 45+ minutes have elapsed and user energy is visibly depleted. When the user is ready:

   > *"Ready to organise what we've got?*
   >
   > [K] Keep exploring
   > [C] Move to organisation"*

   [C] → load `./resources/step-04-organise.md`
   [K] → continue the current facilitation loop
