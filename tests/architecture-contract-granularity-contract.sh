#!/usr/bin/env bash
# Structural safeguards for outcome-aware architecture and delegated implementation.
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


arch_core = read("bmild-arch/SKILL.md")
arch_design = read("bmild-arch/resources/architecture-design.md")
arch_refine = read("bmild-arch/resources/architecture-refinement.md")
arch_handback = read("bmild-arch/resources/architecture-handback.md")
template = read("bmild-arch/assets/system-design-template.md")
criteria = read("bmild-arch/resources/completion-criteria.yaml")
dev_core = read("bmild-dev/SKILL.md")
spec_dev = read("bmild-dev/resources/spec-dev.md")

# Architecture is scoped by authorized outcomes without losing initiative-wide invariants.
require(
    arch_design,
    [
        "authorized outcome/phase",
        "initiative-wide invariants",
        "Later-phase requirements are context, not present authority",
        "deferred requirements remain non-binding",
    ],
    "architecture design outcome scope",
)
require(
    arch_refine,
    [
        "affected authorized outcome(s)",
        "Preserve unaffected outcome contracts",
        "deferred-phase containment",
    ],
    "architecture refinement outcome scope",
)
require(
    arch_handback,
    ["originating outcome/phase", "initiative-wide impact as explicit scope"],
    "architecture handback outcome scope",
)
require(
    template,
    [
        "**Authorized outcome / phase:**",
        "**Deferred requirements:**",
        "**Initiative-wide invariants:**",
    ],
    "system design scope template",
)

# Commitment strength is explicit in the artifact and every consumer knows the vocabulary.
dispositions = ["committed", "delegated", "illustrative", "observed"]
for label, body in {
    "architecture core": arch_core,
    "architecture design": arch_design,
    "architecture refinement": arch_refine,
    "architecture handback": arch_handback,
    "system design template": template,
    "developer core": dev_core,
    "outcome development": spec_dev,
}.items():
    require(body, dispositions, label)
require(template, ["**Applies to:**", "**Disposition:**"], "system design notation")
assert "Every service method specifies" not in criteria
assert "Every table change specifies" not in criteria
for label, body in {
    "architecture core": arch_core,
    "developer core": dev_core,
    "planner readiness": read("bmild-planner/resources/readiness-verification.md"),
    "reviewer core": read("bmild-qa/SKILL.md"),
}.items():
    lowered = body.lower()
    assert "legacy" in lowered, f"{label}: missing legacy disposition compatibility"
    assert "bulk" in lowered and "migration" in lowered, f"{label}: missing no-bulk-migration rule"

# Lance covers load-bearing system behavior, not only implementation surfaces.
for section_id in [
    "outcome_scope",
    "contract_disposition",
    "system_boundaries",
    "quality_attributes",
    "failure_and_consistency",
    "operability_and_evolution",
    "fr_coverage",
]:
    assert f"- id: {section_id}" in criteria, section_id
require(
    template,
    [
        "## 3. System Boundaries & Quality Attributes",
        "## 7. Failure, Consistency & Recovery",
        "## 8. Operability & Evolution",
        "## 10. Implementation-Confirmed Observations",
    ],
    "system design architecture concerns",
)
require(criteria, ["authorized outcome", "Later-phase FRs remain deferred"], "FR coverage")

# Completed design routes by actual need; optional planning is not a default relay.
for label, body in {"design": arch_design, "refinement": arch_refine}.items():
    require(body, ["directly to Alex", "use Sonia only"], f"{label} close routing")
    assert "Default `Next` to Sonia" not in body
require(arch_core, ["point `Next:` to Alex", "Point to Sonia only"], "architecture core routing")

# Alex can record facts but cannot silently turn them into commitments.
require(
    dev_core,
    [
        "two lanes",
        "mechanically add or update an `observed` item",
        "Moving an observation into `committed`",
        "requires Lance's criteria",
    ],
    "developer promotion boundary",
)
for relative in [
    "bmild-dev/resources/spec-dev.md",
    "bmild-dev/resources/spec-fix.md",
    "bmild-dev/resources/direct-dev.md",
    "bmild-dev/resources/direct-fix.md",
]:
    body = read(relative)
    require(body, ["`observed`", "Lance's criteria"], relative)
    assert "Routing heuristics" not in body, relative

for relative in [
    "bmild-qa/resources/spec-fix.md",
    "bmild-qa/resources/direct-fix.md",
]:
    body = read(relative)
    require(body, ["`observed`", "Lance's criteria"], relative)

# Planner and reviewer interpret disposition instead of turning examples into requirements.
require(
    read("bmild-planner/resources/readiness-verification.md"),
    ["Interpret architecture dispositions explicitly", "`illustrative` and `observed` items are not acceptance requirements"],
    "planner architecture interpretation",
)
require(
    read("bmild-qa/SKILL.md"),
    ["Architecture contract interpretation", "`illustrative` content is non-binding", "`observed` content is evidence"],
    "reviewer architecture interpretation",
)

print("architecture-contract-granularity-contract: PASS")
PY
