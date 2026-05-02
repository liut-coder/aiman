param(
  [int[]]$Ports
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$metaDir = Join-Path $repoRoot ".codex_tmp\local\instances"

if (-not (Test-Path $metaDir)) {
  Write-Host "No local instance state directory found."
  exit 0
}

if ($Ports -and $Ports.Count -gt 0) {
  $metaFiles = $Ports | ForEach-Object { Join-Path $metaDir ("main-{0}.json" -f $_) }
} else {
  $metaFiles = Get-ChildItem $metaDir -Filter "main-*.json" -File | Select-Object -ExpandProperty FullName
}

$stopped = @()

foreach ($metaPath in $metaFiles) {
  if (-not (Test-Path $metaPath)) {
    continue
  }

  $meta = Get-Content $metaPath | ConvertFrom-Json
  $process = Get-Process -Id $meta.pid -ErrorAction SilentlyContinue

  if ($null -ne $process) {
    Stop-Process -Id $meta.pid -Force
    $stopped += [pscustomobject]@{
      Port = $meta.port
      Pid = $meta.pid
    }
  }

  Remove-Item $metaPath -Force -ErrorAction SilentlyContinue
}

if ($stopped.Count -eq 0) {
  Write-Host "No script-managed local instances were found."
  exit 0
}

Write-Host "Stopped instances:"
$stopped | Format-Table -AutoSize
