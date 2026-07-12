# Golden tests for the PowerShell slice-budget estimator.
# Exercises bash-tokenizer acceptance criteria FR1/FR9, FR4-FR12, FR15 on the
# current host under whatever PowerShell is available. Real PS 5.1 behavior is
# the CI gate (Slice 3); this runner validates algorithm logic portably.
#
# Printf-free equivalent: no format-string injection; explicit concatenation.
# PS 5.1 clean: no -AsByteStream, no ternary, no ?? / ?. operators.
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

function Ok([string]$label) { Write-Output "PASS $label"; $script:PASS++ }
function Bad([string]$label, [string]$detail) { Write-Output "FAIL $label :: $detail"; $script:FAIL++ }
function Expect-Eq([string]$label, [string]$got, [string]$want) {
    if ($got -eq $want) { Ok $label } else { Bad $label "got [$got] want [$want]" }
}
function Expect-Ge([string]$label, [int]$got, [int]$atLeast) {
    if ($got -ge $atLeast) { Ok $label } else { Bad $label "got [$got] want >=$atLeast" }
}

# Run the estimator capturing stdout; sets $RUN_OUT and $RUN_RC.
function Run-Est {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$InvArgs)
    $script:RUN_OUT = ""
    $script:RUN_RC = 0
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
    Remove-Item -Force -LiteralPath $errTmp -ErrorAction SilentlyContinue
}

function Budget-Val([string]$out, [string]$key) {
    foreach ($ln in $out -split "`n") {
        if ($ln -match ('^' + [regex]::Escape($key) + '\t(.*)$')) { return $Matches[1] }
    }
    return ""
}

# 1-indexed cell, matching the bash row_cell helper.
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

# Mirror the estimator's 2-decimal round-half-up formatter (awk fmt).
function Fmt([double]$x) {
    $s = [int][math]::Floor($x * 100 + 0.5)
    $w = [int][math]::Floor($s / 100)
    $f = $s % 100
    if ($f -lt 10) { return ($w.ToString() + ".0" + $f.ToString()) }
    return ($w.ToString() + "." + $f.ToString())
}

# --- FR1 / FR9: runs, exit 0, all eight fixed sections present ---
$smallpy = Join-Path $FIXTURES 'small.py'
Run-Est '--reads' $smallpy
$missing = ""
if (-not ($script:RUN_OUT -match 'STATUS\t')) { $missing += " STATUS" }
foreach ($s in @('BUDGET', 'READS', 'EDITS', 'SKIPPED_READS', 'SKIPPED_EDITS', 'SKIPPED_NEW', 'NEW_FILE_ESTIMATE')) {
    $hasIt = $false
    foreach ($ln in $script:RUN_OUT -split "`n") { if ($ln -eq $s) { $hasIt = $true; break } }
    if (-not $hasIt) { $missing += " $s" }
}
if ($script:RUN_RC -eq 0 -and $missing -eq "") { Ok 'FR1/FR9 exit0 + fixed sections' }
else { Bad 'FR1/FR9' "rc=$($script:RUN_RC) missing:$missing" }

# --- FR4: raw_tokens = bytes / ratio ---
$bytes = (Get-Item -LiteralPath $smallpy).Length
$expRaw = [int][math]::Floor($bytes / 4)
$gotRaw = Row-Cell $script:RUN_OUT 'READS' $smallpy 3
Expect-Eq "FR4 raw_tokens=bytes/ratio ($expRaw)" $gotRaw "$expRaw"

# --- FR5: superlinear size penalty above threshold (low-threshold config) ---
$medpy = Join-Path $FIXTURES 'medium.py'
$box = Join-Path ([System.IO.Path]::GetTempFileName().TrimEnd('.tmp')) 'bmild-fr5'
$null = New-Item -ItemType Directory -Force -Path $box
$cfg = "penalty_size_threshold = 100`npenalty_size_exponent = 1.5"
[System.IO.File]::WriteAllText((Join-Path $box '.bmild.toml'), $cfg)
$mb = (Get-Item -LiteralPath $medpy).Length
$expSp = Fmt ([math]::Pow($mb / 100, 1.5))
Push-Location $box
try { Run-Est '--reads' $medpy } finally { Pop-Location }
$got5 = Row-Cell $script:RUN_OUT 'READS' $medpy 4
Expect-Eq "FR5 size_penalty=$expSp" $got5 $expSp
Remove-Item -Recurse -Force -LiteralPath $box -ErrorAction SilentlyContinue

# --- FR6: noise penalty (minified bytes-per-line + vendor path) ---
$minif = [System.IO.Path]::GetTempFileName()
$pad = "abcdefghij" * 70
[System.IO.File]::WriteAllText($minif, ($pad + "`n"))
$vendorFile = Join-Path $FIXTURES 'vendor\vendor-file.go'
Run-Est '--reads' $minif $vendorFile
Expect-Eq 'FR6 noise via bytes-per-line' (Row-Cell $script:RUN_OUT 'READS' $minif 5) '2.00'
Expect-Eq 'FR6 noise via vendor path' (Row-Cell $script:RUN_OUT 'READS' $vendorFile 5) '2.00'
Remove-Item -Force -LiteralPath $minif -ErrorAction SilentlyContinue

# --- FR7: triangular carry-forward (K=3 -> carry 2.00) ---
Run-Est '--reads' $smallpy $smallpy $smallpy
Expect-Eq 'FR7 carry=(K+1)/2' (Budget-Val $script:RUN_OUT 'carry_factor') '2.00'
Expect-Eq 'FR7 K=provided count' (Budget-Val $script:RUN_OUT 'K') '3'

# --- FR7b: carry_cap bounds the carry factor at high K ---
# Config override caps below the triangular value: K=3 -> 2.0, capped to 1.5
$boxC = Join-Path ([System.IO.Path]::GetTempFileName().TrimEnd('.tmp')) 'bmild-fr7b'
$null = New-Item -ItemType Directory -Force -Path $boxC
[System.IO.File]::WriteAllText((Join-Path $boxC '.bmild.toml'), "carry_cap = 1.5`n")
Push-Location $boxC
try { Run-Est '--reads' $smallpy $smallpy $smallpy } finally { Pop-Location }
Expect-Eq 'FR7b carry capped to config (1.50)' (Budget-Val $script:RUN_OUT 'carry_factor') '1.50'
# Default cap (2.5) applies when carry_cap absent: K=10 -> 5.5, capped to 2.50
[System.IO.File]::WriteAllText((Join-Path $boxC '.bmild.toml'), "slice_target = 231000`n")
Push-Location $boxC
try { Run-Est '--reads' $smallpy $smallpy $smallpy $smallpy $smallpy $smallpy $smallpy $smallpy $smallpy $smallpy } finally { Pop-Location }
Expect-Eq 'FR7b default carry_cap bounds high K (2.50)' (Budget-Val $script:RUN_OUT 'carry_factor') '2.50'
Remove-Item -Recurse -Force -LiteralPath $boxC -ErrorAction SilentlyContinue

# --- FR8: 2x edit premium (same file read vs edit) ---
Run-Est '--reads' $smallpy
$reEff = Row-Cell $script:RUN_OUT 'READS' $smallpy 7
Run-Est '--edits' $smallpy
$edEff = Row-Cell $script:RUN_OUT 'EDITS' $smallpy 7
Expect-Eq 'FR8 edit premium 2x' $edEff "$([int]$reEff * 2)"

# --- FR10: informed_guess label in STATUS and BUDGET ---
$lab = 0
foreach ($ln in $script:RUN_OUT -split "`n") { if ($ln -match 'informed_guess') { $lab++ } }
Expect-Ge 'FR10 informed_guess in STATUS+BUDGET' $lab 2

# --- FR11: --penalty on present path applies; absent path errors ---
$expPen = [int][math]::Floor([int]$reEff * 1.5 + 0.5)
Run-Est '--reads' $smallpy '--penalty' $smallpy '1.5'
Expect-Eq "FR11 --penalty applies (1.5x -> $expPen)" (Row-Cell $script:RUN_OUT 'READS' $smallpy 7) "$expPen"
Run-Est '--reads' $smallpy '--penalty' (Join-Path $FIXTURES 'nope.md') '2.0'
if ($script:RUN_RC -ne 0) { Ok 'FR11 --penalty absent path errors' } else { Bad 'FR11 absent' "rc=$($script:RUN_RC) (want non-zero)" }

# --- FR12: ## Actuals section in slice template ---
$tpl = [System.IO.File]::ReadAllText($TEMPLATE)
if ($tpl -match '(?m)^## Actuals' -and $tpl -match 'turns_taken' -and $tpl -match 'unplanned_reads') {
    Ok 'FR12 ## Actuals in slice-template'
} else {
    Bad 'FR12' 'template missing Actuals fields'
}

# --- FR15: config-driven params; multiplier defaults to 1.0 ---
$box2 = Join-Path ([System.IO.Path]::GetTempFileName().TrimEnd('.tmp')) 'bmild-fr15'
$null = New-Item -ItemType Directory -Force -Path $box2
[System.IO.File]::WriteAllText((Join-Path $box2 '.bmild.toml'), "tokenizer_ratio = 8.0`n")
Push-Location $box2
try { Run-Est '--reads' $smallpy } finally { Pop-Location }
Expect-Eq 'FR15 config override (ratio=8.00)' (Budget-Val $script:RUN_OUT 'tokenizer_ratio') '8.00'
Remove-Item -Force -LiteralPath (Join-Path $box2 '.bmild.toml') -ErrorAction SilentlyContinue
Push-Location $box2
try { Run-Est '--reads' $smallpy } finally { Pop-Location }
$mult = Budget-Val $script:RUN_OUT 'tokenizer_multiplier'
$ratio = Budget-Val $script:RUN_OUT 'tokenizer_ratio'
if ($mult -eq '1.00' -and $ratio -eq '4.00') { Ok 'FR15 defaults (multiplier=1.00, ratio=4.00)' }
else { Bad 'FR15b' "mult=$mult ratio=$ratio" }
Remove-Item -Recurse -Force -LiteralPath $box2 -ErrorAction SilentlyContinue

# --- PS 5.1 feature discipline: no -AsByteStream / ?? / ?. in the estimator code ---
# Scan code lines only (exclude '#' comment lines) so explanatory comments that
# name the forbidden tokens are not flagged.
$estText = [System.IO.File]::ReadAllText($ESTIMATOR)
$codeLines = ($estText -split "`n") | Where-Object { $_ -notmatch '^\s*#' }
$codeText = $codeLines -join "`n"
$featBad = ""
if ($codeText -match '-AsByteStream') { $featBad += ' -AsByteStream' }
if ($codeText -match '\?\?') { $featBad += ' ??' }
if ($codeText -match '\?\.') { $featBad += ' ?.' }
if ($featBad -eq "") { Ok 'PS5.1 no -AsByteStream/??/.? in estimator' }
else { Bad 'PS5.1 features' "forbidden tokens:$featBad" }

# --- Vuln1: tab in --src rejected; leading-dash --src normalized + measured ---
$tabSrc = $FIXTURES + [char]9 + 'evil'
Run-Est '--new' '1' '--src' $tabSrc
if ($script:RUN_RC -ne 0) { Ok 'Vuln1 tab in --src rejected' } else { Bad 'Vuln1 tab' "rc=$($script:RUN_RC) (want non-zero)" }

$srcDir = Join-Path $FIXTURES '-src-dir'
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

Write-Output '---'
Write-Output "passed=$($script:PASS) failed=$($script:FAIL)"
if ($script:FAIL -ne 0) { exit 1 }
