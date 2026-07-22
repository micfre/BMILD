# Cross-platform equivalence gate for peak_live_v2 (Windows-native runner).
# Companion to equivalence.sh. PS 5.1 clean.
[CmdletBinding()]
param()
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$TESTS_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$FIXTURES  = Join-Path $TESTS_DIR 'fixtures'
$SH_EST    = (Resolve-Path (Join-Path $TESTS_DIR '..\.agents\skills\bmild-planner\scripts\run-budget-slice.sh')).Path
$PS_EST    = (Resolve-Path (Join-Path $TESTS_DIR '..\.agents\skills\bmild-planner\scripts\run-budget-slice.ps1')).Path
$script:PS_EXE = (Get-Process -Id $PID).Path

$script:SH_EXE = $null
foreach ($cand in @('bash', 'sh')) {
    $found = Get-Command $cand -ErrorAction SilentlyContinue
    if ($found) { $script:SH_EXE = $found.Source; break }
}
if (-not $script:SH_EXE) {
    Write-Output "equivalence: SKIP - no bash/sh on PATH (canonical gate is Linux CI per design §7)."
    Write-Output "equivalence: 0 run, 0 pass, 0 fail."
    exit 0
}

$script:PASS = 0
$script:FAIL = 0
$script:FAILED = New-Object System.Collections.ArrayList
$script:SH_OUT = ""; $script:SH_RC = 0
$script:PS_OUT = ""; $script:PS_RC = 0

function Normalize-Out([string]$text) {
    $lines = ($text -replace "`r", "") -split "`n"
    $end = $lines.Count - 1
    while ($end -ge 0 -and $lines[$end] -eq "") { $end-- }
    $out = @()
    for ($i = 0; $i -le $end; $i++) { $out += $lines[$i] }
    return ($out -join "`n")
}

function Run-Shell {
    param([string]$Cwd, [Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $script:SH_OUT = ""; $script:SH_RC = 0
    Push-Location -LiteralPath $Cwd
    try {
        $argStr = ($Args | ForEach-Object { '"' + ($_ -replace '"', '\"') + '"' }) -join ' '
        $cmd = '"' + $script:SH_EXE + '" "' + $script:SH_EST + '" ' + $argStr
        $tmp = [System.IO.Path]::GetTempFileName()
        try {
            $script:SH_OUT = & cmd /c $cmd 2>$tmp
            $script:SH_RC = $LASTEXITCODE
        } catch { $script:SH_RC = 1; $script:SH_OUT = "" }
        Remove-Item -Force -LiteralPath $tmp -ErrorAction SilentlyContinue
    } finally { Pop-Location }
}
function Run-Ps {
    param([string]$Cwd, [Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $script:PS_OUT = ""; $script:PS_RC = 0
    Push-Location -LiteralPath $Cwd
    try {
        $errTmp = [System.IO.Path]::GetTempFileName()
        try {
            $lines = & $script:PS_EXE -NoProfile -File $PS_EST @Args 2>$errTmp
            $script:PS_RC = $LASTEXITCODE
        } catch { $script:PS_RC = 1; $lines = @() }
        if ($null -eq $lines) { $lines = @() }
        $script:PS_OUT = ($lines -join "`n")
        Remove-Item -Force -LiteralPath $errTmp -ErrorAction SilentlyContinue
    } finally { Pop-Location }
}

function Cmp-Case([string]$Label, [string]$So, [int]$Sr, [string]$Po, [int]$Pr, [switch]$MustError) {
    if ($MustError) {
        if ($Sr -eq 0 -or $Pr -eq 0) {
            Write-Output "FAIL $Label :: expected both nonzero; sh=$Sr ps=$Pr"
            $script:FAIL++; [void]$script:FAILED.Add($Label); return
        }
        if ($So -ne "" -or $Po -ne "") {
            Write-Output "FAIL $Label :: expected empty stdout on error"
            $script:FAIL++; [void]$script:FAILED.Add($Label); return
        }
        Write-Output "PASS $Label (both error, no stdout)"; $script:PASS++; return
    }
    $son = Normalize-Out $So
    $pon = Normalize-Out $Po
    if ($Sr -ne $Pr) {
        Write-Output "FAIL $Label :: exit code sh=$Sr ps=$Pr"
        $script:FAIL++; [void]$script:FAILED.Add($Label); return
    }
    if ($son -ne $pon) {
        Write-Output "FAIL $Label :: stdout differs (rc=$Sr)"
        Write-Output "    --- sh (normalized) ---"
        $son -split "`n" | ForEach-Object { Write-Output "    $_" }
        Write-Output "    --- ps (normalized) ---"
        $pon -split "`n" | ForEach-Object { Write-Output "    $_" }
        $script:FAIL++; [void]$script:FAILED.Add($Label); return
    }
    Write-Output "PASS $Label"; $script:PASS++
}

$WORK = Join-Path ([System.IO.Path]::GetTempPath()) ("bmild-equiv-" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $WORK | Out-Null

$MINIF = Join-Path $WORK 'minified.js'
Set-Content -LiteralPath $MINIF -Value (('abcdefghij' * 70) + "`n") -NoNewline -Encoding UTF8

$BINFILE = Join-Path $WORK 'binary.bin'
$zeroes = New-Object byte[] 64
[System.IO.File]::WriteAllBytes($BINFILE, $zeroes)

$LARGE = Join-Path $WORK 'large.txt'
[System.IO.File]::WriteAllText($LARGE, ('abcdefghij' * 4000))

$HIDDEN = Join-Path $FIXTURES '.hidden-config.yaml'

$SANDBOX = Join-Path $WORK 'sandbox'; New-Item -ItemType Directory -Force -Path $SANDBOX | Out-Null
$CFGBOX = Join-Path $WORK 'cfg'; New-Item -ItemType Directory -Force -Path $CFGBOX | Out-Null
Set-Content -LiteralPath (Join-Path $CFGBOX '.bmild.toml') -Value "slice_target = 90000`ntokenizer_base = 11000`ntokenizer_multiplier = 2.0`n"
$LEGBOX = Join-Path $WORK 'legacy'; New-Item -ItemType Directory -Force -Path $LEGBOX | Out-Null
Set-Content -LiteralPath (Join-Path $LEGBOX '.bmild.toml') -Value "tokenizer_ratio = 8.0`ncarry_cap = 1.5`nslice_target = 120000`n"

$A_small  = Join-Path $FIXTURES 'small.py'
$A_medium = Join-Path $FIXTURES 'medium.py'
$A_vendor = Join-Path $FIXTURES 'vendor\vendor-file.go'
$A_srcdir = Join-Path $FIXTURES '-src-dir'

try {
    Run-Shell $SANDBOX --full-reads $A_small; Run-Ps $SANDBOX --full-reads $A_small
    Cmp-Case 'baseline-full-read' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $A_small; Run-Ps $SANDBOX --reads $A_small
    Cmp-Case 'alias-reads' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --symbol-reads $LARGE; Run-Ps $SANDBOX --symbol-reads $LARGE
    Cmp-Case 'symbol-read-cap' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --symbol-edits $LARGE; Run-Ps $SANDBOX --symbol-edits $LARGE
    Cmp-Case 'symbol-edit-cap' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-reads $A_small $A_medium; Run-Ps $SANDBOX --full-reads $A_small $A_medium
    Cmp-Case 'multi-read-breadth' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-edits $A_small; Run-Ps $SANDBOX --full-edits $A_small
    Cmp-Case 'full-edit' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --edits $A_small; Run-Ps $SANDBOX --edits $A_small
    Cmp-Case 'alias-edits' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-reads $A_small --symbol-edits $A_medium
    Run-Ps $SANDBOX --full-reads $A_small --symbol-edits $A_medium
    Cmp-Case 'interleaved-roles' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-reads $MINIF; Run-Ps $SANDBOX --full-reads $MINIF
    Cmp-Case 'full-minified' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-reads $A_vendor; Run-Ps $SANDBOX --full-reads $A_vendor
    Cmp-Case 'vendor-full-read' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-reads $BINFILE $A_small; Run-Ps $SANDBOX --full-reads $BINFILE $A_small
    Cmp-Case 'binary-skip' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-reads $HIDDEN; Run-Ps $SANDBOX --full-reads $HIDDEN
    Cmp-Case 'hidden-file' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    $nope = Join-Path $WORK 'nope.py'
    Run-Shell $SANDBOX --full-reads $nope; Run-Ps $SANDBOX --full-reads $nope
    Cmp-Case 'missing-file' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --new 2 --src $A_srcdir; Run-Ps $SANDBOX --new 2 --src $A_srcdir
    Cmp-Case 'new-with-src' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    $missingDir = Join-Path $WORK 'missing-dir'
    Run-Shell $SANDBOX --new 1 --src $missingDir; Run-Ps $SANDBOX --new 1 --src $missingDir
    Cmp-Case 'new-missing-src' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --full-reads $A_small --penalty $A_small 1.5
    Run-Ps    $SANDBOX --full-reads $A_small --penalty $A_small 1.5
    Cmp-Case 'penalty-present' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    $absent = Join-Path $WORK 'absent.py'
    Run-Shell $SANDBOX --full-reads $A_small --penalty $absent 1.5
    Run-Ps    $SANDBOX --full-reads $A_small --penalty $absent 1.5
    Cmp-Case 'penalty-absent-errors' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC -MustError

    Run-Shell $CFGBOX --full-reads $A_small; Run-Ps $CFGBOX --full-reads $A_small
    Cmp-Case 'config-three-keys' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $LEGBOX --full-reads $A_small; Run-Ps $LEGBOX --full-reads $A_small
    Cmp-Case 'legacy-keys-ignored' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC
} finally {
    Remove-Item -Recurse -Force -LiteralPath $WORK -ErrorAction SilentlyContinue
}

Write-Output "---"
$total = $script:PASS + $script:FAIL
Write-Output "equivalence: $total run, $($script:PASS) pass, $($script:FAIL) fail."
if ($script:FAIL -gt 0) {
    Write-Output ("equivalence: FAILED cases: " + ($script:FAILED -join ' '))
    exit 1
}
Write-Output "equivalence: bash and PowerShell byte-identical across the fixture suite."
