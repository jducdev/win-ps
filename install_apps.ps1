# # Clear the screen
Clear-Host ; clear

# Function to display progress bar
function Show-ProgressBar {
    param(
        [int]$progress,
        [int]$total
    )

    $percent = ($progress / $total) * 100
    Write-Progress -Activity "Installing Applications" -Status "Progress: $($progress)/$($total)" -PercentComplete $percent

    # Move the console output below the overlay progress bar
    for ($i = 0; $i -lt ($total - $progress + 2); $i++) {
        Write-Host "`r`n" -NoNewline
    }
}

# Define an array of app installation commands
$appInstallationCommands = @(
    "Add-AppxPackage -Path .\Microsoft.UI.Xaml.2.7.appx",
    "Add-AppxPackage -Path .\Microsoft.VCLibs.x64.14.00.Desktop.appx",
    "Add-AppxPackage -Path .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle",
    "Add-AppxPackage -Path .\WinGet.msixbundle",
    "Add-AppxPackage -Path .\Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle"
)

# Loop through the app installation commands and display progress
for ($i = 0; $i -lt $appInstallationCommands.Count; $i++) {
    $currentCommand = $appInstallationCommands[$i]
    Invoke-Expression $currentCommand
    Show-ProgressBar -progress ($i + 1) -total $appInstallationCommands.Count
}

# Define the source file path
$sourceFilePath = (Get-Location).Path + "\PowerShell-7.3.4-win-x64.msi"

# Define the destination folder path
$destinationFolderPath = "$env:TEMP\winget\Microsoft.PowerShell.7.3.4.0"

# Create the destination folder if it doesn't exist
if (!(Test-Path -Path $destinationFolderPath)) {
    New-Item -ItemType Directory -Path $destinationFolderPath | Out-Null
}

# Copy the source file to the destination folder
Copy-Item -Path $sourceFilePath -Destination $destinationFolderPath

Write-Host "File '$sourceFilePath' copied to '$destinationFolderPath'."

winget install --id Microsoft.PowerShell -e --accept-source-agreements

Write-Host "Installation of applications completed successfully."
Write-Host "" 
# Run winget list
winget list --accept-source-agreements
