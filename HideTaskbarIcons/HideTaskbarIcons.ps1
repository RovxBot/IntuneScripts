# Define the registry paths for the taskbar items
$taskbarRegistryPaths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\PeopleBand",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\SearchboxTaskbarMode",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\UseActionCenterIcons"
)

# Define the registry values to set (1 for hide, 0 for show)
$taskbarRegistryValues = @(
    1, # Hide People (Widgets)
    1, # Hide Search
    1  # Hide Task View
)

# Loop through the registry paths and set the specified values
for ($i = 0; $i -lt $taskbarRegistryPaths.Length; $i++) {
    Set-ItemProperty -Path $taskbarRegistryPaths[$i] -Name "Serialized" -Value ([byte[]]($taskbarRegistryValues[$i]))
}

# Force the Explorer process to restart for changes to take effect
Stop-Process -Name explorer -Force
Start-Process explorer
