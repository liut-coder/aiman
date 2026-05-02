$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$metaDir = Join-Path $repoRoot ".codex_tmp\local\instances"

if (-not (Test-Path $metaDir)) {
  Write-Host "No script-managed local instances exist."
  exit 0
}

$metaFiles = Get-ChildItem $metaDir -Filter "main-*.json" -File

if ($metaFiles.Count -eq 0) {
  Write-Host "No script-managed local instances exist."
  exit 0
}

$rows = foreach ($metaFile in $metaFiles) {
  $meta = Get-Content $metaFile.FullName | ConvertFrom-Json
  $process = Get-Process -Id $meta.pid -ErrorAction SilentlyContinue

  $listener = $null
  try {
    $listener = Get-NetTCPConnection -LocalPort $meta.port -State Listen -ErrorAction Stop |
      Select-Object -First 1
  } catch {
    $listener = $null
  }

  [pscustomobject]@{
    Port = $meta.port
    Pid = $meta.pid
    Running = [bool]($null -ne $process)
    Listening = [bool]($null -ne $listener)
    DisableRepl = $meta.disableRepl
    StartedAt = $meta.startedAt
  }
}

$rows | Sort-Object Port | Format-Table -AutoSize
