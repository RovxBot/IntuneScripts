# Script by Sam Cooke.

# Function to close running Microsoft Office and Microsoft Teams applications
function Close-OfficeAndTeamsApplications {
    $officeAndTeamsApps = Get-Process | Where-Object { $_.ProcessName -match "EXCEL|WINWORD|OUTLOOK|POWERPNT|MSACCESS|Teams" }
    if ($officeAndTeamsApps.Count -gt 0) {
        Write-Host "Closing Microsoft Office and Microsoft Teams applications..."
        $officeAndTeamsApps | ForEach-Object { $_.CloseMainWindow() }
        # Wait a moment to allow applications to close
        Start-Sleep -Seconds 5
    }
}

# Set the log file path
$LogFilePath = "C:\script_log.txt"

# Start capturing output to a log file
Start-Transcript -Path $LogFilePath

# Initialize a variable to track success
$Success = $true

# Set the network path and user
$NetworkPath = "H:\Documents" # swap with your share drive letter.
$User = $env:username
$FileServer = "Data1" # add your file server name here

# List of file extensions and folders to exclude from the copy operation
$ExcludedItems = @(".SQLITE", ".log", "Login Data")  # Modify this list as needed

# Check if the path already exists
$PathExists = Test-Path -Path $NetworkPath

Write-Host "Connecting to H:\ Drive"

If ($PathExists) {
    Write-Host "Path already exists, Connected!"
}
else {
    Close-OfficeAndTeamsApplications # Close Office and Teams apps before mapping the drive
    (New-Object -ComObject WScript.Network).MapNetworkDrive("H:", "\\$FileServer\Users$\$User")
    $PathExists = Test-Path -Path $NetworkPath
    if (-not $PathExists) {
        Write-Host "Failed to connect to the network drive. Please contact IT Support."
        $Success = $false
    }
}

if ($Success) {
    $SourceDirectory = "H:\*" # Drive letter here
    $DestinationDirectory = "C:\Users\$User\"

    try {
        Close-OfficeAndTeamsApplications # Close Office and Teams apps before copying files

        Get-ChildItem -Path $SourceDirectory -File -Recurse | ForEach-Object {
            $sourceFile = $_.FullName
            $destinationFile = Join-Path -Path $DestinationDirectory -ChildPath $_.Name

            # Check if the file should be excluded from the copy operation
            if ($ExcludedItems -notcontains [System.IO.Path]::GetExtension($sourceFile) -and
                $sourceFile -notlike "H:\Documents\Passwords\*") {
                Copy-Item -Path $sourceFile -Destination $destinationFile -Force
                Write-Host "Copied: $sourceFile"
            }
            else {
                Write-Host "Skipped: $sourceFile"
            }
        }
        Write-Host "Copy completed successfully"
    }
    catch {
        Write-Host "Error occurred during file copy: $_"
        $Success = $false
    }
}

if ($Success) {
    # Add the victory.txt file to C:\Temp. This is so we have something we can use as a detection rule for Intune deployment.
    $VictoryFilePath = "C:\Temp\victory.txt"
    "Victory!" | Out-File -FilePath $VictoryFilePath
    Write-Host "victory.txt file added to C:\Temp"
}

Write-Host "Fin!"
Start-Sleep -Seconds 10

# Stop capturing output to the log file
Stop-Transcript
