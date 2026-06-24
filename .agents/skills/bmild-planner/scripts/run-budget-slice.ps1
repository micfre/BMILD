# BMILD slice-budget estimator (PowerShell 5.1).
# Byte-based token model with superlinear attention-risk penalty layer and
# triangular carry-forward. Emits TSV per the bash-tokenizer system-design
# output contract. PS 5.1 builtins only: no -AsByteStream (uses -Encoding
# Byte), no ternary, no null-coalescing (??). Algorithm mirrors
# run-budget-slice.sh exactly; equivalence enforced by tests (Slice 3).
# Plain param() (no [CmdletBinding()]): advanced binding rejects the manual
# argv-walk pass-through flags (--reads/--penalty/...). Bash does a manual
# $# walk; this mirrors it. Strictness comes from Set-StrictMode + $ErrorActionPreference.
param()
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$script:TAB = [char]9
$script:NL = [char]10

# --- defaults (documented hypotheses, not calibrations) ---
$script:DEFAULT_TARGET = 170000
$script:DEFAULT_BASE = 15000
$script:DEFAULT_MULTIPLIER = 1.0
$script:DEFAULT_RATIO = 4.0
$script:DEFAULT_SIZE_THRESHOLD = 24000
$script:DEFAULT_SIZE_EXPONENT = 1.5
$script:DEFAULT_NOISE_BPL = 500
$script:DEFAULT_NOISE_FACTOR = 2.0
$script:DEFAULT_PENALTY_CAP = 10.0
$script:DEFAULT_EDIT_PREMIUM = 2.0

$script:CFG_TARGET = $script:DEFAULT_TARGET
$script:CFG_BASE = $script:DEFAULT_BASE
$script:CFG_MULTIPLIER = $script:DEFAULT_MULTIPLIER
$script:CFG_RATIO = $script:DEFAULT_RATIO
$script:CFG_SIZE_THRESHOLD = $script:DEFAULT_SIZE_THRESHOLD
$script:CFG_SIZE_EXPONENT = $script:DEFAULT_SIZE_EXPONENT
$script:CFG_NOISE_BPL = $script:DEFAULT_NOISE_BPL
$script:CFG_NOISE_FACTOR = $script:DEFAULT_NOISE_FACTOR
$script:CFG_PENALTY_CAP = $script:DEFAULT_PENALTY_CAP
$script:CFG_EDIT_PREMIUM = $script:DEFAULT_EDIT_PREMIUM

# CLI overrides ($null = not set)
$script:OF_TARGET = $null
$script:OF_BASE = $null
$script:OF_MULTIPLIER = $null
$script:OF_RATIO = $null

# new-file state
$script:NEW_SET = 0
$script:NEW_VAL = $null
$script:src = ""
$script:NEW_AVG_BYTES = 0
$script:NEW_AVG_RAW = 0
$script:NEW_EST_RAW = 0
$script:NEW_MEASURED = $false

# parsed inputs
$script:reads_n = 0
$script:edits_n = 0
$script:mode = "read"
$script:records = New-Object System.Collections.ArrayList
$script:skipped = New-Object System.Collections.ArrayList
$script:pen = @{}
$script:seenPaths = @{}

$script:out = New-Object System.Text.StringBuilder

# --- helpers ---
function Fail-Budget([string]$msg) {
    [Console]::Error.WriteLine("Error: $msg")
    exit 1
}

function Show-Usage {
    $u = "Usage: run-budget-slice.ps1 [options]"
    $u += $script:NL + $script:NL + "Estimate implementation-session context tokens (byte-based model)."
    $u += $script:NL + "Output is TSV with fixed sections in order: STATUS, BUDGET, READS,"
    $u += $script:NL + "EDITS, SKIPPED_READS, SKIPPED_EDITS, SKIPPED_NEW, NEW_FILE_ESTIMATE."
    $u += $script:NL + $script:NL + "Options:"
    $u += $script:NL + "  --target <int>           token budget override"
    $u += $script:NL + "  --base <int>             tokenizer base (K=0 overhead) override"
    $u += $script:NL + "  --multiplier <float>     residual multiplier override (default 1.0)"
    $u += $script:NL + "  --ratio <float>          bytes-per-token ratio override (default 4.0)"
    $u += $script:NL + "  --reads <path>...        switch to read-role mode; collect read files"
    $u += $script:NL + "  --edits <path>...        switch to edit-role mode; collect edit files"
    $u += $script:NL + "  --new <int>              count of new files to estimate"
    $u += $script:NL + "  --src <path>             representative source dir (required when --new > 0)"
    $u += $script:NL + "  --penalty <path> <float> multiplicative indicator penalty (repeatable)"
    $u += $script:NL + "  -h, --help               show this help and exit"
    $u += $script:NL + $script:NL + "Penalty thresholds, exponents, and the edit premium are read from .bmild.toml"
    $u += $script:NL + "and are not exposed as flags. Every estimate is an informed guess."
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
            'tokenizer_ratio' { if (Test-Num $val) { $script:CFG_RATIO = [double]$val } }
            'penalty_size_threshold' { if (Test-UInt $val) { $script:CFG_SIZE_THRESHOLD = [int]$val } }
            'penalty_size_exponent' { if (Test-Num $val) { $script:CFG_SIZE_EXPONENT = [double]$val } }
            'penalty_noise_bpl' { if (Test-UInt $val) { $script:CFG_NOISE_BPL = [int]$val } }
            'penalty_noise_factor' { if (Test-Num $val) { $script:CFG_NOISE_FACTOR = [double]$val } }
            'penalty_cap' { if (Test-Num $val) { $script:CFG_PENALTY_CAP = [double]$val } }
            'edit_premium' { if (Test-Num $val) { $script:CFG_EDIT_PREMIUM = [double]$val } }
        }
    }
}

function Test-Binary([string]$p) {
    # PS 5.1 path: -Encoding Byte (never -AsByteStream, which is PS6+ and
    # forbidden by the design). PS 7 (Core) removed -Encoding Byte, so that
    # binding error falls through to a .NET read of the first 4096 bytes --
    # identical behaviour, keeps the script runnable on PS 7 for logic testing.
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

function Get-NoiseFlag([string]$p) {
    if ($p -like '*/vendor/*') { return 1 }
    if ($p -like '*/node_modules/*') { return 1 }
    if ($p -like '*/dist/*') { return 1 }
    if ($p -like '*/build/*') { return 1 }
    if ($p -like '*/target/*') { return 1 }
    if ($p -like '*.min.*') { return 1 }
    if ($p -like '*.generated.*') { return 1 }
    if ($p -like '*_generated.*') { return 1 }
    if ($p -like '*.pb.go') { return 1 }
    if ($p -like '*.proto.go') { return 1 }
    return 0
}

function Measure-File([string]$path, [string]$role) {
    $p = Normalize-Path $path
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) {
        $null = $script:skipped.Add([pscustomobject]@{ Role = $role; Path = $p })
        return
    }
    $bytes = (Get-Item -LiteralPath $p).Length
    if (Test-Binary $p) {
        $null = $script:skipped.Add([pscustomobject]@{ Role = $role; Path = $p })
        return
    }
    $lines = 0
    $nf = Get-NoiseFlag $p
    if ($nf -eq 0 -and $bytes -gt 0) {
        $all = [System.IO.File]::ReadAllBytes($p)
        $nl = 0
        foreach ($b in $all) { if ($b -eq 10) { $nl++ } }
        if ($all[$all.Length - 1] -eq 10) { $lines = $nl } else { $lines = $nl + 1 }
    }
    $null = $script:records.Add([pscustomobject]@{
        Role = $role; Path = $p; Bytes = $bytes; Lines = $lines
        RawOverride = $null; SizeBasis = $bytes; NoiseFlag = $nf
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

function ConvertTo-Rhu([double]$x) { return [int][math]::Floor($x + 0.5) }

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
    elseif ($a -eq '--reads') { $script:mode = 'read'; $i++ }
    elseif ($a -eq '--edits') { $script:mode = 'edit'; $i++ }
    elseif ($a -eq '--target' -or $a -eq '--base' -or $a -eq '--multiplier' -or $a -eq '--ratio') {
        if (($i + 1) -ge $args.Count) { Fail-Budget "$a requires a value" }
        $v = "$($args[$i + 1])"
        switch ($a) {
            '--target' { if (-not (Test-UInt $v)) { Fail-Budget "--target must be a non-negative integer" }; $script:OF_TARGET = [int]$v }
            '--base' { if (-not (Test-UInt $v)) { Fail-Budget "--base must be a non-negative integer" }; $script:OF_BASE = [int]$v }
            '--multiplier' { if (-not (Test-Num $v)) { Fail-Budget "--multiplier must be numeric" }; $script:OF_MULTIPLIER = [double]$v }
            '--ratio' { if (-not (Test-Num $v)) { Fail-Budget "--ratio must be numeric" }; $script:OF_RATIO = [double]$v }
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
        if ($script:mode -eq 'read') { Measure-File $a 'read'; $script:reads_n++ }
        else { Measure-File $a 'edit'; $script:edits_n++ }
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
if ($null -ne $script:OF_RATIO) { $script:CFG_RATIO = $script:OF_RATIO }

# --- new-file estimation ---
if ($new_count -gt 0) {
    $r = Measure-SourceDir $script:src
    if ($r -eq 'fail') {
        $null = $script:skipped.Add([pscustomobject]@{ Role = 'new'; Path = $script:src })
    } elseif ($r -eq 'ok') {
        $script:NEW_AVG_RAW = [int][math]::Floor($script:NEW_AVG_BYTES / $script:CFG_RATIO)
        $script:NEW_EST_RAW = $new_count * $script:NEW_AVG_RAW
        $script:NEW_MEASURED = $true
        $null = $script:records.Add([pscustomobject]@{
            Role = 'newedit'; Path = '<new-files>'; Bytes = 0; Lines = 0
            RawOverride = $script:NEW_EST_RAW; SizeBasis = $script:NEW_AVG_BYTES; NoiseFlag = 0
        })
        $script:seenPaths['<new-files>'] = 1
    }
}

# --- validate --penalty paths against measured inputs ---
$badPen = $false
foreach ($pk in @($script:pen.Keys)) {
    if (-not $script:seenPaths.ContainsKey($pk)) {
        [Console]::Error.WriteLine("Error: --penalty path not present in reads/edits: $pk")
        $badPen = $true
    }
}
if ($badPen) { exit 1 }

# --- per-file compute + role sums ---
$ratio = $script:CFG_RATIO
$thr = $script:CFG_SIZE_THRESHOLD
$sexp = $script:CFG_SIZE_EXPONENT
$nbpl = $script:CFG_NOISE_BPL
$nfactor = $script:CFG_NOISE_FACTOR
$cap = $script:CFG_PENALTY_CAP
$eprem = $script:CFG_EDIT_PREMIUM
$mult = $script:CFG_MULTIPLIER
$base = $script:CFG_BASE
$target = $script:CFG_TARGET

$wr = 0; $we = 0; $rawtot = 0
foreach ($r in $script:records) {
    if ($null -ne $r.RawOverride) { $raw = [int]$r.RawOverride }
    else { $raw = [int][math]::Floor($r.Bytes / $ratio) }
    if ($r.SizeBasis -le $thr) { $sp = 1.0 }
    else { $sp = [math]::Pow($r.SizeBasis / $thr, $sexp) }
    $lc = if ($r.Lines -lt 1) { 1 } else { $r.Lines }
    $bpl = $r.Bytes / $lc
    if ($r.NoiseFlag -eq 1 -or $bpl -gt $nbpl) { $np = $nfactor } else { $np = 1.0 }
    if ($script:pen.ContainsKey($r.Path)) { $ip = $script:pen[$r.Path] } else { $ip = 1.0 }
    $prod = $sp * $np * $ip
    if ($prod -gt $cap) { $prod = $cap }
    if ($r.Role -eq 'read') { $prem = 1.0 } else { $prem = $eprem }
    $eff = [int][math]::Floor($raw * $prod * $prem + 0.5)
    $rawtot += $raw
    if ($r.Role -eq 'read') { $wr += $eff } else { $we += $eff }
    $null = Add-Member -InputObject $r -NotePropertyName Raw -NotePropertyValue $raw -Force
    $null = Add-Member -InputObject $r -NotePropertyName Sp -NotePropertyValue $sp -Force
    $null = Add-Member -InputObject $r -NotePropertyName Np -NotePropertyValue $np -Force
    $null = Add-Member -InputObject $r -NotePropertyName Ip -NotePropertyValue $ip -Force
    $null = Add-Member -InputObject $r -NotePropertyName Eff -NotePropertyValue $eff -Force
}

$K = $script:reads_n + $script:edits_n + $new_count
$carry = ($K + 1) / 2.0
$est = [int][math]::Floor(($wr + $we) * $carry * $mult + $base + 0.5)
if ($est -le $target) { $stat = 'WITHIN BUDGET'; $delta = $target - $est }
else { $stat = 'OVER BUDGET'; $delta = $est - $target }

# --- emit TSV (fixed section order) ---
Emit-Row 'STATUS' $stat 'informed_guess'
Emit-Blank
Emit-Line 'BUDGET'
Emit-Row 'field' 'value'
Emit-Row 'target' "$target"
Emit-Row 'estimated_total' "$est"
Emit-Row 'delta' "$delta"
Emit-Row 'raw_file_tokens' "$rawtot"
Emit-Row 'weighted_reads' "$wr"
Emit-Row 'weighted_edits' "$we"
Emit-Row 'carry_factor' (ConvertTo-Fmt $carry)
Emit-Row 'K' "$K"
Emit-Row 'tokenizer_base' "$base"
Emit-Row 'tokenizer_multiplier' (ConvertTo-Fmt $mult)
Emit-Row 'tokenizer_ratio' (ConvertTo-Fmt $ratio)
Emit-Row 'estimate_confidence' 'informed_guess'
Emit-Blank
Emit-Line 'READS'
Emit-Row 'path' 'bytes' 'raw_tokens' 'size_penalty' 'noise_penalty' 'indicator_penalty' 'effective_tokens'
foreach ($r in $script:records) {
    if ($r.Role -eq 'read') {
        Emit-Row "$($r.Path)" "$($r.Bytes)" "$($r.Raw)" (ConvertTo-Fmt $r.Sp) (ConvertTo-Fmt $r.Np) (ConvertTo-Fmt $r.Ip) "$($r.Eff)"
    }
}
Emit-Blank
Emit-Line 'EDITS'
Emit-Row 'path' 'bytes' 'raw_tokens' 'size_penalty' 'noise_penalty' 'indicator_penalty' 'effective_tokens'
foreach ($r in $script:records) {
    if ($r.Role -ne 'read') {
        Emit-Row "$($r.Path)" "$($r.Bytes)" "$($r.Raw)" (ConvertTo-Fmt $r.Sp) (ConvertTo-Fmt $r.Np) (ConvertTo-Fmt $r.Ip) "$($r.Eff)"
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
