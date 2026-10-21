---
type: UX Design
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name> | _system"
author: "[user_name] + Katrina (UX)"
---

## 1. Initiative Context & Flow Goals

- **Authorized outcome / phase:** <MVP | Growth | Vision | named outcome | initiative-wide>
- **Authorization source:** <request or authoritative outcome link>
- **In-scope user-facing requirements:** <FR and journey IDs when present; otherwise precise request or source references>
- **Deferred requirements and journeys:** <later phases that inform coherence but create no present implementation authority>
- **Initiative-wide UX invariants:** <observable interaction or accessibility rules shared across outcomes>
- **Affected existing surfaces:** <screens, routes, or flows changed by this outcome>
- **Flow goal:** <specific user behavior this outcome enables>

## UX contract interpretation

User-observable behavior, information, available actions, states, accessibility, and
consequential copy are `committed` by default. Standard component mechanics and private
state handling are `delegated` when established `DESIGN.md` or repository conventions are
sufficient. Mark examples or sketches `illustrative`; mark brownfield behavior `observed`
when it records current reality rather than design intent. Add an explicit **Disposition**
only where the default could be mistaken. Deferred-phase content is non-binding.

## 2. Information Architecture & Routing

New screens, names, routing structure, and URLs.

## 3. User Journeys & Flows

### Flow: <name>

Entry point → steps → exit condition. Include error paths and edge cases.

- **Applies to:** <authorized outcome/phase | initiative-wide>
- **Disposition:** <committed | delegated | illustrative | observed, only when needed>
- **Source journey:** <PRD J-ID when this flow translates a journey, with the protagonist, inline context, climax, and failure path preserved>
- **Evidence:** <Firsthand — confirmed account source | Illustrative — evidence gap recorded, when the source journey carries one>

## 4. Screens / Views

### <Screen Name>

- **Layout Regions:** ...
- **Data Displayed:** ...
- **Available Actions:** ...
- **States:** walk the applicable states among empty / cold-load / error / offline / permission-denied / populated; identify a material state as not applicable with a reason

### Surface closure

- **Needs → surfaces:** every user-facing need in the authorized outcome and its serving surface; a shared or supporting surface records its specific rationale
- **Surfaces → journeys:** every outcome surface and the journey that reaches it
- **Missing links:** <named orphans with their source, surfaced for operator resolution — none when closure holds>

## 5. Initiative-Specific Interaction Model

Consequential or non-standard user-observable behaviour specific to this feature. State
what triggers what and the visible response. Delegate standard component mechanics and
private state handling when established conventions are sufficient.

### Named components

Per named in-scope component: a visual rule and a behavioral rule, or the established
design-system rule (with source) that supplies either. Reference `DESIGN.md` tokens the
design depends on by resolvable `{path.to.token}` name.

## 6. Bounded Assumptions

- **Assumption:** [Low-risk, reversible UX assumption recorded in the consuming artifact]
  - Confidence: [Low/Med/High]
  - Consequence if wrong: [Impact]
  - Revisit trigger: [What evidence or event should force re-evaluation]
