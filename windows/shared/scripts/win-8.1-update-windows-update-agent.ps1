New-Item -Path "C:\" -Name "Updates" -ItemType Directory -ErrorAction SilentlyContinue

Write-Host "$(Get-Date -Format G): Downloading Windows Update Agent"
(New-Object Net.WebClient).DownloadFile("https://download.microsoft.com/download/C/4/F/C4F803A8-D91E-435E-90BF-5BCB019A4010/Windows8-RT-KB2937636-x64.msu","c:\Updates\Windows8-RT-KB2937636-x64.msu")

$kbid="Windows8-RT-KB2937636-x64"
$update="Install Update Agent"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing Windows Update Agent"
