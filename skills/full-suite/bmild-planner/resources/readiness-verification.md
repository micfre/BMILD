# Readiness-Verification

Establish whether the authorized phase/outcome has sufficient intent, usable constraints, and demonstrable completion criteria. Readiness is a quality judgment that Alex may apply during execution, not a mandatory separate session.

## Additional Context

Read the initiative registry and relevant live product, UX, architecture, semantic, and ADR contracts from disk. Check the current outcome in `verification-matrix.md` and unresolved handoff items when present. Use the user request and authoritative phase scope; archived records are history, not current authority.

## Global Directives

- **Close gaps in-session.** Any instruction below to route, defer to another owner, enqueue a handoff, or enter Course-Correction first invokes this skill's `references/gap-resolution.md`. Persist `H-###` only when the episode genuinely leaves the session; after resolution, re-read changed contracts and resume this mode.

- Assess meaning, not document count. A sufficient contract can live in one or several source artifacts. Missing intent, contradictory behavior, unresolved trust boundaries, or untestable critical requirements matter; a missing filename alone does not block work.
- Respect MVP/Growth/Vision boundaries. Deferred features are not authorization. Separate a genuinely blocking decision from a reversible technical question that an experiment can answer.
- Interpret UX authority explicitly: confirm the UX artifact applies to the authorized outcome; treat user-observable behavior, information, actions, states, accessibility, and consequential copy as commitments; preserve delegated implementation mechanics as Alex's choice; and exclude illustrative, observed, and deferred-phase content from acceptance scope. For legacy UX designs, preserve explicit observable decisions and resolve only genuinely ambiguous authority through Katrina's criteria; require no bulk migration.
- Interpret architecture dispositions explicitly: `committed` items are constraints and proof sources; `delegated` items preserve Alex's choice within their boundary; `illustrative` and `observed` items are not acceptance requirements unless another authoritative source makes them so. Confirm architecture applicability matches the authorized outcome.
- For legacy system designs without disposition labels, preserve explicit behavior/data/trust/compatibility/NFR commitments, treat clearly labelled examples and private sketches as non-binding, and resolve genuinely ambiguous authority through Lance's criteria. Do not require a bulk format migration for readiness.
- Readiness can be local: record blocked obligations and let independent authorized work proceed. Never silently waive a requirement or treat accepted handoff history as source truth.
- Verify coverage backward against the outcome directly from source requirements. Planning a test does not prove it. Include relevant NFRs, documentation, security, scalability, maintainability, and user journeys; do not require implementation file predictions.
- **Outcome identity.** When no outcome record exists, mint the next unused initiative-local `O-###` from the verification matrix and pair it with a descriptive title. Never reuse or rename the ID; title changes preserve it. Use that ID in every downstream reference and keep the matrix `## Outcome Index` synchronized.

## Tasks

Progress:

- [ ] Step 1: Resolve the authorized phase/outcome, source authority, excluded future work, and consequential constraints.
- [ ] Step 2: Inspect cross-artifact consistency, architecture outcome applicability/disposition, and repository integration boundaries as needed. Resolve actual owner gaps; use experiments or explicit assumptions only for reversible engineering uncertainty.
- [ ] Step 3: Create or update the `O-###` outcome section of `verification-matrix.md` from `assets/verification-matrix-template.md`. Link all applicable requirements to demonstrable evidence obligations, recording readiness and blockers. Preserve existing implementation/review evidence and other outcomes; invalidate only evidence affected by a changed source. Update the compact Outcome Index entry in the same edit.
- [ ] Step 4: Register the matrix as live. When the outcome record is created or activated, also sync the initiative's `[plan_folder]/rollup.md` registry entry (`Phase`, `Status: active`, `Last updated`) as a mechanical scribe update. Report sufficient readiness or the exact missing decision, and continue an already-authorized engagement. Do not create Slices or offer a separate planning gate merely because readiness passed.

## Definition of Done

- Phase/outcome, committed constraints, applicable requirements, and proof obligations established.
- Actual blockers resolved or recorded without blocking unrelated authorized work.
- Outcome evidence record current; no implementation status misrepresented as verification.
