# BMILD elicitation method catalog server (Windows-native, PowerShell 5.1).
# Serves bounded projections of resources/methods.yaml so an elicitation
# session never loads the full catalog into context except on an explicit
# list-all. Behavior mirrors methods.sh exactly; equivalence is enforced by
# tests. PS 5.1 builtins only: no ternary, no null-coalescing (??), no
# -AsByteStream. Invoke as:
#
#   powershell -File <skill-dir>\scripts\methods.ps1 categories
#   powershell -File <skill-dir>\scripts\methods.ps1 list -category <c> [-category <d>]
#   powershell -File <skill-dir>\scripts\methods.ps1 list -all
#   powershell -File <skill-dir>\scripts\methods.ps1 cast
#   powershell -File <skill-dir>\scripts\methods.ps1 show <name-or-num> [...]
#   powershell -File <skill-dir>\scripts\methods.ps1 random -n <1-12> [-spread]
#          [-exclude <method-name>] ... [-seed <n>]
#
# Exit codes: 0 served (including insufficient_diversity results);
# 1 nothing matched; 2 usage or catalog failure.

param()
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$script:GistMax = 180
$script:ListMax = 24
$script:ShowMax = 4
$script:RandMax = 12

function Fail([string]$msg) {
    [Console]::Error.WriteLine("error: $msg")
    exit 2
}

function Usage() {
    $lines = Get-Content -LiteralPath $PSCommandPath -Encoding UTF8
    foreach ($line in $lines[1..($lines.Count - 1)]) {
        if ($line -notmatch '^#') { break }
        if ($line.Length -gt 1) { [Console]::Error.WriteLine($line.Substring(2)) }
    }
    exit 2
}

# Code-point truncation: .NET string Length counts UTF-16 units, which equals
# code points for the BMP text this catalog carries.
function Get-Gist([string]$d) {
    $s = ($d -replace "[`r`n`t]+", " ")
    if ($s.Length -le $script:GistMax) { return $s }
    $keep = ""
    $lastSpace = 0
    $cps = 0
    foreach ($ch in $s.ToCharArray()) {
        $cps++
        if ($cps -gt $script:GistMax) { break }
        $keep += $ch
        if ($ch -eq ' ') { $lastSpace = $cps }
    }
    if ($lastSpace -gt 1) {
        $keep = $s.Substring(0, $lastSpace - 1)
    }
    return $keep.TrimEnd() + "..."
}

function Get-Catalog() {
    $catalog = Join-Path $PSScriptRoot "..\resources\methods.yaml"
    if (-not (Test-Path -LiteralPath $catalog -PathType Leaf)) {
        Fail "catalog not found: $catalog"
    }
    $records = New-Object System.Collections.ArrayList
    $rec = $null
    $pending = $null
    $ln = 0
    foreach ($line in (Get-Content -LiteralPath $catalog -Encoding UTF8)) {
        $ln++
        if ($line -match '^#') { continue }
        if ($line -match '^[ \t]*$') { continue }
        if ($line -match '^- num:[ \t]*([0-9]+)[ \t]*$') {
            if ($rec -ne $null) { $records.Add($rec) | Out-Null }
            $rec = @{ num = $Matches[1]; category = $null; method_name = $null; description = $null; output_pattern = $null; persona_cast = $null }
            $pending = $null
            continue
        }
        if ($rec -eq $null) {
            Fail "catalog line ${ln}: expected '- num: <n>' record start, got: $line"
        }
        if ($line -match '^    ([^ \t].*)$') {
            if ($pending -eq $null) {
                Fail "catalog line ${ln}: continuation outside a block field: $line"
            }
            if ($rec[$pending]) {
                $rec[$pending] = $rec[$pending] + "`n" + $Matches[1]
            } else {
                $rec[$pending] = $Matches[1]
            }
            continue
        }
        if ($line -match '^  ([a-z_]+):[ \t]*(.*)$') {
            $k = $Matches[1]
            $v = $Matches[2].TrimEnd()
            $allowed = @('num', 'category', 'method_name', 'description', 'output_pattern', 'persona_cast')
            if ($allowed -notcontains $k) {
                Fail "record $($rec.num): unknown field '$k' at catalog line $ln"
            }
            if ($rec[$k] -ne $null) {
                Fail "record $($rec.num): duplicate field '$k' at catalog line $ln"
            }
            $pending = $null
            if ($v -eq '|') { $pending = $k; continue }
            if ($v -match '[\x00-\x1F\x7F]') {
                Fail "record $($rec.num): control character in field '$k'"
            }
            $rec[$k] = $v
            continue
        }
        Fail "unrecognized catalog line ${ln}: $line"
    }
    if ($rec -ne $null) { $records.Add($rec) | Out-Null }
    if ($records.Count -eq 0) { Fail "catalog contains no records" }
    return , $records
}

function Test-Records($records) {
    $seenNum = @{}
    for ($i = 0; $i -lt $records.Count; $i++) {
        $r = $records[$i]
        if ($r.category -eq $null -or $r.method_name -eq $null -or $r.description -eq $null -or $r.output_pattern -eq $null) {
            Fail "record $($r.num): missing one of num/category/method_name/description/output_pattern"
        }
        if ($r.num -notmatch '^[0-9]+$') { Fail "record $($r.num): invalid num" }
        $n = [int]$r.num
        if ($n -lt 1) { Fail "record $($r.num): num must be positive" }
        if ($seenNum.ContainsKey($n)) { Fail "duplicate num $n ($($records[$seenNum[$n]].method_name) and $($r.method_name))" }
        $seenNum[$n] = $i
    }
}

function Get-RandomInt([int]$maxExclusive) {
    # Uniform draw in [0, maxExclusive) with a repeatable seed when supplied.
    if ($script:Rng -ne $null) { return $script:Rng.Next($maxExclusive) }
    return Get-Random -Maximum $maxExclusive
}

function Invoke-SpreadDraw($rows, [int]$n) {
    # Round-robin over shuffled category buckets: one method per category per
    # round until n picks or the pool is exhausted. Mirrors the awk path.
    $buckets = @{}
    foreach ($r in $rows) {
        if (-not $buckets.ContainsKey($r.category)) { $buckets[$r.category] = New-Object System.Collections.ArrayList }
        $buckets[$r.category].Add($r) | Out-Null
    }
    $order = @($buckets.Keys | Sort-Object { Get-RandomInt 1000000 })
    $picked = New-Object System.Collections.ArrayList
    while ($picked.Count -lt $n) {
        $progressed = $false
        foreach ($c in $order) {
            if ($picked.Count -ge $n) { break }
            $b = $buckets[$c]
            if ($b.Count -eq 0) { continue }
            $j = Get-RandomInt $b.Count
            $picked.Add($b[$j]) | Out-Null
            $b.RemoveAt($j)
            $progressed = $true
        }
        if (-not $progressed) { break }
    }
    return $picked
}

function Out-CompactRow($r) {
    "{0}`t{1}`t{2}`t{3}" -f [int]$r.num, $r.category, $r.method_name, (Get-Gist $r.description)
}

function Out-FullRecord($r) {
    "# {0} | {1} | {2}" -f [int]$r.num, $r.category, $r.method_name
    $descLines = $r.description -split "`n", -1
    if ($descLines.Count -eq 1) {
        "description: " + $descLines[0]
    } else {
        "description:"
        foreach ($d in $descLines) { "  " + $d }
    }
    "output_pattern: " + $r.output_pattern
    if ($r.persona_cast -eq 'true') {
        "# persona-cast method: load each participating persona's canonical sibling SOUL.md before executing"
    }
    ""
}

$script:Rng = $null
$records = Get-Catalog
Test-Records $records

if ($args.Count -lt 1) { Usage }
$cmd = [string]$args[0]
$rest = @($args | Select-Object -Skip 1)

switch ($cmd) {
    'categories' {
        if ($rest.Count -gt 0) { Usage }
        $records | Group-Object category | Sort-Object Name | ForEach-Object {
            "{0}`t{1}" -f $_.Name, $_.Count
        }
        exit 0
    }
    'list' {
        $cats = @()
        $all = $false
        for ($i = 0; $i -lt $rest.Count; $i++) {
            switch -Regex ([string]$rest[$i]) {
                '^--category$' {
                    if ($i + 1 -ge $rest.Count) { Usage }
                    $cats += [string]$rest[$i + 1]
                    $i++
                }
                '^--all$' { $all = $true }
                default { Usage }
            }
        }
        if ($all) {
            if ($cats.Count -gt 0) { Usage }
            foreach ($r in ($records | Sort-Object { [int]$_.num })) { Out-CompactRow $r }
            exit 0
        }
        if ($cats.Count -eq 0) { Fail "list needs --category (one or two) or --all" }
        if ($cats.Count -gt 2) { Fail "list accepts at most two categories before primary-method selection" }
        $known = @{}
        foreach ($k in ($records | ForEach-Object { $_.category.ToLower() } | Sort-Object -Unique)) { $known[$k] = $true }
        $want = @{}
        foreach ($c in $cats) {
            $cl = $c.ToLower()
            if (-not $known.ContainsKey($cl)) { Fail "unknown category '$cl' (run 'categories' for the list)" }
            $want[$cl] = $true
        }
        $matched = @($records | Where-Object { $want.ContainsKey($_.category.ToLower()) } | Sort-Object { [int]$_.num })
        if ($matched.Count -gt $script:ListMax) {
            Fail "scoped index would return $($matched.Count) rows (bound $($script:ListMax)); narrow to one category or use random --spread"
        }
        foreach ($r in $matched) { Out-CompactRow $r }
        exit 0
    }
    'cast' {
        if ($rest.Count -gt 0) { Usage }
        foreach ($r in ($records | Where-Object { $_.persona_cast -eq 'true' } | Sort-Object { [int]$_.num })) { Out-CompactRow $r }
        exit 0
    }
    'show' {
        if ($rest.Count -lt 1) { Usage }
        if ($rest.Count -gt $script:ShowMax) {
            Fail "show accepts at most $($script:ShowMax) methods per selection round (one primary plus follow-ups)"
        }
        $found = New-Object System.Collections.ArrayList
        $foundNums = @{}
        $rc = 0
        foreach ($keyRaw in $rest) {
            $key = ([string]$keyRaw).Trim()
            $rec = $null
            if ($key -match '^[0-9]+$') {
                foreach ($r in $records) { if ([int]$r.num -eq [int]$key) { $rec = $r; break } }
            } else {
                $kl = $key.ToLower()
                foreach ($r in $records) { if ($r.method_name.ToLower() -eq $kl) { $rec = $r; break } }
            }
            if ($rec -eq $null) {
                [Console]::Error.WriteLine("# not found: $key")
            } elseif (-not $foundNums.ContainsKey([int]$rec.num)) {
                $foundNums[[int]$rec.num] = $true
                $found.Add($rec) | Out-Null
            }
        }
        foreach ($r in $found) { Out-FullRecord $r }
        if ($found.Count -eq 0) { exit 1 }
        exit 0
    }
    'random' {
        $n = $null
        $spread = $false
        $seed = $null
        $excludes = @()
        for ($i = 0; $i -lt $rest.Count; $i++) {
            switch -Regex ([string]$rest[$i]) {
                '^-n$' {
                    if ($i + 1 -ge $rest.Count) { Usage }
                    $n = [string]$rest[$i + 1]
                    $i++
                }
                '^--spread$' { $spread = $true }
                '^--seed$' {
                    if ($i + 1 -ge $rest.Count) { Usage }
                    $seed = [string]$rest[$i + 1]
                    $i++
                }
                '^--exclude$' {
                    if ($i + 1 -ge $rest.Count) { Usage }
                    $excludes += ([string]$rest[$i + 1]).Trim().ToLower()
                    $i++
                }
                default { Usage }
            }
        }
        if ($n -eq $null) { Usage }
        if ($n -notmatch '^[0-9]+$' -or [int]$n -lt 1) { Fail "random -n must be a positive integer" }
        $n = [int]$n
        if ($n -gt $script:RandMax) { Fail "random -n is bounded to $($script:RandMax); requests above $($script:RandMax) are rejected without returning records" }
        if ($seed -ne $null) {
            if ($seed -notmatch '^[0-9]+$') { Usage }
            $script:Rng = New-Object System.Random([int]$seed)
        }
        $pool = @($records | Where-Object { $excludes -notcontains $_.method_name.ToLower() })
        if ($pool.Count -eq 0) {
            [Console]::Error.WriteLine("# no methods match")
            exit 1
        }
        $distinct = @($pool | ForEach-Object { $_.category } | Sort-Object -Unique).Count
        if ($pool.Count -lt 2 -or $distinct -lt 2) {
            "# insufficient_diversity: pool has $($pool.Count) methods across $distinct categories"
            $limit = [Math]::Min($n, $pool.Count)
            foreach ($r in ($pool | Sort-Object { [int]$_.num } | Select-Object -First $limit)) { Out-CompactRow $r }
            exit 0
        }
        if ($n -gt $pool.Count) { $n = $pool.Count }
        if (-not $spread) {
            $order = New-Object System.Collections.ArrayList
            $idx = New-Object System.Collections.ArrayList
            for ($i = 0; $i -lt $pool.Count; $i++) { $idx.Add($i) | Out-Null }
            for ($i = 0; $i -lt $n; $i++) {
                $j = Get-RandomInt $idx.Count
                $order.Add($pool[$idx[$j]]) | Out-Null
                $idx.RemoveAt($j)
            }
            foreach ($r in $order) { Out-CompactRow $r }
            exit 0
        }
        foreach ($r in (Invoke-SpreadDraw $pool $n)) { Out-CompactRow $r }
        exit 0
    }
    default { Usage }
}
