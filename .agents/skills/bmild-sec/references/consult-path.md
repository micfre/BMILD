# In-Session Frontier Consult Path

> Shared definition for all standard personas (`bmild-{pm,ux,arch,planner,dev,qa,sec}`). Each standard persona ships an identical copy under its own `references/consult-path.md`. The active persona loads **this skill's** copy via a relative path — never `docs/`, never another skill's tree. There is no per-skill bespoke consult logic.

## 1. What this is

When a presiding persona hits a gap in another owner's artifact that the **scribe path cannot take** — because the item is *genuinely open* (a real decision, not a settled fact) or *settled but high-stakes* — it may dispatch the owning persona's **consult subagent** *within the same session*. The subagent is a harness-native agent that loads the owning persona's full identity (`SKILL.md` + `SOUL.md`), runs on the model tier pinned for that persona (Frontier for design-tier + planner), **authors the decision directly** into the owned artifact, and returns a bounded decision record. **No session termination, no user orchestration, no context dump.**

This is the middle tier of the resolution ladder:

1. **Scribe** (`references/scribe-path.md`) — settled fact → transcribed in-turn. Cheapest; runs first, always.
2. **Consult** (this doc) — open or settled-high-stakes, single-owner, non-canonical-tier → owning persona's subagent authors it in-session.
3. **Route** (`handoff.md`, Course-Correction) — multi-owner, canonical-tier, or consult disabled/unavailable → today's orchestrated flow, unchanged.

**Consult ≠ scribe ≠ route.** Scribing transcribes settled facts; consulting obtains an *authored decision* from the owning persona at its pinned model tier; routing defers to a full session. Consulting never lets the presiding persona's model decide an open design question — that is the non-negotiable this path exists to serve.

## 2. The Consult-Eligibility rule (shared, single source)

Consult may fire only when **all** of the following hold:

1. **Scribe gate failed or is inapplicable.** The item is genuinely open (real trade-off, live Preference options) *or* settled-but-high-stakes (scribe gate §2 condition 3: data-model, API-contract, security, or compliance surface). If the full scribe gate passes, scribe instead — consult is the more expensive tier.
2. **Single owner.** Exactly one persona owns the requested change. Judge by who authors that class of change per the cross-artifact flow, not by artifact filename alone: where two personas share write authority on one artifact (e.g. `verification-matrix.md` — Sonia authors at readiness, Rahat repairs/expands), consult targets the persona responsible for the requested class of change; a request spanning both classes routes. ≥2-owner cascades route to Course-Correction.
3. **Non-canonical-tier.** Target is not `context-map.md`, `[plan_folder]/adr/`, or project-root `DESIGN.md`. Canonical-tier artifacts always route (hard fence, §7).
4. **Consult enabled.** `.bmild.toml` carries `consult = 1` (auto) or `consult = 2` (ask). Absent or `0` means off → route normally. Malformed values behave as absent (off) with a one-line warning.
5. **Chain budget available.** The chain budget (§6) has not been exhausted for this gap.

If any condition fails → normal `handoff.md` routing, exactly as today.

## 3. Consent check and config

- `consult = 1` (**auto**): dispatch without asking.
- `consult = 2` (**ask**): emit one inline line — `Consult <Persona> on <bounded question>? Frontier call: <model>/<effort>.` — and dispatch only on yes. A no routes normally.
- `consult` absent or `0` (**off**): never dispatch; behaviour is byte-identical to the pre-consult workflow. This is the default.

Optional pass-throughs `consult_model` and `consult_effort` override the frontier pair (model, reasoning depth) for frontier-pinned consults where the harness exposes both dimensions. Where the harness cannot express one dimension, that override is ignored with a one-line notice (`<key> not supported by this harness — using shipped default.`). Never silently substitute a lower tier: if the pinned or configured model is unavailable, route to `handoff.md` with a one-line notice instead of downgrading.

## 4. The dispatch packet

The presiding persona dispatches with a bounded packet, not a context dump:

- **Question**: one bounded decision question (one trade-off, one artifact).
- **Scope**: initiative name; target artifact + section anchor.
- **Established facts**: the settled facts already known (code truth, in-session decisions) that the decision must respect.
- **Depth marker**: `depth: 1`.
- **Replan context** (Sonia recut consults only): the decision record(s) the recut must honour.

The subagent loads its own context from disk; the packet carries pointers, not payloads.

## 5. The leaf contract (subagent behaviour)

The consult subagent:

1. Loads its own `SKILL.md`, `SOUL.md`, and this `references/consult-path.md` (siblings), then grounds in the packet plus the named artifacts.
2. **Authors** the decision into its owned artifact with the owning persona's full voice and authority; updates the artifact's `timestamp` frontmatter.
3. Writes a **closed-on-write** `handoff.md` entry: `Status: closed`,
   `Promotion Record: authored_by_consult — owner: <persona>; consult-of: <presiding persona>; depth: 1; <date>`
   (record the concrete model + effort pair when the harness reports it).
4. Moves its artifact from `## Stale` back to `## Live` in `registry.md` when listed there.
5. Returns a bounded **decision record**: the decision; rationale (≤3 lines); artifact + section; cascade classification (`unaffected | minor-update | stale`); slice-scope impact (yes/no).
6. **Never dispatches further subagents. Never writes canonical-tier artifacts.** Consult subagents are leaf nodes — on harnesses that support it this is enforced by denying the subagent the task-dispatch tool; elsewhere this line is the enforcement.

## 6. Chain budget

Per gap: **one owner consult + at most one Sonia recut consult** (dispatched by the presiding persona when a returned decision record reports slice-scope impact and the presiding persona is not Sonia). Anything deeper routes to Course-Correction. Consults dispatched from within a consult are forbidden (leaf contract, §5.6).

## 7. Fences (preserved)

- **Canonical-tier artifacts** (`context-map.md`, `[plan_folder]/adr/`, project-root `DESIGN.md`) → never consulted-in-place; always route. Same hard fence as scribe-path §5.
- **≥2-owner cascades** → Course-Correction (orchestration intact).
- **Open-item authoring authority** → strengthened, not weakened: the owning persona authors at its pinned model tier; the presiding model never fills the gap itself.
- **Consult off / unavailable** → byte-identical pre-consult behaviour.
- **No silent tier downgrade** → unavailable pinned model routes; it never falls through to the session model.

## 8. Standing override: Promotion Cascade Check

When `consult ∈ {1, 2}`, the Promotion Cascade Check's **"1 stale owner"** arm resolves by **dispatching that owner's consult** (subject to §2 and the chain budget) instead of auto-enqueueing a follow-up `H-###` that forces a later session. When consult is off, the cascade check behaves exactly as before. The "0 stale owners" and "≥2 stale owners" arms are unchanged.

## 9. Degradation

- Harness has no subagent-dispatch mechanism (or the feature is disabled) → Tier-3 route with notice: `Consult unavailable — routing via handoff.md.`
- Spawn/pinned-model failure → same notice + route. No retry storm, no downgrade.
- After the decision record returns, the presiding persona **re-reads the patched section** (never trusts the summary alone) and resumes its suspended mode per its Same-Session Resumption contract.

## 10. Relationship to scribe path and Course-Correction

The scribe path (settled facts) and this consult path (open or high-stakes single-owner decisions) share one decision tree: scribe gate first, consult rule second, route third. Sonia's Course-Correction is untouched: multi-owner changes still get impact map, roundtable deliberation, and ordered handoff chain. The `authored_by_consult` disposition reuses the closed-on-write provenance pattern established by `applied_by_scribe` (passive provenance, no deferred audit).
