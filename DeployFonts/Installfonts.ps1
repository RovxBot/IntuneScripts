#Get all fonts from Fonts Folder
$Fonts = Get-ChildItem .\Fonts
$regpath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
foreach ($Font in $Fonts) {

    $fontbasename = $font.basename
    If ($Font.Extension -eq ".ttf")  {$fontvalue = $Font.Basename + " (TrueType)"}
    elseif($Font.Extension -eq ".otf") {$fontvalue = $Font.Basename + " (OpenType)"}
    else {Write-Host " Font Extenstion not supported " -ForegroundColor blue -backgroundcolor white; break}

    $fontname = $font.name 
    if (Test-path C:\windows\fonts\$fontname)
    {
        Write-Host "$fontname already exists."
    }
    Else
    {
        Write-Host "Installing $fontname"
        #Installing Font
        $null = Copy-Item -Path $Font.fullname -Destination "C:\Windows\Fonts" -Force -EA Stop
    }
    Write-Host "Creating reg keys..."
    #Creating Font Registry Keys
    $null = New-ItemProperty -Name $fontvalue -Path $regpath -PropertyType string -Value $Font.name -Force -EA Stop    
}