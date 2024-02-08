# Define the list of approved wallpaper names (without file extension)
$approvedWallpapers = @("approvedImage1", "approvedImage2", "approvedBackground")

# Get the current wallpaper path from the registry
$currentWallpaperPath = Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper | Select-Object -ExpandProperty Wallpaper

# Extract the filename without extension from the current wallpaper path
$currentWallpaperName = [System.IO.Path]::GetFileNameWithoutExtension($currentWallpaperPath)

# Check if the current wallpaper name is in the list of approved wallpapers
if ($currentWallpaperName -notin $approvedWallpapers) {
    # Exit with code 1 to indicate that the current wallpaper is not approved
    exit 1
}
else {
    # Exit with code 0 to indicate that the current wallpaper is approved
    exit 0
}
