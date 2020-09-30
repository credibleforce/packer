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

Write-Host "$(Get-Date -Format G): Downloading Convenience rollup update for Windows 7"
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/05/windows6.1-kb3125574-v4-x64_2dafb1d203c8964239af3048b5dd4b1264cd93b9.msu", "C:\Updates\windows6.1-kb3125574-v4-x64.msu")

$kbid="windows6.1-kb3125574-v4-x64"
$update="Convenience rollup update for Windows 7"

Write-Host "$(Get-Date -Format G): Extracting $update"
$ExitCode = Start-Process-Legacy -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing $update. The VM will now reboot and continue the installation process."