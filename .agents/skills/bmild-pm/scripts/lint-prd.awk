# lint-prd.awk - prd-v1 rules engine and JSON emitter (POSIX awk).
# Reads a protocol on stdin (mode line, then mode-specific lines) and emits
# exactly one compact bmild-artifact-lint/v1 JSON object on stdout. The
# wrapper owns argument/lexing duties (path normalization, SHA-256, UTF-8
# validation via native facilities); this program owns scanning rules
# PRD001-PRD006 and every byte of JSON emission. Pure POSIX awk: no
# interval expressions, no gawk/mawk extensions.
#
# Protocol:
#   error / code / detail / path("-" for null) / sha256("-" for null)
#   lint  / path / sha256 / file-to-read

function fail(msg) {
    print "error: " msg > "/dev/stderr"
    print "{\"schema_version\":\"bmild-artifact-lint/v1\",\"ruleset\":\"prd-v1\",\"artifact\":{\"path\":null,\"sha256\":null},\"status\":\"error\",\"blocking\":true,\"total_findings\":0,\"by_severity\":{\"high\":0,\"medium\":0,\"low\":0},\"findings\":[],\"error\":{\"code\":\"internal_error\",\"detail\":\"linter program failure\"}}"
    exit 0
}

# --- JSON string escaping (the sanctioned native emitter) -------------------

function jstr(s,    out, i, c, n) {
    out = "\""
    n = length(s)
    for (i = 1; i <= n; i++) {
        c = substr(s, i, 1)
        if (c == "\"")
            out = out "\\\""
        else if (c == "\\")
            out = out "\\\\"
        else if (c < "\030" || c == "\177") {
            # control characters as \uXXXX (octal-safe via sprintf %04x path)
            out = out sprintf("\\u%04x", chartobyte(c))
        } else
            out = out c
    }
    return out "\""
}

function chartobyte(c) {
    # byte value of a single char under LC_ALL=C semantics
    if (c == "\t") return 9
    if (c == "\n") return 10
    if (c == "\r") return 13
    return index(BYTES, c)
}

function initbytes(    i, s) {
    s = ""
    for (i = 1; i <= 255; i++)
        s = s sprintf("%c", i)
    return s
}

# --- findings collection -----------------------------------------------------

function addfinding(rule, cat, sev, line, detail) {
    NF001++
    FLine[NF001] = line
    FRule[NF001] = rule
    FCat[NF001] = cat
    FSev[NF001] = sev
    FDetail[NF001] = detail
    if (sev == "high")
        NHigh++
    else if (sev == "medium")
        NMed++
    else
        NLow++
}

function sortfindings(    i, j, k1, k2, t) {
    for (i = 2; i <= NF001; i++) {
        k1 = sprintf("%06d %s %04d", FLine[i], FRule[i], i)
        t = i
        while (t > 1) {
            k2 = sprintf("%06d %s %04d", FLine[t - 1], FRule[t - 1], t - 1)
            if (k2 > k1) {
                swapfindings(t, t - 1)
                t--
            } else
                break
        }
    }
}

function swapfindings(a, b,    t) {
    t = FLine[a]; FLine[a] = FLine[b]; FLine[b] = t
    t = FRule[a]; FRule[a] = FRule[b]; FRule[b] = t
    t = FCat[a]; FCat[a] = FCat[b]; FCat[b] = t
    t = FSev[a]; FSev[a] = FSev[b]; FSev[b] = t
    t = FDetail[a]; FDetail[a] = FDetail[b]; FDetail[b] = t
}

function emitresult(path, sha,    out, i, first) {
    sortfindings()
    out = "{\"schema_version\":\"bmild-artifact-lint/v1\",\"ruleset\":\"prd-v1\","
    out = out "\"artifact\":{\"path\":" jstr(path) ",\"sha256\":"
    out = out (sha == "-" ? "null" : jstr(sha)) "},"
    if (NF001 > 0)
        out = out "\"status\":\"findings\",\"blocking\":" ((NHigh + NMed > 0) ? "true" : "false") ","
    else
        out = out "\"status\":\"clean\",\"blocking\":false,"
    out = out "\"total_findings\":" NF001 ","
    out = out "\"by_severity\":{\"high\":" NHigh ",\"medium\":" NMed ",\"low\":" NLow "},"
    out = out "\"findings\":["
    for (i = 1; i <= NF001; i++) {
        if (i > 1)
            out = out ","
        out = out "{\"rule_id\":" jstr(FRule[i]) ",\"category\":" jstr(FCat[i]) ",\"severity\":" jstr(FSev[i]) ",\"detail\":" jstr(FDetail[i]) ",\"location\":{\"path\":" jstr(path) ",\"line\":" FLine[i] "}}"
    }
    out = out "]}"
    print out
}

function emiterror(code, detail, path, sha) {
    status = "error"
    print "{\"schema_version\":\"bmild-artifact-lint/v1\",\"ruleset\":\"prd-v1\",\"artifact\":{\"path\":" (path == "-" ? "null" : jstr(path)) ",\"sha256\":" (sha == "-" ? "null" : jstr(sha)) "},\"status\":\"error\",\"blocking\":true,\"total_findings\":0,\"by_severity\":{\"high\":0,\"medium\":0,\"low\":0},\"findings\":[],\"error\":{\"code\":" jstr(code) ",\"detail\":" jstr(detail) "}}"
}

# --- input loading -----------------------------------------------------------

function loadfile(f,    r, line) {
    NL = 0
    while (1) {
        r = (getline line < f)
        if (r < 0)
            fail("cannot read artifact: " f)
        if (r == 0)
            break
        L[++NL] = line
    }
    close(f)
    if (NL == 0) {
        # empty file: represent as a single empty line so line 1 exists
        NL = 1
        L[1] = ""
    }
}

# --- scan-text masking (PRD001 exclusions) ----------------------------------

function buildscan(    i, j, c, n, line, out, infence, incomment, backtick, spanstart) {
    infence = 0
    incomment = 0
    for (i = 1; i <= NL; i++) {
        line = L[i]
        out = ""
        if (infence) {
            if (line ~ /^```+/ || line ~ /^[ \t]*```+/)
                infence = 0
            Scan[i] = spacesof(line)
            continue
        }
        if (line ~ /^[ \t]*```+/) {
            infence = 1
            Scan[i] = spacesof(line)
            continue
        }
        # mask inline code spans, then HTML comments
        n = length(line)
        backtick = 0
        for (j = 1; j <= n; j++) {
            c = substr(line, j, 1)
            if (incomment) {
                out = out " "
                if (c == ">" && j > 1 && substr(line, j - 1, 2) == "->")
                    incomment = 0
                continue
            }
            if (backtick) {
                out = out " "
                if (c == "`")
                    backtick = 0
                continue
            }
            if (c == "`") {
                out = out " "
                backtick = 1
                continue
            }
            if (c == "<" && substr(line, j, 4) == "<!--") {
                out = out "    "
                j += 3
                incomment = 1
                continue
            }
            out = out c
        }
        Scan[i] = out
    }
}

function spacesof(s,    i, n, o) {
    n = length(s)
    o = ""
    for (i = 1; i <= n; i++)
        o = o " "
    return o
}

# --- PRD001: explicit placeholders -------------------------------------------

function wordboundaryok(s, pos, len,    before, after) {
    before = (pos > 1) ? substr(s, pos - 1, 1) : ""
    after = (pos + len <= length(s)) ? substr(s, pos + len, 1) : ""
    if (before != "" && before ~ /[A-Za-z0-9_]/)
        return 0
    if (after != "" && after ~ /[A-Za-z0-9_]/)
        return 0
    return 1
}

function scanplaceholdermarkers(    i, m, mk, markers, s, from, pos, lit, k, sorted) {
    # standalone uppercase markers
    split("TBD TODO FIXME XXX", markers, " ")
    for (i = 1; i <= NL; i++) {
        s = Scan[i]
        for (m = 1; m <= 4; m++) {
            mk = markers[m]
            from = 1
            while ((pos = index(substr(s, from), mk)) > 0) {
                pos = from + pos - 1
                if (wordboundaryok(s, pos, length(mk)))
                    addfinding("PRD001", "placeholder", "high", i, "placeholder marker '" mk "'")
                from = pos + length(mk)
            }
        }
    }
    # template placeholder inventory (literal matches)
    while ((getline lit < ph) > 0) {
        if (lit ~ /^#/ || lit ~ /^[ \t]*$/)
            continue
        gsub(/\r$/, "", lit)
        if (!(lit in PHSeen)) {
            PHSeen[lit] = 1
            PHLit[++PHN] = lit
        }
    }
    close(ph)
    for (i = 1; i <= NL; i++) {
        s = Scan[i]
        for (m = 1; m <= PHN; m++) {
            lit = PHLit[m]
            if (index(s, lit) > 0)
                addfinding("PRD001", "placeholder", "high", i, "template placeholder '" lit "'")
        }
    }
}

# --- PRD002: frontmatter contract --------------------------------------------

function validdate(v,    y, mo, d, dim) {
    if (v !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/)
        return 0
    y = substr(v, 1, 4) + 0
    mo = substr(v, 6, 2) + 0
    d = substr(v, 9, 2) + 0
    if (mo < 1 || mo > 12 || d < 1)
        return 0
    dim = 31
    if (mo == 4 || mo == 6 || mo == 9 || mo == 11)
        dim = 30
    else if (mo == 2)
        dim = ((y % 4 == 0 && y % 100 != 0) || y % 400 == 0) ? 29 : 28
    return (d <= dim)
}

function stripquotes(v) {
    if (length(v) >= 2 && substr(v, 1, 1) == "\"" && substr(v, length(v), 1) == "\"")
        return substr(v, 2, length(v) - 2)
    return v
}

function scanfrontmatter(    i, closeix, key, val, missing, k, count, dup, nonscalar, sev) {
    RequiredCount = 6
    if (L[1] != "---") {
        addfinding("PRD002", "frontmatter", "high", 1, "frontmatter must open with an exact '---' line")
        return
    }
    closeix = 0
    for (i = 2; i <= NL; i++) {
        if (L[i] == "---") {
            closeix = i
            break
        }
    }
    if (closeix == 0) {
        addfinding("PRD002", "frontmatter", "high", 1, "frontmatter is not closed by an exact '---' line")
        return
    }
    count = 0
    for (i = 2; i < closeix; i++) {
        if (L[i] ~ /^[A-Za-z_][A-Za-z0-9_]*: / || L[i] ~ /^[A-Za-z_][A-Za-z0-9_]*:$/) {
            key = L[i]
            sub(/:.*$/, "", key)
            val = L[i]
            sub(/^[A-Za-z_][A-Za-z0-9_]*:[ \t]*/, "", val)
            if (!(key in FMAllowed)) {
                addfinding("PRD002", "frontmatter", "high", i, "frontmatter key '" key "' is not a template scalar field")
                continue
            }
            if (FMSeen[key] > 0) {
                addfinding("PRD002", "frontmatter", "high", i, "frontmatter key '" key "' appears more than once")
                continue
            }
            FMSeen[key] = i
            FMVal[key] = stripquotes(val)
            count++
        } else if (L[i] ~ /^[ \t]*$/)
            continue
        else
            addfinding("PRD002", "frontmatter", "high", i, "frontmatter accepts only flat scalar fields; malformed line")
    }
    missing = ""
    for (k = 1; k <= 6; k++) {
        key = FMReq[k]
        if (!(key in FMSeen) && key != "")
            missing = missing (missing == "" ? "" : ", ") key
    }
    if (missing != "")
        addfinding("PRD002", "frontmatter", "high", 1, "missing required frontmatter keys: " missing)
    checkfmvalue("type", "PRD")
    checkfmnonempty("title")
    checkfmnonempty("description")
    checkfmnonempty("author")
    if ("timestamp" in FMSeen && FMVal["timestamp"] != "" && !validdate(FMVal["timestamp"]))
        addfinding("PRD002", "frontmatter", "high", FMSeen["timestamp"], "timestamp is not a valid YYYY-MM-DD date")
    if ("scope" in FMSeen && FMVal["scope"] !~ /^[a-z0-9]+(-[a-z0-9]+)*$/)
        addfinding("PRD002", "frontmatter", "high", FMSeen["scope"], "scope must match ^[a-z0-9]+(-[a-z0-9]+)*$")
}

function checkfmvalue(key, want) {
    if (key in FMSeen && FMVal[key] != want)
        addfinding("PRD002", "frontmatter", "high", FMSeen[key], "frontmatter key '" key "' must equal '" want "'")
}

function checkfmnonempty(key) {
    if (key in FMSeen && FMVal[key] == "")
        addfinding("PRD002", "frontmatter", "high", FMSeen[key], "frontmatter key '" key "' must be non-empty")
}

# --- PRD003: requirement and journey IDs --------------------------------------

function scanids(    i, id, fam, seqn, expfr, expj, firstfr, firstj, frn, jn, seen) {
    expfr = 0
    expj = 0
    firstfr = 0
    firstj = 0
    for (i = 1; i <= NL; i++) {
        if (L[i] ~ /^- FR[1-9][0-9]*: /) {
            frn = L[i]
            sub(/^- FR/, "", frn)
            sub(/:.*$/, "", frn)
            if ((("FR", frn) in IDSeen)) {
                addfinding("PRD003", "id_continuity", "high", i, "duplicate FR ID: FR" frn)
            } else {
                IDSeen["FR", frn] = i
                FRDef[++FRN] = frn + 0
                FRLine[frn + 0] = i
                if (expfr == 0 && frn + 0 != 1 && firstfr == 0)
                    firstfr = i
                if (expfr > 0 && frn + 0 != expfr && firstfr == 0)
                    firstfr = i
                expfr = frn + 1
            }
        } else if (L[i] ~ /^- J[1-9][0-9]* — Journey: /) {
            jn = L[i]
            sub(/^- J/, "", jn)
            sub(/ —.*$/, "", jn)
            if ((("J", jn) in IDSeen)) {
                addfinding("PRD003", "id_continuity", "high", i, "duplicate journey ID: J" jn)
            } else {
                IDSeen["J", jn] = i
                JDef[++JN] = jn + 0
                JLine[jn + 0] = i
                if (expj == 0 && jn + 0 != 1 && firstj == 0)
                    firstj = i
                if (expj > 0 && jn + 0 != expj && firstj == 0)
                    firstj = i
                expj = jn + 1
            }
        }
    }
    if (firstfr > 0)
        addfinding("PRD003", "id_continuity", "medium", firstfr, "FR IDs must start at 1 and ascend contiguously")
    if (firstj > 0)
        addfinding("PRD003", "id_continuity", "medium", firstj, "journey IDs must start at 1 and ascend contiguously")
}

# --- PRD004: phase traceability -----------------------------------------------

function findheading(text,    i) {
    for (i = 1; i <= NL; i++)
        if (L[i] == text)
            return i
    return 0
}

function sectionend(start,    i) {
    for (i = start + 1; i <= NL; i++)
        if (L[i] ~ /^## /)
            return i - 1
    return NL
}

function scanphases(    i, start, end, phase, pline, tokens, n, t, fam, a, b, rest, dash, tail, tailpfx, firstinc, k, s) {
    start = findheading("## Scope & Prioritization")
    if (start == 0) {
        # no committed phases can exist; anchor missing membership at line 1
        firstinc = 1
    } else {
        end = sectionend(start)
        phase = ""
        for (i = start + 1; i <= end; i++) {
            if (L[i] ~ /^- \*\*.*:\*\* / || L[i] ~ /^- \*\*.*:\*\*[ \t]*$/) {
                phase = L[i]
                sub(/^- \*\*/, "", phase)
                sub(/:\*\*.*$/, "", phase)
                pline = i
                continue
            }
            if (L[i] ~ /^  - Includes: / && phase != "") {
                INC++
                INCLine[INC] = i
                INCPhase[INC] = phase
                INCValue[INC] = L[i]
                sub(/^  - Includes: /, "", INCValue[INC])
            }
        }
        if (INC == 0)
            firstinc = start
        else
            firstinc = INCLine[1]
    }
    # validate tokens and build membership
    for (k = 1; k <= INC; k++) {
        n = split(INCValue[k], tokens, ",")
        for (t = 1; t <= n; t++) {
            s = tokens[t]
            gsub(/^[ \t]+|[ \t]+$/, "", s)
            if (s == "") {
                addfinding("PRD004", "phase_traceability", "high", INCLine[k], "empty token in Includes list")
                continue
            }
            if (s !~ /^(FR|J)[1-9][0-9]*(-(FR|J)[1-9][0-9]*)?$/) {
                addfinding("PRD004", "phase_traceability", "high", INCLine[k], "malformed Includes token '" s "'")
                continue
            }
            fam = (substr(s, 1, 1) == "F") ? "FR" : "J"
            rest = (fam == "FR") ? substr(s, 3) : substr(s, 2)
            dash = index(rest, "-")
            if (dash > 0) {
                tail = substr(rest, dash + 1)
                tailpfx = (fam == "FR") ? substr(tail, 1, 2) : substr(tail, 1, 1)
                if (tailpfx != fam) {
                    addfinding("PRD004", "phase_traceability", "high", INCLine[k], "cross-family range '" s "'")
                    continue
                }
                a = substr(rest, 1, dash - 1) + 0
                b = ((fam == "FR") ? substr(tail, 3) : substr(tail, 2)) + 0
                if (b < a) {
                    addfinding("PRD004", "phase_traceability", "high", INCLine[k], "reversed range '" s "'")
                    continue
                }
            } else {
                a = rest + 0
                b = a
            }
            for (i = a; i <= b; i++) {
                if (!((fam, i "") in IDSeen)) {
                    addfinding("PRD004", "phase_traceability", "high", INCLine[k], "unresolved reference '" fam i "'")
                    continue
                }
                MemberCount[fam, i]++
                if (MemberCount[fam, i] == 2)
                    RepeatAt[fam, i] = INCLine[k]
            }
        }
    }
    # missing membership
    for (k = 1; k <= FRN; k++)
        if (MemberCount["FR", FRDef[k] ""] + 0 == 0)
            addfinding("PRD004", "phase_traceability", "medium", firstinc, "FR" FRDef[k] " is not included in any committed phase")
    for (k = 1; k <= JN; k++)
        if (MemberCount["J", JDef[k] ""] + 0 == 0)
            addfinding("PRD004", "phase_traceability", "medium", firstinc, "J" JDef[k] " is not included in any committed phase")
    # repeated membership
    for (k = 1; k <= FRN; k++)
        if (MemberCount["FR", FRDef[k] ""] + 0 > 1)
            addfinding("PRD004", "phase_traceability", "medium", RepeatAt["FR", FRDef[k] ""], "FR" FRDef[k] " is included in more than one committed phase")
    for (k = 1; k <= JN; k++)
        if (MemberCount["J", JDef[k] ""] + 0 > 1)
            addfinding("PRD004", "phase_traceability", "medium", RepeatAt["J", JDef[k] ""], "J" JDef[k] " is included in more than one committed phase")
}

# --- PRD005: consequence-driven assumptions -----------------------------------

function scanassumptions(    i, j, aline, text, conf, confline, cons, recons, dupconf, dupcons, t) {
    i = 1
    while (i <= NL) {
        if (L[i] !~ /^- \*\*Assumption:\*\* /) {
            i++
            continue
        }
        text = L[i]
        sub(/^- \*\*Assumption:\*\* /, "", text)
        if (text ~ /^[ \t]*$/)
            addfinding("PRD005", "assumption_structure", "medium", i, "assumption text is empty")
        conf = 0
        cons = 0
        for (j = i + 1; j <= NL; j++) {
            if (L[j] ~ /^- \*\*Assumption:\*\* / || L[j] ~ /^## /)
                break
            t = L[j]
            sub(/^[ \t]*- /, "", t)
            if (t ~ /^Confidence: /) {
                conf++
                if (conf > 1)
                    continue
                sub(/^Confidence: /, "", t)
                if (t != "Low" && t != "Medium" && t != "High")
                    addfinding("PRD005", "assumption_structure", "medium", i, "Confidence must be Low, Medium, or High")
            } else if (t ~ /^Consequence if wrong: /) {
                cons++
                if (cons > 1)
                    continue
                sub(/^Consequence if wrong: /, "", t)
                if (t ~ /^[ \t]*$/)
                    addfinding("PRD005", "assumption_structure", "medium", i, "Consequence if wrong is empty")
            }
        }
        if (conf == 0)
            addfinding("PRD005", "assumption_structure", "medium", i, "assumption is missing its Confidence field")
        if (conf > 1)
            addfinding("PRD005", "assumption_structure", "medium", i, "assumption has more than one Confidence field")
        if (cons == 0)
            addfinding("PRD005", "assumption_structure", "medium", i, "assumption is missing its Consequence if wrong field")
        if (cons > 1)
            addfinding("PRD005", "assumption_structure", "medium", i, "assumption has more than one Consequence if wrong field")
        i = j
    }
}

# --- PRD006: documentation audiences -------------------------------------------

function scdocs(    start, end, i, val, parts, n, aud, k, found, dup) {
    start = findheading("## Documentation Scope")
    if (start == 0) {
        addfinding("PRD006", "documentation_scope", "medium", 1, "Documentation Scope section is missing")
        return
    }
    end = sectionend(start)
    DAud[1] = "User docs"
    DAud[2] = "Operator docs"
    DAud[3] = "Contributor docs"
    for (k = 1; k <= 3; k++)
        DFound[DAud[k]] = 0
    for (i = start + 1; i <= end; i++) {
        aud = ""
        if (L[i] ~ /^- User docs: /) aud = "User docs"
        else if (L[i] ~ /^- Operator docs: /) aud = "Operator docs"
        else if (L[i] ~ /^- Contributor docs: /) aud = "Contributor docs"
        else continue
        DFound[aud]++
        if (DFound[aud] > 1) {
            addfinding("PRD006", "documentation_scope", "medium", i, aud " audience appears more than once")
            continue
        }
        val = L[i]
        sub("^- " aud ": ", "", val)
        n = split(val, parts, " — ")
        if (n != 3) {
            addfinding("PRD006", "documentation_scope", "medium", i, aud " entry must be '<decision> — <scope-or-reason> — <verification-claim>'")
            continue
        }
        if (parts[1] != "required" && parts[1] != "not required" && parts[1] != "deferred_by_user") {
            addfinding("PRD006", "documentation_scope", "medium", i, aud " decision must be required, not required, or deferred_by_user")
            continue
        }
        if (parts[1] == "required") {
            if (parts[2] ~ /^[ \t]*$/ || parts[3] ~ /^[ \t]*$/)
                addfinding("PRD006", "documentation_scope", "medium", i, aud " required decision must carry non-empty scope and verification clauses")
        }
    }
    for (k = 1; k <= 3; k++)
        if (DFound[DAud[k]] == 0)
            addfinding("PRD006", "documentation_scope", "medium", start, DAud[k] " audience decision is missing")
}

# --- driver -------------------------------------------------------------------

BEGIN {
    BYTES = initbytes()
    FMAllowed["type"] = 1
    FMAllowed["title"] = 1
    FMAllowed["description"] = 1
    FMAllowed["timestamp"] = 1
    FMAllowed["scope"] = 1
    FMAllowed["author"] = 1
    split("type title description timestamp scope author", FMReq, " ")

    NHigh = 0
    NMed = 0
    NLow = 0
    NF001 = 0
    getline mode
    if (mode == "error") {
        getline code
        getline detail
        getline epath
        getline esha
        emiterror(code, detail, epath, esha)
        exit 0
    }
    if (mode != "lint")
        fail("unknown protocol mode")
    getline path
    getline sha
    getline artfile

    loadfile(artfile)
    buildscan()
    scanplaceholdermarkers()
    scanfrontmatter()
    scanids()
    scanphases()
    scanassumptions()
    scdocs()
    emitresult(path, sha)
    exit 0
}
