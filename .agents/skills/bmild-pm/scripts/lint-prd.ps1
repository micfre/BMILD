# BMILD PRD lint gate, ruleset prd-v1 (Windows-native, PowerShell 5.1).
# Deterministic mechanical checks over one PRD candidate; emits exactly one
# compact bmild-artifact-lint/v1 JSON object on stdout. Every handled result
# exits 0: inspect status/blocking/findings, never the process status.
# Registration binding is Faisal's owner-governed decision (J2), not a
# filesystem guarantee. Behavior mirrors lint-prd.sh; equivalence is enforced
# by tests. PS 5.1 builtins only.
#
#   powershell -File <skill-dir>\scripts\lint-prd.ps1 -root <project-root> -artifact <path-within-root>

param(
    [string]$root = "",
    [string]$artifact = ""
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

if ($root -eq "" -or $artifact -eq "") {
    Emit-ErrorResult "unsupported_invocation" "usage: lint-prd.ps1 -root <project-root> -artifact <path-within-root>" $null $null
}

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Emit-ErrorResult([string]$code, [string]$detail, $path, $sha) {
    $o = New-Object System.Collections.Specialized.OrderedDictionary
    $o["schema_version"] = "bmild-artifact-lint/v1"
    $o["ruleset"] = "prd-v1"
    $art = New-Object System.Collections.Specialized.OrderedDictionary
    if ($null -eq $path) { $art["path"] = $null } else { $art["path"] = [string]$path }
    if ($null -eq $sha) { $art["sha256"] = $null } else { $art["sha256"] = [string]$sha }
    $o["artifact"] = $art
    $o["status"] = "error"
    $o["blocking"] = $true
    $o["total_findings"] = 0
    $o["by_severity"] = @{ high = 0; medium = 0; low = 0 }
    $o["findings"] = @()
    $o["error"] = @{ code = $code; detail = $detail }
    $o | ConvertTo-Json -Compress -Depth 5
    exit 0
}

# --- argument handling ---------------------------------------------------------

if (-not (Test-Path -LiteralPath $root -PathType Container)) {
    Emit-ErrorResult "unsupported_invocation" "root is not a directory: $root" $artifact $null
}

$a = $artifact -replace '\\', '/'
if ($a -cmatch '^[A-Za-z]:' -or $a.StartsWith('/')) {
    Emit-ErrorResult "unsupported_invocation" "artifact path must be relative to root: $artifact" $artifact $null
}
while ($a.StartsWith('./')) { $a = $a.Substring(2) }
$stack = New-Object System.Collections.ArrayList
foreach ($seg in ($a -split '/')) {
    if ($seg -eq '' -or $seg -eq '.') { continue }
    if ($seg -eq '..') {
        if ($stack.Count -eq 0) {
            Emit-ErrorResult "unsupported_invocation" "artifact path escapes root or is empty: $artifact" $artifact $null
        }
        $stack.RemoveAt($stack.Count - 1) | Out-Null
        continue
    }
    $stack.Add($seg) | Out-Null
}
if ($stack.Count -eq 0) {
    Emit-ErrorResult "unsupported_invocation" "artifact path escapes root or is empty: $artifact" $artifact $null
}
$norm = ($stack -join '/')
$target = Join-Path $root ($stack -join '\')

if (-not (Test-Path -LiteralPath $target)) {
    Emit-ErrorResult "not_found" "artifact not found under root: $norm" $norm $null
}
$item = Get-Item -LiteralPath $target -Force
if ($item -isnot [System.IO.FileInfo] -or $item.Attributes.ToString().Contains('Directory')) {
    Emit-ErrorResult "unreadable" "artifact is not a readable regular file: $norm" $norm $null
}

# --- byte snapshot: SHA-256 from the same bytes the rules inspect ---------------

$bytes = [System.IO.File]::ReadAllBytes($target)
$sha256 = ""
$sha = [System.Security.Cryptography.SHA256]::Create()
try {
    $hash = $sha.ComputeHash($bytes)
    foreach ($b in $hash) { $sha256 += $b.ToString('x2') }
} finally {
    $sha.Dispose()
}

# strict UTF-8 decode: invalid sequences are non_utf8, not a silent drop
$text = $null
try {
    $enc = New-Object System.Text.UTF8Encoding($false, $true)
    $text = $enc.GetString($bytes)
} catch [System.Text.DecoderFallbackException] {
    Emit-ErrorResult "non_utf8" "artifact is not valid UTF-8: $norm" $norm $sha256
}

# --- rules engine ----------------------------------------------------------------

$script:L = $text -split "`n"
# strip the single trailing empty element produced by a final newline
if ($script:L.Count -gt 1 -and $script:L[$script:L.Count - 1] -eq "") {
    $script:L = $script:L[0..($script:L.Count - 2)]
}
if ($script:L.Count -eq 0) { $script:L = @("") }

$script:Findings = New-Object System.Collections.ArrayList
$script:NHigh = 0
$script:NMed = 0
$script:NLow = 0

function Add-Finding([string]$rule, [string]$cat, [string]$sev, [int]$line, [string]$detail) {
    $f = New-Object System.Collections.Specialized.OrderedDictionary
    $f["rule_id"] = $rule
    $f["category"] = $cat
    $f["severity"] = $sev
    $f["detail"] = $detail
    $f["_line"] = $line
    $f["_seq"] = $script:Findings.Count
    $script:Findings.Add($f) | Out-Null
    switch ($sev) {
        'high' { $script:NHigh++ }
        'medium' { $script:NMed++ }
        default { $script:NLow++ }
    }
}

function Get-Lines() { return ,$script:L }

function New-Scan() {
    # PRD001 scan text: fences blanked, then inline code spans, then HTML
    # comments; physical line numbers preserved.
    $scan = New-Object System.Collections.ArrayList
    $infence = $false
    $incomment = $false
    for ($i = 0; $i -lt $script:L.Count; $i++) {
        $line = $script:L[$i]
        if ($infence) {
            if ($line -match '^[ \t]*```+') { $infence = $false }
            $scan.Add((' ' * $line.Length)) | Out-Null
            continue
        }
        if ($line -match '^[ \t]*```+') {
            $infence = $true
            $scan.Add((' ' * $line.Length)) | Out-Null
            continue
        }
        $out = New-Object System.Text.StringBuilder
        $incode = $false
        for ($j = 0; $j -lt $line.Length; $j++) {
            $c = $line[$j]
            if ($incomment) {
                [void]$out.Append(' ')
                if ($c -eq '>' -and $j -gt 0 -and $line[$j - 1] -eq '-') {
                    # only closes on "-->"; the '-' we already masked was the second
                    if ($j -gt 1 -and $line[$j - 2] -eq '-') { $incomment = $false }
                }
                continue
            }
            if ($incode) {
                [void]$out.Append(' ')
                if ($c -eq '`') { $incode = $false }
                continue
            }
            if ($c -eq '`') {
                [void]$out.Append(' ')
                $incode = $true
                continue
            }
            if ($c -eq '<' -and $j -le $line.Length - 4 -and $line.Substring($j, 4) -eq '<!--') {
                [void]$out.Append('    ')
                $j += 3
                $incomment = $true
                continue
            }
            [void]$out.Append($c)
        }
        $scan.Add($out.ToString()) | Out-Null
    }
    return ,$scan
}

function Invoke-Prd001($scan) {
    $markers = @('TBD', 'TODO', 'FIXME', 'XXX')
    $wordChars = [System.Text.RegularExpressions.Regex]::new('[A-Za-z0-9_]')
    for ($i = 0; $i -lt $scan.Count; $i++) {
        $s = $scan[$i]
        foreach ($mk in $markers) {
            $from = 0
            while ($true) {
                $pos = $s.IndexOf($mk, $from, [System.StringComparison]::Ordinal)
                if ($pos -lt 0) { break }
                $okBefore = ($pos -eq 0) -or (-not $wordChars.IsMatch([string]$s[$pos - 1]))
                $afterIx = $pos + $mk.Length
                $okAfter = ($afterIx -ge $s.Length) -or (-not $wordChars.IsMatch([string]$s[$afterIx]))
                if ($okBefore -and $okAfter) {
                    Add-Finding 'PRD001' 'placeholder' 'high' ($i + 1) "placeholder marker '$mk'"
                }
                $from = $pos + $mk.Length
            }
        }
    }
    $phFile = Join-Path $PSScriptRoot 'prd-v1-placeholders.txt'
    foreach ($lit0 in (Get-Content -LiteralPath $phFile -Encoding UTF8)) {
        $lit = $lit0.TrimEnd("`r")
        if ($lit -eq '' -or $lit.StartsWith('#')) { continue }
        for ($i = 0; $i -lt $scan.Count; $i++) {
            if ($scan[$i].IndexOf($lit, [System.StringComparison]::Ordinal) -ge 0) {
                Add-Finding 'PRD001' 'placeholder' 'high' ($i + 1) "template placeholder '$lit'"
            }
        }
    }
}

function ConvertFrom-FrontmatterValue([string]$v) {
    if ($v.Length -ge 2 -and $v[0] -eq '"' -and $v[$v.Length - 1] -eq '"') {
        return $v.Substring(1, $v.Length - 2)
    }
    return $v
}

function Test-ValidDate([string]$v) {
    if ($v -notmatch '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$') { return $false }
    try {
        [void][datetime]::ParseExact($v, 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture)
        return $true
    } catch {
        return $false
    }
}

function Invoke-Prd002() {
    $L = $script:L
    if ($L[0] -cne '---') {
        Add-Finding 'PRD002' 'frontmatter' 'high' 1 "frontmatter must open with an exact '---' line"
        return
    }
    $close = -1
    for ($i = 1; $i -lt $L.Count; $i++) {
        if ($L[$i] -ceq '---') { $close = $i; break }
    }
    if ($close -lt 1) {
        Add-Finding 'PRD002' 'frontmatter' 'high' 1 "frontmatter is not closed by an exact '---' line"
        return
    }
    $allowed = @('type', 'title', 'description', 'timestamp', 'scope', 'author')
    $fmLine = @{}
    $fmVal = @{}
    for ($i = 1; $i -lt $close; $i++) {
        if ($L[$i] -match '^[ \t]*$') { continue }
        if ($L[$i] -cmatch '^([A-Za-z_][A-Za-z0-9_]*):[ \t]*(.*)$') {
            $key = $Matches[1]
            $val = $Matches[2]
            if ($allowed -notcontains $key) {
                Add-Finding 'PRD002' 'frontmatter' 'high' ($i + 1) "frontmatter key '$key' is not a template scalar field"
                continue
            }
            if ($fmLine.ContainsKey($key)) {
                Add-Finding 'PRD002' 'frontmatter' 'high' ($i + 1) "frontmatter key '$key' appears more than once"
                continue
            }
            $fmLine[$key] = $i + 1
            $fmVal[$key] = ConvertFrom-FrontmatterValue $val
        } else {
            Add-Finding 'PRD002' 'frontmatter' 'high' ($i + 1) 'frontmatter accepts only flat scalar fields; malformed line'
        }
    }
    $missing = @($allowed | Where-Object { -not $fmLine.ContainsKey($_) })
    if ($missing.Count -gt 0) {
        Add-Finding 'PRD002' 'frontmatter' 'high' 1 ("missing required frontmatter keys: " + ($missing -join ', '))
    }
    if ($fmLine.ContainsKey('type') -and $fmVal['type'] -cne 'PRD') {
        Add-Finding 'PRD002' 'frontmatter' 'high' $fmLine['type'] "frontmatter key 'type' must equal 'PRD'"
    }
    foreach ($k in @('title', 'description', 'author')) {
        if ($fmLine.ContainsKey($k) -and $fmVal[$k] -eq '') {
            Add-Finding 'PRD002' 'frontmatter' 'high' $fmLine[$k] "frontmatter key '$k' must be non-empty"
        }
    }
    if ($fmLine.ContainsKey('timestamp') -and $fmVal['timestamp'] -ne '' -and -not (Test-ValidDate $fmVal['timestamp'])) {
        Add-Finding 'PRD002' 'frontmatter' 'high' $fmLine['timestamp'] 'timestamp is not a valid YYYY-MM-DD date'
    }
    if ($fmLine.ContainsKey('scope') -and $fmVal['scope'] -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
        Add-Finding 'PRD002' 'frontmatter' 'high' $fmLine['scope'] 'scope must match ^[a-z0-9]+(-[a-z0-9]+)*$'
    }
}

function Invoke-Prd003() {
    $L = $script:L
    $seen = @{}
    $expF = 0
    $expJ = 0
    $firstF = 0
    $firstJ = 0
    $frDef = New-Object System.Collections.ArrayList
    $jDef = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt $L.Count; $i++) {
        if ($L[$i] -cmatch '^- FR([1-9][0-9]*): ') {
            $n = [int]$Matches[1]
            if ($seen.ContainsKey("FR$n")) {
                Add-Finding 'PRD003' 'id_continuity' 'high' ($i + 1) "duplicate FR ID: FR$n"
            } else {
                $seen["FR$n"] = $true
                $frDef.Add($n) | Out-Null
                if ($expF -eq 0 -and $n -ne 1 -and $firstF -eq 0) { $firstF = $i + 1 }
                if ($expF -gt 0 -and $n -ne $expF -and $firstF -eq 0) { $firstF = $i + 1 }
                $expF = $n + 1
            }
        } elseif ($L[$i] -cmatch '^- J([1-9][0-9]*) — Journey: ') {
            $n = [int]$Matches[1]
            if ($seen.ContainsKey("J$n")) {
                Add-Finding 'PRD003' 'id_continuity' 'high' ($i + 1) "duplicate journey ID: J$n"
            } else {
                $seen["J$n"] = $true
                $jDef.Add($n) | Out-Null
                if ($expJ -eq 0 -and $n -ne 1 -and $firstJ -eq 0) { $firstJ = $i + 1 }
                if ($expJ -gt 0 -and $n -ne $expJ -and $firstJ -eq 0) { $firstJ = $i + 1 }
                $expJ = $n + 1
            }
        }
    }
    if ($firstF -gt 0) {
        Add-Finding 'PRD003' 'id_continuity' 'medium' $firstF 'FR IDs must start at 1 and ascend contiguously'
    }
    if ($firstJ -gt 0) {
        Add-Finding 'PRD003' 'id_continuity' 'medium' $firstJ 'journey IDs must start at 1 and ascend contiguously'
    }
    return @{ fr = $frDef; j = $jDef; seen = $seen }
}

function Invoke-Prd004($ids) {
    $L = $script:L
    $start = -1
    for ($i = 0; $i -lt $L.Count; $i++) {
        if ($L[$i] -ceq '## Scope & Prioritization') { $start = $i; break }
    }
    $firstinc = 1
    $includes = @()
    if ($start -ge 0) {
        $end = $L.Count - 1
        for ($i = $start + 1; $i -lt $L.Count; $i++) {
            if ($L[$i] -cmatch '^## ') { $end = $i - 1; break }
        }
        $phase = ''
        for ($i = $start + 1; $i -le $end; $i++) {
            if ($L[$i] -cmatch '^- \*\*.*:\*\* ' -or $L[$i] -cmatch '^- \*\*.*:\*\*[ \t]*$') {
                $phase = $L[$i]
                continue
            }
            if ($L[$i] -cmatch '^  - Includes: ' -and $phase -ne '') {
                $includes += @{ line = $i + 1; value = $L[$i] -creplace '^  - Includes: ', '' }
            }
        }
        if ($includes.Count -gt 0) { $firstinc = $includes[0].line } else { $firstinc = $start + 1 }
    }
    $member = @{}
    $repeatAt = @{}
    foreach ($inc in $includes) {
        foreach ($tok0 in ($inc.value -split ',')) {
            $s = $tok0.Trim()
            if ($s -eq '') {
                Add-Finding 'PRD004' 'phase_traceability' 'high' $inc.line 'empty token in Includes list'
                continue
            }
            if ($s -cnotmatch '^(FR|J)[1-9][0-9]*(-(FR|J)[1-9][0-9]*)?$') {
                Add-Finding 'PRD004' 'phase_traceability' 'high' $inc.line "malformed Includes token '$s'"
                continue
            }
            if ($s.Substring(0, 1) -ceq 'F') { $fam = 'FR' } else { $fam = 'J' }
            if ($fam -eq 'FR') { $rest = $s.Substring(2) } else { $rest = $s.Substring(1) }
            $dash = $rest.IndexOf('-')
            $a = 0
            $b = 0
            if ($dash -ge 0) {
                $tail = $rest.Substring($dash + 1)
                if ($fam -eq 'FR') { $tailpfx = $tail.Substring(0, 2) } else { $tailpfx = $tail.Substring(0, 1) }
                if ($tailpfx -cne $fam) {
                    Add-Finding 'PRD004' 'phase_traceability' 'high' $inc.line "cross-family range '$s'"
                    continue
                }
                $a = [int]$rest.Substring(0, $dash)
                if ($fam -eq 'FR') { $b = [int]$tail.Substring(2) } else { $b = [int]$tail.Substring(1) }
                if ($b -lt $a) {
                    Add-Finding 'PRD004' 'phase_traceability' 'high' $inc.line "reversed range '$s'"
                    continue
                }
            } else {
                $a = [int]$rest
                $b = $a
            }
            for ($n = $a; $n -le $b; $n++) {
                if (-not $ids.seen.ContainsKey("$fam$n")) {
                    Add-Finding 'PRD004' 'phase_traceability' 'high' $inc.line "unresolved reference '$fam$n'"
                    continue
                }
                $k = "$fam$n"
                if ($member.ContainsKey($k)) {
                    $member[$k]++
                    $repeatAt[$k] = $inc.line
                } else {
                    $member[$k] = 1
                }
            }
        }
    }
    foreach ($n in $ids.fr) {
        if (-not $member.ContainsKey("FR$n")) {
            Add-Finding 'PRD004' 'phase_traceability' 'medium' $firstinc "FR$n is not included in any committed phase"
        }
    }
    foreach ($n in $ids.j) {
        if (-not $member.ContainsKey("J$n")) {
            Add-Finding 'PRD004' 'phase_traceability' 'medium' $firstinc "J$n is not included in any committed phase"
        }
    }
    foreach ($n in $ids.fr) {
        if ($member.ContainsKey("FR$n") -and $member["FR$n"] -gt 1) {
            Add-Finding 'PRD004' 'phase_traceability' 'medium' $repeatAt["FR$n"] "FR$n is included in more than one committed phase"
        }
    }
    foreach ($n in $ids.j) {
        if ($member.ContainsKey("J$n") -and $member["J$n"] -gt 1) {
            Add-Finding 'PRD004' 'phase_traceability' 'medium' $repeatAt["J$n"] "J$n is included in more than one committed phase"
        }
    }
}

function Invoke-Prd005() {
    $L = $script:L
    $i = 0
    while ($i -lt $L.Count) {
        if ($L[$i] -cnotmatch '^- \*\*Assumption:\*\* ') { $i++; continue }
        $text = $L[$i] -creplace '^- \*\*Assumption:\*\* ', ''
        if ($text.Trim() -eq '') {
            Add-Finding 'PRD005' 'assumption_structure' 'medium' ($i + 1) 'assumption text is empty'
        }
        $conf = 0
        $cons = 0
        $j = $i + 1
        for (; $j -lt $L.Count; $j++) {
            if ($L[$j] -cmatch '^- \*\*Assumption:\*\* ' -or $L[$j] -cmatch '^## ') { break }
            $t = $L[$j] -creplace '^[ \t]*- ', ''
            if ($t -cmatch '^Confidence: ') {
                $conf++
                if ($conf -eq 1) {
                    $v = $t -creplace '^Confidence: ', ''
                    if ($v -cne 'Low' -and $v -cne 'Medium' -and $v -cne 'High') {
                        Add-Finding 'PRD005' 'assumption_structure' 'medium' ($i + 1) 'Confidence must be Low, Medium, or High'
                    }
                }
            } elseif ($t -cmatch '^Consequence if wrong: ') {
                $cons++
                if ($cons -eq 1) {
                    $v = $t -creplace '^Consequence if wrong: ', ''
                    if ($v.Trim() -eq '') {
                        Add-Finding 'PRD005' 'assumption_structure' 'medium' ($i + 1) 'Consequence if wrong is empty'
                    }
                }
            }
        }
        if ($conf -eq 0) {
            Add-Finding 'PRD005' 'assumption_structure' 'medium' ($i + 1) 'assumption is missing its Confidence field'
        }
        if ($conf -gt 1) {
            Add-Finding 'PRD005' 'assumption_structure' 'medium' ($i + 1) 'assumption has more than one Confidence field'
        }
        if ($cons -eq 0) {
            Add-Finding 'PRD005' 'assumption_structure' 'medium' ($i + 1) 'assumption is missing its Consequence if wrong field'
        }
        if ($cons -gt 1) {
            Add-Finding 'PRD005' 'assumption_structure' 'medium' ($i + 1) 'assumption has more than one Consequence if wrong field'
        }
        $i = $j
    }
}

function Invoke-Prd006() {
    $L = $script:L
    $start = -1
    for ($i = 0; $i -lt $L.Count; $i++) {
        if ($L[$i] -ceq '## Documentation Scope') { $start = $i; break }
    }
    if ($start -lt 0) {
        Add-Finding 'PRD006' 'documentation_scope' 'medium' 1 'Documentation Scope section is missing'
        return
    }
    $end = $L.Count - 1
    for ($i = $start + 1; $i -lt $L.Count; $i++) {
        if ($L[$i] -cmatch '^## ') { $end = $i - 1; break }
    }
    $auds = @('User docs', 'Operator docs', 'Contributor docs')
    $found = @{}
    foreach ($a0 in $auds) { $found[$a0] = 0 }
    for ($i = $start + 1; $i -le $end; $i++) {
        $aud = $null
        foreach ($a0 in $auds) {
            if ($L[$i] -cmatch ("^- " + [regex]::Escape($a0) + ": ")) { $aud = $a0; break }
        }
        if ($null -eq $aud) { continue }
        $found[$aud]++
        if ($found[$aud] -gt 1) {
            Add-Finding 'PRD006' 'documentation_scope' 'medium' ($i + 1) "$aud audience appears more than once"
            continue
        }
        $val = $L[$i] -creplace ("^- " + [regex]::Escape($aud) + ": "), ''
        $parts = @($val -csplit ' — ')
        if ($parts.Count -ne 3) {
            Add-Finding 'PRD006' 'documentation_scope' 'medium' ($i + 1) "$aud entry must be '<decision> — <scope-or-reason> — <verification-claim>'"
            continue
        }
        if ($parts[0] -cne 'required' -and $parts[0] -cne 'not required' -and $parts[0] -cne 'deferred_by_user') {
            Add-Finding 'PRD006' 'documentation_scope' 'medium' ($i + 1) "$aud decision must be required, not required, or deferred_by_user"
            continue
        }
        if ($parts[0] -ceq 'required' -and ($parts[1].Trim() -eq '' -or $parts[2].Trim() -eq '')) {
            Add-Finding 'PRD006' 'documentation_scope' 'medium' ($i + 1) "$aud required decision must carry non-empty scope and verification clauses"
        }
    }
    foreach ($a0 in $auds) {
        if ($found[$a0] -eq 0) {
            Add-Finding 'PRD006' 'documentation_scope' 'medium' ($start + 1) "$a0 audience decision is missing"
        }
    }
}

# --- run ---------------------------------------------------------------------------

$scan = New-Scan
Invoke-Prd001 $scan
Invoke-Prd002
$ids = Invoke-Prd003
Invoke-Prd004 $ids
Invoke-Prd005
Invoke-Prd006

$script:Findings = @($script:Findings | Sort-Object -Property @{ Expression = { $_["_line"] } }, @{ Expression = { $_["rule_id"] } }, @{ Expression = { $_["_seq"] } })

$out = New-Object System.Collections.Specialized.OrderedDictionary
$out["schema_version"] = "bmild-artifact-lint/v1"
$out["ruleset"] = "prd-v1"
$art = New-Object System.Collections.Specialized.OrderedDictionary
$art["path"] = $norm
$art["sha256"] = $sha256
$out["artifact"] = $art
if ($script:Findings.Count -gt 0) {
    $out["status"] = 'findings'
    $out["blocking"] = ($script:NHigh + $script:NMed -gt 0)
} else {
    $out["status"] = 'clean'
    $out["blocking"] = $false
}
$out["total_findings"] = $script:Findings.Count
$out["by_severity"] = @{ high = $script:NHigh; medium = $script:NMed; low = $script:NLow }
$findingsOut = @()
foreach ($f in $script:Findings) {
    $fo = New-Object System.Collections.Specialized.OrderedDictionary
    $fo["rule_id"] = $f["rule_id"]
    $fo["category"] = $f["category"]
    $fo["severity"] = $f["severity"]
    $fo["detail"] = $f["detail"]
    $lo = New-Object System.Collections.Specialized.OrderedDictionary
    $lo["path"] = $norm
    $lo["line"] = $f["_line"]
    $fo["location"] = $lo
    $findingsOut += $fo
}
$out["findings"] = $findingsOut
$out | ConvertTo-Json -Compress -Depth 5
exit 0
