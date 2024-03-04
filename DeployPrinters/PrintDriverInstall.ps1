#script is packaged as an app (Intunewin) and deployed along with oemsetup.inf
C:\Windows\SysNative\pnputil.exe /add-driver "$psscriptroot\x64\oemsetup.inf" /install
# Leave a file behind so it can be used during detection    
        $VictoryFilePath = "C:\Temp\Driver.txt"
        "Driver!" | Out-File -FilePath $VictoryFilePath