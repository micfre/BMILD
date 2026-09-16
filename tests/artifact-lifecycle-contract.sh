#!/usr/bin/env bash
# Guards handoff vocabulary, registry recovery, semantic-map creation, and rollup bootstrap.
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

handoff = read("bmild-pm/assets/handoff-template.md")
require(
    handoff,
    [
        "Owner Disposition: pending | accepted | deferred | rejected | superseded",
        "Promotion Record: pending",
        "context.md",
        "context-map.md",
    ],
    "handoff schema",
)

registry = read("bmild-pm/assets/registry-template.md")
frontmatter = registry.split("---", 2)[1]
for field in ["type:", "title:", "description:", "timestamp:", "scope:"]:
    assert field in frontmatter, f"registry OKF frontmatter missing {field}"
for heading in ["## Live", "## Archived", "## Stale"]:
    assert heading in registry, f"registry missing {heading}"
require(registry, ["governing H-### or change-proposal", "returns it to Live after promotion"], "registry lifecycle")

for relative in [
    "bmild-pm/resources/pm-handback.md",
    "bmild-ux/resources/ux-handback.md",
    "bmild-arch/resources/architecture-handback.md",
    "bmild-planner/resources/planning-handback.md",
    "bmild-qa/resources/qa-handback.md",
]:
    body = read(relative)
    require(body, ["Owner Disposition", "Promotion Record", "## Stale", "## Live", "unresolved artifacts stale"], relative)

context_template = ".agents/skills/bmild-pm/assets/context-map-template.md"
for relative in ["bmild-pm/SKILL.md", "bmild-ux/SKILL.md", "bmild-arch/SKILL.md"]:
    require(read(relative), [context_template, "When `context-map.md` is required but absent"], relative)
require(read("bmild-qa/resources/security-review.md"), [context_template, "when the owner-authorized edit needs a new file"], "QA semantic routing")

pm = read("bmild-pm/SKILL.md")
require(pm, ["Rollup bootstrap", "rollup-template.md", "initial registry entry mechanically"], "PM rollup bootstrap")
require(read("bmild-pm/resources/project-bearing.md"), ["rollup-template.md", "when absent"], "bearing rollup creation")
require(read("bmild-planner/resources/course-correction.md"), ["Creates `[plan_folder]/rollup.md`", "rollup-template.md"], "course-correction rollup creation")

brain = read("bmild-brainstorming/resources/step-03-execute.md")
for retired in ["facilitation_prompts", "energy_level"]:
    assert retired not in brain, f"brainstorming references nonexistent field {retired}"
require(brain, ["technique_name", "description"], "brainstorming schema")

export = read("bmild-brainstorming/resources/step-04-organise.md")
require(export, ["self-contained markdown record in chat", "explicitly names or authorizes a destination"], "brainstorm export")

roundtable = read("bmild-roundtable/resources/step-01-open.md")
require(roundtable, ["Any standard persona may convene", "Prototype and Bug Fix", "Rahat"], "roundtable convener contract")

print("artifact-lifecycle-contract: PASS")
PY
