<#
PowerShell setup script for FlutterFire & Firebase tools
- Installs Node.js LTS via winget (if available)
- Installs firebase-tools via npm
- Activates flutterfire_cli via Dart
- Adds Pub cache bin to PATH (%APPDATA%\Pub\Cache\bin)

Run as Administrator: open PowerShell as Admin and run:
  powershell -ExecutionPolicy Bypass -File .\scripts\setup_flutterfire.ps1
#>

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-ErrorExit($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Confirm running
Write-Info "This script will install Node.js (via winget if available), firebase-tools, and flutterfire_cli."
$ok = Read-Host "Proceed? (y/n)"
if ($ok -ne 'y' -and $ok -ne 'Y') { Write-Info "Cancelled by user."; exit 0 }

# 1) Install Node.js LTS via winget if available
$hasWinget = Get-Command winget -ErrorAction SilentlyContinue
if ($hasWinget) {
  Write-Info "winget detected. Installing Node.js LTS via winget..."
  try {
    winget install --id OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements
  } catch {
    Write-Warn "winget install failed or was cancelled. You can install Node.js manually from https://nodejs.org/en/."
  }
} else {
  Write-Warn "winget not found — skipping automated Node install. If Node is not installed on your machine, download LTS from https://nodejs.org/en/."
}

# 2) Verify node/npm
Write-Info "Checking node and npm versions..."
$nodeVer = (& node --version) -replace "\r|\n","" 2>$null
$npmVer = (& npm --version) -replace "\r|\n","" 2>$null
if (-not $nodeVer) { Write-Warn "node not found. If you installed Node just now, open a NEW PowerShell window then re-run this script or run the subsequent commands manually." }
else { Write-Info "node version: $nodeVer" }
if (-not $npmVer) { Write-Warn "npm not found." } else { Write-Info "npm version: $npmVer" }

# 3) Install firebase-tools via npm (if npm available)
if ($npmVer) {
  Write-Info "Installing firebase-tools globally via npm..."
  try {
    npm install -g firebase-tools
    Write-Info "firebase-tools installed. Version: $(firebase --version)"
  } catch {
    Write-Warn "Failed to install firebase-tools via npm. You may need to run PowerShell as Administrator or install npm manually."    
  }
} else {
  Write-Warn "Skipping firebase-tools install because npm is missing. Install Node/npm first and rerun."
}

# 4) Activate FlutterFire CLI via Dart (doesn't need npm)
Write-Info "Activating FlutterFire CLI via Dart pub global activate..."
try {
  dart pub global activate flutterfire_cli
  Write-Info "FlutterFire CLI activated. You can run: dart pub global run flutterfire_cli --version"
} catch {
  Write-Warn "Failed to activate flutterfire_cli via dart. Make sure Dart/Flutter SDK is installed and on PATH."
}

# 5) Add Pub cache bin(s) and npm bin to PATH (persists across sessions)
$pubBinRoaming = "$env:APPDATA\Pub\Cache\bin"
$pubBinLocal = "$env:LOCALAPPDATA\Pub\Cache\bin"
$npmBin = "$env:APPDATA\npm"
$toAdd = @()
if (Test-Path $pubBinLocal) { $toAdd += $pubBinLocal }
elseif (Test-Path $pubBinRoaming) { $toAdd += $pubBinRoaming }
if (Test-Path $npmBin) { $toAdd += $npmBin }

if ($toAdd.Count -gt 0) {
  Write-Info "Ensuring these bins are on PATH: $($toAdd -join ', ')"
  $currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
  foreach ($p in $toAdd) {
    if ($currentPath -notlike "*${p}*") {
      try {
        $newPath = $currentPath + ';' + $p
        [Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')
        $currentPath = $newPath
        Write-Info "Added $p to user PATH"
      } catch {
        Write-Warn "Failed to add $p to PATH. You can add it manually."
      }
    } else {
      Write-Info "$p already in PATH"
    }
  }
} else {
  Write-Warn "No pub/npm bin directories found — they will be created after activating packages or installing npm packages."
}

# Final information
Write-Info "Done. Recommended next steps:"
Write-Host "  1) Open a NEW PowerShell window (important after PATH changes)"
Write-Host "  2) Verify:"
Write-Host "       node --version"
Write-Host "       npm --version"
Write-Host "       firebase --version"
Write-Host "       flutterfire --version  (or dart pub global run flutterfire_cli --version)"
Write-Host "  3) If all good, run: flutterfire configure --project=unihosp-21a44"

Write-Info "If anything fails, copy the error output and share it and I will help debug."