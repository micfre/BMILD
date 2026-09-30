#!/usr/bin/env bash
# Source contracts, not a simulator or evidence of model compliance.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$ROOT" <<'PY'
from pathlib import Path
import json
import re
import sys
root = Path(sys.argv[1])
skills = root / '.agents/skills'
def read(path):
    return (skills / path).read_text()
def require(body, terms):
    for term in terms:
        assert term in body, f'Missing development-path contract: {term}'

core = read('bmild-dev/SKILL.md')
require(core, ['Mode 1: Spec-Dev', 'Mode 5: Slice-Dev', 'resources/slice-dev.md',
               'Historical Slice presence alone', 'fix-only request precedence'])
for path in list(skills.rglob('*.md')) + [root / 'README.md', root / 'AGENTS.md']:
    assert 'Outcome Development' not in path.read_text(), path
spec = read('bmild-dev/resources/spec-dev.md')
require(spec, ['independent Comprehensive Review', 'Explicit implementation-only',
               'multiple existing Slices', 'future-phase', 'do not fork the development transcript',
               'Repair authority never expands product scope', 'resume this outcome'])
slice_dev = read('bmild-dev/resources/slice-dev.md')
require(slice_dev, ['sole next eligible Slice', 'several candidates qualify',
                    'With none eligible', 'dependencies independently accepted on current evidence',
                    'Sonia resolves boundary or dependency changes', 'Alex chooses private structure',
                    'do not create an outcome for each Slice', 'Do not set parent readiness from a partial Slice',
                    'series only when the user explicitly authorizes', 'Only Rahat accepts and archives',
                    'include source completeness and integrated verification',
                    'reviewer-authored production repair requires a different independent reviewer',
                    'If isolation is unavailable', 'Spec-Fix or Direct-Fix'])
planning = read('bmild-planner/resources/slice-planning.md')
require(read('bmild-planner/SKILL.md'), ['Mode 6: Slice Planning', 'resources/slice-planning.md'])
require(planning, ['only when explicitly requested', 'settled contracts',
                   'next unused number across live and archived', 'never renumber or reuse',
                   'Do not mint an outcome merely for each Slice', 'dependency cycles',
                   'Preserve completed evidence', 'acceptance boundaries and dependencies',
                   'Planning alone does not authorize implementation or a series'])
require(read('bmild-planner/resources/delivery-strategy.md'), ['Requests to create or revise persistent Slices use Slice Planning'])
for filename, artifact_type in [('slice-template.md', 'Slice'), ('slices-template.md', 'Slice Registry')]:
    body = read('bmild-planner/assets/' + filename)
    frontmatter = body.split('---', 2)[1]
    keys = re.findall(r'^([a-z_]+):', frontmatter, re.M)
    assert keys[:4] == ['type', 'title', 'description', 'timestamp'], (filename, keys)
    require(body, [f'type: {artifact_type}\n', 'O-###', 'verification-matrix.md#', 'Dependencies:', 'Continuation', 'Rahat'])
    assert not re.search(r'^#{1,6}.*(?:[Bb]udget|[Ff]orecast|[Ff]ile inventory|[Ee]stimate|[Pp]redicted)', body), filename
require(read('bmild-planner/assets/slice-template.md'), ['Sources:', 'Acceptance boundary', 'Implementation guidance'])
require(read('bmild-planner/assets/verification-matrix-template.md'), ['### Slice evidence', 'partial acceptance', 'Integrated outcome verification', 'Do not create an outcome merely for each Slice'])
for mode in ['comprehensive-review', 'verification', 'security-review', 'code-review', 'qa-handback']:
    body = read(f'bmild-qa/resources/{mode}.md')
    require(body, ['Only Rahat sets Slice', 'do not create an outcome per Slice',
                   'Every Slice passing alone cannot accept the outcome', 'stale dependency proof',
                   'whole-outcome source coverage and integrated verification',
                   'Targeted review cannot stand in for other required axes'])
require(read('bmild-qa/resources/nyquist.md'), ['# Nyquist Design', 'upfront proof', 'not completed-work acceptance'])
direct = read('bmild-dev/resources/direct-dev.md')
require(direct, ['Groundtruth once', 'Load BMILD memory only when', 'explicitly requested',
                 'default to completed implementation with local proof', 'same scope and explicit completion boundary',
                 'If isolation is unavailable', 'reviewer-authored repair requires a different reviewer'])
assert '**Work classification**' not in direct
assert 'Classify work' not in direct
for persona in ['bmild-dev', 'bmild-qa']:
    require(read(f'{persona}/resources/spec-fix.md'), ['A governing source is sufficient entry'])
    for mode in ['spec-fix', 'direct-fix']:
        body = read(f'{persona}/resources/{mode}.md')
        require(body, ['Explicit fix-only requests', 'repair authority never expands product scope'])
        if persona == 'bmild-dev':
            require(body, ['suspended Spec-Dev, Slice-Dev, or Direct-Dev', 'resume development'])
        else:
            # Rahat never resumes a suspended Alex development target; Alex reaches Rahat only via consult or handoff.
            assert 'suspended Spec-Dev' not in body, f'{persona}/{mode}: Rahat must not carry Alex continuation'
    require(read(f'{persona}/resources/direct-fix.md'), ['governing contract or tracked defect context is found', 'retaining confirmed diagnosis'])
# Cases are bounded, machine-readable trial inputs; don't count them as executed trials.
cases = json.loads((root / 'tests/evaluations/outcome-execution-cases.json').read_text())
ids = [case['id'] for case in cases['cases']]
assert len(ids) == len(set(ids))
for case in cases['cases']:
    assert all(case.get(key) for key in ['id', 'request', 'setup', 'checks']), case
for case_id in ['implementation_only', 'slice_planning', 'slice_dependency', 'slice_ambiguous',
                'slice_private_refactor', 'slice_boundary_revision', 'slice_partial_acceptance',
                'slice_stale_dependency', 'slice_final_integration', 'direct_discovers_spec',
                'fix_discovers_context', 'repair_and_resume', 'direct_independent_review']:
    assert case_id in ids, case_id
print('development-paths-contract: PASS (source contracts and trial input integrity; not model behavior)')
PY
