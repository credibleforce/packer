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

New-Item -Path "C:\" -Name "Updates" -ItemType Directory -ErrorAction SilentlyContinue

Write-Host "$(Get-Date -Format G): Downloading .NET Framework 4.8"
(New-Object Net.WebClient).DownloadFile("https://download.visualstudio.microsoft.com/download/pr/014120d7-d689-4305-befd-3cb711108212/0fd66638cde16859462a6243a4629a50/ndp48-x86-x64-allos-enu.exe", "C:\Updates\ndp48-x86-x64-allos-enu.exe")
 
Write-Host "$(Get-Date -Format G): Installing .NET Framework 4.8"
$ExitCode = Start-Process-Legacy -FilePath "C:\Updates\ndp48-x86-x64-allos-enu.exe" -ArgumentList "/passive /norestart /log C:\Windows\Temp\ndp48-x86-x64-allos-enu.log" -Wait
Write-Host "Result: $ExitCode"

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing .NET Framework 4.8. The VM will now reboot and continue the installation process."
