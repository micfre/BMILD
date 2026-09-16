#!/usr/bin/env bash
# Guards stable outcome identity, writer precedence, review state, and archival ownership.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$ROOT" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
skills = root / ".agents/skills"

def read(relative):
    return (skills / relative).read_text()

def require(body, terms, label):
    for term in terms:
        assert term in body, f"{label}: missing contract: {term}"

template = read("bmild-planner/assets/verification-matrix-template.md")
require(
    template,
    [
        "## Outcome Index",
        "## O-001",
        "next unused initiative-local `O-###`",
        "never reuse an ID",
        "ID remains immutable",
        "Rahat owns review verdicts, `done`, and the final archival decision",
        "no open handoff, RCA, security-review, or continuation obligation",
    ],
    "verification matrix template",
)

for relative in [
    "bmild-planner/resources/readiness-verification.md",
    "bmild-dev/resources/spec-dev.md",
    "bmild-qa/resources/nyquist.md",
]:
    body = read(relative)
    require(body, ["O-###", "next unused", "Outcome Index"], relative)

spec_dev = read("bmild-dev/resources/spec-dev.md")
require(
    spec_dev,
    [
        ".agents/skills/bmild-planner/resources/readiness-verification.md",
        "qa_status: review_requested",
        "full `bmild-qa` Comprehensive Review",
        "does not substitute for full outcome acceptance",
    ],
    "outcome development",
)

nyquist = read("bmild-qa/resources/nyquist.md")
require(nyquist, ["regardless of whether Sonia created them or Alex created them"], "matrix repair precedence")

assert "ready_for_verification" not in "\n".join(
    path.read_text() for path in skills.rglob("*") if path.is_file()
), "retired QA request state remains in skill sources"

reference = None
for mode in ["comprehensive-review", "verification", "security-review", "code-review", "qa-handback"]:
    body = read(f"bmild-qa/resources/{mode}.md")
    blocks = re.findall(r"<!-- outcome-assurance:start -->.*?<!-- outcome-assurance:end -->", body, re.S)
    assert len(blocks) == 1, mode
    reference = blocks[0] if reference is None else reference
    assert blocks[0] == reference, f"outcome assurance drift: {mode}"
require(
    reference,
    [
        "final outstanding outcome",
        "Rahat moves `verification-matrix.md`",
        "every outcome is `done`",
        "continuation obligation",
        "registry entry (`Status: complete`, `Last updated`) as a mechanical scribe update",
    ],
    "embedded archival gate",
)

for relative in [
    "bmild-planner/resources/readiness-verification.md",
    "bmild-dev/resources/spec-dev.md",
]:
    require(read(relative), ["registry entry (`Phase`, `Status: active`, `Last updated`) as a mechanical scribe update"], relative)
require(read("bmild-qa/resources/qa-handback.md"), ["registry entry (`Status: complete`, `Last updated`) as a mechanical scribe update"], "QA handback archival sync")

security_template = read("bmild-qa/assets/security-review-template.md")
security_mode = read("bmild-qa/resources/security-review.md")
for label, body in {"security template": security_template, "security mode": security_mode}.items():
    require(body, ["resolved", "security_status: cleared", "finding history"], label)

agents = (root / "AGENTS.md").read_text()
require(agents, ["immutable, initiative-local `O-###`", "Outcome Index", "Rahat archives the matrix", "mechanical projections of authoritative state"], "repository contract")

print("outcome-lifecycle-contract: PASS")
PY
