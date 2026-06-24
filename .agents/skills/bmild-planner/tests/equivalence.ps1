# Cross-platform equivalence gate for the bash/PowerShell budget estimator
# (Windows-native runner).
#
# Executes both implementations against the same fixture scenarios, normalizes
# line endings, and diffs. Companion to equivalence.sh; the canonical CI gate is
# a single Linux runner with pwsh (design §7 layer 3). This Windows variant lets
# a Windows-native dev run the same comparison locally and serves as a
# redundant CI signal on windows-latest.
#
# Requires a bash available on PATH (Git for Windows ships one). SKIPs with
# exit 0 when no bash/sh is present.
#
# PS 5.1 clean: no -AsByteStream, no ternary, no ?? / ?. No format-string
# injection; explicit concatenation only.
[CmdletBinding()]
param()
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$TESTS_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$FIXTURES  = Join-Path $TESTS_DIR 'fixtures'
$SH_EST    = (Resolve-Path (Join-Path $TESTS_DIR '..\scripts\run-budget-slice.sh')).Path
$PS_EST    = (Resolve-Path (Join-Path $TESTS_DIR '..\scripts\run-budget-slice.ps1')).Path
$script:PS_EXE = (Get-Process -Id $PID).Path

# Locate a bash/sh. Git for Windows provides bash; WSL provides sh/bash too.
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

# Normalize captured output: drop CR, strip trailing blank lines.
function Normalize-Out([string]$text) {
    $lines = ($text -replace "`r", "") -split "`n"
    $end = $lines.Count - 1
    while ($end -ge 0 -and $lines[$end] -eq "") { $end-- }
    $out = @()
    for ($i = 0; $i -le $end; $i++) { $out += $lines[$i] }
    return ($out -join "`n")
}

# Run-Shell <cwd> <args...> -> sets $script:SH_OUT, $script:SH_RC
function Run-Shell {
    param([string]$Cwd, [Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $script:SH_OUT = ""; $script:SH_RC = 0
    Push-Location -LiteralPath $Cwd
    try {
        # bash/sh -c style: invoke the estimator with args. Capture stdout.
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
# Run-Ps <cwd> <args...> -> sets $script:PS_OUT, $script:PS_RC
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

# --- build temp fixture corpus (runtime-generated inputs that cannot commit) ---
$WORK = Join-Path ([System.IO.Path]::GetTempPath()) ("bmild-equiv-" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $WORK | Out-Null

$MINIF = Join-Path $WORK 'minified.js'
$line = ('abcdefghij' * 70)
Set-Content -LiteralPath $MINIF -Value $line -NoNewline -Encoding UTF8
Add-Content -LiteralPath $MINIF -Value ""

$BINFILE = Join-Path $WORK 'binary.bin'
$zeroes = New-Object byte[] 64
([System.IO.File]::WriteAllBytes($BINFILE, $zeroes))

$HIDDEN = Join-Path $FIXTURES '.hidden-config.yaml'

# sandbox with NO .bmild.toml ancestor so defaults apply
$SANDBOX = Join-Path $WORK 'sandbox'; New-Item -ItemType Directory -Force -Path $SANDBOX | Out-Null
# sandbox with a low size threshold to activate size_penalty on medium.py
$LOWTB = Join-Path $WORK 'lowthresh'; New-Item -ItemType Directory -Force -Path $LOWTB | Out-Null
Set-Content -LiteralPath (Join-Path $LOWTB '.bmild.toml') -Value "penalty_size_threshold = 100`npenalty_size_exponent = 1.5`n"

$A_small  = Join-Path $FIXTURES 'small.py'
$A_medium = Join-Path $FIXTURES 'medium.py'
$A_vendor = Join-Path $FIXTURES 'vendor\vendor-file.go'
$A_srcdir = Join-Path $FIXTURES '-src-dir'

# --- scenarios: identical args to both scripts; cwd selects .bmild.toml ---
try {
    Run-Shell $SANDBOX --reads $A_small; Run-Ps $SANDBOX --reads $A_small
    Cmp-Case 'baseline-read' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $A_small $A_medium; Run-Ps $SANDBOX --reads $A_small $A_medium
    Cmp-Case 'multi-read-carry' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --edits $A_small; Run-Ps $SANDBOX --edits $A_small
    Cmp-Case 'edit-premium' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $A_small --edits $A_medium; Run-Ps $SANDBOX --reads $A_small --edits $A_medium
    Cmp-Case 'interleaved' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $MINIF; Run-Ps $SANDBOX --reads $MINIF
    Cmp-Case 'noise-bpl' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $A_vendor; Run-Ps $SANDBOX --reads $A_vendor
    Cmp-Case 'noise-vendor' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $BINFILE $A_small; Run-Ps $SANDBOX --reads $BINFILE $A_small
    Cmp-Case 'binary-skip' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $HIDDEN; Run-Ps $SANDBOX --reads $HIDDEN
    Cmp-Case 'hidden-file' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    $nope = Join-Path $WORK 'nope.py'
    Run-Shell $SANDBOX --reads $nope; Run-Ps $SANDBOX --reads $nope
    Cmp-Case 'missing-file' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --new 2 --src $A_srcdir; Run-Ps $SANDBOX --new 2 --src $A_srcdir
    Cmp-Case 'new-with-src' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    $missingDir = Join-Path $WORK 'missing-dir'
    Run-Shell $SANDBOX --new 1 --src $missingDir; Run-Ps $SANDBOX --new 1 --src $missingDir
    Cmp-Case 'new-missing-src' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    Run-Shell $SANDBOX --reads $A_small --penalty $A_small 1.5
    Run-Ps    $SANDBOX --reads $A_small --penalty $A_small 1.5
    Cmp-Case 'penalty-present' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC

    $absent = Join-Path $WORK 'absent.py'
    Run-Shell $SANDBOX --reads $A_small --penalty $absent 1.5
    Run-Ps    $SANDBOX --reads $A_small --penalty $absent 1.5
    Cmp-Case 'penalty-absent-errors' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC -MustError

    Run-Shell $LOWTB --reads $A_medium; Run-Ps $LOWTB --reads $A_medium
    Cmp-Case 'config-size-penalty' $script:SH_OUT $script:SH_RC $script:PS_OUT $script:PS_RC
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
