# Define the registry settings to remediate
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

# Function to set the registry key to the desired value
function Set-RegistryKey {
    param (
        [string]$Path,
        [string]$Key,
        [object]$Value
    )

    try {
        Set-ItemProperty -Path $Path -Name $Key -Value $Value -ErrorAction Stop
        Write-Output "Registry key $Path\$Key set to $Value successfully."
    } catch {
        Write-Output "Failed to set registry key $Path\$Key."
    }
}

foreach ($setting in $registrySettings) {
    Set-RegistryKey -Path $setting.Path -Key $setting.Key -Value $setting.Value
}
