# BMILD slice-budget estimator (PowerShell 5.1) — peak_live_v2.
# Predicts peak live context occupancy for an implementation session under
# code-intel / LSP workflows (full contract reads + capped symbol excerpts).
# Emits TSV with fixed sections matching run-budget-slice.sh. PS 5.1 builtins
# only: no -AsByteStream, no ternary, no null-coalescing. Algorithm mirrors
# the POSIX script exactly; equivalence enforced by tests.
# Plain param() (no [CmdletBinding()]): advanced binding rejects the manual
# argv-walk pass-through flags.
param()
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$script:TAB = [char]9
$script:NL = [char]10

# --- user-configurable defaults ---
$script:DEFAULT_TARGET = 170000
$script:DEFAULT_BASE = 15000
$script:DEFAULT_MULTIPLIER = 1.0

# --- peak_live_v2 internal constants ---
$script:MODEL_ID = 'peak_live_v2'
$script:BYTES_PER_TOKEN = 4
$script:TURN_RESERVE = 20000
$script:SYMBOL_READ_CAP = 2500
$script:SYMBOL_EDIT_CAP = 5000
$script:ITEM_OVERHEAD = 500

$script:CFG_TARGET = $script:DEFAULT_TARGET
$script:CFG_BASE = $script:DEFAULT_BASE
$script:CFG_MULTIPLIER = $script:DEFAULT_MULTIPLIER

$script:OF_TARGET = $null
$script:OF_BASE = $null
$script:OF_MULTIPLIER = $null

$script:NEW_SET = 0
$script:NEW_VAL = $null
$script:src = ""
$script:NEW_AVG_BYTES = 0
$script:NEW_AVG_RAW = 0
$script:NEW_EST_RAW = 0
$script:NEW_MEASURED = $false

$script:reads_n = 0
$script:edits_n = 0
$script:mode = 'full_read'
$script:records = New-Object System.Collections.ArrayList
$script:skipped = New-Object System.Collections.ArrayList
$script:pen = @{}
$script:seenPaths = @{}
$script:legacyKeys = New-Object System.Collections.ArrayList

$script:out = New-Object System.Text.StringBuilder

function Fail-Budget([string]$msg) {
    [Console]::Error.WriteLine("Error: $msg")
    exit 1
}

function Show-Usage {
    $u = "Usage: run-budget-slice.ps1 [options]"
    $u += $script:NL + $script:NL + "Estimate peak live context tokens for one implementation Slice (peak_live_v2)."
    $u += $script:NL + "Assumes code-intelligence / LSP workflows: contracts and docs are full-file"
    $u += $script:NL + "context; source navigation is capped symbol excerpts. Output is TSV with"
    $u += $script:NL + "fixed sections: STATUS, BUDGET, READS, EDITS, SKIPPED_READS, SKIPPED_EDITS,"
    $u += $script:NL + "SKIPPED_NEW, NEW_FILE_ESTIMATE."
    $u += $script:NL + $script:NL + "Options:"
    $u += $script:NL + "  --target <int>           token budget override (slice_target)"
    $u += $script:NL + "  --base <int>             mandatory-context overhead override (tokenizer_base)"
    $u += $script:NL + "  --multiplier <float>     residual safety margin override (tokenizer_multiplier)"
    $u += $script:NL + "  --full-reads <path>...   switch to full-read mode; collect full-file reads"
    $u += $script:NL + "  --symbol-reads <path>... switch to symbol-read mode; collect capped excerpts"
    $u += $script:NL + "  --full-edits <path>...   switch to full-edit mode; collect full-file edits"
    $u += $script:NL + "  --symbol-edits <path>... switch to symbol-edit mode; collect capped edits"
    $u += $script:NL + "  --reads <path>...        alias for --full-reads (compatibility)"
    $u += $script:NL + "  --edits <path>...        alias for --full-edits (compatibility)"
    $u += $script:NL + "  --new <int>              count of new files to estimate"
    $u += $script:NL + "  --src <path>             representative source dir (required when --new > 0)"
    $u += $script:NL + "  --penalty <path> <float> multiplicative indicator penalty (repeatable)"
    $u += $script:NL + "  -h, --help               show this help and exit"
    $u += $script:NL + $script:NL + "User-facing .bmild.toml keys: slice_target, tokenizer_base, tokenizer_multiplier."
    $u += $script:NL + "Byte/token ratio, turn reserve, symbol caps, and per-item overhead are fixed"
    $u += $script:NL + "by peak_live_v2. Every estimate is an informed guess."
    [Console]::Out.WriteLine($u)
    exit 0
}

function Test-UInt([string]$s) {
    if ($s -eq "") { return $false }
    return $s -match '^[0-9]+$'
}

function Test-Num([string]$s) {
    if ($s -eq "") { return $false }
    $dots = 0
    foreach ($ch in $s.ToCharArray()) {
        if ($ch -ge '0' -and $ch -le '9') { continue }
        if ($ch -eq '.') { $dots++; continue }
        return $false
    }
    return $dots -le 1
}

function Normalize-Path([string]$p) {
    if ($p.Contains([char]9) -or $p.Contains([char]10)) {
        Fail-Budget "path contains tab or newline: $p"
    }
    if ($p.StartsWith('-')) { return "./" + $p }
    return $p
}

function Find-BmildToml([string]$startDir) {
    $d = $startDir
    while ($true) {
        $c = Join-Path $d ".bmild.toml"
        if (Test-Path -LiteralPath $c) { return $c }
        $parent = Split-Path -Parent $d
        if (-not $parent -or $parent -eq $d) {
            $root = Join-Path $d ".bmild.toml"
            if (Test-Path -LiteralPath $root) { return $root }
            return $null
        }
        $d = $parent
    }
}

function Note-Legacy([string]$key) {
    if (-not $script:legacyKeys.Contains($key)) {
        $null = $script:legacyKeys.Add($key)
    }
}

function Read-Config([string]$path) {
    if (-not $path) { return }
    if (-not (Test-Path -LiteralPath $path)) { return }
    foreach ($line in Get-Content -LiteralPath $path) {
        if ($line -notmatch '^\s*([A-Za-z0-9_]+)\s*=\s*(.+?)\s*$') { continue }
        $key = $Matches[1]
        $val = $Matches[2]
        if ($val.Length -ge 2 -and $val.StartsWith('"') -and $val.EndsWith('"')) {
            $val = $val.Substring(1, $val.Length - 2)
        }
        switch ($key) {
            'slice_target' { if (Test-UInt $val) { $script:CFG_TARGET = [int]$val } }
            'tokenizer_base' { if (Test-UInt $val) { $script:CFG_BASE = [int]$val } }
            'tokenizer_multiplier' { if (Test-Num $val) { $script:CFG_MULTIPLIER = [double]$val } }
            'tokenizer_ratio' { Note-Legacy $key }
            'penalty_size_threshold' { Note-Legacy $key }
            'penalty_size_exponent' { Note-Legacy $key }
            'penalty_noise_bpl' { Note-Legacy $key }
            'penalty_noise_factor' { Note-Legacy $key }
            'penalty_cap' { Note-Legacy $key }
            'edit_premium' { Note-Legacy $key }
            'carry_cap' { Note-Legacy $key }
        }
    }
}

function Test-Binary([string]$p) {
    # PS 5.1 path: -Encoding Byte. PS 7 removed it; fall through to .NET read.
    $head = $null
    try {
        $head = Get-Content -LiteralPath $p -Encoding Byte -ReadCount 4096 -TotalCount 4096 -WarningAction SilentlyContinue
    } catch {
        $all = $null
        try { $all = [System.IO.File]::ReadAllBytes($p) } catch { return $false }
        if ($null -eq $all) { return $false }
        if ($all.Length -gt 4096) { $head = $all[0..4095] } else { $head = $all }
    }
    if ($null -eq $head) { return $false }
    foreach ($b in $head) { if ($b -eq 0) { return $true } }
    return $false
}

function Measure-File([string]$path, [string]$role) {
    $p = Normalize-Path $path
    if ($role -eq 'full_read' -or $role -eq 'symbol_read') { $skipRole = 'read' }
    else { $skipRole = 'edit' }
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) {
        $null = $script:skipped.Add([pscustomobject]@{ Role = $skipRole; Path = $p })
        return
    }
    $bytes = (Get-Item -LiteralPath $p -Force).Length
    if (Test-Binary $p) {
        $null = $script:skipped.Add([pscustomobject]@{ Role = $skipRole; Path = $p })
        return
    }
    $lines = 0
    if ($bytes -gt 0) {
        $all = [System.IO.File]::ReadAllBytes($p)
        $nl = 0
        foreach ($b in $all) { if ($b -eq 10) { $nl++ } }
        if ($all[$all.Length - 1] -eq 10) { $lines = $nl } else { $lines = $nl + 1 }
    }
    $null = $script:records.Add([pscustomobject]@{
        Role = $role; Path = $p; Bytes = $bytes; Lines = $lines
        RawOverride = $null
    })
    $script:seenPaths[$p] = 1
}

function Measure-SourceDir([string]$srcDir) {
    if (-not (Test-Path -LiteralPath $srcDir -PathType Container)) { return 'fail' }
    $items = Get-ChildItem -LiteralPath $srcDir -Recurse -File -Force -ErrorAction SilentlyContinue
    $sum = [long]0; $cnt = 0; $found = $false
    if ($null -ne $items) {
        foreach ($f in $items) {
            if (Test-Binary $f.FullName) { continue }
            $sum += $f.Length; $cnt++; $found = $true
        }
    }
    if (-not $found) { return 'empty' }
    $script:NEW_AVG_BYTES = [int][math]::Floor($sum / $cnt)
    return 'ok'
}

function ConvertTo-Fmt([double]$x) {
    $s = [int][math]::Floor($x * 100 + 0.5)
    $w = [int][math]::Floor($s / 100)
    $f = $s % 100
    if ($f -lt 10) { return ($w.ToString() + ".0" + $f.ToString()) }
    return ($w.ToString() + "." + $f.ToString())
}

function Emit-Row {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Fields)
    if ($null -ne $Fields) { $null = $script:out.Append(($Fields -join $script:TAB)) }
    $null = $script:out.Append($script:NL)
}
function Emit-Line([string]$Line) {
    $null = $script:out.Append($Line); $null = $script:out.Append($script:NL)
}
function Emit-Blank { $null = $script:out.Append($script:NL) }

# --- argument parsing ---
$i = 0
while ($i -lt $args.Count) {
    $a = "$($args[$i])"
    if ($a -eq '--help' -or $a -eq '-h') { Show-Usage }
    elseif ($a -eq '--full-reads' -or $a -eq '--reads') { $script:mode = 'full_read'; $i++ }
    elseif ($a -eq '--symbol-reads') { $script:mode = 'symbol_read'; $i++ }
    elseif ($a -eq '--full-edits' -or $a -eq '--edits') { $script:mode = 'full_edit'; $i++ }
    elseif ($a -eq '--symbol-edits') { $script:mode = 'symbol_edit'; $i++ }
    elseif ($a -eq '--target' -or $a -eq '--base' -or $a -eq '--multiplier') {
        if (($i + 1) -ge $args.Count) { Fail-Budget "$a requires a value" }
        $v = "$($args[$i + 1])"
        switch ($a) {
            '--target' { if (-not (Test-UInt $v)) { Fail-Budget "--target must be a non-negative integer" }; $script:OF_TARGET = [int]$v }
            '--base' { if (-not (Test-UInt $v)) { Fail-Budget "--base must be a non-negative integer" }; $script:OF_BASE = [int]$v }
            '--multiplier' { if (-not (Test-Num $v)) { Fail-Budget "--multiplier must be numeric" }; $script:OF_MULTIPLIER = [double]$v }
        }
        $i += 2
    }
    elseif ($a -eq '--new') {
        if (($i + 1) -ge $args.Count) { Fail-Budget "--new requires a value" }
        $script:NEW_SET = 1; $script:NEW_VAL = "$($args[$i + 1])"; $i += 2
    }
    elseif ($a -eq '--src') {
        if (($i + 1) -ge $args.Count) { Fail-Budget "--src requires a value" }
        $script:src = Normalize-Path "$($args[$i + 1])"; $i += 2
    }
    elseif ($a -eq '--penalty') {
        if (($i + 2) -ge $args.Count) { Fail-Budget "--penalty requires <path> <factor>" }
        $ppath = Normalize-Path "$($args[$i + 1])"
        $pf = "$($args[$i + 2])"
        if (-not (Test-Num $pf)) { Fail-Budget "--penalty factor must be a positive float: $pf" }
        $pfd = [double]$pf
        if ($pfd -le 0) { Fail-Budget "--penalty factor must be positive: $pf" }
        if ($script:pen.ContainsKey($ppath)) { $script:pen[$ppath] = $script:pen[$ppath] * $pfd }
        else { $script:pen[$ppath] = $pfd }
        $i += 3
    }
    elseif ($a.StartsWith('--')) { Fail-Budget "unknown option: $a" }
    else {
        if ($script:mode -eq 'full_read' -or $script:mode -eq 'symbol_read') {
            Measure-File $a $script:mode; $script:reads_n++
        } else {
            Measure-File $a $script:mode; $script:edits_n++
        }
        $i++
    }
}

# --- resolve new-file count ---
if ($script:NEW_SET -eq 1) {
    if (-not (Test-UInt $script:NEW_VAL)) { Fail-Budget "--new must be a non-negative integer" }
    $new_count = [int]$script:NEW_VAL
} else {
    $new_count = 0
}
if ($new_count -gt 0 -and $script:src -eq "") { Fail-Budget "--new requires --src" }
if ($script:reads_n -eq 0 -and $script:edits_n -eq 0 -and $new_count -eq 0) {
    Fail-Budget "no reads, edits, or new files were provided"
}

# --- config + overrides ---
$cfgPath = Find-BmildToml (Get-Location).Path
Read-Config $cfgPath
if ($null -ne $script:OF_TARGET) { $script:CFG_TARGET = $script:OF_TARGET }
if ($null -ne $script:OF_BASE) { $script:CFG_BASE = $script:OF_BASE }
if ($null -ne $script:OF_MULTIPLIER) { $script:CFG_MULTIPLIER = $script:OF_MULTIPLIER }

if ($script:legacyKeys.Count -gt 0) {
    $joined = ($script:legacyKeys -join ' ')
    [Console]::Error.WriteLine("Warning: ignoring legacy .bmild.toml keys ($joined). peak_live_v2 accepts only slice_target, tokenizer_base, tokenizer_multiplier; remove the obsolete keys.")
}

# --- new-file estimation ---
if ($new_count -gt 0) {
    $r = Measure-SourceDir $script:src
    if ($r -eq 'fail') {
        $null = $script:skipped.Add([pscustomobject]@{ Role = 'new'; Path = $script:src })
    } elseif ($r -eq 'ok') {
        $script:NEW_AVG_RAW = [int][math]::Floor($script:NEW_AVG_BYTES / $script:BYTES_PER_TOKEN)
        $script:NEW_EST_RAW = $new_count * $script:NEW_AVG_RAW
        $script:NEW_MEASURED = $true
        $null = $script:records.Add([pscustomobject]@{
            Role = 'newedit'; Path = '<new-files>'; Bytes = 0; Lines = 0
            RawOverride = $script:NEW_EST_RAW
        })
        $script:seenPaths['<new-files>'] = 1
    }
}

# --- validate --penalty paths ---
$badPen = $false
foreach ($pk in @($script:pen.Keys)) {
    if (-not $script:seenPaths.ContainsKey($pk)) {
        [Console]::Error.WriteLine("Error: --penalty path not present in reads/edits: $pk")
        $badPen = $true
    }
}
if ($badPen) { exit 1 }

# --- per-file compute + role sums ---
$bpt = $script:BYTES_PER_TOKEN
$srcap = $script:SYMBOL_READ_CAP
$secap = $script:SYMBOL_EDIT_CAP
$ioh = $script:ITEM_OVERHEAD
$tres = $script:TURN_RESERVE
$mult = $script:CFG_MULTIPLIER
$base = $script:CFG_BASE
$target = $script:CFG_TARGET

$fr = 0; $sr = 0; $fe = 0; $se = 0; $nf = 0; $rawtot = 0
foreach ($r in $script:records) {
    if ($null -ne $r.RawOverride) { $raw = [int]$r.RawOverride }
    else { $raw = [int][math]::Floor($r.Bytes / $bpt) }
    if ($script:pen.ContainsKey($r.Path)) { $ip = $script:pen[$r.Path] } else { $ip = 1.0 }
    if ($r.Role -eq 'symbol_read') {
        $access = 'symbol'; $kind = 'read'
        if ($raw -lt $srcap) { $capped = $raw } else { $capped = $srcap }
    } elseif ($r.Role -eq 'symbol_edit') {
        $access = 'symbol'; $kind = 'edit'
        if ($raw -lt $secap) { $capped = $raw } else { $capped = $secap }
    } elseif ($r.Role -eq 'newedit') {
        $access = 'full'; $kind = 'edit'; $capped = $raw
    } elseif ($r.Role -eq 'full_edit') {
        $access = 'full'; $kind = 'edit'; $capped = $raw
    } else {
        $access = 'full'; $kind = 'read'; $capped = $raw
    }
    $eff = [int][math]::Floor($capped * $ip + 0.5)
    $rawtot += $raw
    if ($r.Role -eq 'full_read') { $fr += $eff }
    elseif ($r.Role -eq 'symbol_read') { $sr += $eff }
    elseif ($r.Role -eq 'full_edit') { $fe += $eff }
    elseif ($r.Role -eq 'symbol_edit') { $se += $eff }
    elseif ($r.Role -eq 'newedit') { $nf += $eff }
    $null = Add-Member -InputObject $r -NotePropertyName Raw -NotePropertyValue $raw -Force
    $null = Add-Member -InputObject $r -NotePropertyName Access -NotePropertyValue $access -Force
    $null = Add-Member -InputObject $r -NotePropertyName Kind -NotePropertyValue $kind -Force
    $null = Add-Member -InputObject $r -NotePropertyName Ip -NotePropertyValue $ip -Force
    $null = Add-Member -InputObject $r -NotePropertyName Eff -NotePropertyValue $eff -Force
}

$K = $script:reads_n + $script:edits_n + $new_count
$overhead = $K * $ioh
$variable = $fr + $sr + $fe + $se + $nf + $overhead
$est = [int][math]::Floor($base + $tres + $variable * $mult + 0.5)
if ($est -le $target) { $stat = 'WITHIN BUDGET'; $delta = $target - $est; $headroom = $delta }
else { $stat = 'OVER BUDGET'; $delta = $est - $target; $headroom = 0 - $delta }

# --- emit TSV ---
Emit-Row 'STATUS' $stat 'informed_guess'
Emit-Blank
Emit-Line 'BUDGET'
Emit-Row 'field' 'value'
Emit-Row 'model' $script:MODEL_ID
Emit-Row 'target' "$target"
Emit-Row 'estimated_peak' "$est"
Emit-Row 'estimated_total' "$est"
Emit-Row 'delta' "$delta"
Emit-Row 'headroom' "$headroom"
Emit-Row 'raw_file_tokens' "$rawtot"
Emit-Row 'full_reads' "$fr"
Emit-Row 'symbol_reads' "$sr"
Emit-Row 'full_edits' "$fe"
Emit-Row 'symbol_edits' "$se"
Emit-Row 'new_file_tokens' "$nf"
Emit-Row 'item_overhead' "$overhead"
Emit-Row 'turn_reserve' "$tres"
Emit-Row 'K' "$K"
Emit-Row 'tokenizer_base' "$base"
Emit-Row 'tokenizer_multiplier' (ConvertTo-Fmt $mult)
Emit-Row 'estimate_confidence' 'informed_guess'
Emit-Blank
Emit-Line 'READS'
Emit-Row 'path' 'bytes' 'raw_tokens' 'access' 'indicator_penalty' 'effective_tokens'
foreach ($r in $script:records) {
    if ($r.Kind -eq 'read') {
        Emit-Row "$($r.Path)" "$($r.Bytes)" "$($r.Raw)" "$($r.Access)" (ConvertTo-Fmt $r.Ip) "$($r.Eff)"
    }
}
Emit-Blank
Emit-Line 'EDITS'
Emit-Row 'path' 'bytes' 'raw_tokens' 'access' 'indicator_penalty' 'effective_tokens'
foreach ($r in $script:records) {
    if ($r.Kind -eq 'edit') {
        Emit-Row "$($r.Path)" "$($r.Bytes)" "$($r.Raw)" "$($r.Access)" (ConvertTo-Fmt $r.Ip) "$($r.Eff)"
    }
}
Emit-Blank

$skipR = @(); $skipE = @(); $skipN = @()
foreach ($s in $script:skipped) {
    switch ($s.Role) {
        'read' { $skipR += $s.Path }
        'edit' { $skipE += $s.Path }
        'new' { $skipN += $s.Path }
    }
}
Emit-Line 'SKIPPED_READS'; Emit-Line 'path'; foreach ($p in $skipR) { Emit-Line $p }; Emit-Blank
Emit-Line 'SKIPPED_EDITS'; Emit-Line 'path'; foreach ($p in $skipE) { Emit-Line $p }; Emit-Blank
Emit-Line 'SKIPPED_NEW'; Emit-Line 'path'; foreach ($p in $skipN) { Emit-Line $p }; Emit-Blank

Emit-Line 'NEW_FILE_ESTIMATE'
Emit-Row 'field' 'value'
Emit-Row 'count' "$new_count"
Emit-Row 'src' "$($script:src)"
$avgB = if ($script:NEW_MEASURED) { "$($script:NEW_AVG_BYTES)" } else { '0' }
$avgR = if ($script:NEW_MEASURED) { "$($script:NEW_AVG_RAW)" } else { '0' }
$estR = if ($script:NEW_MEASURED) { "$($script:NEW_EST_RAW)" } else { '0' }
Emit-Row 'avg_bytes_per_file' $avgB
Emit-Row 'avg_raw_tokens_per_file' $avgR
Emit-Row 'estimated_raw_tokens' $estR
Emit-Row 'estimated_tokens' $estR

[Console]::Out.Write($script:out.ToString())
[Console]::Out.Flush()
exit 0
