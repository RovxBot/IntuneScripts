# Define the list of approved wallpaper names (without file extension)
$approvedWallpapers = @("Background1", "Background_New", "Background2", "Byethorne Park, Nairne", "Griselda Hill, Flinders Ranges", "Waikerie Riverfront")

# Get the current wallpaper path from the registry
$currentWallpaperPath = Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper | Select-Object -ExpandProperty Wallpaper
Write-Host "Current wallpaper path: $currentWallpaperPath"

# Extract the filename without extension from the current wallpaper path
$currentWallpaperName = [System.IO.Path]::GetFileNameWithoutExtension($currentWallpaperPath)
Write-Host "Current wallpaper name: $currentWallpaperName"

# Check if the current wallpaper name is in the list of approved wallpapers
if ($currentWallpaperName -notin $approvedWallpapers) {
    exit 1
}
else {
    exit 0
}