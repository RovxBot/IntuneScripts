#Install BurntToast module
Install-Module -Name BurntToast

# Set the system culture to English Australia silently
Set-Culture en-AU

# Set the system locale to English United States silently
Set-WinSystemLocale -SystemLocale en-US

# Set the UI language override to English United States silently
Set-WinUILanguageOverride -Language en-US

# Set the user language list to English Australia silently
Set-WinUserLanguageList en-AU -Force

# Set the home location to GeoID 12 (Australia) silently
Set-WinHomeLocation -GeoId 12

# Create a detection file in the user's profile directory
$filePath = [System.IO.Path]::Combine($env:USERPROFILE, "LanguageSettingsApplied.txt")
New-Item -ItemType File -Path $filePath -Force

# Register a scheduled task to display a notification and restart
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-WindowStyle Hidden -Command "New-BurntToastNotification -Text \"Language and region settings have been updated. Please restart your computer.\" -AppLogo 'C:\path\to\your\logo.png'"; Restart-Computer -Force'
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "RestartNotificationTask" -Force

# Pause the script for a moment to allow the task to be registered
Start-Sleep -Seconds 5

# Inform the user that a notification will be displayed shortly, prompting them to restart
Write-Host "Language and region settings have been silently enforced. A notification will be displayed shortly, informing you to restart your computer. Please save your work, and thank you for your cooperation."

# Pause the script for 10 seconds before exiting (optional)
Start-Sleep -Seconds 10
