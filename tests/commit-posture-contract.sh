#!/usr/bin/env bash
# Co-owned structural and local-Git contract for commit posture.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODES=(spec-dev spec-fix direct-dev direct-fix)
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

extract_block() {
    local file=$1 marker=$2
    sed -n "/<!-- ${marker}:start -->/,/<!-- ${marker}:end -->/p" "$file"
}

reference_preflight=""
reference_completion=""
for mode in "${MODES[@]}"; do
    file="${ROOT}/.agents/skills/bmild-dev/resources/${mode}.md"
    [ -f "$file" ] || { fail "missing $file"; continue; }
    for marker in commit-posture-preflight commit-posture-completion; do
        count=$(rg -c -F "<!-- ${marker}:start -->" "$file" || true)
        [ "$count" -eq 1 ] || fail "$file: expected one ${marker} block, found $count"
    done

    preflight=$(extract_block "$file" commit-posture-preflight)
    completion=$(extract_block "$file" commit-posture-completion)
    if [ -z "$reference_preflight" ]; then
        reference_preflight=$preflight
        reference_completion=$completion
    else
        [ "$preflight" = "$reference_preflight" ] || fail "$file: preflight block drift"
        [ "$completion" = "$reference_completion" ] || fail "$file: completion block drift"
    fi

    preflight_line=$(rg -n -F '<!-- commit-posture-preflight:start -->' "$file" | cut -d: -f1)
    tasks_line=$(rg -n -F 'Progress:' "$file" | head -n1 | cut -d: -f1)
    eligibility_line=$(rg -n -F 'Establish mode eligibility:' "$file" | cut -d: -f1)
    completion_line=$(rg -n -F '<!-- commit-posture-completion:start -->' "$file" | cut -d: -f1)
    close_line=$(rg -n 'Step [0-9]+: Close' "$file" | tail -n1 | cut -d: -f1)
    [ "$preflight_line" -lt "$tasks_line" ] || fail "$file: preflight is not before implementation tasks"
    [ "$eligibility_line" -lt "$completion_line" ] || fail "$file: eligibility is not before completion"
    [ "$completion_line" -lt "$close_line" ] || fail "$file: completion is not before Close"
    ! rg -q 'resources/commit-posture\.md' "$file" || fail "$file: shared runtime indirection found"
done

rg -q -F '`ready-for-review`' "${ROOT}/.agents/skills/bmild-dev/resources/spec-dev.md" || fail "Spec-Dev eligibility missing"
rg -q -F 'completed documented fix' "${ROOT}/.agents/skills/bmild-dev/resources/spec-fix.md" || fail "Spec-Fix eligibility missing"
rg -q -F 'completed bounded work' "${ROOT}/.agents/skills/bmild-dev/resources/direct-dev.md" || fail "Direct-Dev eligibility missing"
rg -q -F 'confirmed root cause' "${ROOT}/.agents/skills/bmild-dev/resources/direct-fix.md" || fail "Direct-Fix eligibility missing"

for file in .agents/skills/bmild-dev/SKILL.md README.md AGENTS.md; do
    for token in 'commit = 0' 'commit = 1' 'commit = 2' 'conventional-commits' 'branch'; do
        rg -q -F "$token" "${ROOT}/${file}" || fail "$file: missing aligned token '$token'"
    done
done
rg -q '^commit = 0 .*0: off; 1: message .* local commit; 2: message only' "${ROOT}/.bmild.toml.example" || fail ".bmild.toml.example: posture values/default drift"
rg -q '^# format = "conventional-commits"' "${ROOT}/.bmild.toml.example" || fail ".bmild.toml.example: format drift"
rg -q '^branch = "current" .*current \| initiative' "${ROOT}/.bmild.toml.example" || fail ".bmild.toml.example: branch drift"

new_repo() {
    local dir=$1
    git init -q -b main "$dir"
    git -C "$dir" config user.email fixture@example.test
    git -C "$dir" config user.name Fixture
    printf 'base\n' >"$dir/base.txt"
    git -C "$dir" add base.txt
    git -C "$dir" commit -q -m 'chore: initial fixture'
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Targeted commit: exact path set and parent transition; unrelated states survive.
repo="$TMP/targeted"
new_repo "$repo"
printf 'tracked\n' >"$repo/task.txt"
git -C "$repo" add task.txt
git -C "$repo" commit -q -m 'chore: add task'
printf 'user staged\n' >"$repo/unrelated-staged.txt"
git -C "$repo" add unrelated-staged.txt
printf 'user unstaged\n' >"$repo/unrelated-unstaged.txt"
printf 'changed\n' >>"$repo/task.txt"
pre=$(git -C "$repo" rev-parse HEAD)
msg=$'feat: preserve literal transport\n\nQuotes "x", backticks `x`, dollars $HOME, Unicode café.\n\nTests: fixture\n'
printf '%s' "$msg" | git -C "$repo" commit -q --only --file=- -- task.txt
post=$(git -C "$repo" rev-parse HEAD)
[ "$post" != "$pre" ] || fail "targeted fixture: HEAD did not move"
[ "$(git -C "$repo" rev-parse HEAD^)" = "$pre" ] || fail "targeted fixture: parent mismatch"
[ "$(git -C "$repo" diff-tree --no-commit-id --name-only -r HEAD)" = task.txt ] || fail "targeted fixture: path set mismatch"
git -C "$repo" diff --cached --quiet -- unrelated-staged.txt && fail "targeted fixture: staged work lost"
[ -f "$repo/unrelated-unstaged.txt" ] || fail "targeted fixture: unstaged work lost"
[ "$(git -C "$repo" log -1 --format=%B)" = "${msg%$'\n'}" ] || fail "targeted fixture: message transport changed"

# New file via intent-to-add is committed without consuming unrelated index state.
printf 'new\n' >"$repo/new-task.txt"
git -C "$repo" add --intent-to-add -- new-task.txt
printf 'feat: add task file\n\nTests: fixture\n' | git -C "$repo" commit -q --only --file=- -- new-task.txt
git -C "$repo" cat-file -e HEAD:new-task.txt || fail "intent-to-add fixture: file absent"
git -C "$repo" diff --cached --quiet -- unrelated-staged.txt && fail "intent-to-add fixture: unrelated index lost"

# Hook failure preserves content and unrelated index; only created intent entry is restored.
printf '#!/bin/sh\nexit 1\n' >"$repo/.git/hooks/pre-commit"
chmod +x "$repo/.git/hooks/pre-commit"
printf 'blocked\n' >"$repo/hook-task.txt"
git -C "$repo" add --intent-to-add -- hook-task.txt
if printf 'test: hook failure\n' | git -C "$repo" commit -q --only --file=- -- hook-task.txt; then
    fail "hook fixture: commit unexpectedly succeeded"
fi
git -C "$repo" restore --staged --source=HEAD -- hook-task.txt
[ -f "$repo/hook-task.txt" ] || fail "hook fixture: content lost"
git -C "$repo" diff --cached --quiet -- unrelated-staged.txt && fail "hook fixture: unrelated index lost"

# Branch fixtures: dirty switch blocked by contract, clean local switch/create remain local.
repo="$TMP/branches"
new_repo "$repo"
printf 'dirty\n' >"$repo/dirty.txt"
[ -n "$(git -C "$repo" status --porcelain=v1 --untracked-files=all)" ] || fail "branch fixture: dirty state missing"
before=$(git -C "$repo" symbolic-ref --short HEAD)
[ "$before" = main ] || fail "branch fixture: unexpected initial branch"
rm "$repo/dirty.txt"
git -C "$repo" switch -q -c commit-posture
[ "$(git -C "$repo" symbolic-ref --short HEAD)" = commit-posture ] || fail "branch fixture: create failed"
git -C "$repo" switch -q main
git -C "$repo" switch -q -- commit-posture
[ "$(git -C "$repo" symbolic-ref --short HEAD)" = commit-posture ] || fail "branch fixture: local switch failed"
git -C "$repo" switch -q --detach
git -C "$repo" symbolic-ref --quiet --short HEAD >/dev/null 2>&1 && fail "branch fixture: detached HEAD not detected"

if [ "$failures" -gt 0 ]; then
    echo "commit-posture-contract: $failures failure(s)" >&2
    exit 1
fi

echo "commit-posture-contract: PASS"
