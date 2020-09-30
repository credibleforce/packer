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


function Expand-ZIPFile($file, $destination)
{
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($file)
    foreach($item in $zip.items())
    {
        $shell.Namespace($destination).copyhere($item)
    }
}

New-Item -Path "C:\" -Name "Updates" -ItemType Directory -ErrorAction SilentlyContinue

Write-Host "$(Get-Date -Format G): Downloading Windows Management Framework 5.1"
(New-Object Net.WebClient).DownloadFile("https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip", "C:\Updates\Win7AndW2K8R2-KB3191566-x64.zip")

Write-Host "$(Get-Date -Format G): Installing Windows Management Framework 5.1"
Expand-ZipFile "C:\Updates\Win7AndW2K8R2-KB3191566-x64.zip" -destination "C:\Updates"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\Win7AndW2K8R2-KB3191566-x64.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
$ExitCode = Start-Process-Legacy -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\Windows6.1-KB2809215-x64.cab /quiet /norestart /LogPath:C:\Windows\Temp\KB2809215-x64.log" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"
$ExitCode = Start-Process-Legacy -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\Windows6.1-KB2872035-x64.cab /quiet /norestart /LogPath:C:\Windows\Temp\KB2872035-x64.log" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"
$ExitCode = Start-Process-Legacy -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\Windows6.1-KB2872047-x64.cab /quiet /norestart /LogPath:C:\Windows\Temp\KB2872047-x64.log" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"
$ExitCode = Start-Process-Legacy -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\Windows6.1-KB3033929-x64.cab /quiet /norestart /LogPath:C:\Windows\Temp\KB3033929-x64.log" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"
$ExitCode = Start-Process-Legacy -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\Windows6.1-KB3191566-x64.cab /quiet /norestart /LogPath:C:\Windows\Temp\KB3191566-x64.log" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse

Write-Host "$(Get-Date -Format G): Finished installing Windows Management Framework 5.1. The VM will now reboot and continue the installation process."