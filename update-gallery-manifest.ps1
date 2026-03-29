# Regenerates gallery/manifest.json from image files in gallery/
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dir = Join-Path $root 'gallery'
$ext = @('.jpg', '.jpeg', '.png', '.webp', '.gif')
$out = Join-Path $dir 'manifest.json'
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
$names = @(Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue |
  Where-Object { $ext -contains $_.Extension.ToLowerInvariant() } |
  Sort-Object Name |
  ForEach-Object { 'gallery/' + $_.Name })
if ($names.Count -eq 0) {
  $json = '[]'
} else {
  $json = ($names | ConvertTo-Json -Compress)
}
[System.IO.File]::WriteAllText($out, $json)
Write-Host "Wrote $($names.Count) image(s) to $out"
