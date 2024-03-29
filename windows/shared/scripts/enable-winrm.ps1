Function New-LegacySelfSignedCert
{
    Param (
        [string]$SubjectName,
        [int]$ValidDays = 1095
    )

    $hostnonFQDN = $env:computerName
    $hostFQDN = [System.Net.Dns]::GetHostByName(($env:computerName)).Hostname
    $SignatureAlgorithm = "SHA256"

    $name = New-Object -COM "X509Enrollment.CX500DistinguishedName.1"
    $name.Encode("CN=$SubjectName", 0)

    $key = New-Object -COM "X509Enrollment.CX509PrivateKey.1"
    $key.ProviderName = "Microsoft Enhanced RSA and AES Cryptographic Provider"
    $key.KeySpec = 1
    $key.Length = 4096
    $key.SecurityDescriptor = "D:PAI(A;;0xd01f01ff;;;SY)(A;;0xd01f01ff;;;BA)(A;;0x80120089;;;NS)"
    $key.MachineContext = 1
    $key.Create()

    $serverauthoid = New-Object -COM "X509Enrollment.CObjectId.1"
    $serverauthoid.InitializeFromValue("1.3.6.1.5.5.7.3.1")
    $ekuoids = New-Object -COM "X509Enrollment.CObjectIds.1"
    $ekuoids.Add($serverauthoid)
    $ekuext = New-Object -COM "X509Enrollment.CX509ExtensionEnhancedKeyUsage.1"
    $ekuext.InitializeEncode($ekuoids)

    $cert = New-Object -COM "X509Enrollment.CX509CertificateRequestCertificate.1"
    $cert.InitializeFromPrivateKey(2, $key, "")
    $cert.Subject = $name
    $cert.Issuer = $cert.Subject
    $cert.NotBefore = (Get-Date).AddDays(-1)
    $cert.NotAfter = $cert.NotBefore.AddDays($ValidDays)

    $SigOID = New-Object -ComObject X509Enrollment.CObjectId
    $SigOID.InitializeFromValue(([Security.Cryptography.Oid]$SignatureAlgorithm).Value)

    [string[]] $AlternativeName  += $hostnonFQDN
    $AlternativeName += $hostFQDN
    $IAlternativeNames = New-Object -ComObject X509Enrollment.CAlternativeNames

    foreach ($AN in $AlternativeName)
    {
        $AltName = New-Object -ComObject X509Enrollment.CAlternativeName
        $AltName.InitializeFromString(0x3,$AN)
        $IAlternativeNames.Add($AltName)
    }

    $SubjectAlternativeName = New-Object -ComObject X509Enrollment.CX509ExtensionAlternativeNames
    $SubjectAlternativeName.InitializeEncode($IAlternativeNames)

    [String[]]$KeyUsage = ("DigitalSignature", "KeyEncipherment")
    $KeyUsageObj = New-Object -ComObject X509Enrollment.CX509ExtensionKeyUsage
    $KeyUsageObj.InitializeEncode([int][Security.Cryptography.X509Certificates.X509KeyUsageFlags]($KeyUsage))
    $KeyUsageObj.Critical = $true

    $cert.X509Extensions.Add($KeyUsageObj)
    $cert.X509Extensions.Add($ekuext)
    $cert.SignatureInformation.HashAlgorithm = $SigOID
    $CERT.X509Extensions.Add($SubjectAlternativeName)
    $cert.Encode()

    $enrollment = New-Object -COM "X509Enrollment.CX509Enrollment.1"
    $enrollment.InitializeFromRequest($cert)
    $certdata = $enrollment.CreateRequest(0)
    $enrollment.InstallResponse(2, $certdata, 0, "")

    # extract/return the thumbprint from the generated cert
    $parsed_cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $parsed_cert.Import([System.Text.Encoding]::UTF8.GetBytes($certdata))

    return $parsed_cert.Thumbprint
}

# Configure Network Adapters
Write-Output "Ensuring network adapters are set to home/work"
$NetworkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$Connections = $NetworkListManager.GetNetworkConnections()
$Connections | ForEach-Object { $_.GetNetwork().SetCategory(1) }

Write-Output "Restarting WinRM Service..."
Stop-Service WinRM
Set-Service WinRM -StartupType "Automatic"
Start-Service WinRM

# Remove WinRM Listeners
Get-ChildItem WSMan:\Localhost\listener | Remove-Item -Recurse

Write-Output "Restarting WinRM Service..."
Stop-Service WinRM
Set-Service WinRM -StartupType "Automatic"
Start-Service WinRM

# Configure WinRM Defaults
Write-Output "Set WinRM Default"
Set-Item -Path WSMan:\LocalHost\MaxTimeoutms -Value '1800000'
Set-Item -Path WSMan:\LocalHost\Shell\MaxMemoryPerShellMB -Value '2048'
Set-Item -Path WSMan:\LocalHost\Shell\MaxShellsPerUser -Value '30'
Set-Item -Path WSMan:\LocalHost\Shell\MaxConcurrentUsers -Value '30'
Set-Item -Path WSMan:\LocalHost\Shell\MaxProcessesPerShell -Value '30'
Set-Item -Path WSMan:\LocalHost\Service\AllowUnencrypted -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Basic -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\CredSSP -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Negotiate -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Kerberos -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Certificate -Value 'true'

# Configure firewall to allow WinRM HTTP connections.
Write-Output "Enabling Inbound Firewall Rules for WinRM HTTP"
netsh advfirewall firewall add rule name="Windows Remote Management (HTTP-In)" profile="Domain,Private" dir=in localport=5985 protocol=TCP action=allow
netsh advfirewall firewall add rule name="Windows Remote Management (HTTP-In-Public)" profile="Public" dir=in localport=5985 protocol=TCP action=allow

# Configure firewall to allow WinRM HTTPS connections.
Write-Output "Enabling Inbound Firewall Rules for WinRM HTTPS"
#$fwtest1 = Get-NetFirewallRule -Name "WINRM-HTTPS-In-TCP" -ErrorAction SilentlyContinue
#$fwtest2 = Get-NetFirewallRule -Name "WINRM-HTTPS-In-TCP-PUBLIC" -ErrorAction SilentlyContinue
$fwtest1 = netsh advfirewall firewall show rule name="Windows Remote Management (HTTPS-In)" profile="Domain,Private"
$fwtest2 = netsh advfirewall firewall show rule name="Windows Remote Management (HTTPS-In-Public)" profile="Public"

If ($fwtest1.count -lt 5)
{
    Write-Output "Enable WinRM HTTPS Firewall Inbound for Domain/Private"
    # New-NetFirewallRule -Name "WINRM-HTTPS-In-TCP" `
    #     -DisplayName "Windows Remote Management (HTTPS-In)" `
    #     -Description "Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]" `
    #     -Group "Windows Remote Management" `
    #     -Program "System" `
    #     -Protocol TCP `
    #     -LocalPort "5986" `
    #     -Action Allow `
    #     -Profile Domain,Private
    netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" profile="Domain,Private" dir=in localport=5986 protocol=TCP action=allow
}ElseIf ($fwtest1.count -ge 5){
    Write-Output "Enabling WinRM HTTPS Firewall Inbound for Domain/Private"
    #Enable-NetFirewallRule -Name "WINRM-HTTPS-In-TCP" -ErrorAction SilentlyContinue
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In)" new profile="Domain,Private" enable=yes
}
If ($fwtest2.count -lt 5)
{
    Write-Output "Enable WinRM HTTPS Firewall Inbound for Public"
    # New-NetFirewallRule -Name "WINRM-HTTPS-In-TCP-PUBLIC" `
    #     -DisplayName "Windows Remote Management (HTTPS-In)" `
    #     -Description "Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]" `
    #     -Group "Windows Remote Management" `
    #     -Program "System" `
    #     -Protocol TCP `
    #     -LocalPort "5986" `
    #     -Action Allow `
    #     -Profile Public
    netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In-Public)" profile="Public" dir=in localport=5986 protocol=TCP action=allow
}ElseIf ($fwtest2.count -gt 5){
    Write-Output "Enabling WinRM HTTPS Firewall Inbound for Public"
    #Enable-NetFirewallRule -Name "WINRM-HTTPS-In-TCP-PUBLIC" -ErrorAction SilentlyContinue
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In-Public)" new profile="Public" enable=yes
}


Write-Output "Enable LocalAccountTokenFilterPolicy"
# Ensure LocalAccountTokenFilterPolicy is set to 1
# https://github.com/ansible/ansible/issues/42978
$token_path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$token_prop_name = "LocalAccountTokenFilterPolicy"
$token_key = Get-Item -Path $token_path
$token_value = $token_key.GetValue($token_prop_name, $null)
if ($token_value -ne 1) {
    Write-Output "Setting LocalAccountTOkenFilterPolicy to 1"
    if ($null -ne $token_value) {
        Remove-ItemProperty -Path $token_path -Name $token_prop_name
    }
    New-ItemProperty -Path $token_path -Name $token_prop_name -Value 1 -PropertyType DWORD > $null
}

Write-Output "Enable WinRM HTTP Listener"
New-Item -Path WSMan:\LocalHost\Listener -Address * -Transport HTTP -Port "5985" -force

Write-Output "Enable WinRM HTTPS Listener"
$Hostname = [System.Net.Dns]::GetHostByName((hostname)).HostName.ToUpper()
$thumbprint = New-LegacySelfSignedCert -SubjectName $Hostname
New-Item -Path WSMan:\LocalHost\Listener -Address * -Transport HTTPS -Hostname $Hostname -CertificateThumbPrint $thumbprint -Port "5986" -force

Write-Output "Restarting WinRM Service..."
Stop-Service WinRM
Set-Service WinRM -StartupType "Automatic"
Start-Service WinRM

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
Write-Output "PS Remoting has been successfully configured."