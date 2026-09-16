#!/usr/bin/env bash
# Guards the complete Course-Correction flow and proposal mechanics.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$ROOT" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
skills = root / ".agents/skills"
resource = (skills / "bmild-planner/resources/course-correction.md").read_text()
template = (skills / "bmild-planner/assets/change-proposal-template.md").read_text()

steps = [int(value) for value in re.findall(r"^- \[ \] Step (\d+):", resource, re.M)]
assert steps == list(range(1, 11)), f"Course-Correction steps drifted: {steps}"

for term in [
    "User confirmation is an entry condition",
    "unaffected | mechanical | owner-decision | coupled-change | stale",
    "## Resolution Record",
    "bounded ladder episode for each independent owner consequence",
    "Mark only unresolved artifacts stale",
    "return resolved artifacts to `## Live`",
    "Update authorized outcome scope, readiness, dependencies, and affected proof",
    "resume the work that triggered Course-Correction",
]:
    assert term in resource, f"Course-Correction missing: {term}"

for heading in [
    "## Trigger",
    "## Evidence",
    "## Impact Map",
    "## Bounded Questions (ordered by leverage)",
    "## Roundtable Synthesis Records",
    "## Resolution Record",
    "## Ordered Handoff Chain",
    "## SP Items",
    "## Decision Log Echo",
]:
    assert heading in template, f"change proposal missing {heading}"

for term in [
    "unaffected | mechanical | owner-decision | coupled-change | stale",
    "applied_by_scribe | authored_by_guest | authored_by_consult",
    "Only work that genuinely left the session",
    "Disposition: <pending | applied_by_handback>",
]:
    assert term in template, f"change proposal mechanics missing: {term}"

print("course-correction-contract: PASS")
PY
