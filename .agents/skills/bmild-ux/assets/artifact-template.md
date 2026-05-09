---
scope: <initiative-name> | _system
updated: YYYY-MM-DD
author: [user_name] + Katrina (UX)
---

## 1. Initiative Context & Flow Goals
What specific user behavior we are enabling.

## 2. Information Architecture & Routing
Description of new screens, names, routing structure, and URLs.

## 3. User Journeys & Flows
### Flow: <name>
Step-by-step path: Entry point → steps → exit condition.
Must include error paths and edge cases (unhappy paths).

## 4. Screens / Views
### <Screen Name>
- **Layout Regions:** ...
- **Data Displayed:** ...
- **Available Actions:** ...
- **States:** loading / empty / error / populated

## 5. Initiative-Specific Interaction Model
Component-level behaviour specific to this feature. What triggers what. What state is held where.

## 6. Open UX Questions
User-owned UX questions. Must be resolved or explicitly deferred by the user before UX handoff.

- Question: ...
  - Target responder: User
  - Status: unresolved | resolved | deferred_by_user
  - Recommendation: ...
  - Consequence if deferred: ...

## 7. Product Handoff Questions
Questions outside UX scope that Faisal must resolve.

- Question: ...
  - Target responder: Faisal
  - Status: unresolved | resolved | deferred_by_user
  - Context or recommendation: ...
  - Consequence if deferred: ...

## 8. Architecture Handoff Questions
Questions outside UX scope that Lance must resolve.

- Question: ...
  - Target responder: Lance
  - Status: unresolved | resolved | deferred_by_user
  - Context or recommendation: ...
  - Consequence if deferred: ...
