##Script by Sam Cooke
##This script will query an Australian public holiday API and use it to create holidays in Teams Voice for you.
##Currently set to gather Adelaide results.

function Get-PublicHolidays {
    $Holidays = @()
    $URI = "https://data.gov.au/data/api/3/action/datastore_search?resource_id="
    $ResourceID = '2dee10ef-2d0c-44a0-a66b-eb8ce59d9110'
    $Results = (Invoke-RestMethod -Uri "$($URI)$($ResourceID)" -Method Get).Result 
    $ADLResults = $Results.records | Where-Object {($_.Jurisdiction -eq "adl")}
        $holidays = foreach ($Holiday in $ADLResults){
            $HolidayDate = ([datetime]::ParseExact($Holiday.Date, 'yyyyMMdd', $null)).toshortdatestring()
            $HolidayEndDate = ([datetime]::ParseExact($Holiday.Date, 'yyyyMMdd', $null))
            $HolidayEndDateString = ($HolidayEndDate.AddDays(1)).ToShortDateString() 
            [PSCustomObject]@{
            StartDate = $HolidayDate
            EndDate = $HolidayEndDateString
            Name = $Holiday.'Holiday Name'
            }
    
        }
        return $Holidays
    }
    
    
    $teamsSession = Connect-MicrosoftTeams
    Import-PSSession $teamsSession -AllowClobber
    
    Get-PublicHolidays | ForEach-Object{
    $DateRange = New-CsOnlineDateTimeRange -Start $_.StartDate -End $_.EndDate
    New-CsOnlineSchedule -Name $_.Name -FixedSchedule -DateTimeRanges @($DateRange)
    }
    
    $CurrentHolidays = Get-PublicHolidays
    $CurrentHolidays | Select-Object Name, @{n="StartDateTime1"; e={$_.StartDate +' 00:00'}},@{n="EndDateTime1"; e={$_.EndDate +' 00:00'}},StartDateTime2,EndDateTime2,StartDateTime3,EndDateTime3,StartDateTime4,EndDateTime4,StartDateTime5,EndDateTime5,StartDateTime6,EndDateTime6,StartDateTime7,EndDateTime7,StartDateTime8,EndDateTime8,StartDateTime9,EndDateTime9,StartDateTime10,EndDateTime10 | Export-Csv -Path C:\Temp\Holidays.csv -NoTypeInformation -Force
    $bytes = [System.IO.File]::ReadAllBytes("C:\temp\Holidays.csv")
    $AAs = Get-CsAutoAttendant
    $AAs | % {Import-CsAutoAttendantHolidays -Input $Bytes -Identity $_.Identity}