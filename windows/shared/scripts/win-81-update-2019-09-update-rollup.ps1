New-Item -Path "C:\" -Name "Updates" -ItemType Directory

Write-Host "$(Get-Date -Format G): Downloading Convenience rollup update for Windows 8.1 2019-09"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/d/msdownload/update/software/secu/2019/09/windows6.1-kb4516065-x64_40a6dff87423268e55a909d40a310ac66386be0d.msu", "C:\Updates\windows6.1-kb4516065-x64.msu")

$kbid="windows6.1-kb4516065-x64"
$update="Convenience rollup update for Windows 8.1 - 2019-09"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing $update. The VM will now reboot and continue the installation process."