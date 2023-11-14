# Script written by Sam Cooke

# Function to close running Microsoft Office and Microsoft Teams applications
function Close-OfficeAndTeamsApplications {
    $officeAndTeamsApps = Get-Process | Where-Object { $_.ProcessName -match "EXCEL|WINWORD|OUTLOOK|POWERPNT|MSACCESS|Teams" }
    if ($officeAndTeamsApps.Count -gt 0) {
        Write-Host "Closing Microsoft Office and Microsoft Teams applications..."
        $officeAndTeamsApps | ForEach-Object { $_.CloseMainWindow() }
        Start-Sleep -Seconds 5  # Wait a moment to allow applications to close
    }
}

# Function to connect to a network drive
function Connect-ToNetworkDrive {
    param (
        [string]$NetworkPath,
        [string]$FileServer,
        [string]$User
    )

    Write-Host "Connecting to H:\ Drive"
    if (-not (Test-Path -Path $NetworkPath)) {
        Close-OfficeAndTeamsApplications # Close Office and Teams apps before mapping the drive
        $driveMapping = (New-Object -ComObject WScript.Network).MapNetworkDrive("H:", "\\$FileServer\Users$\$User")
        if (-not $driveMapping) {
            Write-Host "Failed to connect to the network drive. Please contact IT Support."
            $global:OperationSuccess = $false
        }
    } else {
        Write-Host "Path already exists, Connected!"
    }
}

# Function to perform final actions upon successful execution
function PerformFinalActions {
    param (
        [bool]$OperationSuccess
    )

    if ($OperationSuccess) {
        # Add the victory.txt file to C:\Temp for detection rule
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
        $ExcludedFolders = @("Folder1", "Folder2", "Folder3", "Foder4")

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
