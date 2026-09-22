#!/usr/bin/env bash
# Structural safeguards for the spec-sharpening authoring disciplines:
# journey evidence, counter-metrics, ADR Prevents, dimension sweep, and the
# UX token/component/surface-state contract with two-pass validation.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$ROOT" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
skills = root / ".agents/skills"
fixtures = root / "tests/fixtures/spec-sharpening"


def read(relative):
    return (skills / relative).read_text()


def read_fixture(name):
    return (fixtures / name).read_text()


def require(body, terms, label):
    for term in terms:
        assert term in body, f"{label}: missing contract: {term}"


# --- Placement: PM journey evidence and counter-metrics (FR1-FR4) ------------

prd_criteria = read("bmild-pm/resources/prd-completion-criteria.yaml")
write_prd = read("bmild-pm/resources/write-prd.md")
refine_prd = read("bmild-pm/resources/refine-prd.md")
prd_template = read("bmild-pm/assets/prd-template.md")
brief_criteria = read("bmild-pm/resources/brief-completion-criteria.yaml")
brief_template = read("bmild-pm/assets/product-brief-template.md")
write_brief = read("bmild-pm/resources/write-product-brief.md")
refine_brief = read("bmild-pm/resources/refine-brief.md")

require(
    prd_criteria,
    [
        '- id: success_measures',
        "counter-metric",
        "harmful",
        "Firsthand",
        "Illustrative",
        "evidence gap",
        "climax beat",
        "explicit failure path",
        'a generic "the user"',
    ],
    "PRD journey/metric criteria",
)
require(
    write_prd,
    [
        "Captured, not authored",
        "ask for a real session first",
        "evidence gap",
        "without re-asking",
        "Counter-metrics.",
    ],
    "PRD authoring discipline",
)
require(
    refine_prd,
    [
        "Journey evidence survives refinement",
        "Never let refinement rewrite an illustrative journey as firsthand",
        "counter-metric pairing",
    ],
    "PRD refinement discipline",
)
require(
    prd_template,
    [
        "Evidence: Firsthand",
        "Illustrative — evidence gap",
        "Climax and success exit",
        "Failure path:",
        "**Counter-metric:**",
        "Reveals:",
        "include only when requirements involve user-facing behavior",
    ],
    "PRD template journey/metric shape",
)
for label, body in {
    "brief criteria": brief_criteria,
    "brief authoring": write_brief,
    "brief refinement": refine_brief,
}.items():
    require(body, ["ounter-metric"], label)
require(
    brief_criteria,
    ["paired with a counter-metric", "names no harmful"],
    "brief counter-metric criteria",
)
require(brief_template, ["**Counter-metric:**"], "brief template")

# --- Placement: UX evidence, closure, tokens, components, states (FR5-FR12) ---

ux_criteria = read("bmild-ux/resources/completion-criteria.yaml")
ux_design = read("bmild-ux/resources/ux-design.md")
ux_refine = read("bmild-ux/resources/ux-refinement.md")
ux_template = read("bmild-ux/assets/ux-design-template.md")

require(
    ux_criteria,
    [
        "Firsthand or Illustrative evidence label",
        "never rewritten as observed behavior",
        "traces to a serving surface",
        "journey that reaches it",
        "forced artificial journey",
        "- id: token_contract",
        "{path.to.token}",
        "never invents a token",
        "- id: component_contract",
        "visual rule and a behavioral rule",
        "cold-load",
        "permission-denied",
        "no usable behavior",
    ],
    "UX sharpened criteria",
)
require(
    ux_design,
    [
        "Preserve source journey evidence",
        "Close the surface graph, never invent into it",
        "{path.to.token}",
        "Two-pass validation",
        "empty, cold-load, error, offline, and permission-denied",
        "mechanical coverage before judgment",
    ],
    "UX authoring discipline",
)
require(
    ux_refine,
    ["Preserve evidence and references in changed content", "mechanical coverage before judgment"],
    "UX refinement discipline",
)
require(
    ux_template,
    [
        "**Source journey:**",
        "**Evidence:**",
        "### Surface closure",
        "**Needs → surfaces:**",
        "**Surfaces → journeys:**",
        "**Missing links:**",
        "{path.to.token}",
        "cold-load",
        "permission-denied",
        "visual rule and a behavioral rule",
    ],
    "UX template sharpened shape",
)

# --- Placement: Arch Prevents and dimension sweep (FR7-FR8) -------------------

adr_template = read("bmild-arch/assets/adr-template.md")
arch_criteria = read("bmild-arch/resources/completion-criteria.yaml")
arch_design = read("bmild-arch/resources/architecture-design.md")
arch_refine = read("bmild-arch/resources/architecture-refinement.md")
sys_template = read("bmild-arch/assets/system-design-template.md")

require(
    adr_template,
    ["**Prevents:**", "merely repeats the decision fails", "populated `Prevents` line"],
    "ADR template Prevents field",
)
require(
    arch_criteria,
    ["- id: dimension_sweep", "operational envelope", "`Prevents` line"],
    "architecture sweep criteria",
)
require(
    arch_design,
    [
        "Structural dimension sweep at finalize",
        "operational envelope",
        "populated `Prevents`",
    ],
    "architecture design sweep",
)
require(arch_refine, ["`Prevents`", "structural dimension sweep"], "architecture refinement sweep")
require(
    sys_template,
    [
        "### Structural dimension sweep for this outcome",
        "Deployment & environments:",
        "Infrastructure provider:",
        "Operations & observability:",
        "silently absent dimension is a finding",
    ],
    "system design template sweep",
)

# --- Mechanical mirror: weak fixtures fail, corrected fixtures pass ----------

weak_prd = read_fixture("weak-prd.md")
corrected_prd = read_fixture("corrected-prd.md")
journey_marks = ["Climax and success exit", "Failure path", "Evidence: Firsthand|Illustrative"]


def journey_shape(body):
    present = [
        ("Climax and success exit" in body),
        ("Failure path:" in body),
        (re.search(r"Evidence: (Firsthand|Illustrative)", body) is not None),
        ("Counter-metric:" in body),
    ]
    return all(present), present


weak_ok, weak_present = journey_shape(weak_prd)
corrected_ok, _ = journey_shape(corrected_prd)
assert not weak_ok and sum(weak_present) <= 1, "weak PRD fixture unexpectedly passes the journey/metric shape"
assert corrected_ok, "corrected PRD fixture fails the journey/metric shape"


def adr_prevents(body):
    prevents = re.search(r"\*\*Prevents:\*\*\s*(.*)", body)
    if not prevents:
        return False, "missing Prevents"
    before = body[: body.index("**Prevents:**")]
    paragraphs = [p.strip() for p in before.split("\n\n") if p.strip()]
    decision = paragraphs[-1] if paragraphs else ""
    text = prevents.group(1).strip()
    if not text:
        return False, "empty Prevents"
    if not decision:
        return False, "no decision statement found"
    core = lambda s: s.strip().rstrip(".")
    if core(text) in core(decision) or core(decision) in core(text):
        return False, "Prevents restates the decision"
    return True, ""


weak_adr_ok, why = adr_prevents(read_fixture("weak-adr.md"))
assert not weak_adr_ok, f"weak ADR fixture unexpectedly passes: {why}"
corrected_adr_ok, why = adr_prevents(read_fixture("corrected-adr.md"))
assert corrected_adr_ok, f"corrected ADR fixture fails: {why}"


def design_tokens(design_md):
    front = design_md.split("---")[1]
    tokens = set()
    path = []
    for line in front.splitlines():
        if not line.strip():
            continue
        indent = len(line) - len(line.lstrip())
        key = line.split(":")[0].strip()
        while path and path[-1][1] >= indent:
            path.pop()
        path.append((key, indent))
        tokens.add(".".join(k for k, _ in path))
    return tokens


def token_refs(body):
    return set(re.findall(r"\{([a-zA-Z][a-zA-Z0-9]*(?:\.[a-zA-Z0-9]+)+)\}", body))


tokens = design_tokens(read_fixture("design-system.md"))
assert {"colors.primary", "colors.neutral", "typography.body"} <= tokens, "fixture design system tokens"
weak_ux = read_fixture("weak-ux.md")
corrected_ux = read_fixture("corrected-ux.md")
unresolved_weak = token_refs(weak_ux) - tokens
unresolved_corrected = token_refs(corrected_ux) - tokens
assert unresolved_weak == {"colors.brandBlue"}, f"weak UX fixture should contain one unresolved token, got {unresolved_weak}"
assert not unresolved_corrected, f"corrected UX fixture has unresolved tokens: {unresolved_corrected}"

components = re.findall(r"- \*\*(.+?):\*\*(.*?)(?=\n- \*\*|\Z)", corrected_ux.split("## 5.")[1], re.S)
assert components, "corrected UX fixture has no named component"
for name, body in components:
    assert "Visual" in body and "Behavioral" in body, f"component {name} lacks visual+behavioral pair"
weak_components = re.findall(r"- \*\*(.+?):\*\*(.*?)(?=\n- \*\*|\Z)", weak_ux.split("## 5.")[1], re.S)
for name, body in weak_components:
    assert "Behavioral" not in body, f"weak component {name} unexpectedly carries a behavioral rule"

state_names = ["Empty", "Cold-load", "Error", "Offline", "Permission-denied"]
corrected_states = corrected_ux.split("### Enrollment confirmation screen")[1].split("### Surface closure")[0]
covered = [s for s in state_names if re.search(rf"- \*\*{s}:", corrected_states)]
assert len(covered) >= 4, f"corrected state walk covers too few states: {covered}"
assert "not applicable" in corrected_states, "corrected fixture lacks an explicit non-applicability reason"
weak_states = weak_ux.split("### Enrollment confirmation screen")[1].split("## 5.")[0]
assert "handles errors appropriately" in weak_states and "- **Error:" not in weak_states, (
    "weak fixture should demonstrate aggregate edge-state handling"
)
assert "### Surface closure" in corrected_ux, "corrected fixture lacks surface closure"
assert "### Surface closure" not in weak_ux, "weak fixture should lack surface closure"

print("spec-sharpening-contract: PASS")
PY
