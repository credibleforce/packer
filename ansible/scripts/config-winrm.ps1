# You cannot change the network location if you are joined to a domain, so abort
if(1,3,4,5 -contains (Get-WmiObject win32_computersystem).DomainRole) { return }

# Get network connections
$networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$connections = $networkListManager.GetNetworkConnections()

$connections |foreach {
  $_.GetNetwork().SetCategory(1)
}

Set-Item -Path WSMan:\LocalHost\MaxTimeoutms -Value '1800000'
Set-Item -Path WSMan:\LocalHost\Shell\MaxMemoryPerShellMB -Value '2048'
Set-Item -Path WSMan:\LocalHost\Shell\MaxShellsPerUser -Value '30'
Set-Item -Path WSMan:\LocalHost\Shell\MaxConcurrentUsers -Value '30'
Set-Item -Path WSMan:\LocalHost\Shell\MaxProcessesPerShell -Value '30'
Set-Item -Path WSMan:\LocalHost\Service\AllowUnencrypted -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Basic -Value 'false'
Set-Item -Path WSMan:\LocalHost\Service\Auth\CredSSP -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Negotiate -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Kerberos -Value 'true'
Set-Item -Path WSMan:\LocalHost\Service\Auth\Certificate -Value 'true'

Enable-PSRemoting -Force