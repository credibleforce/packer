New-Item -Path "C:\" -Name "Updates" -ItemType Directory

# kb2937592
Write-Host "$(Get-Date -Format G): Downloading Update for Windows 8.1 - kb2937592"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/c/msdownload/update/software/crup/2014/02/windows8.1-kb2937592-x64_4abc0a39c9e500c0fbe9c41282169c92315cafc2.msu", "C:\Updates\windows8.1-kb2937592-x64.msu")

$kbid="windows8.1-kb2937592-x64"
$update="Update for Windows 8.1 - kb2937592"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

# kb2959977
Write-Host "$(Get-Date -Format G): Downloading Update for Windows 8.1 - kb2959977"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/c/msdownload/update/software/secu/2014/04/windows8.1-kb2959977-x64_574ba2d60baa13645b764f55069b74b2de866975.msu", "C:\Updates\windows8.1-kb2959977-x64.msu")

$kbid="windows8.1-kb2959977-x64"
$update="Update for Windows 8.1 - kb2959977"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

# kb2934018
Write-Host "$(Get-Date -Format G): Downloading Update for Windows 8.1 - kb2934018"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/c/msdownload/update/software/secu/2014/04/windows8.1-kb2934018-x64_234a5fc4955f81541f5bfc0d447e4fc4934efc38.msu", "C:\Updates\windows8.1-kb2934018-x64.msu")

$kbid="windows8.1-kb2934018-x64"
$update="Update for Windows 8.1 - kb2934018"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

# kb2938439
Write-Host "$(Get-Date -Format G): Downloading Update for Windows 8.1 - kb2938439"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/c/msdownload/update/software/crup/2014/03/windows8.1-kb2938439-x64_3ed1574369e36b11f37af41aa3a875a115a3eac1.msu", "C:\Updates\windows8.1-kb2938439-x64.msu")

$kbid="windows8.1-kb2938439-x64"
$update="Update for Windows 8.1 - kb2938439"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

# kb2919355
Write-Host "$(Get-Date -Format G): Downloading Update for Windows 8.1 - kb2919355"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/d/msdownload/update/software/crup/2014/02/windows8.1-kb2919355-x64_e6f4da4d33564419065a7370865faacf9b40ff72.msu", "C:\Updates\windows8.1-kb2919355-x64.msu")

$kbid="windows8.1-kb2919355-x64"
$update="Update for Windows 8.1 - kb2919355"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

# kb2932046
Write-Host "$(Get-Date -Format G): Downloading Update for Windows 8.1 - kb2932046"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/d/msdownload/update/software/crup/2014/02/windows8.1-kb2932046-x64_6aee5fda6e2a6729d1fbae6eac08693acd70d985.msu", "C:\Updates\windows8.1-kb2932046-x64.msu")

$kbid="windows8.1-kb2932046-x64"
$update="Update for Windows 8.1 - kb2932046"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait


Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing $update. The VM will now reboot and continue the installation process."