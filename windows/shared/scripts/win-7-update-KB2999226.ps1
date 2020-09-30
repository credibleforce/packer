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
(New-Object Net.WebClient).DownloadFile("https://download.microsoft.com/download/1/1/5/11565A9A-EA09-4F0A-A57E-520D5D138140/Windows6.1-KB2999226-x64.msu", "C:\Updates\Windows6.1-KB2999226-x64.msu")

$kbid="Windows6.1-KB2999226-x64"
$update="KB2999226 update for Windows 7"

Write-Host "$(Get-Date -Format G): Extracting $update"
$ExitCode = Start-Process-Legacy -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"

Write-Host "$(Get-Date -Format G): Installing $update"
Start-Process -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing $update. The VM will now reboot and continue the installation process."