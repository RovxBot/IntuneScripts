# Remediation script to unpin the Microsoft Store app from the taskbar

$TaskbarShortcutPath = [System.Environment]::GetFolderPath("CommonPrograms") + "\Microsoft Store.lnk"

# Check if the taskbar shortcut exists
if (Test-Path $TaskbarShortcutPath) {
    try {
        # Remove the taskbar shortcut
        Remove-Item $TaskbarShortcutPath -Force
    } catch {
        Write-Output "Error: $_"
        Exit 1  # Return a non-zero exit code to indicate an issue during remediation.
    }
} else {
    Exit 0  # Return a zero exit code to indicate no remediation needed.
}
