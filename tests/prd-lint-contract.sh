#!/usr/bin/env bash
# prd-v1 lint contract: seeded-defect detection per rule class, zero false
# positives on excluded lookalikes, exact result schema, determinism, byte
# fixtures, and the structured error vocabulary. Every handled invocation
# exits 0.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LINT="$REPO_ROOT/.agents/skills/bmild-pm/scripts/lint-prd.sh"
FIX="$REPO_ROOT/tests/fixtures/prd-lint"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

hash_of() { # portable SHA-256 (macOS ships shasum, not sha256sum)
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | cut -d' ' -f1
    else
        shasum -a 256 "$1" | cut -d' ' -f1
    fi
}

# JSON validation and field extraction via python (development/test tooling
# only; runtime stays native).
run_lint() { # $1 artifact path within root; prints JSON
    sh "$LINT" --root "$REPO_ROOT" --artifact "$1"
}

check_json() { # $1 file with one JSON object; asserts schema closure
    python3 - "$1" <<'PY' || { fail "$1: schema violation"; return 1; }
import json, sys
raw = open(sys.argv[1], encoding='utf-8').read()
d = json.loads(raw)  # single complete object, no trailing content
assert raw.count('\n') <= 1 and raw.strip().endswith('}'), "one compact object on stdout"
assert d["schema_version"] == "bmild-artifact-lint/v1"
assert d["ruleset"] == "prd-v1"
assert set(d.keys()) == {"schema_version", "ruleset", "artifact", "status", "blocking",
                         "total_findings", "by_severity", "findings"} or \
       set(d.keys()) == {"schema_version", "ruleset", "artifact", "status", "blocking",
                         "total_findings", "by_severity", "findings", "error"}, d.keys()
assert set(d["artifact"].keys()) == {"path", "sha256"}
assert d["status"] in ("clean", "findings", "error")
assert isinstance(d["blocking"], bool)
assert d["total_findings"] == len(d["findings"])
bs = d["by_severity"]
assert set(bs.keys()) == {"high", "medium", "low"}
assert bs["high"] + bs["medium"] + bs["low"] == d["total_findings"]
assert (d["blocking"] is True) == (d["status"] == "error" or bs["high"] + bs["medium"] > 0)
sev_rank = {"high": 0, "medium": 1, "low": 2}
prev = None
for f in d["findings"]:
    assert set(f.keys()) == {"rule_id", "category", "severity", "detail", "location"}
    assert set(f["location"].keys()) == {"path", "line"}
    assert isinstance(f["location"]["line"], int) and f["location"]["line"] >= 1
    assert f["rule_id"] in ("PRD001", "PRD002", "PRD003", "PRD004", "PRD005", "PRD006")
    assert f["severity"] in ("high", "medium", "low")
    key = (f["location"]["line"], f["rule_id"])
    if prev is not None:
        assert key >= prev, "findings must be ordered by line then rule_id"
    prev = key
cat = {"PRD001": "placeholder", "PRD002": "frontmatter", "PRD003": "id_continuity",
       "PRD004": "phase_traceability", "PRD005": "assumption_structure",
       "PRD006": "documentation_scope"}
for f in d["findings"]:
    assert f["category"] == cat[f["rule_id"]], f
if d["status"] == "error":
    assert set(d["error"].keys()) == {"code", "detail"}
    assert d["error"]["code"] in ("not_found", "unreadable", "non_utf8",
                                  "unsupported_invocation", "internal_error")
    assert d["error"]["detail"] != ""
    assert d["total_findings"] == 0 and d["findings"] == []
    assert d["blocking"] is True
else:
    assert "error" not in d
if d["status"] == "clean":
    assert d["blocking"] is False and d["total_findings"] == 0
PY
}

assert_status() { # $1 json file, $2 expected status, $3 expected blocking
    python3 - "$1" "$2" "$3" <<'PY' || fail "$1: expected status=$2 blocking=$3"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert d["status"] == sys.argv[2], d["status"]
assert str(d["blocking"]).lower() == sys.argv[3].lower(), d["blocking"]
PY
}

expect_finding() { # $1 json file, $2 rule, $3 severity, $4 line
    python3 - "$1" "$2" "$3" "$4" <<'PY' || fail "$1: expected $2/$3 at line $4"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
want = (sys.argv[2], sys.argv[3], int(sys.argv[4]))
for f in d["findings"]:
    if (f["rule_id"], f["severity"], f["location"]["line"]) == want:
        sys.exit(0)
sys.exit(1)
PY
}

expect_absent() { # $1 json file, $2 rule
    python3 - "$1" "$2" <<'PY' || fail "$1: unexpected $2 finding"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert not any(f["rule_id"] == sys.argv[2] for f in d["findings"])
PY
}

fx() { echo "tests/fixtures/prd-lint/$1"; }

# --- clean fixture: zero findings ------------------------------------------------

run_lint "$(fx clean.md)" >"$OUT/clean.json"
check_json "$OUT/clean.json"
assert_status "$OUT/clean.json" clean false

# negative lookalikes: markers only inside code fences, inline code, comments
run_lint "$(fx prd001-negatives.md)" >"$OUT/neg.json"
check_json "$OUT/neg.json"
assert_status "$OUT/neg.json" clean false

# --- seeded defects: one per rule class ---------------------------------------------

run_lint "$(fx prd001.md)" >"$OUT/p1.json"
check_json "$OUT/p1.json"
assert_status "$OUT/p1.json" findings true
tbd_line=$(grep -n 'The remaining plan is TBD overall' "$FIX/prd001.md" | cut -d: -f1)
actor_line=$(grep -nF '[Actor] can rely' "$FIX/prd001.md" | cut -d: -f1)
expect_finding "$OUT/p1.json" PRD001 high "$tbd_line"
expect_finding "$OUT/p1.json" PRD001 high "$actor_line"

run_lint "$(fx prd002.md)" >"$OUT/p2.json"
check_json "$OUT/p2.json"
assert_status "$OUT/p2.json" findings true
ts_line=$(grep -n 'timestamp: 2026-02-30' "$FIX/prd002.md" | cut -d: -f1)
expect_finding "$OUT/p2.json" PRD002 high "$ts_line"
expect_finding "$OUT/p2.json" PRD002 high 1   # missing required keys anchor at line 1

run_lint "$(fx prd003-duplicate.md)" >"$OUT/p3a.json"
check_json "$OUT/p3a.json"
assert_status "$OUT/p3a.json" findings true
dup_line=$(grep -n 'A duplicate journey appears' "$FIX/prd003-duplicate.md" | cut -d: -f1)
expect_finding "$OUT/p3a.json" PRD003 high "$dup_line"

run_lint "$(fx prd003-gap.md)" >"$OUT/p3b.json"
check_json "$OUT/p3b.json"
assert_status "$OUT/p3b.json" findings true
gap_line=$(grep -n '^- FR3:' "$FIX/prd003-gap.md" | cut -d: -f1)
expect_finding "$OUT/p3b.json" PRD003 medium "$gap_line"

run_lint "$(fx prd004-unresolved.md)" >"$OUT/p4a.json"
check_json "$OUT/p4a.json"
assert_status "$OUT/p4a.json" findings true
inc_line=$(grep -n 'Includes: FR1-FR9, J1' "$FIX/prd004-unresolved.md" | cut -d: -f1)
expect_finding "$OUT/p4a.json" PRD004 high "$inc_line"

run_lint "$(fx prd004-repeated.md)" >"$OUT/p4b.json"
check_json "$OUT/p4b.json"
assert_status "$OUT/p4b.json" findings true
rep_line=$(grep -n 'Includes: FR1$' "$FIX/prd004-repeated.md" | cut -d: -f1)
expect_finding "$OUT/p4b.json" PRD004 medium "$rep_line"

run_lint "$(fx prd005.md)" >"$OUT/p5.json"
check_json "$OUT/p5.json"
assert_status "$OUT/p5.json" findings true
as_line=$(grep -n 'The fixture structure is stable' "$FIX/prd005.md" | cut -d: -f1)
expect_finding "$OUT/p5.json" PRD005 medium "$as_line"

run_lint "$(fx prd006.md)" >"$OUT/p6.json"
check_json "$OUT/p6.json"
assert_status "$OUT/p6.json" findings true
op_line=$(grep -nF 'Operator docs: maybe' "$FIX/prd006.md" | cut -d: -f1)
doc_heading=$(grep -n '^## Documentation Scope' "$FIX/prd006.md" | cut -d: -f1)
expect_finding "$OUT/p6.json" PRD006 medium "$op_line"
expect_finding "$OUT/p6.json" PRD006 medium "$doc_heading"   # missing audience anchors at the heading

# --- adversarial content: JSON escaping of user-controlled detail and path ----------

run_lint "$(fx adversarial.md)" >"$OUT/adv.json"
check_json "$OUT/adv.json"
expect_finding "$OUT/adv.json" PRD004 high "$(( $(grep -n 'Includes: FR1-FR2, J1,' "$FIX/adversarial.md" | cut -d: -f1) ))"
python3 - "$OUT/adv.json" <<'PY' || fail "adversarial detail must round-trip through JSON"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert any('quote' in f["detail"] and 'ü' in f["detail"] for f in d["findings"])
PY
python3 - "$OUT/adv.json" <<'PY' || fail "control bytes 0x18-0x1F in details must be \\u-escaped, not raw"
import json, sys
raw = open(sys.argv[1], encoding='utf-8').read()
assert '\\u0018' in raw and '\\u001b' in raw, "raw JSON must carry the \\u0018/\\u001b escapes"
d = json.loads(raw)
assert any(chr(0x18) in f["detail"] and chr(0x1b) in f["detail"] for f in d["findings"])
PY

# unicode/space-bearing artifact path must round-trip as data
mkdir -p "$OUT/ünïcode dir"
# shellcheck disable=SC1111
cp "$FIX/clean.md" "$OUT/ünïcode dir/„prd“.md"
sh "$LINT" --root "$OUT" --artifact 'ünïcode dir/„prd“.md' >"$OUT/uni.json"
check_json "$OUT/uni.json"
assert_status "$OUT/uni.json" clean false

# --- determinism (NFR): identical bytes, path, and ordered result ---------------------

run_lint "$(fx prd001.md)" >"$OUT/det1.json"
run_lint "$(fx prd001.md)" >"$OUT/det2.json"
cmp -s "$OUT/det1.json" "$OUT/det2.json" || fail "repeated lint of unchanged PRD must be byte-identical"
sha_a=$(python3 -c "import json;print(json.load(open('$OUT/det1.json'))['artifact']['sha256'])")
sha_b=$(hash_of "$FIX/prd001.md")
[[ "$sha_a" == "$sha_b" ]] || fail "reported sha256 must be the candidate's actual byte identity"

# --- byte fixtures: BOM, CRLF, NUL, non-UTF-8 -------------------------------------------

python3 - "$FIX/clean.md" "$OUT" <<'PY'
import pathlib, sys
base = pathlib.Path(sys.argv[1]).read_bytes()
out = pathlib.Path(sys.argv[2])
(out / "bom.md").write_bytes(b"\xef\xbb\xbf" + base)
(out / "crlf.md").write_bytes(base.replace(b"\n", b"\r\n"))
nul = base.replace(b"stable.\n", b"stable.\n\x00\n")
assert b"\x00" in nul
(out / "nul.md").write_bytes(nul)
(out / "nonutf8.md").write_bytes(b"\xff\xfe not utf8 \x80\x81")
PY

sh "$LINT" --root "$OUT" --artifact bom.md >"$OUT/bom.json"
check_json "$OUT/bom.json"
assert_status "$OUT/bom.json" findings true
expect_finding "$OUT/bom.json" PRD002 high 1   # BOM is not stripped: first line is not exact ---

sh "$LINT" --root "$OUT" --artifact crlf.md >"$OUT/crlf.json"
check_json "$OUT/crlf.json"
assert_status "$OUT/crlf.json" findings true
expect_finding "$OUT/crlf.json" PRD002 high 1   # '---\r' is not an exact '---' line
expect_absent "$OUT/crlf.json" PRD001

sh "$LINT" --root "$OUT" --artifact nul.md >"$OUT/nul.json"
check_json "$OUT/nul.json"
# valid UTF-8 containing NUL is supported input, never non_utf8
assert_status "$OUT/nul.json" clean false

sh "$LINT" --root "$OUT" --artifact nonutf8.md >"$OUT/nonutf8.json"
check_json "$OUT/nonutf8.json"
assert_status "$OUT/nonutf8.json" error true
python3 - "$OUT/nonutf8.json" <<'PY' || fail "non-UTF-8 must be a structured non_utf8 error"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert d["error"]["code"] == "non_utf8", d["error"]
assert d["artifact"]["sha256"], "bytes were read: identity must be present"
PY

# --- error vocabulary and path normalization ---------------------------------------------

sh "$LINT" --root "$REPO_ROOT" --artifact tests/fixtures/prd-lint/nope.md >"$OUT/nf.json"
check_json "$OUT/nf.json"
assert_status "$OUT/nf.json" error true
python3 - "$OUT/nf.json" <<'PY' || fail "missing artifact must be not_found with null sha"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert d["error"]["code"] == "not_found" and d["artifact"]["sha256"] is None
PY

# traversal and absolute paths are rejected lexically
for bad in "../secret.md" "a/../../escape.md" "/etc/passwd" "./"; do
    sh "$LINT" --root "$REPO_ROOT" --artifact "$bad" >"$OUT/trav.json" 2>/dev/null
    check_json "$OUT/trav.json"
    python3 - "$OUT/trav.json" <<'PY' || fail "path '$bad' must be rejected as unsupported_invocation"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert d["status"] == "error" and d["error"]["code"] == "unsupported_invocation", d
PY
done

# leading ./ is normalized away
sh "$LINT" --root "$REPO_ROOT" --artifact "./$(fx clean.md)" >"$OUT/dot.json"
check_json "$OUT/dot.json"
assert_status "$OUT/dot.json" clean false
python3 - "$OUT/dot.json" <<'PY' || fail "leading ./ must be stripped from the reported path"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert not d["artifact"]["path"].startswith("./")
PY

# malformed invocation still returns the structured object with exit 0
set +e
sh "$LINT" --root "$REPO_ROOT" >"$OUT/noargs.json" 2>/dev/null
rc=$?
set -e
[[ "$rc" -eq 0 ]] || fail "handled invocation must exit 0 (got $rc)"
check_json "$OUT/noargs.json"
python3 - "$OUT/noargs.json" <<'PY' || fail "missing arguments must be unsupported_invocation"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert d["error"]["code"] == "unsupported_invocation"
PY

# unreadable regular file
cp "$FIX/clean.md" "$OUT/locked.md"
chmod 000 "$OUT/locked.md"
if [[ "$(id -u)" -ne 0 ]]; then
    sh "$LINT" --root "$OUT" --artifact locked.md >"$OUT/locked.json"
    check_json "$OUT/locked.json"
    python3 - "$OUT/locked.json" <<'PY' || fail "unreadable file must be a structured unreadable error"
import json, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
assert d["error"]["code"] == "unreadable", d["error"]
PY
fi
chmod 644 "$OUT/locked.md"

# --- self-containment: no external runtime, network, or root helpers ----------------------

for f in "$REPO_ROOT/.agents/skills/bmild-pm/scripts/"*; do
    grep -qE 'curl|wget|npm |pip |uv |python|node |gem |apt-get' "$f" && fail "$f references an external dependency"
done

if [ "$failures" -gt 0 ]; then
    echo "prd-lint-contract: $failures failure(s)" >&2
    exit 1
fi
echo "prd-lint-contract: PASS"
