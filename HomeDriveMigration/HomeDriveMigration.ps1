# Script by Sam Cooke.

# Set the log file path
$LogFilePath = "C:\script_log.txt"

# Start capturing output to a log file
Start-Transcript -Path $LogFilePath

# Initialize a variable to track success
$Success = $true

# Set the network path and user
$NetworkPath = "H:\Documents" #swap with your share drive letter.
$User = $env:username

# Check if the path already exists
$PathExists = Test-Path -Path $NetworkPath

Write-Host "Connecting to H:\ Drive"

If ($PathExists) {
    Write-Host "Path already exists, Connected!"
}
else {
    (New-Object -ComObject WScript.Network).MapNetworkDrive("H:", "\\<FILESERVER>\Users$\$User") #Enter file server name here, and drive letter.
    $PathExists = Test-Path -Path $NetworkPath
    if (-not $PathExists) {
        Write-Host "Failed to connect to the network drive. Please contact IT Support."
        $Success = $false
    }
}

if ($Success) {
    $SourceDirectory = "H:\*" #Drive letter here
    $DestinationDirectory = "C:\Users\$User\"

    try {
        Copy-Item -Force -Recurse -Path $SourceDirectory -Destination $DestinationDirectory -Verbose
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
