# Representative corrected UX contract block

Corrected shape for FR6, FR9–FR12: resolvable token references by name,
visual plus behavioral rules per named component (or a named inherited source),
per-surface state walk with behavior or genuine non-applicability, and recorded
bidirectional surface closure.

## 4. Screens / Views

### Enrollment confirmation screen

- **States:**
  - **Empty:** never empty — confirmation always renders at least one child card; if the session has no children the route redirects to the chooser.
  - **Cold-load:** cached submission summary renders immediately; server confirmation swaps in when it arrives.
  - **Error:** a confirmation-desync message names the affected child and offers "resend confirmation email".
  - **Offline:** not applicable — this route performs no writes; a stale read shows the last cached summary with an "as of" timestamp.
  - **Permission-denied:** a parent without enrollment access for a child sees that child's card collapsed with a "contact registrar" action instead of the details.

### Surface closure

- **Needs → surfaces:** N1 confirm all children — served by Enrollment confirmation screen; N2 fix a stale address — served by the shared Profile editor (supporting surface: reused from the account area rather than given an artificial enrollment-only journey; its journey J2 already lands there).
- **Surfaces → journeys:** Enrollment confirmation screen — J1 step 3; Profile editor — J2.
- **Missing links:** none.

## 5. Named components

- **Confirmation banner:** Visual — `{colors.primary}` background, neutral text per `typography.body`. Behavioral — appears on successful submission only, announces the per-child outcome count, and dismisses into an undoable snackbar for 8 seconds. Inherited — elevation from `DESIGN.md` Global UX Patterns "Elevation & Depth".
