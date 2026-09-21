#!/bin/sh
# BMILD elicitation method catalog server (POSIX hosts).
# Serves bounded projections of resources/methods.yaml so an elicitation
# session never loads the full catalog into context except on an explicit
# list-all. Invoked as:
#
#   sh <skill-dir>/scripts/methods.sh categories
#   sh <skill-dir>/scripts/methods.sh list --category <c> [--category <d>]
#   sh <skill-dir>/scripts/methods.sh list --all
#   sh <skill-dir>/scripts/methods.sh cast
#   sh <skill-dir>/scripts/methods.sh show <name-or-num> [name-or-num ...]
#   sh <skill-dir>/scripts/methods.sh random -n <1-12> [--spread]
#          [--exclude <method-name>] ... [--seed <n>]
#
# Exit codes: 0 served (including insufficient_diversity results);
# 1 nothing matched (unknown show key, empty random pool); 2 usage or
# catalog failure. See methods.ps1 for the Windows-native equivalent.
set -eu
LC_ALL=C
export LC_ALL

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
CATALOG="$SCRIPT_DIR/../resources/methods.yaml"
AWKPROG="$SCRIPT_DIR/serve-methods.awk"

usage() {
    awk 'NR == 1 { next } /^#/ { sub(/^# ?/, ""); print; next } { exit }' < "$0" >&2
    exit 2
}

[ -f "$CATALOG" ] || { echo "error: catalog not found: $CATALOG" >&2; exit 2; }
[ -f "$AWKPROG" ] || { echo "error: server program not found: $AWKPROG" >&2; exit 2; }

[ $# -ge 1 ] || usage
cmd=$1
shift

case $cmd in
    categories|cast|listall)
        [ $# -eq 0 ] || usage
        printf '%s\n' "$cmd" | awk -v catalog="$CATALOG" -f "$AWKPROG"
        ;;
    list)
        cats=""
        all=0
        while [ $# -gt 0 ]; do
            case $1 in
                --category)
                    [ $# -ge 2 ] || usage
                    cats="$cats$2
"
                    shift 2
                    ;;
                --all) all=1; shift ;;
                *) usage ;;
            esac
        done
        if [ "$all" -eq 1 ]; then
            [ -z "$cats" ] || usage
            printf 'listall\n' | awk -v catalog="$CATALOG" -f "$AWKPROG"
        else
            printf 'list\n%s' "$cats" | awk -v catalog="$CATALOG" -f "$AWKPROG"
        fi
        ;;
    show)
        [ $# -ge 1 ] || usage
        { printf 'show\n'; printf '%s\n' "$@"; } | awk -v catalog="$CATALOG" -f "$AWKPROG"
        ;;
    random)
        n=""
        spread=0
        seed=""
        excludes=""
        while [ $# -gt 0 ]; do
            case $1 in
                -n)
                    [ $# -ge 2 ] || usage
                    n=$2
                    shift 2
                    ;;
                --spread) spread=1; shift ;;
                --seed)
                    [ $# -ge 2 ] || usage
                    seed=$2
                    shift 2
                    ;;
                --exclude)
                    [ $# -ge 2 ] || usage
                    excludes="$excludes$2
"
                    shift 2
                    ;;
                *) usage ;;
            esac
        done
        [ -n "$n" ] || usage
        case $n in
            ''|*[!0-9]*) usage ;;
        esac
        seedarg=""
        if [ -n "$seed" ]; then
            case $seed in
                ''|*[!0-9]*) usage ;;
            esac
            seedarg="-v seed=$seed"
        fi
        # shellcheck disable=SC2086
        { printf 'random\n%s\n%d\n%s' "$n" "$spread" "$excludes"; } |
            awk -v catalog="$CATALOG" $seedarg -f "$AWKPROG"
        ;;
    *)
        usage
        ;;
esac
