# Artifact Promotion Protocol

> Shared definition for advanced facilitators (`bmild-{roundtable,elicit,brainstorming}`). Each facilitator ships an identical copy under its own `references/promotion-protocol.md`. The active skill loads **this skill's** copy via a relative path — never `docs/`, never another skill's tree.

Promotion turns ratified agreement into organizational truth (promotion-only truth). It does **not** create a second authoring privilege. Facilitator apply is **presiding scribe** over scribe-eligible inventory lines, or durable routing for everything else.

## 1. Trigger triad

Fire the gate between ratification and close when **all** of these hold:

1. The user has **ratified** a decision, not merely expressed a preference.
2. The decision changes a **durable contract**: requirements, authority, data semantics, system boundary, interaction behavior, verification, terminology, or phase scope.
3. At least one **source-of-truth artifact** is now stale or incomplete relative to the ratification.

If any condition fails → skip the promotion gate; use the skill's normal close.

**Counterexample:** wording tweak to an already-decided error label → no gate unless it changes an existing UX/source artifact.

**Regression example:** ratified operator-configured authority, per-record commercial semantics, MVP inheritance, Growth deferral, new UI status treatment, and new verification obligations → inventory product, architecture, UX, QA, terminology, ADR (canonical-route), and handoff impacts; ask once; do not author delivery slices without planner/user direction.

## 2. Impact inventory

Produce a compact inventory. Each line:

- **Artifact** — path under initiative or project root
- **Owner** — persona who owns the artifact
- **Action class** — exactly one of:
  - `scribe` — settled, reversible, non-high-stakes, non-canonical; eligible for facilitator scribe if authorized
  - `owner-handback` — needs owning persona judgment or Handback (open Preference, high-stakes surface, unsettled wording)
  - `canonical-route` — `context-map.md`, `[plan_folder]/adr/`, or project-root `DESIGN.md` — **never** facilitator-written
  - `planner-deferred` — `slices.md` / `slice-<N>.md` unless the user explicitly includes delivery

Classification hints:

- Product semantics / scope → product brief, PRD, context
- System / data contract → system design, context; ADR → `canonical-route`
- User-visible behavior → UX design; global patterns → `DESIGN.md` as `canonical-route`
- Proof / acceptance → verification matrix
- Historical routing → handoff, registry; RCA → dated addendum, not retrospective rewrite
- Delivery decomposition → `planner-deferred` by default

## 3. Owner-count / cascade gate

Before asking for apply authority:

1. Count **distinct design-tier owners** with non-trivial `scribe` or `owner-handback` updates (PM, UX, Arch, QA as owners of their source artifacts).
2. If **≥2** such owners → do **not** batch-scribe across owners. Recommend Sonia Course-Correction (or resume the planner convener). Close as `ratified_and_routed` (or pending/deferred if the user declines routing). Persist the inventory in `handoff.md` or the active `change-proposal-<slug>.md` when write authority permits.
3. If **1** owner (or only `canonical-route` / `planner-deferred` lines remain) → proceed to the one authorization ask.

After any successful scribe, run the **Promotion Cascade Check**. If the cascade marks **≥2** stale owners → stop further batch apply; mark `registry.md ## Stale` and route Course-Correction.

## 4. Ask once

Ask for authorization with concrete cost — not a vague “what next?”:

> “I found [N] impacted design artifacts ([list action classes: M scribe-eligible, K route/handback, C canonical-route]) and [P] planner-owned delivery artifact(s). Do you want me to promote the ratified decisions into the scribe-eligible design artifacts now, route the rest via handoff/Course-Correction, and leave Slice authoring for Sonia?”

Preserve user control:

- **Authorize apply** → attempt each `scribe` line under §5; route non-scribable lines.
- **Not now** → `ratified_pending_authorization` + durable backlog when permitted.
- **Explicitly defer docs** → `ratified_with_documentation_deferred` + durable backlog when permitted.

## 5. Apply rules (authorization is necessary, not sufficient)

For each inventory line after authorization:

1. Re-check action class. `canonical-route` and `planner-deferred` never become facilitator writes from this protocol.
2. For `scribe` candidates, run full **Scribe-Eligibility** (settled source, reversible, no high-stakes surface, no canonical-tier). Roundtable-ratified content additionally requires Non-negotiable-only synthesis and unmodified ratification (same qualifier as Course-Correction scribe).
3. On pass:
   - Load the target owner's entire `SOUL.md` (voice-resolution: sibling of that persona's `SKILL.md`).
   - Settlement-verify against their beliefs/tensions/vocabulary.
   - Write the exact settled patch; update `timestamp`.
   - Dual attribution: in-artifact `Owner Disposition: applied_by_scribe — voiced-for: [owner]; scribe: Facilitator ([skill]); settled-from: prior-debate; [date]` and a **closed-on-write** `handoff.md` entry with matching `Promotion Record`.
   - Run Promotion Cascade Check.
4. On fail → `owner-handback` or `canonical-route`; enqueue open handoff / recommend owning persona or Course-Correction. Do not silently skip without recording the route.

**Elicit / Brainstorming write boundary:** default close remains a handoff note to the convener. Facilitator scribe apply requires explicit user authorization for facilitator writes (same as Roundtable forward-direction). Without that authorization, close `ratified_pending_authorization` and resume the convener.

**Context B (course-correction consultation):** the facilitator does **not** run this apply path. Append synthesis to the change-proposal; Sonia owns post-ratification scribe/handback. No double-gate.

## 6. Close states

When the gate fired, close with exactly one state:

- `ratified_and_promoted` — every attempted `scribe` line succeeded; remaining inventory lines were routed (canonical / handback / planner-deferred) with durable backlog entries where required
- `ratified_and_routed` — no facilitator scribe apply; inventory persisted as routing/CC/handoff backlog
- `ratified_pending_authorization` — user did not authorize promote/route writes yet; inventory remains in chat and, when permitted, an open `handoff.md` promotion_request
- `ratified_with_documentation_deferred` — user explicitly deferred documentation; same durability rules as pending

Forbidden: claim `ratified_and_promoted` if any attempted scribe failed, or if canonical-tier / multi-owner work was written by the facilitator.

## 7. Durable backlog

Pending, deferred, and routed closes that need async continuity write (when handoff write authority exists):

- One open `handoff.md` item per deferred promotion inventory (type `promotion_request`), body carries the inventory, **no** `applied_by_scribe` until apply.
- Or append to an existing initiative `change-proposal-<slug>.md` when Course-Correction is already active.

Chat-only synthesis is insufficient for fresh-window reload policy.

## 8. RCA addenda

Historical `rca-<slug>.md` files receive **dated addenda** when a ratification changes understanding of a past defect. Do not rewrite historical evidence sections retrospectively.

## 9. Design vs delivery

Default promotion excludes `slices.md` and `slice-<N>.md`. Include them only when the user explicitly authorizes planner-owned delivery artifacts, or when a separate Planner session is invoked.
