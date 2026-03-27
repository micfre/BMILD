# Onboarding

BMILD can join at any stage. You do not need to start from scratch.

## What Stage Are You At?

Pick the closest match and invoke that persona directly.

| Stage | Start with | Example |
| :--- | :--- | :--- |
| I have an idea and need to define the work | **Faisal (PM)** | `Faisal, help me frame a feature for account recovery.` |
| I know what the feature is and need the UX worked out | **Katrina (UX)** | `Katrina, design the onboarding flow for this feature.` |
| I need backend or system contracts | **Lance (Architect)** | `Lance, design the API and data model for this feature.` |
| UX and architecture are ready and I need implementation slices | **Sonia (Delivery Planner)** | `Sonia, check readiness and decompose this feature into slices.` |
| I have a Slice ready to build | **Alex (Developer)** | `Alex, implement slice 3.` |
| Something is broken or I need verification | **Rahat (QA)** | `Rahat, verify slice 3 and identify any coverage gaps.` |

## Midstream Entry

BMILD personas are expected to read the live context in `plans/` before they question you or route the next step.

That means you can enter mid-lifecycle and say:

- `Katrina, continue the UX design for persona breadth.`
- `Sonia, what Slice should happen next?`
- `Alex, continue with slice 4.`
- `Rahat, verify the completed Slice before handoff.`

The persona should tell you what context it loaded, what stage seems current, and who should engage next when it reaches a handoff boundary.

## If You Are Coming From BMAD

BMILD is intentionally narrower. It does not try to mirror BMAD persona-for-persona.

Use BMILD by intent:

| BMAD-style need | BMILD start point |
| :--- | :--- |
| Product framing or PRD work | **Faisal (PM)** |
| UX design | **Katrina (UX)** |
| Architecture and technical contracts | **Lance (Architect)** |
| Readiness checks, release planning, or slice decomposition | **Sonia (Delivery Planner)** |
| Implementation | **Alex (Developer)** |
| Debugging, RCA, regression coverage, or verification | **Rahat (QA)** |

What BMILD intentionally does not replicate:

- Large persona catalogs
- Scrum ceremony language
- Separate status-planning personas when `Delivery Planner` already owns readiness, sequencing, status clarity, and rerouting

## Suggested First Move

- New feature: start with **Faisal**
- Existing feature that needs design: start with **Katrina** or **Lance**
- Approved design ready for breakdown: start with **Sonia**
- Active implementation: start with **Alex**
- Bug, regression, or release confidence question: start with **Rahat**

If you want the broader positioning and lifecycle map, go back to [README.md](README.md).
