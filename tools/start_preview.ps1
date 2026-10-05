$ErrorActionPreference = 'Stop'
$repository = Split-Path -Parent $PSScriptRoot
$githubPages = Split-Path -Parent $repository
$preview = Join-Path $githubPages 'sdliqian2021.github.io\tools\preview_sites.py'
$pythonCommand = Get-Command python -CommandType Application -ErrorAction SilentlyContinue
$pythonCommand = if (
    $pythonCommand -and
    $pythonCommand.Source -notmatch '\\WindowsApps\\python(?:3)?\.exe$'
) { $pythonCommand } else { $null }
$pythonPath = if ($pythonCommand) { $pythonCommand.Source } else { $null }
$pythonArguments = @()

if (-not $pythonPath) {
    $pythonCommand = Get-Command py -ErrorAction SilentlyContinue
    if ($pythonCommand) {
        $pythonPath = $pythonCommand.Source
        $pythonArguments = @('-3')
    }
}

if (-not $pythonPath) {
    throw 'Python 3 was not found. Install Python or add python.exe to PATH, then retry.'
}

if (-not (Test-Path -LiteralPath $preview -PathType Leaf)) {
    throw "Unified preview tool not found: $preview"
}

$previewArguments = @($args)
if ($previewArguments -notcontains '--port') {
    foreach ($candidatePort in 4000..4010) {
        $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $candidatePort)
        try {
            $listener.Start()
            $previewArguments += @('--port', [string]$candidatePort)
            break
        }
        catch [System.Net.Sockets.SocketException] {
            continue
        }
        finally {
            $listener.Stop()
        }
    }
}

& $pythonPath @pythonArguments $preview @previewArguments
exit $LASTEXITCODE
