# disable winrm firewall rules
Write-Output "Disabling WinRM over HTTP/HTTPS..."
# Disable-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -ErrorAction SilentlyContinue
# Disable-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -ErrorAction SilentlyContinue
# Disable-NetFirewallRule -Name "WINRM-HTTPS-In-TCP" -ErrorAction SilentlyContinue
# Disable-NetFirewallRule -Name "WINRM-HTTPS-In-TCP-PUBLIC" -ErrorAction SilentlyContinue
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new profile=any enable=no
netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In)" new profile="Domain,Private" enable=no
netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In-Public)" new profile="Public" enable=no

Write-Output "Disable LocalAccountTokenFilterPolicy"
# Ensure LocalAccountTokenFilterPolicy is set to 1
# https://github.com/ansible/ansible/issues/42978
$token_path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$token_prop_name = "LocalAccountTokenFilterPolicy"
$token_key = Get-Item -Path $token_path
$token_value = $token_key.GetValue($token_prop_name, $null)
if ($token_value -ne 0) {
    Write-Verbose "Setting LocalAccountTOkenFilterPolicy to 0"
    if ($null -ne $token_value) {
        Remove-ItemProperty -Path $token_path -Name $token_prop_name
    }
    New-ItemProperty -Path $token_path -Name $token_prop_name -Value 0 -PropertyType DWORD > $null
}

# disable winrm service
Write-Output "Disable WinRM Service"
$winrmService = Get-Service -Name WinRM -ErrorAction SilentlyContinue
if ($winrmService.Status -eq "Running"){
    # remove winrm listeners
    Write-Output "Disable WinRM Listener"
    Get-ChildItem WSMan:\Localhost\listener | Remove-Item -Recurse
    Disable-PSRemoting -Force
    
}
Stop-Service winrm
Set-Service -Name winrm -StartupType Disabled

# Test a remoting connection to localhost, which should work.
$httpResult = Invoke-Command -ComputerName "localhost" -ScriptBlock {$env:COMPUTERNAME} -ErrorVariable httpError -ErrorAction SilentlyContinue
$httpsOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$httpsResult = New-PSSession -UseSSL -ComputerName "localhost" -SessionOption $httpsOptions -ErrorVariable httpsError -ErrorAction SilentlyContinue
If ($httpResult -and $httpsResult)
{
    Write-Output "HTTP: Enabled | HTTPS: Enabled"
}
ElseIf ($httpsResult -and !$httpResult)
{
    Write-Output "HTTP: Disabled | HTTPS: Enabled"
}
ElseIf ($httpResult -and !$httpsResult)
{
    Write-Output "HTTP: Enabled | HTTPS: Disabled"
}
Else
{
    Write-Output "Unable to establish an HTTP or HTTPS remoting session."
}
Write-Output "WinRM has been successfully disable."