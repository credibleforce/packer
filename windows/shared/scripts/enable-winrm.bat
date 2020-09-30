rem Enable-NetFirewallRule for WinRM
netsh advfirewall firewall add rule name="Port 5985" dir=in action=allow protocol=TCP localport=5985
sc.exe config winrm start= auto

cmd.exe /c winrm quickconfig -q

cmd.exe /c winrm set winrm/config @{MaxTimeoutms="1800000"}

cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}
cmd.exe /c winrm set winrm/config/client/auth @{Basic="true"}

cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="2048"}
cmd.exe /c winrm set winrm/config/winrs @{MaxShellsPerUser="30"}
cmd.exe /c winrm set winrm/config/winrs @{MaxConcurrentUsers="30"}
cmd.exe /c winrm set winrm/config/winrs @{MaxProcessesPerShell="30"}