#!/usr/bin/env bash
# Elicitation method-serving contract: catalog fidelity, bounded serving
# interface, selection spread behavior, and skill self-containment.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$REPO_ROOT/.agents/skills/bmild-elicit"
CATALOG="$SKILL/resources/methods.yaml"
SERVE="$SKILL/scripts/methods.sh"
BMAD_CSV="$REPO_ROOT/external_references/bmad-method/skills/bmad-advanced-elicitation/assets/methods.csv"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT
failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }

serve() { sh "$SERVE" "$@"; }

# --- FR1: canonical catalog fidelity (BMAD-METHOD 6.13 order) -----------------

if [[ -f "$BMAD_CSV" ]]; then
    expected_nums=$(tail -n +2 "$BMAD_CSV" | cut -d, -f1 | paste -sd,)
    expected_names=$(tail -n +2 "$BMAD_CSV" | cut -d, -f3 | paste -sd,)
else
    # CI checkouts may exclude external references; the 71-record order is
    # asserted structurally and by the spot checks below.
    expected_nums=$(seq -s, 1 71)
    expected_names=""
fi

actual_nums=$(awk '/^- num:/{printf "%s%s", sep, $3; sep=","}' "$CATALOG")
[[ "$actual_nums" == "$expected_nums" ]] || fail "catalog numbering diverges from BMAD-METHOD 6.13 order"

if [[ -n "$expected_names" ]]; then
    actual_names=$(awk '/^  method_name:/{sub(/^  method_name: /,""); printf "%s%s", sep, $0; sep=","}' "$CATALOG")
    [[ "$actual_names" == "$expected_names" ]] || fail "catalog method names/order diverge from BMAD-METHOD 6.13"
fi

count=$(grep -c '^- num:' "$CATALOG")
[[ "$count" -eq 71 ]] || fail "catalog holds $count records, expected 71"

dupes=$(awk '/^- num:/{n[$3]++} END{for (k in n) if (n[k]>1) print k}' "$CATALOG")
[[ -z "$dupes" ]] || fail "duplicate method numbers: $dupes"

# five served fields per record; persona_cast optional, nothing else
bad_fields=$(awk '
    /^- num:/ { rec++; saw["num"]=1; next }
    /^  [a-z_]+:/ { k=$1; sub(/:$/,"",k);
        if (k!="category" && k!="method_name" && k!="description" && k!="output_pattern" && k!="persona_cast") print rec": "k }
    /^$/ { delete saw; next }
' "$CATALOG")
[[ -z "$bad_fields" ]] || fail "unexpected catalog fields: $bad_fields"

# --- FR4: category discovery without records -----------------------------------

serve categories >"$OUT/cats.txt"
[[ "$(wc -l <"$OUT/cats.txt")" -eq 12 ]] || fail "expected 12 categories, got $(wc -l <"$OUT/cats.txt")"
grep -q $'^framing\t4$' "$OUT/cats.txt" || fail "framing category count wrong"
grep -q $'^core\t11$' "$OUT/cats.txt" || fail "core category count wrong"
if grep -q $'\t.*[→—]' "$OUT/cats.txt"; then fail "category discovery leaked record content"; fi

# --- FR5: bounded compact index -------------------------------------------------

serve list --category framing >"$OUT/framing.txt"
[[ "$(wc -l <"$OUT/framing.txt")" -eq 4 ]] || fail "framing index must hold 4 rows"
head -1 "$OUT/framing.txt" | grep -q $'^44\tframing\tAbstraction Laddering\t' || fail "framing index first row wrong (BMAD renumbering)"
# gist cap: at most 180 Unicode code points, single line, no output_pattern leakage
python3 - "$OUT/framing.txt" <<'PY' || fail "gist 180-code-point bound violated"
import sys
for i, line in enumerate(open(sys.argv[1], encoding='utf-8'), 1):
    gist = line.rstrip('\n').split('\t')[3]
    assert len(gist) <= 180, (i, len(gist))
PY
grep -q 'output_pattern' "$OUT/framing.txt" && fail "compact rows leaked output_pattern"
serve list --category core --category collaboration >"$OUT/two.txt" || fail "two-category listing failed"
[[ "$(wc -l <"$OUT/two.txt")" -eq 23 ]] || fail "core+collaboration index must hold 23 rows"
python3 - "$OUT/two.txt" <<'PY' || fail "gist 180-code-point bound violated on two-category index"
import sys
for i, line in enumerate(open(sys.argv[1], encoding='utf-8'), 1):
    gist = line.rstrip('\n').split('\t')[3]
    assert len(gist) <= 180, (i, len(gist))
PY
serve list --category core --category collaboration --category risk >"$OUT/three.txt" 2>/dev/null && fail "third category must be rejected" || [[ $? -eq 2 ]] || fail "third category rejection must exit 2"
serve list --category nosuch >/dev/null 2>&1 && fail "unknown category must fail" || [[ $? -eq 2 ]] || fail "unknown category must exit 2"

# --- FR3/FR2: persona-cast identification and served-field exclusion -------------

serve cast >"$OUT/cast.txt"
cast_names=$(awk -F'\t' '{print $3}' "$OUT/cast.txt" | paste -sd,)
[[ "$cast_names" == "Stakeholder Round Table,Expert Panel Review,Cross-Functional War Room,Security Audit Personas" ]] \
    || fail "persona_cast inventory wrong: $cast_names"

serve show "Security Audit Personas" >"$OUT/show-cast.txt"
grep -q '^# persona-cast method: load each participating' "$OUT/show-cast.txt" || fail "persona-cast show must carry the SOUL-loading instruction"
! awk '/^persona_cast:/{found=1} END{exit !found}' "$OUT/show-cast.txt" || fail "persona_cast must stay out of served fields"
grep -c '^description: ' "$OUT/show-cast.txt" | grep -q '^1$' || fail "show record description framing wrong"

# --- FR6: exact retrieval bounds --------------------------------------------------

serve show 24 "First Principles Analysis" >"$OUT/show24.txt"
grep -q '^# 24 | core | First Principles Analysis$' "$OUT/show24.txt" || fail "show by number/name failed"
[[ "$(grep -c '^# [0-9]* | ' "$OUT/show24.txt")" -eq 1 ]] || fail "duplicate-key show must serve one record"
serve show 24 25 26 27 >/dev/null || fail "four-method show must pass"
serve show 24 25 26 27 28 >/dev/null 2>&1 && fail "five-method show must be rejected" || [[ $? -eq 2 ]] || fail "five-method show must exit 2"
serve show "No Such Method" >/dev/null 2>"$OUT/missing.txt" && fail "unknown show must exit 1" || [[ $? -eq 1 ]] || fail "unknown show exit code"
grep -q '^# not found: No Such Method$' "$OUT/missing.txt" || fail "unknown show must be reported, not substituted"
serve show 24 "No Such Method" >"$OUT/mixed.txt" 2>/dev/null
grep -q '^# 24 | core | First Principles Analysis$' "$OUT/mixed.txt" || fail "mixed show must still serve found record"

# --- FR7: random spread, clamping, exclusions, rejection above 12 ------------------

serve random -n 13 >/dev/null 2>&1 && fail "random -n 13 must be rejected" || [[ $? -eq 2 ]] || fail "random -n 13 must exit 2"

for seed in 1 7 42 99; do
    serve random -n 12 --spread --seed "$seed" >"$OUT/spread-$seed.txt"
    rows=$(wc -l <"$OUT/spread-$seed.txt")
    [[ "$rows" -eq 12 ]] || fail "seed $seed: spread draw returned $rows rows"
    nuniq=$(awk -F'\t' '{print $1}' "$OUT/spread-$seed.txt" | sort -u | wc -l)
    [[ "$nuniq" -eq 12 ]] || fail "seed $seed: spread draw repeated a method"
    cats=$(awk -F'\t' '{print $2}' "$OUT/spread-$seed.txt" | sort -u | wc -l)
    [[ "$cats" -eq 12 ]] || fail "seed $seed: spread draw used $cats categories, expected 12 distinct"
    nres=$(awk -F'\t' '{print NF}' "$OUT/spread-$seed.txt" | sort -u | paste -sd,)
    [[ "$nres" == "4" ]] || fail "seed $seed: compact rows must have exactly 4 fields"
done

# clamping: request 12 from a 2-category pool via exclusions is impossible via
# CLI at scale; prove clamping with a synthetic catalog root below.
# exclusion: drawn pool must not contain excluded methods
serve random -n 5 --spread --exclude "Tree of Thoughts" --exclude "Graph of Thoughts" --exclude "Thread of Thought" --seed 3 >"$OUT/excl.txt"
grep -qE '^(1|2|3)\t' "$OUT/excl.txt" && fail "excluded methods leaked into draw"

# determinism of the seeded draw on one host
serve random -n 6 --spread --seed 11 >"$OUT/det-a.txt"
serve random -n 6 --spread --seed 11 >"$OUT/det-b.txt"
cmp -s "$OUT/det-a.txt" "$OUT/det-b.txt" || fail "seeded draw is not repeatable"

# --- FR8: explicit list-all is the only whole-catalog interaction -------------------

serve list --all >"$OUT/all.txt"
[[ "$(wc -l <"$OUT/all.txt")" -eq 71 ]] || fail "list --all must return all 71 compact rows"
# no other interaction returns everything: spot-check the bounded ones above
[[ "$(wc -l <"$OUT/cats.txt")" -eq 12 && "$(wc -l <"$OUT/framing.txt")" -eq 4 ]] || fail "bounded interactions changed shape"

# --- synthetic catalog: clamping, insufficient_diversity, empty pool, fail-closed ---

make_root() { # $1 = yaml content file
    local r
    r="$OUT/root-$1"
    mkdir -p "$r/resources" "$r/scripts"
    cp "$SKILL/scripts/methods.sh" "$SKILL/scripts/serve-methods.awk" "$r/scripts/"
    cp "$2" "$r/resources/methods.yaml"
    echo "$r"
}

printf '%s\n' \
'- num: 1' '  category: core' '  method_name: Solo One' '  description: |' '    Only method in a lonely pool' '  output_pattern: a → b' \
'- num: 2' '  category: core' '  method_name: Solo Two' '  description: |' '    Second lonely method' '  output_pattern: b → c' \
> "$OUT/solo.yaml"
r1=$(make_root solo "$OUT/solo.yaml")
sh "$r1/scripts/methods.sh" random -n 5 --spread >"$OUT/insuf.txt" 2>&1
grep -q '^# insufficient_diversity: pool has 2 methods across 1 categories$' "$OUT/insuf.txt" || fail "single-category pool must signal insufficient_diversity"
[[ "$(grep -c $'^[0-9]' "$OUT/insuf.txt")" -eq 2 ]] || fail "insufficient_diversity must still return the residual rows (clamped)"

printf '%s\n' \
'- num: 1' '  category: core' '  method_name: Only One' '  description: |' '    Single record' '  output_pattern: x → y' \
> "$OUT/one.yaml"
r2=$(make_root one "$OUT/one.yaml")
sh "$r2/scripts/methods.sh" random -n 3 --spread >"$OUT/insuf1.txt" 2>&1
grep -q '^# insufficient_diversity: pool has 1 methods across 1 categories$' "$OUT/insuf1.txt" || fail "single-method pool must signal insufficient_diversity"

sh "$r2/scripts/methods.sh" random -n 3 --exclude "Only One" >/dev/null 2>"$OUT/empty.txt" && fail "empty pool must exit 1" || [[ $? -eq 1 ]] || fail "empty pool must exit 1"
grep -q '^# no methods match$' "$OUT/empty.txt" || fail "empty pool must be reported"

# malformed catalog fails closed
printf '%s\n' '- num: 1' '  category: core' '  method_name: Broken' '  description: |' '    Missing output pattern' > "$OUT/broken.yaml"
r3=$(make_root broken "$OUT/broken.yaml")
sh "$r3/scripts/methods.sh" categories >/dev/null 2>"$OUT/broken-err.txt" && fail "malformed catalog must fail closed" || [[ $? -eq 2 ]] || fail "malformed catalog must exit 2"
grep -q 'missing one of' "$OUT/broken-err.txt" || fail "malformed catalog must name the violation"

# scoped index bound: two synthetic categories that would exceed 24 rows
{
    for i in $(seq 1 13); do
        printf '%s\n' "- num: $i" '  category: bigone' "  method_name: Big One $i" '  description: |' '    filler' '  output_pattern: a → b'
    done
    for i in $(seq 14 26); do
        printf '%s\n' "- num: $i" '  category: bigtwo' "  method_name: Big Two $i" '  description: |' '    filler' '  output_pattern: a → b'
    done
} > "$OUT/big.yaml"
r6=$(make_root big "$OUT/big.yaml")
sh "$r6/scripts/methods.sh" list --category bigone --category bigtwo >/dev/null 2>&1 && fail "26-row scoped index must be rejected" || [[ $? -eq 2 ]] || fail "24-row bound must exit 2"
sh "$r6/scripts/methods.sh" list --category bigone >/dev/null 2>&1 || fail "13-row single-category index must pass"

# duplicate nums fail closed
printf '%s\n' \
'- num: 1' '  category: core' '  method_name: First' '  description: |' '    d' '  output_pattern: p' \
'- num: 1' '  category: core' '  method_name: Second' '  description: |' '    d' '  output_pattern: p' \
> "$OUT/dupe.yaml"
r4=$(make_root dupe "$OUT/dupe.yaml")
sh "$r4/scripts/methods.sh" categories >/dev/null 2>&1 && fail "duplicate num must fail closed" || [[ $? -eq 2 ]] || fail "duplicate num must exit 2"

# multiline description fidelity (catalog-fidelity NFR)
printf '%s\n' \
'- num: 1' '  category: core' '  method_name: Multi Line' '  description: |' '    First line of description' '    Second line with ünicode — punctuation' '  output_pattern: a → b' \
> "$OUT/multi.yaml"
r5=$(make_root multi "$OUT/multi.yaml")
sh "$r5/scripts/methods.sh" show 1 >"$OUT/multi-show.txt"
grep -q '^description:$' "$OUT/multi-show.txt" || fail "multiline description must be served as a block"
grep -q '^  Second line with ünicode — punctuation$' "$OUT/multi-show.txt" || fail "multiline description content lost"
sh "$r5/scripts/methods.sh" list --category core >"$OUT/multi-list.txt"
awk -F'\t' 'NR==1 && $4 !~ /Second line/ { exit 1 }' "$OUT/multi-list.txt" || fail "gist must fold multiline descriptions"

# --- skill self-containment (NFR): no external runtime, network, or root helpers ----

for f in "$SKILL/scripts/methods.sh" "$SKILL/scripts/serve-methods.awk"; do
    grep -qE 'curl|wget|npm |pip |uv |python|node |require|gem |apt-get|make -C|\$\{?REPO' "$f" && fail "$f references an external dependency or root helper"
done

# unrelated working directory: serving works from anywhere
( cd / && sh "$SERVE" categories >/dev/null ) || fail "serving must not depend on the caller's working directory"

# --- selection-v1 scenario corpus (admissibility of the served bench) ---------------

declare -A weakness_primary=(
    [SEL001]="Socratic Questioning"
    [SEL002]="Pre-mortem Analysis"
    [SEL003]="Stakeholder Round Table"
    [SEL004]="Tree of Thoughts"
    [SEL005]="Occam's Razor Application"
    [SEL006]="Architecture Decision Records"
)
for sel in SEL001 SEL002 SEL003 SEL004 SEL005 SEL006; do
    serve show "${weakness_primary[$sel]}" >/dev/null 2>&1 || fail "$sel primary method not servable"
done

# --- POSIX-portability smoke: no gawk-isms may enter the awk program ----------
# The macOS lane runs BSD awk; gawk --posix approximates that strictness here.
if command -v gawk >/dev/null 2>&1; then
    AWKPROG="$SKILL/scripts/serve-methods.awk"
    printf 'categories\n' | gawk --posix -v catalog="$CATALOG" -f "$AWKPROG" >"$OUT/px-cats.txt" ||
        fail "serve-methods.awk must run under gawk --posix (categories)"
    [[ -s "$OUT/px-cats.txt" ]] || fail "posix categories smoke produced no output"
    printf 'random\n5\n1\n' | gawk --posix -v catalog="$CATALOG" -v seed=3 -f "$AWKPROG" >"$OUT/px-rand.txt" ||
        fail "serve-methods.awk must run under gawk --posix (seeded spread)"
    [[ -s "$OUT/px-rand.txt" ]] || fail "posix random smoke produced no output"
    printf 'show\n9\n' | gawk --posix -v catalog="$CATALOG" -f "$AWKPROG" >"$OUT/px-show.txt" ||
        fail "serve-methods.awk must run under gawk --posix (show)"
    grep -q '^# 9 |' "$OUT/px-show.txt" || fail "posix show smoke lost the record"
fi

if [ "$failures" -gt 0 ]; then
    echo "method-serving-contract: $failures failure(s)" >&2
    exit 1
fi
echo "method-serving-contract: PASS"
