net stop tiledatamodelsvc
%SystemRoot%\System32\reg.exe DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f
%SystemRoot%\System32\reg.exe DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /f
%SystemRoot%\System32\shutdown.exe /s /f /c "Packer shutdown"