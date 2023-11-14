# Function to close running Microsoft Office and Microsoft Teams applications
function Close-OfficeAndTeamsApplications {
    $officeAndTeamsApps = Get-Process | Where-Object { $_.ProcessName -match "EXCEL|WINWORD|OUTLOOK|POWERPNT|MSACCESS|Teams" }
    if ($officeAndTeamsApps.Count -gt 0) {
        Write-Host "Closing Microsoft Office and Microsoft Teams applications..."
        $officeAndTeamsApps | ForEach-Object { $_.CloseMainWindow() }
        Start-Sleep -Seconds 5  # Wait a moment to allow applications to close
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
$FileServer = "<SERVER>" # add your file server name here

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
}

# Function to execute the data migration process
function ExecuteDataMigration {
    # Set the log file path
    $LogFilePath = "C:\Temp\script_log.txt"
    # Start capturing output to a log file
    Start-Transcript -Path $LogFilePath

    # Set the network path and user
    $NetworkPath = "H:\Documents"
    $User = $env:username
    $FileServer = "data1"

    # Initialize a variable to track success
    $global:OperationSuccess = $true

    Close-OfficeAndTeamsApplications

    Connect-ToNetworkDrive -NetworkPath $NetworkPath -FileServer $FileServer -User $User

    if ($global:OperationSuccess) {
        # Define source and destination directories
        $DirectoryMappings = @{
            "Contacts" = "C:\Users\$User\Contacts"
            "Documents" = "C:\Users\$User\Documents"
            "Desktop" = "C:\Users\$User\Desktop"
            "Favorites" = "C:\Users\$User\Favorites"
            "Links" = "C:\Users\$User\Links"
            "Music" = "C:\Users\$User\Music"
            "Pictures" = "C:\Users\$User\Pictures"
            "Videos" = "C:\Users\$User\Videos"
            "AppData" = "C:\Users\$User\AppData"
        }

        # List of folders to exclude from the copy operation
        $ExcludedFolders = @("Folder4", "Folder3", "Folder2", "Folder1")

        foreach ($entry in $DirectoryMappings.GetEnumerator()) {
            $sourceDirectory = "H:\$($entry.Key)"
            $destinationDirectory = $entry.Value

            # Ensure the destination directory exists or create if not present
            if (-not (Test-Path -Path $destinationDirectory -PathType Container)) {
                New-Item -Path $destinationDirectory -ItemType Directory -Force | Out-Null
            }

            # Copy files maintaining the directory structure, excluding specified folders
            robocopy $sourceDirectory $destinationDirectory /E /R:1 /W:1 /TEE /NP /XF $ExcludedFolders
        }
    }

    PerformFinalActions -OperationSuccess $global:OperationSuccess

    # Stop capturing output to the log file
    Stop-Transcript
}

# Execute the data migration script
ExecuteDataMigration
