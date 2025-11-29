# Ensure the script is running as Administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "Not running as Administrator - relaunching elevated..."
    Start-Process wt -Verb RunAs -ArgumentList @(
        "pwsh",
        "-File",
        $PSCommandPath
    )
    exit
}

Write-Host "Running as Administrator." -ForegroundColor Green

$ErrorActionPreference = 'Stop'   # Fail fast on errors

Write-Host "=== Zen Browser Config Setup (PowerShell) ==="

# Directory where this script is located
$ScriptDir = Split-Path -Parent $PSCommandPath
Write-Host "Script directory: $ScriptDir"

# Zen profiles directory
$ZenDir = Join-Path $env:APPDATA 'zen\Profiles'
if (-not (Test-Path -LiteralPath $ZenDir)) {
    Write-Host "Error: Zen profiles directory not found at '$ZenDir'" -ForegroundColor Red
    Write-Host "Make sure Zen Browser is installed and has been run at least once."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Looking for profile under: $ZenDir"

# Find first profile matching *.Default (release)
$profileItem = Get-ChildItem -LiteralPath $ZenDir -Directory |
Where-Object { $_.Name -like '*.Default (release)*' } |
Select-Object -First 1

if (-not $profileItem) {
    Write-Host "Error: Could not find Zen profile directory matching '*.Default (release)*' under '$ZenDir'" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$ProfileDir = $profileItem.FullName
Write-Host "Using profile: $ProfileDir"

# Chrome directory
$ChromeDir = Join-Path $ProfileDir 'chrome'
if (-not (Test-Path -LiteralPath $ChromeDir)) {
    Write-Host "Error: Chrome directory not found at '$ChromeDir'" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Chrome directory: $ChromeDir"

# -------------------------
# Helper: ensure symlink
# -------------------------
function Set-Symlink {
    param(
        [Parameter(Mandatory)]
        [string] $TargetPath,

        [Parameter(Mandatory)]
        [string] $SourcePath
    )

    Write-Host ""
    Write-Host "Processing link:"
    Write-Host "  Target: $TargetPath"
    Write-Host "  Source: $SourcePath"

    if (Test-Path -LiteralPath $TargetPath) {
        # Get info about existing file/link
        $item = Get-Item -LiteralPath $TargetPath

        if (-not $item.LinkType) {
            Write-Host "Error: existing '$TargetPath' is not a symlink. Aborting." -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }

        Write-Host "Existing symlink found, removing..."
        Remove-Item -LiteralPath $TargetPath
    } else {
        Write-Host "No existing file at target path. Creating new link..."
    }

    try {
        Write-Host "Creating symlink..."
        Write-Host "  '$TargetPath'"
        Write-Host "    -> '$SourcePath'"
        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -ErrorAction Stop | Out-Null
    }
    catch {
        Write-Host ""
        Write-Host "Failed to create symlink:" -ForegroundColor Red
        Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Create/refresh symlinks
$UserChromeTarget = Join-Path $ChromeDir 'userChrome.css'
$UserChromeSource = Join-Path $ScriptDir 'userChrome.css'
Set-Symlink -TargetPath $UserChromeTarget -SourcePath $UserChromeSource

$UserJsTarget = Join-Path $ProfileDir 'user.js'
$UserJsSource = Join-Path $ScriptDir 'user.js'
Set-Symlink -TargetPath $UserJsTarget -SourcePath $UserJsSource

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "  userChrome.css -> $UserChromeTarget"
Write-Host "  user.js        -> $UserJsTarget"
Write-Host ""
Write-Host "Restart Zen Browser to apply changes."
Read-Host "Press Enter to exit"
