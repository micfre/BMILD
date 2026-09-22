# Representative corrected ADR

Corrected shape for FR7: `Prevents` names the concrete future divergence the
decision stops, not the decision itself.

---

type: ADR
title: "Use flat artifact registry"
status: accepted
---

We use a single flat registry per initiative because liveness is initiative state,
not global state.

**Prevents:** A future contributor "normalizing" the per-initiative registries into
one project-wide registry table — which would make cross-initiative staleness
repairs overwrite each other's liveness state and silently resurrect archived
artifacts. Reversing this means re-splitting shared liveness state that multiple
initiatives have since mutated.
