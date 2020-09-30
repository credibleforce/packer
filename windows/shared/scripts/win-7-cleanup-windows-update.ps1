Get-Service -Name wuauserv | Stop-Service
Rename-Item C:\Windows\SoftwareDistribution SoftwareDistribution.old
Remove-Item -Path C:\Windows\SoftwareDistribution.old -Recurse
Get-Service -Name wuauserv | Start-Service