#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pythonScript = Join-Path $scriptDir "budget-slice.py"

$runners = @(
    @{ Command = "uv"; Args = @("run", $pythonScript) },
    @{ Command = "python3"; Args = @($pythonScript) },
    @{ Command = "python"; Args = @($pythonScript) },
    @{ Command = "py"; Args = @("-3", $pythonScript) }
)

foreach ($runner in $runners) {
    if (Get-Command $runner.Command -ErrorAction SilentlyContinue) {
        & $runner.Command @($runner.Args + $args)
        exit $LASTEXITCODE
    }
}

[Console]::Error.WriteLine("Error: no supported Python runner found. Install uv or Python 3.8+ and retry.")
exit 1
