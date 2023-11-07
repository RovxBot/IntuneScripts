# Detection script to check if the Microsoft Teams chat icon is pinned to the taskbar

$TaskbarShortcutPath = [System.Environment]::GetFolderPath("CommonPrograms") + "\Microsoft Teams.lnk"

# Check if the taskbar shortcut exists
if (Test-Path $TaskbarShortcutPath) {
    Exit 1  # Return a non-zero exit code to indicate detection.
} else {
    Exit 0  # Return a zero exit code to indicate no detection.
}
