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
        "../bmild-planner/resources/readiness-verification.md",
        "qa_status: review_requested",
        "full `bmild-qa` Comprehensive Review",
        "does not substitute for full outcome acceptance",
    ],
    "Spec-Dev",
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

# Obligation inventory: each atomic acceptance rule in the shared block. Restructuring the block for
# readability must keep every rule; a rewrite that drops or rewords one fails here first.
require(
    reference,
    [
        # Scope
        "Resolve the authorized phase/outcome from the request, live source contracts, and `verification-matrix.md`",
        "read those sources independently from disk",
        "A named Slice or explicit PR/diff/branch/commit/file set is also a valid target",
        "include staged, unstaged, and untracked work",
        "not because multiple old Slices exist",
        "create its outcome record from Sonia's template using settled scope",
        "no planner invocation is required",
        "do not invent an initiative or spec",
        # Independence
        "did not implement the reviewed production changes",
        "did not inherit the development transcript",
        "renaming a persona or forking full history does not",
        "the implementer's summary only helps navigation",
        "leave acceptance pending, and prepare a fresh-window transition",
        "A reviewer-authored production fix needs a different independent reviewer",
        # Evidence identity
        "Record code/change identity, source-contract identity, and relevant environment",
        "Changes make affected proof pending; preserve unaffected current evidence and historical results",
        "A final pass checks current state still matches reviewed state",
        "Do not clear findings or publish accepted status from stale evidence",
        # Status authority
        "Rahat alone writes `qa_status: verified | failed | blocked`",
        "`security_status: findings_open | cleared`",
        "`code_review_status: findings_open | cleared`",
        "Explicit not-applicable dispositions require a scope-specific rationale",
        "`not_reviewed`, missing fields, unrun required proof, and an omitted axis are never terminal",
        "Targeted review cannot stand in for other required axes",
        # Done gate
        "`status: done` only with established independence, current evidence for every required source obligation and review axis, no unresolved required finding, and verified phase scope",
        "Otherwise preserve `ready_for_review` or the actual blocked state",
        "Reconcile closure in this pass; do not hand back to Rahat merely for closure",
        # Matrix archival
        "The matrix remains live while any outcome needs it",
        "only if every outcome is `done` and no open handoff, RCA, security-review, or continuation obligation depends on it; otherwise keep it live and record the reason",
        "Never archive unrelated outcomes",
        # Slice scope
        "scoped evidence under its parent `O-###`",
        "do not create an outcome per Slice or set parent verdicts from partial acceptance",
        "Only Rahat sets Slice `status: done` when its own boundary and all applicable axes have current independent evidence and no required finding remains",
        "Mirror only that accepted scope into `slices.md`",
        "move `slice-<N>.md` to registry `## Archived` only after its own status is done",
        "Keep the parent active while implementation remains",
        "include whole-outcome source coverage and integrated verification in that review",
        "Every Slice passing alone cannot accept the outcome; omitted requirements, stale dependency proof, and integration gaps remain open in the parent matrix",
        "reopen historical completed Slices merely to normalize fields",
    ],
    "outcome-assurance obligation inventory",
)

agents = (root / "AGENTS.md").read_text()
require(agents, ["immutable, initiative-local `O-###`", "Outcome Index", "Rahat archives the matrix", "mechanical projections of authoritative state"], "repository contract")

print("outcome-lifecycle-contract: PASS")
PY
