New-Item -Path "C:\" -Name "Updates" -ItemType Directory

Write-Host "$(Get-Date -Format G): Downloading Convenience rollup update for Windows 8.1 2020-01"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/c/msdownload/update/software/secu/2020/01/windows6.1-kb4534310-x64_4dc78a6eeb14e2eac1ede7381f4a93658c8e2cdc.msu", "C:\Updates\windows6.1-kb4534310-x64.msu")

$kbid="windows6.1-kb4519976-x64"
$update="Convenience rollup update for Windows 8.1 - 2020-01"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing $update. The VM will now reboot and continue the installation process."