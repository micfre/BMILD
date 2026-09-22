# native-serving-lane.ps1 - Windows-native serving/lint battery for the
# three-OS CI matrix (elicitation-refine FR15-FR17, NFR cross-OS parity).
# Runs under both pwsh and Windows PowerShell 5.1. Asserts the same semantic
# expectations as the POSIX contract tests: fixture lint results with exact
# rule/severity/line tuples and representative selector projections.
# PS 5.1 builtins only.

param()
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$root = Split-Path -Parent $PSScriptRoot
$elicit = Join-Path $root ".agents\skills\bmild-elicit\scripts"
$pm = Join-Path $root ".agents\skills\bmild-pm\scripts"
$fix = Join-Path $root "tests\fixtures\prd-lint"
$script:Failures = 0

function Fail([string]$msg) {
    # stderr, never the output stream: Fail inside a function like Find-Line
    # must not pollute its return value.
    [Console]::Error.WriteLine("FAIL: $msg")
    $script:Failures++
}

function Serve([string[]]$argv) {
    & powershell -NoProfile -File (Join-Path $elicit "methods.ps1") @argv
    if ($LASTEXITCODE -ne 0) { Fail "methods.ps1 $($argv -join ' ') exited $LASTEXITCODE" }
}

function Lint([string]$artifact) {
    $out = & powershell -NoProfile -File (Join-Path $pm "lint-prd.ps1") -root $root -artifact $artifact
    if ($LASTEXITCODE -ne 0) { Fail "lint-prd.ps1 exited $LASTEXITCODE" }
    return ($out | Out-String) | ConvertFrom-Json
}

# --- selector battery -----------------------------------------------------------

$cats = @(Serve @('categories'))
if ($cats.Count -ne 12) { Fail "expected 12 categories, got $($cats.Count)" }
$framing = @($cats | Where-Object { $_ -ceq "framing`t4" })
if ($framing.Count -ne 1) { Fail "framing`t4 missing from categories" }

$rows = @(Serve @('list', '--category', 'framing'))
if ($rows.Count -ne 4) { Fail "framing index must hold 4 rows" }
$first = ($rows[0] -split "`t")
if ($first[0] -ne '44' -or $first[2] -ne 'Abstraction Laddering') { Fail "framing first row wrong" }

$show = @(Serve @('show', '24'))
if (-not ($show -join "`n").Contains('# 24 | core | First Principles Analysis')) { Fail "show 24 header wrong" }
if (@($show | Where-Object { $_ -cmatch '^persona_cast:' }).Count -ne 0) { Fail "persona_cast must stay out of served fields" }

$cast = @(Serve @('cast'))
if ($cast.Count -ne 4) { Fail "cast must list 4 persona-cast methods" }

$all = @(Serve @('list', '--all'))
if ($all.Count -ne 71) { Fail "list --all must return 71 rows" }

$spread = @(Serve @('random', '-n', '12', '--spread', '--seed', '7'))
if ($spread.Count -ne 12) { Fail "spread draw must return 12 rows" }
$nums = @($spread | ForEach-Object { ($_ -split "`t")[0] } | Sort-Object -Unique)
$catv = @($spread | ForEach-Object { ($_ -split "`t")[1] } | Sort-Object -Unique)
if ($nums.Count -ne 12) { Fail "spread draw repeated a method" }
if ($catv.Count -ne 12) { Fail "spread draw must use 12 distinct categories" }

$rejected = & powershell -NoProfile -File (Join-Path $elicit "methods.ps1") random -n 13 2>$null
if ($LASTEXITCODE -ne 2) { Fail "random -n 13 must exit 2" }

# --- linter battery: expected (rule, severity, line) tuples ------------------------

function Expect-Clean([string]$name) {
    $d = Lint "tests/fixtures/prd-lint/$name"
    if ($d.status -ne 'clean') {
        Fail "$name expected clean, got $($d.status): $(($d.findings | ForEach-Object { $_.rule_id + '@' + $_.location.line }) -join ', ')"
    }
}

function Expect-Findings([string]$name, [object[]]$tuples) {
    $d = Lint "tests/fixtures/prd-lint/$name"
    if ($d.status -ne 'findings') { Fail "$name expected findings, got $($d.status)"; return }
    foreach ($t in $tuples) {
        $hit = @($d.findings | Where-Object { $_.rule_id -eq $t[0] -and $_.severity -eq $t[1] -and $_.location.line -eq [int]$t[2] })
        if ($hit.Count -lt 1) {
            Fail "$name expected $($t[0])/$($t[1]) at line $($t[2]); got: $(($d.findings | ForEach-Object { $_.rule_id + '/' + $_.severity + '@' + $_.location.line }) -join ', ')"
        }
    }
}

function Find-Line([string]$name, [string]$pattern) {
    $i = 0
    foreach ($line in (Get-Content -LiteralPath (Join-Path $fix $name) -Encoding UTF8)) {
        $i++
        if ($line -cmatch $pattern) { return $i }
    }
    Fail "pattern not found in ${name}: $pattern"
    return 0
}

Expect-Clean 'clean.md'
Expect-Clean 'prd001-negatives.md'

$tbd = Find-Line 'prd001.md' 'The remaining plan is TBD overall'
$actor = Find-Line 'prd001.md' [regex]::Escape('[Actor] can rely')
Expect-Findings 'prd001.md' @(
    @('PRD001', 'high', "$tbd"),
    @('PRD001', 'high', "$actor")
)

$ts = Find-Line 'prd002.md' 'timestamp: 2026-02-30'
Expect-Findings 'prd002.md' @(
    @('PRD002', 'high', "$ts"),
    @('PRD002', 'high', '1')
)

$dup = Find-Line 'prd003-duplicate.md' 'A duplicate journey appears'
Expect-Findings 'prd003-duplicate.md' @('PRD003', 'high', "$dup")

$gap = Find-Line 'prd003-gap.md' '^- FR3:'
Expect-Findings 'prd003-gap.md' @('PRD003', 'medium', "$gap")

$inc = Find-Line 'prd004-unresolved.md' 'Includes: FR1-FR9, J1'
Expect-Findings 'prd004-unresolved.md' @('PRD004', 'high', "$inc")

$rep = Find-Line 'prd004-repeated.md' 'Includes: FR1$'
Expect-Findings 'prd004-repeated.md' @('PRD004', 'medium', "$rep")

$as = Find-Line 'prd005.md' 'The fixture structure is stable'
Expect-Findings 'prd005.md' @('PRD005', 'medium', "$as")

$op = Find-Line 'prd006.md' [regex]::Escape('Operator docs: maybe')
$dh = Find-Line 'prd006.md' '^## Documentation Scope'
Expect-Findings 'prd006.md' @(
    @('PRD006', 'medium', "$op"),
    @('PRD006', 'medium', "$dh")
)

# adversarial escaping round-trip
$adv = Lint 'tests/fixtures/prd-lint/adversarial.md'
$esc = @($adv.findings | Where-Object { $_.detail.Contains('quote') -and $_.detail.Contains([char]0x00FC) })
if ($esc.Count -lt 1) { Fail "adversarial detail must round-trip quotes and unicode" }
$ctl = @($adv.findings | Where-Object { $_.detail.Contains([char]0x18) -and $_.detail.Contains([char]0x1B) })
if ($ctl.Count -lt 1) { Fail "adversarial detail must round-trip control bytes 0x18-0x1F escaped" }

# determinism: identical bytes on repeated runs
$a = Lint 'tests/fixtures/prd-lint/prd001.md'
$b = Lint 'tests/fixtures/prd-lint/prd001.md'
if (-not ($a -eq $b)) { Fail "repeated lint must be semantically identical" }
if ($a.artifact.sha256 -ne (Get-FileHash -Algorithm SHA256 (Join-Path $fix 'prd001.md')).Hash.ToLower()) {
    Fail "reported sha256 must equal the candidate identity"
}

# --- isolated layout from an unrelated working directory ---------------------------

$tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ("lane-" + [guid]::NewGuid().ToString('N')))
try {
    New-Item -ItemType Directory -Path (Join-Path $tmp "relocated\skills") -Force | Out-Null
    Copy-Item -Recurse (Join-Path $root ".agents\skills\bmild-elicit") (Join-Path $tmp "relocated\skills\bmild-elicit")
    Copy-Item -Recurse (Join-Path $root ".agents\skills\bmild-pm") (Join-Path $tmp "relocated\skills\bmild-pm")
    New-Item -ItemType Directory -Path (Join-Path $tmp "unrelated") -Force | Out-Null
    Push-Location (Join-Path $tmp "unrelated")
    try {
        $iso = & powershell -NoProfile -File (Join-Path $tmp "relocated\skills\bmild-elicit\scripts\methods.ps1") categories
        if ($LASTEXITCODE -ne 0 -or @($iso).Count -ne 12) { Fail "isolated relocated copy failed to serve" }
        $isol = & powershell -NoProfile -File (Join-Path $tmp "relocated\skills\bmild-pm\scripts\lint-prd.ps1") -root $root -artifact tests/fixtures/prd-lint/clean.md
        $isol = ($isol | Out-String) | ConvertFrom-Json
        if ($isol.status -ne 'clean') { Fail "isolated relocated linter diverged: $($isol.status)" }
    } finally {
        Pop-Location
    }
} finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

if ($script:Failures -gt 0) {
    Write-Output "native-serving-lane.ps1: $($script:Failures) failure(s)"
    exit 1
}
Write-Output "native-serving-lane.ps1: PASS ($PSVersionTable.PSVersion)"
exit 0
