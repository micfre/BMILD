#!/usr/bin/env bash
# Structural safeguards for phase-traceable product scope and outcome-aware UX authority.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$ROOT" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
skills = root / ".agents/skills"


def read(relative):
    return (skills / relative).read_text()


def require(body, terms, label):
    for term in terms:
        assert term in body, f"{label}: missing contract: {term}"


prd_template = read("bmild-pm/assets/prd-template.md")
prd_criteria = read("bmild-pm/resources/prd-completion-criteria.yaml")
write_prd = read("bmild-pm/resources/write-prd.md")
refine_prd = read("bmild-pm/resources/refine-prd.md")
brief_template = read("bmild-pm/assets/product-brief-template.md")
brief_criteria = read("bmild-pm/resources/brief-completion-criteria.yaml")
write_brief = read("bmild-pm/resources/write-product-brief.md")
refine_brief = read("bmild-pm/resources/refine-brief.md")

ux_core = read("bmild-ux/SKILL.md")
ux_template = read("bmild-ux/assets/ux-design-template.md")
ux_criteria = read("bmild-ux/resources/completion-criteria.yaml")
ux_design = read("bmild-ux/resources/ux-design.md")
ux_refine = read("bmild-ux/resources/ux-refinement.md")
ux_handback = read("bmild-ux/resources/ux-handback.md")

# PM defines phase membership precisely without turning every defined phase into authority.
require(
    prd_template,
    ["Phase 1 (MVP) outcome", "Includes: [FR and journey IDs]", "does not authorize its implementation"],
    "PRD phase template",
)
require(
    prd_criteria,
    ["stable identifier", "included FR and journey IDs", "does not itself authorize implementation"],
    "PRD phase criteria",
)
require(write_prd, ["Phase traceability without implied authority", "remaining non-authoritative"], "PRD authoring")
require(
    refine_prd,
    ["stable FR and journey IDs", "load only the affected sections", "Do not preload unrelated downstream artifacts"],
    "PRD progressive refinement",
)

# A bearing reference is provenance only; project-level direction stays in rollup.md.
for label, body in {
    "brief template": brief_template,
    "brief criteria": brief_criteria,
    "brief authoring": write_brief,
}.items():
    lowered = body.lower()
    assert "provenance" in lowered, f"{label}: missing bearing provenance"
    assert "project-scoped" in lowered or "project-level" in lowered, f"{label}: bearing scope drift"
require(write_brief, ["Do not copy the project-level rationale or reconsideration condition"], "bounded bearing provenance")

# Independent owner consequences do not automatically become Course-Correction.
require(
    refine_brief,
    ["independent Katrina, Lance, or Sonia consequences", "only when choices are coupled"],
    "brief refinement routing",
)

# UX binds only the authorized outcome while retaining initiative-wide invariants.
require(
    ux_template,
    ["Authorized outcome / phase", "Deferred requirements and journeys", "Initiative-wide UX invariants"],
    "UX scope template",
)
require(
    ux_criteria,
    ["- id: outcome_scope", "Later-phase requirements remain", "no UX", "treatment is required"],
    "UX outcome criteria",
)
for label, body in {
    "UX design": ux_design,
    "UX refinement": ux_refine,
    "UX handback": ux_handback,
}.items():
    lowered = body.lower()
    assert "outcome" in lowered and "deferred" in lowered, f"{label}: missing outcome containment"
assert "Every functional requirement from prd.md" not in ux_criteria

# Observable UX commitments remain binding without freezing private implementation mechanics.
dispositions = ["committed", "delegated", "illustrative", "observed"]
for label, body in {
    "UX core": ux_core,
    "UX template": ux_template,
    "UX criteria": ux_criteria,
    "architect": read("bmild-arch/SKILL.md"),
    "developer": read("bmild-dev/SKILL.md"),
    "planner": read("bmild-planner/resources/readiness-verification.md"),
    "reviewer": read("bmild-qa/resources/comprehensive-review.md"),
}.items():
    require(body, dispositions, label)
    lowered = body.lower()
    assert "mechanics" in lowered, f"{label}: missing delegated mechanics boundary"

assert "For each interactive element" not in ux_criteria
assert "Every screen has an explicit description" not in ux_criteria
require(ux_core, ["no bulk migration is required"], "legacy UX compatibility")

print("product-ux-outcome-contract: PASS")
PY
