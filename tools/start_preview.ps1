$ErrorActionPreference = "Stop"
$repository = Split-Path -Parent $PSScriptRoot
$githubPages = Split-Path -Parent $repository
$preview = Join-Path $githubPages "sdliqian2021.github.io\tools\preview_sites.py"
$pythonCommand = Get-Command python -CommandType Application -ErrorAction SilentlyContinue
$pythonCommand = if (
    $pythonCommand -and
    $pythonCommand.Source -notmatch "\\WindowsApps\\python(?:3)?\.exe$"
) { $pythonCommand } else { $null }
$pythonPath = if ($pythonCommand) { $pythonCommand.Source } else { $null }
$pythonArguments = @()

if (-not $pythonPath) {
    $localPythonRoot = Join-Path $env:LOCALAPPDATA "Programs\Python"
    $pythonPath = Get-ChildItem -LiteralPath $localPythonRoot -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending |
        ForEach-Object { Join-Path $_.FullName "python.exe" } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
        Select-Object -First 1
}

if (-not $pythonPath) {
    $pythonCommand = Get-Command py -ErrorAction SilentlyContinue
    if ($pythonCommand) {
        $pythonPath = $pythonCommand.Source
        $pythonArguments = @("-3")
    }
}

if (-not $pythonPath) {
    throw "Python 3 was not found. Install Python or add python.exe to PATH, then retry."
}

if (-not (Test-Path -LiteralPath $preview -PathType Leaf)) {
    throw "Unified preview tool not found: $preview"
}

$previewArguments = @($args)
$hasExplicitPort = $previewArguments -contains "--port"
if (-not $hasExplicitPort) {
    $selectedPort = $null
    foreach ($candidatePort in 4000..4010) {
        $listener = [System.Net.Sockets.TcpListener]::new(
            [System.Net.IPAddress]::Loopback,
            $candidatePort
        )
        try {
            $listener.Start()
            $selectedPort = $candidatePort
            break
        }
        catch [System.Net.Sockets.SocketException] {
            continue
        }
        finally {
            $listener.Stop()
        }
    }
    if (-not $selectedPort) {
        throw "No available local preview port was found from 4000 through 4010."
    }
    if ($selectedPort -ne 4000) {
        Write-Host "Port 4000 is busy; using port $selectedPort instead."
        $previewArguments += @("--port", [string]$selectedPort)
    }
}

Push-Location $repository
try {
    & $pythonPath @pythonArguments $preview @previewArguments
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
finally {
    Pop-Location
}
