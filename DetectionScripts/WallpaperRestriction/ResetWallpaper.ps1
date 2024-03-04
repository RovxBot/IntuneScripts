# Path to the default wallpaper (full path with extension)
$defaultWallpaperPath = "C:\PathTo\Wallpaper\Wallpaper.png"

# Use the Windows API to set the desktop wallpaper
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@ 

# Define SPI constants
$SPI_SETDESKWALLPAPER = 20
$SPIF_UPDATEINIFILE = 1
$SPIF_SENDCHANGE = 2

# Set the default wallpaper
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $defaultWallpaperPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)