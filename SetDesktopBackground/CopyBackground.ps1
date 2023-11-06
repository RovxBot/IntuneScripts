New-item -itemtype directory -force -path "c:\Program Files\Background"

Copy-item -path "$psscriptroot\Background-Image.png" -destination "C:\Program Files\Background\Background-Image.png"

Return 0