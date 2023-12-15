# Set the system culture to English Australia silently
try {
    Set-Culture en-AU -ErrorAction Stop
}
catch {
    Write-Host "Failed to set system culture to English Australia. Error: $_"
    exit 1
}

# Set the system locale to English United States silently
try {
    Set-WinSystemLocale -SystemLocale en-au -ErrorAction Stop
}
catch {
    Write-Host "Failed to set system locale to English United States. Error: $_"
    exit 1
}

# Set the UI language override to English United States silently
try {
    Set-WinUILanguageOverride -Language en-US -ErrorAction Stop
}
catch {
    Write-Host "Failed to set UI language override to English United States. Error: $_"
    exit 1
}

# Set the user language list to English Australia silently
try {
    Set-WinUserLanguageList en-AU -Force -ErrorAction Stop
}
catch {
    Write-Host "Failed to set user language list to English Australia. Error: $_"
    exit 1
}

# Set the home location to GeoID 12 (Australia) silently
try {
    Set-WinHomeLocation -GeoId 12 -ErrorAction Stop
}
catch {
    Write-Host "Failed to set home location to Australia. Error: $_"
    exit 1
}

# Create a detection file in the user's profile directory
$detectionFilePath = [System.IO.Path]::Combine($env:USERPROFILE, "LanguageSettingsApplied.txt")
try {
    New-Item -ItemType File -Path $detectionFilePath -Force -ErrorAction Stop
}
catch {
    Write-Host "Failed to create detection file. Error: $_"
    exit 1
}

# Inform the user that language and region settings have been updated
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$confirmation = [System.Windows.Forms.MessageBox]::Show("Language and region settings have been updated. Do you want to restart your computer now?", "Settings Updated", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Information)

if ($confirmation -eq 'Yes') {
    # Register a scheduled task to restart the computer
    try {
        $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-Command Restart-Computer -Force'
        $trigger = New-ScheduledTaskTrigger -AtStartup
        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "RestartTask" -Force
    }
    catch {
        Write-Host "Failed to register restart task. Error: $_"
        exit 1
    }

    # Pause the script for a moment to allow the task to be registered
    Start-Sleep -Seconds 5
    Write-Host "Your computer will restart shortly. Please save your work."
}
else {
    Write-Host "You chose not to restart your computer. Please restart at your earliest convenience."
}

# Logging
$logPath = [System.IO.Path]::Combine($env:USERPROFILE, "ScriptLog.txt")
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logPath -Value "$timestamp - Script executed successfully."
