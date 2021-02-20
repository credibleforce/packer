net stop tiledatamodelsvc
%SystemRoot%\System32\reg.exe DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f
%SystemRoot%\System32\reg.exe DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /f
REM set MY_SESSION_ID=unknown
REM for /f "tokens=3-4" %%a in ('query session %username%') do @if "%%b"=="Active" set MY_SESSION_ID=%%a
REM logoff %MY_SESSION_ID%
start %SystemRoot%\System32\shutdown /s /f /t 1800 /c "Packer shutdown"