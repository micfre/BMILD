#!/usr/bin/env bash
# Native-parity and packaging contract: selector and linter run identically
# from isolated copies of the owning skill folders at each first-class harness
# skill-root layout and an arbitrary relocated root, from an unrelated working
# directory, and from an unpacked release-style archive. Where pwsh is
# available, the Windows-native paths are exercised and compared semantically;
# otherwise the PS lane is deferred to the three-OS CI matrix.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_ELICIT="$REPO_ROOT/.agents/skills/bmild-elicit"
FIX="$REPO_ROOT/tests/fixtures/prd-lint"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

# fixture project containing one lintable PRD
mkdir -p "$OUT/project/plans/demo-initiative"
cp "$FIX/clean.md" "$OUT/project/plans/demo-initiative/prd.md"
expected_sha=$(sha256sum "$OUT/project/plans/demo-initiative/prd.md" | cut -d' ' -f1)

make_layout() { # $1 = destination skill-root parent, $2.. skills
    local parent=$1
    shift
    local s
    for s in "$@"; do
        mkdir -p "$parent/skills"
        cp -R "$REPO_ROOT/.agents/skills/$s" "$parent/skills/$s"
    done
}

# --- isolated first-class layouts + arbitrary relocation ------------------------

declare -a LAYOUTS=(
    "$OUT/layout-agents/.agents"
    "$OUT/layout-claude/.claude"
    "$OUT/layout-opencode/.opencode"
    "$OUT/relocated/arbitrary-root"
)
for l in "${LAYOUTS[@]}"; do
    make_layout "$l" bmild-elicit bmild-pm
done

# unrelated working directory: the caller's cwd must not matter
mkdir -p "$OUT/unrelated-cwd"
cd "$OUT/unrelated-cwd"

baseline=""
for l in "${LAYOUTS[@]}"; do
    tag=$(basename "$(dirname "$l")")/$(basename "$l")
    sel="$l/skills/bmild-elicit/scripts/methods.sh"
    lin="$l/skills/bmild-pm/scripts/lint-prd.sh"

    sh "$sel" categories >"$OUT/$tag.categories" || fail "$tag: categories failed"
    sh "$sel" list --category framing >"$OUT/$tag.list" || fail "$tag: list failed"
    sh "$sel" show 24 >"$OUT/$tag.show" || fail "$tag: show failed"
    sh "$sel" random -n 5 --spread --seed 7 >"$OUT/$tag.random" || fail "$tag: random failed"
    sh "$sel" list --all >"$OUT/$tag.all" || fail "$tag: list --all failed"
    sh "$lin" --root "$OUT/project" --artifact plans/demo-initiative/prd.md >"$OUT/$tag.lint" || fail "$tag: lint failed"

    [[ "$(wc -l <"$OUT/$tag.all")" -eq 71 ]] || fail "$tag: list --all row count"
    python3 - "$OUT/$tag.lint" "$expected_sha" <<'PY' || fail "$tag: lint result wrong"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert d["status"] == "clean" and d["artifact"]["sha256"] == sys.argv[2]
assert d["artifact"]["path"] == "plans/demo-initiative/prd.md"
PY

    if [[ -z "$baseline" ]]; then
        baseline=$tag
        continue
    fi
    for artifact in categories list show random all lint; do
        cmp -s "$OUT/$baseline.$artifact" "$OUT/$tag.$artifact" \
            || fail "$tag: $artifact output diverges from $baseline layout"
    done
done

# --- release-style staging and unpack --------------------------------------------

STAGE="$OUT/release-stage"
mkdir -p "$STAGE"
cp -R "$REPO_ROOT/.agents" "$STAGE/.agents"
tar -czf "$OUT/release.tar.gz" -C "$STAGE" .agents
UNPACK="$OUT/unpacked"
mkdir -p "$UNPACK"
tar -xzf "$OUT/release.tar.gz" -C "$UNPACK"

for needed in \
    .agents/skills/bmild-elicit/scripts/methods.sh \
    .agents/skills/bmild-elicit/scripts/serve-methods.awk \
    .agents/skills/bmild-elicit/scripts/methods.ps1 \
    .agents/skills/bmild-elicit/resources/methods.yaml \
    .agents/skills/bmild-pm/scripts/lint-prd.sh \
    .agents/skills/bmild-pm/scripts/lint-prd.awk \
    .agents/skills/bmild-pm/scripts/lint-prd.ps1 \
    .agents/skills/bmild-pm/scripts/prd-v1-placeholders.txt; do
    [[ -f "$UNPACK/$needed" ]] || fail "release archive is missing $needed"
done

sh "$UNPACK/.agents/skills/bmild-elicit/scripts/methods.sh" random -n 5 --spread --seed 7 >"$OUT/unpack.random" || fail "unpacked selector failed"
cmp -s "$OUT/$baseline.random" "$OUT/unpack.random" || fail "unpacked release draw diverges from repository behavior"
sh "$UNPACK/.agents/skills/bmild-pm/scripts/lint-prd.sh" --root "$OUT/project" --artifact plans/demo-initiative/prd.md >"$OUT/unpack.lint" || fail "unpacked linter failed"
cmp -s "$OUT/$baseline.lint" "$OUT/unpack.lint" || fail "unpacked release lint diverges from repository behavior"

# --- non-executable invocation is the supported path --------------------------------

[[ -x "$SRC_ELICIT/scripts/methods.sh" ]] && chmod -x "$SRC_ELICIT/scripts/methods.sh"
sh "$SRC_ELICIT/scripts/methods.sh" categories >/dev/null || fail "selector must not depend on the executable bit"
chmod +x "$SRC_ELICIT/scripts/methods.sh"

# --- PowerShell lane (when pwsh exists; CI covers Windows-native 5.1) ---------------

if command -v pwsh >/dev/null 2>&1; then
    psel="$OUT/layout-agents/.agents/skills/bmild-elicit/scripts/methods.ps1"
    plin="$OUT/layout-agents/.agents/skills/bmild-pm/scripts/lint-prd.ps1"
    pwsh -NoProfile -File "$psel" categories >"$OUT/ps.categories" || fail "pwsh categories failed"
    pwsh -NoProfile -File "$psel" list --category framing >"$OUT/ps.list" || fail "pwsh list failed"
    pwsh -NoProfile -File "$psel" random -n 5 --spread --seed 7 >"$OUT/ps.random" || fail "pwsh random failed"
    for artifact in categories list; do
        cmp -s "$OUT/$baseline.$artifact" "$OUT/ps.$artifact" \
            || fail "pwsh $artifact diverges from the POSIX path (seeded random is expected to differ)"
    done
    pwsh -NoProfile -File "$plin" -root "$OUT/project" -artifact plans/demo-initiative/prd.md >"$OUT/ps.lint" || fail "pwsh lint failed"
    python3 - "$OUT/$baseline.lint" "$OUT/ps.lint" <<'PY' || fail "pwsh lint semantics diverge from the POSIX path"
import json, sys
a = json.load(open(sys.argv[1], encoding='utf-8'))
b = json.load(open(sys.argv[2], encoding='utf-8'))
assert a == b, "semantic lint results must be identical across native paths"
PY
    echo "native-parity-contract: PASS (pwsh lane exercised)"
else
    echo "native-parity-contract: PASS (pwsh unavailable here; PS lane covered by the three-OS CI matrix)"
fi

if [ "$failures" -gt 0 ]; then
    echo "native-parity-contract: $failures failure(s)" >&2
    exit 1
fi
