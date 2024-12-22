
$installScript =  Invoke-RestMethod https://raw.githubusercontent.com/gabriel-vanca/VCLibs/main/Deploy_MS_VCLibs.ps1
Invoke-Expression $installScript

# Set the execution policy without requiring confirmation
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Set the path to the script you want to call
$scriptPath = Join-Path $PSScriptRoot "install_apps.ps1"

# Use the call operator to invoke the script
& $scriptPath

# Install Microsoft.UI.Xaml.2.7.appx
Add-AppxPackage -Path .\Microsoft.UI.Xaml.2.7.appx

# Install Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage -Path .\Microsoft.VCLibs.x64.14.00.Desktop.appx

# Install Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Add-AppxPackage -Path .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

# To install the stable release of winget on Windows Sandbox
$progressPreference = 'silentlyContinue'
$latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
Write-Information "Downloading winget to artifacts directory..."
Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage $latestWingetMsixBundle

# Install WinGet.msixbundle
Add-AppxPackage -Path .\WinGet.msixbundle

# Enable the use of LocalManifestFiles to install an application using a YAML file
winget settings --enable localmanifestfiles
winget install --manifest .\install_apps.yaml

# Check if the current user has administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script requires administrative privileges. Please run the script as an administrator."
    Exit 1
}

# Enable Windows Developer mode
try {
    # Set registry key value to enable Developer mode
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
    Write-Host "`nWindows Developer mode has been enabled successfully.`n"
} catch {
    Write-Error "Failed to enable Windows Developer mode. Error: $($_.Exception.Message)"
    Exit 1
}
