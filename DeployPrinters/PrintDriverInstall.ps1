C:\Windows\SysNative\pnputil.exe /add-driver "$psscriptroot\x64\oemsetup.inf" /install
        $VictoryFilePath = "C:\Temp\Driver.txt"
        "Driver!" | Out-File -FilePath $VictoryFilePath