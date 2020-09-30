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

# First check if Service Pack 1 is installed.
$os = Get-WmiObject -class Win32_OperatingSystem
if ($os.ServicePackMajorVersion -ge 1) {
    Write-Host "Windows 7 Service Pack 1 is already installed."
    Exit
}

New-Item -Path "C:\" -Name "Updates" -ItemType Directory

Write-Host "$(Get-Date -Format G): Downloading and installing Windows 7 Service Pack 1."
Write-Host "$(Get-Date -Format G): This process can take up to 30 minutes."

Write-Host "$(Get-Date -Format G): Downloading Windows 7 Service Pack 1"
try{
    (New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/msdownload/update/software/svpk/2011/02/windows6.1-kb976932-x64_74865ef2562006e51d7f9333b4a8d45b7a749dab.exe", "C:\Updates\windows6.1-KB976932-X64.exe")

    Write-Host "$(Get-Date -Format G): Installing Windows 7 Service Pack 1"
    $ExitCode = Start-Process-Legacy -FilePath "C:\Updates\Windows6.1-KB976932-X64.exe" -ArgumentList "/quiet /nodialog /norestart" -Wait
    Write-Host "Result: $ExitCode"

    Remove-Item -LiteralPath "C:\Updates" -Force -Recurse

    Write-Host "$(Get-Date -Format G): Finished installing Windows 7 Service Pack 1. The VM will now reboot and continue the installation process."
    Write-Host "$(Get-Date -Format G): This may take a couple of minutes."

    Exit 0
}catch{
    Write-Host "$(Get-Date -Format G): Failed To Download/Install Windows 7 Service Pack 1"
    Write-Host "$(Get-Date -Format G): Error - $_"
    Exit 1
}