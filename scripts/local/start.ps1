param(
  [int[]]$Ports = @(3000),
  [switch]$PrimaryWithRepl,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$stateDir = Join-Path $repoRoot ".codex_tmp\local"
$metaDir = Join-Path $stateDir "instances"

New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
New-Item -ItemType Directory -Force -Path $metaDir | Out-Null

function Get-MetaPath([int]$Port) {
  Join-Path $metaDir ("main-{0}.json" -f $Port)
}

function Get-PortListener([int]$Port) {
  try {
    Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction Stop |
      Select-Object -First 1
  } catch {
    $null
  }
}

function Stop-ManagedInstance([int]$Port) {
  $metaPath = Get-MetaPath $Port
  if (-not (Test-Path $metaPath)) {
    return
  }

  $meta = Get-Content $metaPath | ConvertFrom-Json
  $process = Get-Process -Id $meta.pid -ErrorAction SilentlyContinue
  if ($null -ne $process) {
    Stop-Process -Id $meta.pid -Force
  }

  Remove-Item $metaPath -Force -ErrorAction SilentlyContinue
}

$started = @()

for ($i = 0; $i -lt $Ports.Count; $i++) {
  $port = $Ports[$i]
  $metaPath = Get-MetaPath $port
  $listener = Get-PortListener $port

  if ($Force) {
    Stop-ManagedInstance $port
    $listener = Get-PortListener $port
  }

  if ($listener) {
    Write-Host ("Skip port {0}, listener already exists. PID={1}" -f $port, $listener.OwningProcess)
    continue
  }

  if (Test-Path $metaPath) {
    Write-Host ("Skip port {0}, stale state file found: {1}" -f $port, $metaPath)
    continue
  }

  $disableRepl = if ($PrimaryWithRepl -and $i -eq 0) { "0" } else { "1" }

  $startInfo = New-Object System.Diagnostics.ProcessStartInfo
  $startInfo.FileName = "node"
  $startInfo.Arguments = ".\main.js"
  $startInfo.WorkingDirectory = $repoRoot
  $startInfo.UseShellExecute = $false
  $startInfo.CreateNoWindow = $true
  $startInfo.EnvironmentVariables["HTTP_PORT"] = [string]$port
  $startInfo.EnvironmentVariables["DISABLE_REPL"] = $disableRepl

  $process = New-Object System.Diagnostics.Process
  $process.StartInfo = $startInfo
  $null = $process.Start()

  Start-Sleep -Milliseconds 800

  if ($process.HasExited) {
    Write-Host ("Port {0} failed to start, process already exited." -f $port)
    continue
  }

  $meta = [ordered]@{
    pid = $process.Id
    port = $port
    disableRepl = $disableRepl
    startedAt = (Get-Date).ToString("s")
  } | ConvertTo-Json

  Set-Content -Path $metaPath -Value $meta -Encoding utf8

  $started += [pscustomobject]@{
    Port = $port
    Pid = $process.Id
    DisableRepl = $disableRepl
  }
}

if ($started.Count -eq 0) {
  Write-Host "No new instances were started."
  exit 0
}

Write-Host "Started instances:"
$started | Format-Table -AutoSize
