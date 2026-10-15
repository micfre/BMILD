---
type: ADR
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name> | _cross"
status: "proposed | accepted | deprecated | superseded by ADR-NNNN"
---

<One to three sentences stating the context, the decision, and the reason. Then the drift-protection line:>

**Prevents:** <the specific divergence a future reader would cause by re-litigating or "fixing" this deliberate choice — what actually breaks or drifts if the decision is casually reversed. A `Prevents` that merely repeats the decision fails; name the real consequence.>

## Optional sections

<Include only when they add genuine value. Most ADRs will not need any of them.>

- **Considered Options** — only when the rejected alternatives are worth remembering (one terse line per option); otherwise the full analysis lives in the relevant `system-design.md` §2.
- **Consequences** — only when a non-obvious downstream effect must be called out.

## Numbering and scope

- Filename: `<NNNN>-<slug>.md`. Scan `[plan_folder]/adr/` for the highest existing number and increment by one.
- `[plan_folder]/adr/` is the single discovery point for all drift-protection ADRs. Set the `scope:` frontmatter to the initiative name, or `_cross` for a cross-initiative commitment.

## What qualifies (the triple-axis gate)

All three must be true. If any is missing, skip the ADR — the decision belongs in `system-design.md` §2 only.

1. **Hard to reverse** — the cost of changing your mind later is meaningful.
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and one was picked for specific reasons.

What commonly qualifies: architectural shape; integration patterns between contexts; technology choices that carry lock-in; boundary and scope decisions (the explicit *no*s are as valuable as the *yes*s); deliberate deviations from the obvious path; constraints not visible in the code; rejected alternatives when the rejection is non-obvious. Cross-initiative commitments commonly qualify; an initiative-local decision that is surprising and hard to reverse also qualifies.

Every drift-protection ADR carries a populated `Prevents` line naming the concrete future divergence it stops. The triple-axis gate decides *whether* an ADR exists; `Prevents` is the field a future reader needs before "fixing" a deliberate choice — an ADR whose `Prevents` restates its decision is incomplete.
