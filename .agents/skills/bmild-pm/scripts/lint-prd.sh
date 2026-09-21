#!/bin/sh
# BMILD PRD lint gate, ruleset prd-v1 (POSIX hosts).
# Deterministic mechanical checks over one PRD candidate; emits exactly one
# compact bmild-artifact-lint/v1 JSON object on stdout. Every handled result
# exits 0: inspect status/blocking/findings, never the process status.
# Registration binding is Faisal's owner-governed decision (J2), not a
# filesystem guarantee. See lint-prd.ps1 for the Windows-native equivalent.
#
#   sh <skill-dir>/scripts/lint-prd.sh --root <project-root> --artifact <path-within-root>
set -eu
LC_ALL=C
export LC_ALL

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
AWKPROG="$SCRIPT_DIR/lint-prd.awk"
PH="$SCRIPT_DIR/prd-v1-placeholders.txt"

usage() {
    printf 'error\nunsupported_invocation\nusage: lint-prd.sh --root <project-root> --artifact <path-within-root>\n-\n-\n' |
        awk -v ph="$PH" -f "$AWKPROG"
    exit 0
}

[ -f "$AWKPROG" ] || { echo "error: linter program not found: $AWKPROG" >&2; exit 3; }
[ -f "$PH" ] || { echo "error: rule asset not found: $PH" >&2; exit 3; }

root=""
artifact=""
while [ $# -gt 0 ]; do
    case $1 in
        --root)
            [ $# -ge 2 ] || usage
            root=$2
            shift 2
            ;;
        --artifact)
            [ $# -ge 2 ] || usage
            artifact=$2
            shift 2
            ;;
        *) usage ;;
    esac
done
if [ -z "$root" ] || [ -z "$artifact" ]; then usage; fi

# mode/code/detail/path/sha protocol lines; the awk program owns all JSON
# emission (shell string concatenation is not a JSON emitter).
emit_error() {
    printf 'error\n%s\n%s\n%s\n%s\n' "$1" "$2" "$3" "$4" | awk -v ph="$PH" -f "$AWKPROG"
    exit 0
}

NULLSHA="-"

[ -d "$root" ] || emit_error unsupported_invocation "root is not a directory: $root" "$artifact" "$NULLSHA"

# Lexical artifact normalization: / separators, no leading ./, no escape.
case $artifact in
    /*) emit_error unsupported_invocation "artifact path must be relative to root: $artifact" "$artifact" "$NULLSHA" ;;
esac
norm=""
rest=$artifact
EscapeCheck=0
while :; do
    case $rest in
        ./*) rest=${rest#./} ;;
        *) break ;;
    esac
done
oldifs=$IFS
IFS=/
set -f
# shellcheck disable=SC2086
set -- $rest
for seg in "$@"; do
    case $seg in
        ""|.) continue ;;
        ..)
            case $norm in
                "") EscapeCheck=1; break ;;
                */*) norm=${norm%/*} ;;
                *) norm="" ;;
            esac
            ;;
        *) norm=${norm:+$norm/}$seg ;;
    esac
done
set +f
IFS=$oldifs
if [ "$EscapeCheck" -eq 1 ] || [ -z "$norm" ]; then
    emit_error unsupported_invocation "artifact path escapes root or is empty: $artifact" "$artifact" "$NULLSHA"
fi

target=$root/$norm
if [ ! -e "$target" ]; then
    emit_error not_found "artifact not found under root: $norm" "$norm" "$NULLSHA"
fi
if [ ! -f "$target" ] || [ ! -r "$target" ]; then
    emit_error unreadable "artifact is not a readable regular file: $norm" "$norm" "$NULLSHA"
fi

sha=""
if command -v sha256sum >/dev/null 2>&1; then
    sha=$(sha256sum "$target") && sha=${sha%% *} || sha=""
elif command -v shasum >/dev/null 2>&1; then
    sha=$(shasum -a 256 "$target") && sha=${sha%% *} || sha=""
elif command -v openssl >/dev/null 2>&1; then
    sha=$(openssl dgst -sha256 -r "$target") && sha=${sha%% *} || sha=""
fi
case $sha in
    ''|*[!0-9a-f]*) emit_error internal_error "no native SHA-256 facility available on this host" "$norm" "$NULLSHA" ;;
esac

if ! iconv -f UTF-8 -t UTF-8 "$target" >/dev/null 2>&1; then
    emit_error non_utf8 "artifact is not valid UTF-8: $norm" "$norm" "$sha"
fi

printf 'lint\n%s\n%s\n%s\n' "$norm" "$sha" "$target" | awk -v ph="$PH" -f "$AWKPROG"
