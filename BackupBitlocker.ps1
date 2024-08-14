try{
    $BLV = Get-BitLockerVolume -MountPoint $env:SystemDrive
            $KeyProtectorID=""
            foreach($keyProtector in $BLV.KeyProtector){
                if($keyProtector.KeyProtectorType -eq "RecoveryPassword"){
                    $KeyProtectorID=$keyProtector.KeyProtectorId
                    break;
                }
            }
    
           $result = BackupToAAD-BitLockerKeyProtector -MountPoint "$($env:SystemDrive)" -KeyProtectorId $KeyProtectorID
    return $true
    }
    catch{
         return $false
    }