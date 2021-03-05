net stop tiledatamodelsvc > /nul 2>&1
if exist a:\unattend.xml (
  c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /quiet /unattend:a:\unattend.xml
) else (
  del /F \Windows\System32\Sysprep\unattend.xml
  c:\windows\system32\sysprep\sysprep.exe /generalize /quiet /oobe
)
