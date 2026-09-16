#!/usr/bin/env bash
# Structural safeguards for Option C. These checks protect source contracts;
# they do not claim to measure model compliance or end-to-end performance.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$ROOT" <<'PY'
from pathlib import Path
import re, sys
root = Path(sys.argv[1])
skills = root / '.agents/skills'

def text(rel):
    return (skills / rel).read_text()

def require(body, terms):
    for term in terms:
        assert term in body, f'Missing contract: {term}'

# Entry and evidence schema are phase/outcome based without a Slice prerequisite.
require(text('bmild-dev/SKILL.md'), ['Mode 1: Outcome Development', '*(primary)*', 'several old Slices', 'authorized phase'])
require(text('bmild-dev/resources/spec-dev.md'), ['MVP/Growth/Vision', 'A Slice, separate planner invocation', 'not an entry requirement', 'future-phase', 'fresh isolated context', 'do not fork the development transcript', 'Preserve other outcomes'])
require(text('bmild-planner/assets/verification-matrix-template.md'), ['## Outcome Index', '## O-001', '- Phase:', '- Authorization:', '- Reviewed state:', '- Review independence:', 'Implementation: pending', 'Verification: pending', 'Multiple outcomes remain independent', '- Status: active | blocked | ready_for_review | done'])

# Machine-matched status tokens use underscores; hyphenated status forms are retired.
for line in text('bmild-planner/assets/verification-matrix-template.md').splitlines():
    if re.match(r'^\s*- .*?(?:[Ss]tatus|Readiness|Repair):', line):
        assert not re.search(r'[a-z]+-[a-z]+', line.split(':', 1)[1]), f'Hyphenated status token: {line}'
require(text('bmild-planner/assets/change-proposal-template.md'), ['status: open | in_progress | applied | abandoned'])
for path in list(skills.rglob('*')) + [root / 'AGENTS.md']:
    if path.is_file() and 'ready-for-review' in path.read_text():
        raise AssertionError(f'Retired hyphenated status token: {path}')

# Safety-critical acceptance executes at point of use in every review mode.
reference = None
for mode in ['comprehensive-review', 'verification', 'security-review', 'code-review', 'qa-handback']:
    body = text(f'bmild-qa/resources/{mode}.md')
    blocks = re.findall(r'<!-- outcome-assurance:start -->.*?<!-- outcome-assurance:end -->', body, re.S)
    assert len(blocks) == 1, mode
    current = blocks[0]
    reference = current if reference is None else reference
    assert current == reference, f'Acceptance contract drift: {mode}'
    assert body.index(current) < body.index('## Tasks'), mode
require(reference, ['fresh reviewer context', 'did not implement', 'did not inherit', 'different independent reviewer', 'no unresolved required finding', 'verified phase scope', 'current evidence', 'never terminal', 'Never archive unrelated outcomes'])
for mode in ['spec-fix', 'direct-fix']:
    body = text(f'bmild-qa/resources/{mode}.md')
    require(body, ['fixed_pending_review', 'different fresh reviewer context', 'Review-only requests do not authorize production edits'])
    assert 'Matrix items → `implemented` or `passed`' not in body
    assert 'No Slice-scope expansion' not in body

# Removing a fallback means removing its runtime surface, not just its entry route.
for rel in ['bmild-planner/scripts/run-budget-slice.sh', 'bmild-planner/scripts/run-budget-slice.ps1', 'bmild-planner/assets/slice-template.md', 'bmild-planner/assets/slices-template.md', 'bmild-planner/resources/phase-scoped-planning.md', 'bmild-planner/resources/full-initiative-planning.md', 'bmild-planner/resources/replanning.md']:
    assert not (skills / rel).exists(), rel
for path in skills.rglob('*'):
    if not path.is_file():
        continue
    body = path.read_text()
    assert 'run-budget-slice' not in body, path
    assert 'peak_live_v2' not in body, path
    # Skill-local literal resource/asset/reference links must resolve. Dynamic
    # examples and cross-skill paths are handled by their owning contracts.
    for rel in re.findall(r'`((?:resources|assets|references)/[^`\s]+\.(?:md|yaml))`', body):
        if any(c in rel for c in '*<>'):
            continue
        owner = skills / path.relative_to(skills).parts[0]
        if owner.name in {'bmild-elicit', 'bmild-roundtable', 'bmild-brainstorming'} and rel == 'references/gap-resolution.md':
            continue  # Explicit reference to the presiding standard persona's copy.
        assert (owner / rel).exists(), f'{path}: broken local resource {rel}'
ci = (root / '.github/workflows/ci.yml').read_text()
assert 'estimator-native:' not in ci and 'estimator-equivalence:' not in ci
for name in ['.bmild.toml', '.bmild.toml.example']:
    path = root / name
    if path.exists():
        assert not re.search(r'^(?:slice_target|tokenizer_base|tokenizer_multiplier)\s*=', path.read_text(), re.M), name
print('outcome-execution-contract: PASS (routing, evidence, embedded independence, retirement, resource links)')
PY
