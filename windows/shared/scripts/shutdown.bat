echo "Shutting down" > "%temp%\shutdown.txt"
net stop tiledatamodelsvc > /nul 2>&1
c:\windows\system32\shutdown.exe /s /t 10 /f /d p:4:1 /c Packer_Provisioning_Shutdown