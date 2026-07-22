# Golden tests for the PowerShell peak_live_v2 slice-budget estimator.
# Mirrors tests/run-golden.sh invariants. PS 5.1 clean.
[CmdletBinding()]
param()
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$TESTS_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$FIXTURES = Join-Path $TESTS_DIR 'fixtures'
$ESTIMATOR = Join-Path $TESTS_DIR '..\.agents\skills\bmild-planner\scripts\run-budget-slice.ps1'
$ESTIMATOR = (Resolve-Path $ESTIMATOR).Path
$TEMPLATE = Join-Path $TESTS_DIR '..\.agents\skills\bmild-planner\assets\slice-template.md'
$TEMPLATE = (Resolve-Path $TEMPLATE).Path

$script:PS_EXE = (Get-Process -Id $PID).Path

$script:PASS = 0
$script:FAIL = 0
$script:RUN_OUT = ""
$script:RUN_RC = 0
$script:RUN_ERR = ""

function Ok([string]$label) { Write-Output "PASS $label"; $script:PASS++ }
function Bad([string]$label, [string]$detail) { Write-Output "FAIL $label :: $detail"; $script:FAIL++ }
function Expect-Eq([string]$label, [string]$got, [string]$want) {
    if ($got -eq $want) { Ok $label } else { Bad $label "got [$got] want [$want]" }
}
function Expect-Ge([string]$label, [int]$got, [int]$atLeast) {
    if ($got -ge $atLeast) { Ok $label } else { Bad $label "got [$got] want >=$atLeast" }
}

function Run-Est {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$InvArgs)
    $script:RUN_OUT = ""
    $script:RUN_RC = 0
    $script:RUN_ERR = ""
    $errTmp = [System.IO.Path]::GetTempFileName()
    try {
        $lines = & $script:PS_EXE -NoProfile -File $ESTIMATOR @InvArgs 2>$errTmp
        $script:RUN_RC = $LASTEXITCODE
    } catch {
        $script:RUN_RC = 1
        $lines = @()
    }
    if ($null -eq $lines) { $lines = @() }
    $script:RUN_OUT = ($lines -join "`n") -replace "`r", ""
    if (Test-Path -LiteralPath $errTmp) {
        $script:RUN_ERR = ([System.IO.File]::ReadAllText($errTmp) -replace "`r", "")
        Remove-Item -Force -LiteralPath $errTmp -ErrorAction SilentlyContinue
    }
}

function Budget-Val([string]$out, [string]$key) {
    foreach ($ln in $out -split "`n") {
        if ($ln -match ('^' + [regex]::Escape($key) + '\t(.*)$')) { return $Matches[1] }
    }
    return ""
}

function Row-Cell([string]$out, [string]$section, [string]$path, [int]$cell) {
    $inSec = $false
    foreach ($ln in $out -split "`n") {
        if ($ln -eq $section) { $inSec = $true; continue }
        if (-not $inSec) { continue }
        $fields = $ln -split "`t"
        if ($fields.Count -le 1) { $inSec = $false; continue }
        if ($fields[0] -eq $path) { return $fields[$cell - 1] }
    }
    return ""
}

# --- FR1 / FR9 ---
$smallpy = Join-Path $FIXTURES 'small.py'
Run-Est '--full-reads' $smallpy
$missing = ""
if (-not ($script:RUN_OUT -match 'STATUS\t')) { $missing += " STATUS" }
foreach ($s in @('BUDGET', 'READS', 'EDITS', 'SKIPPED_READS', 'SKIPPED_EDITS', 'SKIPPED_NEW', 'NEW_FILE_ESTIMATE')) {
    $hasIt = $false
    foreach ($ln in $script:RUN_OUT -split "`n") { if ($ln -eq $s) { $hasIt = $true; break } }
    if (-not $hasIt) { $missing += " $s" }
}
if ($script:RUN_RC -eq 0 -and $missing -eq "") { Ok 'FR1/FR9 exit0 + fixed sections' }
else { Bad 'FR1/FR9' "rc=$($script:RUN_RC) missing:$missing" }
Expect-Eq 'model peak_live_v2' (Budget-Val $script:RUN_OUT 'model') 'peak_live_v2'

# --- FR4 ---
$bytes = (Get-Item -LiteralPath $smallpy).Length
$expRaw = [int][math]::Floor($bytes / 4)
Expect-Eq "FR4 raw_tokens=bytes/4 ($expRaw)" (Row-Cell $script:RUN_OUT 'READS' $smallpy 3) "$expRaw"
Expect-Eq 'full access on --full-reads' (Row-Cell $script:RUN_OUT 'READS' $smallpy 4) 'full'

# --- Symbol caps vs full reads ---
$large = [System.IO.Path]::GetTempFileName()
$pad = 'abcdefghij' * 4000
[System.IO.File]::WriteAllText($large, $pad)
Run-Est '--symbol-reads' $large
Expect-Eq 'symbol access' (Row-Cell $script:RUN_OUT 'READS' $large 4) 'symbol'
Expect-Eq 'symbol_reads capped at 2500' (Budget-Val $script:RUN_OUT 'symbol_reads') '2500'
$symPeak = [int](Budget-Val $script:RUN_OUT 'estimated_peak')

Run-Est '--full-reads' $large
$fullEff = [int](Row-Cell $script:RUN_OUT 'READS' $large 6)
Expect-Ge 'full read exceeds symbol cap' $fullEff 2501
$fullPeak = [int](Budget-Val $script:RUN_OUT 'estimated_peak')
Expect-Ge 'full peak > symbol peak' $fullPeak ($symPeak + 1)
Remove-Item -Force -LiteralPath $large -ErrorAction SilentlyContinue

# --- Symbol edit cap 5000 > read cap 2500 ---
$mid = [System.IO.Path]::GetTempFileName()
[System.IO.File]::WriteAllText($mid, ('abcdefghij' * 3500))
Run-Est '--symbol-reads' $mid
Expect-Eq 'symbol_read cap 2500' (Budget-Val $script:RUN_OUT 'symbol_reads') '2500'
Run-Est '--symbol-edits' $mid
Expect-Eq 'symbol_edit cap 5000' (Budget-Val $script:RUN_OUT 'symbol_edits') '5000'
Remove-Item -Force -LiteralPath $mid -ErrorAction SilentlyContinue

# --- Linear breadth ---
Run-Est '--full-reads' $smallpy
Expect-Eq 'K=1' (Budget-Val $script:RUN_OUT 'K') '1'
Expect-Eq 'item_overhead K=1 is 500' (Budget-Val $script:RUN_OUT 'item_overhead') '500'
$p1 = [int](Budget-Val $script:RUN_OUT 'estimated_peak')
Run-Est '--full-reads' $smallpy $smallpy $smallpy
Expect-Eq 'K=3' (Budget-Val $script:RUN_OUT 'K') '3'
Expect-Eq 'item_overhead K=3 is 1500' (Budget-Val $script:RUN_OUT 'item_overhead') '1500'
$p3 = [int](Budget-Val $script:RUN_OUT 'estimated_peak')
Expect-Ge 'peak grows with breadth' $p3 ($p1 + 1)

# --- Aliases ---
Run-Est '--reads' $smallpy
Expect-Eq '--reads alias full' (Row-Cell $script:RUN_OUT 'READS' $smallpy 4) 'full'
Run-Est '--edits' $smallpy
Expect-Eq '--edits alias full' (Row-Cell $script:RUN_OUT 'EDITS' $smallpy 4) 'full'

# --- New files ---
$srcDir = Join-Path $FIXTURES '-src-dir'
Run-Est '--new' '2' '--src' $srcDir
Expect-Ge 'new_file_tokens > 0' ([int](Budget-Val $script:RUN_OUT 'new_file_tokens')) 1
Expect-Eq 'NEW_FILE count' (Budget-Val $script:RUN_OUT 'count') '2'

# --- informed_guess ---
$lab = 0
foreach ($ln in $script:RUN_OUT -split "`n") { if ($ln -match 'informed_guess') { $lab++ } }
Expect-Ge 'FR10 informed_guess in STATUS+BUDGET' $lab 2

# --- penalty ---
Run-Est '--full-reads' $smallpy
$baseEff = [int](Row-Cell $script:RUN_OUT 'READS' $smallpy 6)
$expPen = [int][math]::Floor($baseEff * 1.5 + 0.5)
Run-Est '--full-reads' $smallpy '--penalty' $smallpy '1.5'
Expect-Eq 'FR11 --penalty applies' (Row-Cell $script:RUN_OUT 'READS' $smallpy 6) "$expPen"
Run-Est '--full-reads' $smallpy '--penalty' (Join-Path $FIXTURES 'nope.md') '2.0'
if ($script:RUN_RC -ne 0) { Ok 'FR11 --penalty absent path errors' } else { Bad 'FR11 absent' "rc=$($script:RUN_RC) (want non-zero)" }

# --- template schema ---
$tpl = [System.IO.File]::ReadAllText($TEMPLATE)
if ($tpl -match '(?m)^## Actuals' -and $tpl -match 'turns_taken' -and $tpl -match 'compaction_count' `
    -and $tpl -match 'peak_live_context' -and $tpl -match 'peak_context_pct' `
    -and $tpl -match 'unexpected_whole_file_source_reads' -and $tpl -match 'estimated_peak' `
    -and $tpl -match 'peak_live_v2') {
    Ok 'FR12 Actuals + peak_live_v2 template schema'
} else {
    Bad 'FR12' 'template missing Actuals / peak_live_v2 fields'
}

# --- supported TOML ---
$box = Join-Path ([System.IO.Path]::GetTempFileName().TrimEnd('.tmp')) 'bmild-cfg'
$null = New-Item -ItemType Directory -Force -Path $box
[System.IO.File]::WriteAllText((Join-Path $box '.bmild.toml'), "slice_target = 90000`ntokenizer_base = 11000`ntokenizer_multiplier = 2.0`n")
Push-Location $box
try { Run-Est '--full-reads' $smallpy } finally { Pop-Location }
Expect-Eq 'config slice_target' (Budget-Val $script:RUN_OUT 'target') '90000'
Expect-Eq 'config tokenizer_base' (Budget-Val $script:RUN_OUT 'tokenizer_base') '11000'
Expect-Eq 'config tokenizer_multiplier' (Budget-Val $script:RUN_OUT 'tokenizer_multiplier') '2.00'
Expect-Ge 'multiplier affects peak' ([int](Budget-Val $script:RUN_OUT 'estimated_peak')) 31001
Remove-Item -Recurse -Force -LiteralPath $box -ErrorAction SilentlyContinue

# --- defaults ---
$box2 = Join-Path ([System.IO.Path]::GetTempFileName().TrimEnd('.tmp')) 'bmild-def'
$null = New-Item -ItemType Directory -Force -Path $box2
Push-Location $box2
try { Run-Est '--full-reads' $smallpy } finally { Pop-Location }
Expect-Eq 'default multiplier 1.00' (Budget-Val $script:RUN_OUT 'tokenizer_multiplier') '1.00'
Expect-Eq 'default base 15000' (Budget-Val $script:RUN_OUT 'tokenizer_base') '15000'
Expect-Eq 'turn_reserve 20000' (Budget-Val $script:RUN_OUT 'turn_reserve') '20000'
Remove-Item -Recurse -Force -LiteralPath $box2 -ErrorAction SilentlyContinue

# --- legacy keys ---
$box3 = Join-Path ([System.IO.Path]::GetTempFileName().TrimEnd('.tmp')) 'bmild-leg'
$null = New-Item -ItemType Directory -Force -Path $box3
[System.IO.File]::WriteAllText((Join-Path $box3 '.bmild.toml'), "tokenizer_ratio = 8.0`ncarry_cap = 1.5`nedit_premium = 9.0`npenalty_cap = 3.0`nslice_target = 120000`n")
Push-Location $box3
try { Run-Est '--full-reads' $smallpy } finally { Pop-Location }
Expect-Eq 'legacy keys still exit 0' "$($script:RUN_RC)" '0'
Expect-Eq 'legacy does not change target' (Budget-Val $script:RUN_OUT 'target') '120000'
if ($script:RUN_ERR -match 'ignoring legacy .bmild.toml keys' -and $script:RUN_ERR -match 'tokenizer_ratio' -and $script:RUN_ERR -match 'carry_cap') {
    Ok 'legacy key migration warning'
} else {
    Bad 'legacy warn' "stderr=[$($script:RUN_ERR)]"
}
Expect-Eq 'legacy ratio ignored' (Row-Cell $script:RUN_OUT 'READS' $smallpy 3) "$expRaw"
Remove-Item -Recurse -Force -LiteralPath $box3 -ErrorAction SilentlyContinue

# --- PS 5.1 feature discipline ---
$estText = [System.IO.File]::ReadAllText($ESTIMATOR)
$codeLines = ($estText -split "`n") | Where-Object { $_ -notmatch '^\s*#' }
$codeText = $codeLines -join "`n"
$featBad = ""
if ($codeText -match '-AsByteStream') { $featBad += ' -AsByteStream' }
if ($codeText -match '\?\?') { $featBad += ' ??' }
if ($codeText -match '\?\.') { $featBad += ' ?.' }
if ($featBad -eq "") { Ok 'PS5.1 no -AsByteStream/??/.? in estimator' }
else { Bad 'PS5.1 features' "forbidden tokens:$featBad" }

# --- Vuln1 ---
$tabSrc = $FIXTURES + [char]9 + 'evil'
Run-Est '--new' '1' '--src' $tabSrc
if ($script:RUN_RC -ne 0) { Ok 'Vuln1 tab in --src rejected' } else { Bad 'Vuln1 tab' "rc=$($script:RUN_RC) (want non-zero)" }

$samplePy = Join-Path $srcDir 'sample.py'
$sampleBytes = (Get-Item -LiteralPath $samplePy).Length
Run-Est '--new' '1' '--src' $srcDir
Expect-Eq 'Vuln1 baseline avg_bytes (absolute dir)' (Budget-Val $script:RUN_OUT 'avg_bytes_per_file') "$sampleBytes"
Push-Location $FIXTURES
try { Run-Est '--new' '1' '--src' '-src-dir' } finally { Pop-Location }
$avg = Budget-Val $script:RUN_OUT 'avg_bytes_per_file'
$srcOut = Budget-Val $script:RUN_OUT 'src'
if ($script:RUN_RC -eq 0 -and $avg -eq "$sampleBytes" -and $srcOut -eq './-src-dir') {
    Ok 'Vuln1 leading-dash --src normalized + measured'
} else {
    Bad 'Vuln1 leading-dash' "rc=$($script:RUN_RC) avg=$avg src=$srcOut"
}

# --- Monotonic ---
$medpy = Join-Path $FIXTURES 'medium.py'
Run-Est '--full-reads' $smallpy
$mono1 = [int](Budget-Val $script:RUN_OUT 'estimated_peak')
Run-Est '--full-reads' $smallpy '--full-reads' $medpy
$mono2 = [int](Budget-Val $script:RUN_OUT 'estimated_peak')
Expect-Ge 'monotonic peak' $mono2 $mono1

Write-Output '---'
Write-Output "passed=$($script:PASS) failed=$($script:FAIL)"
if ($script:FAIL -ne 0) { exit 1 }
