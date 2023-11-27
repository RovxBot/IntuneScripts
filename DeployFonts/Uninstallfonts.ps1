#Get all fonts from Fonts Folder 
$Fonts = Get-ChildItem .\Fonts
$regpath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

foreach ($Font in $Fonts) {

    $fontname = $font.name
    $fontbasename = $font.basename
    If ($Font.Extension -eq ".ttf")  {$fontvalue = $Font.Basename + " (TrueType)"}
    elseif($Font.Extension -eq ".otf") {$fontvalue = $Font.Basename + " (OpenType)"}
    else {Write-Host " Font Extenstion not supported " -ForegroundColor blue -backgroundcolor white; break} 
    #Remove Font from Windows folder
    Remove-Item C:\windows\fonts\$fontname -force -EA SilentlyContinue
    #Delete corresponding registry keys for the font
    Remove-ItemProperty -Path $regpath -Name $fontvalue -force -EA SilentlyContinue
}