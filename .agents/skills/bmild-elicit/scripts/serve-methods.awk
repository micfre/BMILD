# serve-methods.awk - BMILD elicitation catalog serving engine (POSIX awk).
# Reads the invocation protocol on stdin (command line, then argument lines),
# the canonical catalog from the -v catalog file, and writes bounded
# projections to stdout. Malformed catalog data or a rule violation fails
# closed on stderr with exit 2. Pure POSIX awk: no gawk/mawk extensions.
#
# Protocol (one entry per line):
#   categories
#   list            followed by 0..2 category-name lines
#   listall
#   cast
#   show            followed by 1..4 method-name-or-number lines
#   random          followed by: n line, spread flag line (0/1), then
#                   exclusion method-name lines until EOF
# Optional -v seed=N makes the random draw repeatable on this host (test aid;
# sequences are not stable across awk implementations or platforms).

function fail(msg) {
    print "error: " msg > "/dev/stderr"
    exit 2
}

function trim(s) {
    sub(/^[ \t]+/, "", s)
    sub(/[ \t]+$/, "", s)
    return s
}

# UTF-8 continuation bytes (0x80-0x191, decimal 128-191) as a lookup string:
# counting them converts byte lengths into code-point lengths without
# multibyte locale support.
function mkcont(    i, s) {
    s = ""
    for (i = 128; i <= 191; i++)
        s = s sprintf("%c", i)
    return s
}

function cplen(s,    i, n, c) {
    n = length(s)
    if (n <= GistMax)
        return n
    for (i = 1; i <= n; i++) {
        c = substr(s, i, 1)
        if (index(CONT, c) > 0)
            n--
    }
    return n
}

# Truncate s to at most max code points; cut at the last space when possible
# and mark truncation with an ellipsis. Deterministic for both native paths.
function cptruncate(s, max,    i, n, c, cps, cut, lastspace, keep) {
    n = length(s)
    if (cplen(s) <= max)
        return s
    cps = 0
    cut = n
    lastspace = 0
    keep = ""
    for (i = 1; i <= n; i++) {
        c = substr(s, i, 1)
        if (index(CONT, c) == 0)
            cps++
        if (cps > max) {
            cut = i - 1
            break
        }
        keep = keep c
        if (c == " ")
            lastspace = cps
    }
    if (lastspace > 1) {
        cps = 0
        keep = ""
        for (i = 1; i <= cut; i++) {
            c = substr(s, i, 1)
            if (index(CONT, c) == 0)
                cps++
            if (cps >= lastspace)
                break
            keep = keep c
        }
    }
    return keep "..."
}

function gist(d,    s) {
    s = d
    gsub(/[\r\n\t]+/, " ", s)
    return cptruncate(s, GistMax)
}

function compactrow(i) {
    printf "%d\t%s\t%s\t%s\n", Num[i], Cat[i], Name[i], gist(Desc[i])
}

function fullrecord(i,    l, n, j) {
    printf "# %d | %s | %s\n", Num[i], Cat[i], Name[i]
    n = split(Desc[i], l, "\n")
    if (n == 1)
        print "description: " l[1]
    else {
        print "description:"
        for (j = 1; j <= n; j++)
            print "  " l[j]
    }
    print "output_pattern: " Pat[i]
    if (Cast[i])
        print "# persona-cast method: load each participating persona's canonical sibling SOUL.md before executing"
    print ""
}

# --- catalog loading -------------------------------------------------------

function closerecord(    k) {
    # validate the record just closed, if any
    if (R == 0)
        return
    if (RecNum !~ /^[0-9]+$/)
        fail("record " R ": invalid num '" RecNum "'")
    if (Rec["category"] == "" || Rec["method_name"] == "" || Rec["description"] == "" || Rec["output_pattern"] == "")
        fail("record " RecNum ": missing one of num/category/method_name/description/output_pattern")
    if (Rec["persona_cast"] != "" && Rec["persona_cast"] != "true")
        fail("record " RecNum ": persona_cast must be 'true' when present")
    Num[R] = RecNum + 0
    Cat[R] = Rec["category"]
    Name[R] = Rec["method_name"]
    Desc[R] = Rec["description"]
    Pat[R] = Rec["output_pattern"]
    Cast[R] = (Rec["persona_cast"] == "true") ? 1 : 0
    if (Num[R] < 1)
        fail("record " RecNum ": num must be positive")
    if (Num[R] in NumIdx)
        fail("duplicate num " Num[R] " (" Name[NumIdx[Num[R]]] " and " Name[R] ")")
    NumIdx[Num[R]] = R
    NameIdx[tolower(Name[R])] = R
    for (k in Rec)
        delete Rec[k]
}

function badcontrol(s,    i, c) {
    for (i = 1; i <= length(s); i++) {
        c = substr(s, i, 1)
        if (c < " " || c == "\177")
            return 1
    }
    return 0
}

function loadcatalog(    line, k, v, r, ln) {
    R = 0
    RecNum = ""
    pending = ""
    ln = 0
    while (1) {
        r = (getline line < catalog)
        if (r < 0)
            fail("cannot read catalog: " catalog)
        if (r == 0)
            break
        ln++
        if (line ~ /^#/)
            continue
        if (line ~ /^[ \t]*$/)
            continue
        if (line ~ /^- num:[ \t]*[0-9]+[ \t]*$/) {
            closerecord()
            R++
            v = line
            sub(/^- num:[ \t]*/, "", v)
            sub(/[ \t]*$/, "", v)
            RecNum = v
            for (k in seen)
                delete seen[k]
            seen["num"] = 1
            pending = ""
            continue
        }
        if (R == 0)
            fail("catalog line " ln ": expected '- num: <n>' record start, got: " line)
        if (line ~ /^    [^ \t]/) {
            v = line
            sub(/^ +/, "", v)
            if (pending == "")
                fail("catalog line " ln ": continuation outside a block field: " line)
            if (Rec[pending] == "")
                Rec[pending] = v
            else
                Rec[pending] = Rec[pending] "\n" v
            continue
        }
        if (line ~ /^  [a-z_]+:( .*)?$/) {
            k = line
            sub(/^  /, "", k)
            sub(/:.*$/, "", k)
            v = line
            sub(/^  [a-z_]+:[ \t]*/, "", v)
            sub(/[ \t]+$/, "", v)
            if (!(k in Allowed))
                fail("record " RecNum ": unknown field '" k "' at catalog line " ln)
            if (k in seen)
                fail("record " RecNum ": duplicate field '" k "' at catalog line " ln)
            seen[k] = 1
            pending = ""
            if (v == "|") {
                pending = k
                continue
            }
            if (badcontrol(v))
                fail("record " RecNum ": control character in field '" k "'")
            Rec[k] = v
            continue
        }
        fail("unrecognized catalog line " ln ": " line)
    }
    close(catalog)
    closerecord()
    if (R == 0)
        fail("catalog contains no records: " catalog)
}

# --- serving ----------------------------------------------------------------

function categorycounts(    i, c, n, sorted, j, tmp) {
    n = 0
    for (i = 1; i <= R; i++) {
        c = Cat[i]
        if (c in Count)
            Count[c]++
        else {
            Count[c] = 1
            n++
            sorted[n] = c
        }
    }
    for (i = 2; i <= n; i++) {
        tmp = sorted[i]
        j = i - 1
        while (j >= 1 && sorted[j] > tmp) {
            sorted[j + 1] = sorted[j]
            j--
        }
        sorted[j + 1] = tmp
    }
    for (i = 1; i <= n; i++)
        printf "%s\t%d\n", sorted[i], Count[sorted[i]]
    for (i in Count)
        delete Count[i]
}

function findkey(key) {
    key = trim(key)
    if (key ~ /^[0-9]+$/)
        return ((key + 0) in NumIdx) ? NumIdx[key + 0] : 0
    key = tolower(key)
    return (key in NameIdx) ? NameIdx[key] : 0
}

function servelist(    i, c, want, rows, matched, ncat) {
    ncat = 0
    while ((getline c) > 0) {
        c = tolower(trim(c))
        if (c == "")
            continue
        if (!(c in KnownCat))
            fail("unknown category '" c "' (run 'categories' for the list)")
        want[c] = 1
        ncat++
    }
    if (ncat == 0)
        fail("list needs --category (one or two) or --all")
    if (ncat > 2)
        fail("list accepts at most two categories before primary-method selection")
    rows = 0
    for (i = 1; i <= R; i++) {
        if (tolower(Cat[i]) in want)
            matched[++rows] = i
    }
    if (rows > ListMax)
        fail("scoped index would return " rows " rows (bound " ListMax "); narrow to one category or use random --spread")
    for (i = 1; i <= rows; i++)
        compactrow(matched[i])
}

function servecast(    i) {
    for (i = 1; i <= R; i++)
        if (Cast[i])
            compactrow(i)
}

function serveshow(    key, i, found, fc, missing, mc, n) {
    n = 0
    fc = 0
    mc = 0
    while ((getline key) > 0) {
        if (trim(key) == "")
            continue
        n++
        if (n > ShowMax)
            fail("show accepts at most " ShowMax " methods per selection round (one primary plus follow-ups)")
        i = findkey(key)
        if (i > 0) {
            if (!(i in ShownRec))
                found[++fc] = i
            ShownRec[i] = 1
        } else
            missing[++mc] = trim(key)
    }
    if (n == 0)
        fail("show needs at least one method name or number")
    for (i = 1; i <= mc; i++)
        print "# not found: " missing[i] > "/dev/stderr"
    for (i = 1; i <= fc; i++)
        fullrecord(found[i])
    if (fc == 0)
        exit 1
}

function distinctcats(    i, c, n) {
    n = 0
    for (i in Pool) {
        c = Cat[i]
        if (!(c in PC)) {
            PC[c] = 1
            n++
        }
    }
    return n
}

function serverandom(    line, n, spread, name, i, c, poolsz, distinct, r, picked, bi, bj, tmp, nb, progressed) {
    getline n
    getline spread
    while ((getline name) > 0) {
        name = tolower(trim(name))
        if (name == "")
            continue
        Ex[name] = 1
    }
    if (n !~ /^[0-9]+$/ || n + 0 < 1)
        fail("random -n must be a positive integer")
    n = n + 0
    if (n > RandMax)
        fail("random -n is bounded to " RandMax "; requests above " RandMax " are rejected without returning records")
    poolsz = 0
    for (i = 1; i <= R; i++) {
        if (tolower(Name[i]) in Ex)
            continue
        Pool[i] = 1
        poolsz++
    }
    if (poolsz == 0) {
        print "# no methods match" > "/dev/stderr"
        exit 1
    }
    distinct = distinctcats()
    if (poolsz < 2 || distinct < 2) {
        printf "# insufficient_diversity: pool has %d methods across %d categories\n", poolsz, distinct
        limit = (poolsz < n) ? poolsz : n
        picked = 0
        for (i = 1; i <= R && picked < limit; i++) {
            if (i in Pool) {
                compactrow(i)
                picked++
            }
        }
        return
    }
    if (n > poolsz)
        n = poolsz
    if (!spread) {
        picked = 0
        while (picked < n) {
            r = 1 + int(rand() * R)
            if ((r in Pool) && !(r in Taken)) {
                Taken[r] = 1
                compactrow(r)
                picked++
            }
        }
        return
    }
    # spread: round-robin over shuffled category buckets, one method per
    # category per round, until n picks or the pool is exhausted.
    nb = 0
    for (c in PC) {
        nb++
        buckets[nb] = c
        bsize[c] = 0
    }
    for (bi = 1; bi <= nb; bi++) {
        bj = bi + int(rand() * (nb - bi + 1))
        tmp = buckets[bi]
        buckets[bi] = buckets[bj]
        buckets[bj] = tmp
    }
    for (i = 1; i <= R; i++) {
        if (i in Pool) {
            c = Cat[i]
            bsize[c]++
            bucket[c "," bsize[c]] = i
        }
    }
    picked = 0
    while (picked < n) {
        progressed = 0
        for (bi = 1; bi <= nb && picked < n; bi++) {
            c = buckets[bi]
            if (bsize[c] == 0)
                continue
            r = 1 + int(rand() * bsize[c])
            i = bucket[c "," r]
            bucket[c "," r] = bucket[c "," bsize[c]]
            delete bucket[c "," bsize[c]]
            bsize[c]--
            Taken[i] = 1
            compactrow(i)
            picked++
            progressed = 1
        }
        if (progressed == 0)
            break
    }
}

BEGIN {
    GistMax = 180
    ListMax = 24
    ShowMax = 4
    RandMax = 12
    CONT = mkcont()
    Allowed["num"] = 1
    Allowed["category"] = 1
    Allowed["method_name"] = 1
    Allowed["description"] = 1
    Allowed["output_pattern"] = 1
    Allowed["persona_cast"] = 1
    srand((seed == "") ? systime() : seed + 0)

    getline cmd
    if (cmd == "")
        fail("no command received")

    loadcatalog()
    for (i = 1; i <= R; i++)
        KnownCat[tolower(Cat[i])] = 1

    if (cmd == "categories")
        categorycounts()
    else if (cmd == "list")
        servelist()
    else if (cmd == "listall") {
        for (i = 1; i <= R; i++)
            compactrow(i)
    } else if (cmd == "cast")
        servecast()
    else if (cmd == "show")
        serveshow()
    else if (cmd == "random")
        serverandom()
    else
        fail("unknown command '" cmd "'")
    exit 0
}
