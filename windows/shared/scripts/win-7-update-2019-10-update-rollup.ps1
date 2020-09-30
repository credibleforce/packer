Function Start-Process-Legacy{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        [Parameter(Mandatory=$false)]
        [string]$ArgumentList="",
        [Parameter(Mandatory=$false)]
        [switch]$Wait = $false
    )
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $FilePath
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $ArgumentList
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    if($Wait){$p.WaitForExit(); return $p.ExitCode}
    return 0;
}

New-Item -Path "C:\" -Name "Updates" -ItemType Directory

Write-Host "$(Get-Date -Format G): Downloading October 2019 Update Rollup for Windows 7"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/c/msdownload/update/software/secu/2019/10/windows6.1-kb4519976-x64_58dae3b116e5c3f2e3d8e2623fd50d561601e145.msu", "C:\Updates\windows6.1-kb4519976-x64.msu")

$kbid="windows6.1-kb4519976-x64"
$update="October 2019 Update Rollup for Windows 7"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
$ExitCode = Start-Process-Legacy "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing $update. The VM will now reboot and continue the installation process."