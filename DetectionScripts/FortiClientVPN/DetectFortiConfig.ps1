# Define the registry settings to check
$registrySettings = @(
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="use_external_browser"; Value=0; Type="DWORD"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="sso_enabled"; Value=1; Type="DWORD"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="ServerCert"; Value=1; Type="SZ"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="Server"; Value="URL"; Type="SZ"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="promptusername"; Value=0; Type="DWORD"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="promptcertificate"; Value=0; Type="DWORD"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="Description"; Value=""; Type="SZ"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="DATA3"; Value=""; Type="SZ"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="DATA1"; Value="VALUE"; Type="SZ"},
    @{Path="HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\NCI-AUS"; Key="azure_auto_login"; Value=0; Type="DWORD"}
)

# Function to check if the registry key exists and has the correct value
function Test-RegistryKey {
    param (
        [string]$Path,
        [string]$Key,
        [object]$Value
    )

    try {
        $currentValue = Get-ItemPropertyValue -Path $Path -Name $Key -ErrorAction Stop
        if ($currentValue -eq $Value) {
            return $true
        } else {
            return $false
        }
    } catch {
        return $false
    }
}

$allSettingsCorrect = $true

foreach ($setting in $registrySettings) {
    if (-not (Test-RegistryKey -Path $setting.Path -Key $setting.Key -Value $setting.Value)) {
        Write-Output "Registry key $($setting.Path)\$($setting.Key) is not set correctly."
        $allSettingsCorrect = $false
    }
}

if ($allSettingsCorrect) {
    Write-Output "All registry keys are set correctly."
    exit 0  # Success
} else {
    Write-Output "One or more registry keys are not set correctly."
    exit 1  # Failure
}

Pause
