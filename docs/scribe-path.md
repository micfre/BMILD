# In-Context Guest-Voice Scribe Path

> Shared definition for all standard personas (`bmild-{pm,ux,arch,planner,dev,qa,sec}`). Single source of truth for the Scribe-Eligibility gate, the in-context procedure, attribution, and fences. Each persona's `SKILL.md` points here; there is no per-skill bespoke scribe logic.

## 1. What this is

When a presiding persona detects a **settled** fact that needs transcribing into **another owner's** artifact (code-truth divergence, an incomplete doc blocking downstream work, or a doc-vs-doc conflict), it may scribe the exact settled patch **in its own turn** — loading the target owner's canonical voice from their `SOUL.md`, running a one-pass settlement check, and writing the patch with dual attribution. **No skill switch, no user routing, no separate mode, no deferred audit.**

This is the explicit authoring→scribing trade the user accepted: what is lost is the owner's *personal authorship of wording* on an already-settled fact; what is preserved is the owner's *stance* (verbatim, from `SOUL.md`) and the truth-state invariant (the artifact now reflects the settled fact, attributed). **Scribe ≠ author** — scribing transcribes settled facts; it never decides open ones.

## 2. The Scribe-Eligibility gate (shared, single source)

All four must hold. If any fails, route normally via `handoff.md` (deliberation and orchestration preserved).

1. **Settled source.** The fact derives from one of:
   - *code truth* — the code provably does X, and the doc says otherwise; or
   - *in-session decision* — the owner or the user already stated it in this chat; or
   - *prior ratified debate/roundtable* — a recorded synthesis the user ratified; or
   - *obvious single-option constraint* — only one non-absurd reading exists.

   No remaining open **Preference** options. If a real trade-off is still live, it is not settled → route.
2. **Reversible.** The change can be reverted without structural rework.
3. **No high-stakes surface.** No data-model, API-contract, security, or compliance surface change. These route *even when settled* — wording risk is highest where the surface is load-bearing, and the owning persona's voice matters most there.
4. **No canonical-tier distillation.** Does not require writing `context-map.md`, `[plan_folder]/adr/`, or project-root `DESIGN.md`. Those **always route** (hard fence, §5).

> This gate generalizes the Course-Correction scribe gate (`bmild-planner/resources/course-correction.md`). Sonia's post-roundtable changes always qualify under condition 1's *prior ratified debate/roundtable* arm; other personas additionally qualify under the *code truth*, *in-session*, and *obvious* arms without needing a prior ratification step.

## 3. The procedure

When a settled gap/conflict is detected in another owner's artifact:

1. **Run the Scribe-Eligibility gate (§2).** Any condition fails → normal `handoff.md` routing. Stop here.
2. **Load** the target owner's **entire `SOUL.md`** — sibling of their `SKILL.md`, resolved relative to their own skill dir per the voice-resolution contract (`plans/adr/0003-persona-soul-canonical-voice.md`; e.g. `.agents/skills/bmild-ux/SOUL.md`). Whole-file load — never a paraphrase, never a heading-boundary scrape. This is the **same resolution rule** each persona already uses for its own `SOUL.md`, applied to the *target* owner. One voice-resolution contract, two consumers (this + roundtable attendee-voice loading).
3. **Settlement-verify** — one pass against the loaded `SOUL.md` fields (`## What I believe`, `## My vocabulary`, `## My tensions`, `## What gets under my skin`, `## My perspective in one line`): *"From [owner]'s beliefs, tensions, and vocabulary, does this settled fact — and its exact wording — land correctly?"* The structured fields make this check discriminating: a "settled" wording that trips the owner's own stated *tensions* or *pet peeves* is caught here and routed.
   - **Genuine objection surfaces** → the fact was not settled → route normally.
4. **Scribe** the exact settled patch into the target artifact; update its `timestamp` frontmatter date. Add a one-line note at the scribed location carrying the attribution (§4).
5. **Attribute** (§4) and **run the Promotion Cascade Check** (defined in each Handback mode resource; see `pm-handback.md` Step 4 / `planning-handback.md` Step 3): classify downstream consumers as `unaffected | minor-update | stale`.
   - **1 stale owner** → auto-enqueue one follow-up `H-###` per stale artifact; close follows the owning persona's verbatim-invocation rule.
   - **≥2 stale owners** → mark each in `registry.md ## Stale` and route to Sonia in Course-Correction (multi-owner orchestration preserved).
6. **Continue.** No deferred audit. No close ritual beyond the persona's normal Exit/Handoff.

## 4. Attribution (passive provenance, NOT deferred audit)

Every scribed edit carries dual attribution so truth remains attributable (truth-state invariant; QA/Rahat still verifies against shipped behavior):

- **In the target artifact**, at the scribed location:
  `Owner Disposition: applied_by_scribe — voiced-for: [owner]; scribe: [presiding persona]; settled-from: [code-truth | in-session | prior-debate | obvious]; [date]`
- **A closed-on-write `handoff.md` entry** for the same change: `Status: closed`, `Promotion Record` carries the same `applied_by_scribe` string.

**This is traceability, not deferred audit.** There is **no `audit_pending` disposition, no readiness block, no nag** requiring the voiced owner to make a later judgement call. The owner may re-word or revert freely if they ever read it, but nothing asks them to. Reuses the existing `applied_by_scribe` disposition (`bmild-planner/assets/change-proposal-template.md`), broadened from Sonia-only to any presiding persona.

## 5. Fences (preserved)

- **Canonical-tier artifacts** (`context-map.md`, `[plan_folder]/adr/`, project-root `DESIGN.md`) → **never** scribed; always route. Hard fence — restated in every persona's pointer paragraph.
- **Genuinely debatable/open items** → route (strong-minded deliberation intact).
- **≥2-owner cascades** → Course-Correction (orchestration intact).
- **Design-tier authoring authority** → intact: scribing transcribes *settled* facts; it does not author *decisions*.
- **Execution-tier scribing into a design-tier artifact** → a deliberate, gated extension of the existing Alex→`system-design.md` precedent (`bmild-dev/SKILL.md` Scope Boundary): an execution-tier persona may scribe a settled fact into a design-tier artifact only when the full gate holds.

## 6. Security-review note (Zach)

Zach 🟥 is a terminal node (`bmild-sec/SKILL.md`): he does not auto-handoff, and his findings *tag* Alex/Lance/Katrina rather than route onward. Because security findings are a high-stakes surface, the gate's condition 3 routes almost any scribe *into* a `security-review-<slug>.md`. The common scribe case involving Zach is therefore a presiding persona detecting a settled, **non-security** correction to a `security-review-<slug>.md` (e.g. a code-truth location or path fix); the gate still applies in full, and the settlement-verify loads Zach's `SOUL.md`.

## 7. Relationship to Course-Correction

Sonia's Course-Correction scribe (`bmild-planner/resources/course-correction.md`) is the **original** scribe path; this doc generalizes it to all personas. Sonia's path additionally tracks applications in the change-proposal artifact (`## Scribe Applications`) and attributes to the roundtable session — those mechanics are Sonia-specific and stay in `course-correction.md`. The **gate** (§2) and the **general procedure** (§3) are shared here.

## 8. Rollout

Pilot on **Dev + Planner** first — both already carry scribe precedents (Alex→`system-design.md`; Sonia→Course-Correction scribe). Validate the gate threshold against ~5–10 recent real `handoff.md` items (recently-closed `source_defect` and `promotion_request` entries are the test corpus), then the same wording generalizes to PM/UX/Arch/QA/Sec. The mechanism is available on all seven personas from landing; the pilot calibrates the *threshold*, not the availability.
