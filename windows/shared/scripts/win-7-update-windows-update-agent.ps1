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

Write-Host "$(Get-Date -Format G): Downloading Windows Update Agent"
try{
    (New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/windowsupdateagent-7.6-x64.exe","c:\Updates\windowsupdateagent-7.6-x64.exe")

    Write-Host "$(Get-Date -Format G): Installing Windows Update Agent"
    $ExitCode = Start-Process-Legacy -FilePath "c:\updates\windowsupdateagent-7.6-x64.exe" -ArgumentList "/quiet /norestart" -wait
    Write-Host "Result: $ExitCode"

    Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
    Write-Host "$(Get-Date -Format G): Finished installing Windows Update Agent"
    Exit 0
}catch{
    Write-Host "$(Get-Date -Format G): Failed To Download/Install Windows 7 Service Pack 1"
    Write-Host "$(Get-Date -Format G): Error - $_"
    Exit 1
}