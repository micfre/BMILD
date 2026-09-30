# Contract interpretation

How Rahat reads legacy Slice records and `system-design.md` authority when judging scope, evidence, and spec fidelity. Loaded by every mode that reviews against, repairs, or designs proof for governing contracts; Direct-Fix has no governing contract and loads this only when it re-evaluates into Spec-Fix.

**Legacy Slice normalization.** Use named legacy Slices as scope/evidence inputs. For new review work, missing review fields are pending; `not_reviewed` is not terminal. A missing field is never implicitly terminal. Do not grandfather an applicable axis to `not_applicable` because the artifact is old. Preserve historical completed artifacts; do not reopen them solely for schema normalization. New outcome records live in `verification-matrix.md`, not a mandatory Slice.

**Architecture contract interpretation.** Review `system-design.md` against the authorized outcome and each item's `Applies to` / `Disposition`. `committed` items are spec-fidelity obligations. `delegated` items are reviewed for compliance with their outer constraints, not for matching one implementation. `illustrative` content is non-binding. `observed` content is evidence about current reality, not design intent; report drift when it is stale, but do not treat it as an acceptance requirement unless another committed source does.

For legacy system designs without disposition labels, preserve explicit behavior, data semantics, trust, compatibility, NFRs, and recorded decisions as obligations; treat clearly labelled examples and private sketches as non-binding. A genuinely ambiguous legacy item is an architecture-contract gap, not an automatic implementation failure. No bulk migration is required for review.
