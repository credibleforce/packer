New-Item -Path "C:\" -Name "Updates" -ItemType Directory -ErrorAction SilentlyContinue

Write-Host "$(Get-Date -Format G): Downloading Windows Management Framework 5.1"
(New-Object Net.WebClient).DownloadFile("https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu", "C:\Updates\Win8.1AndW2K12R2-KB3191564-x64.msu")

$kbid="Win8.1AndW2K12R2-KB3191564-x64"
$update="Install Windows Management Framework 5.1"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse

Write-Host "$(Get-Date -Format G): Finished installing Windows Management Framework 5.1. The VM will now reboot and continue the installation process."