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
}else{
    Write-Host "Windows 7 Service Pack 1 missing."
}

New-Item -Path "C:\" -Name "Updates" -ItemType Directory

Write-Host "$(Get-Date -Format G): Downloading and installing Windows 7 Certificate Trusted Roots Update."
Write-Host "$(Get-Date -Format G): This process can take up to 30 minutes."

Write-Host "$(Get-Date -Format G): Downloading Windows 7 Certificate Trusted Roots Update"
(New-Object Net.WebClient).DownloadFile("http://ctldl.windowsupdate.com/msdownload/update/v3/static/trustedr/en/authrootstl.cab", "C:\Updates\authrootstl.cab")
(New-Object Net.WebClient).DownloadFile("http://ctldl.windowsupdate.com/msdownload/update/v3/static/trustedr/en/disallowedcertstl.cab", "C:\Updates\disallowedcertstl.cab")
(New-Object Net.WebClient).DownloadFile("http://download.windowsupdate.com/d/msdownload/update/software/secu/2013/05/windows6.1-kb2813430-x64_0a282a6077331c034ba2d31b85dfe65dcc71e380.msu", "C:\Updates\windows6.1-kb2813430-x64.msu")
(New-Object Net.WebClient).DownloadFile("http://download.microsoft.com/download/2/4/8/248D8A62-FCCD-475C-85E7-6ED59520FC0F/MicrosoftRootCertificateAuthority2011.cer", "C:\Updates\MicrosoftRootCertificateAuthority2011.cer")

# expand the cab file to obtain the sst
Write-Host "$(Get-Date -Format G): Expanding authrootstl.cab..."
Start-Process -FilePath "cmd" -ArgumentList "/c expand c:\updates\authrootstl.cab -F:* C:\updates\authroot.sst" -Wait
Write-Host "$(Get-Date -Format G): Expanding disallowedcertstl.cab..."
Start-Process -FilePath "cmd" -ArgumentList "/c expand c:\updates\disallowedcertstl.cab -F:* C:\updates\disallowedcert.sst" -Wait

#import authorized roots
try{
    [reflection.assembly]::LoadWithPartialName("System.Security")
    $certs = new-object system.security.cryptography.x509certificates.x509certificate2collection
    $certs.import("c:\updates\authroot.sst")
    $store = new-object system.security.cryptography.X509Certificates.X509Store -argumentlist "AuthRoot", LocalMachine
    $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]"ReadWrite")
    $store.AddRange($certs)
}catch{
    Write-Host "$(Get-Date -Format G): Error: $Error[0]"
}

# import disallowed roots
try{
    [reflection.assembly]::LoadWithPartialName("System.Security")
    $certs = new-object system.security.cryptography.x509certificates.x509certificate2collection
    $certs.import("c:\updates\disallowedcert.sst")
    $store = new-object system.security.cryptography.X509Certificates.X509Store -argumentlist "Disallowed", LocalMachine
    $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]"ReadWrite")
    $store.AddRange($certs)
}catch{
    Write-Host "$(Get-Date -Format G): Error: $Error[0]"
}

# install kb2813430
$kbid="windows6.1-kb2813430-x64"
$update="Install kb2813430"

Write-Host "$(Get-Date -Format G): Extracting $update"
Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Updates\$kbid.msu /extract:C:\Updates" -Wait

Write-Host "$(Get-Date -Format G): Installing $update"
$ExitCode = Start-Process-Legacy -FilePath "dism.exe" -ArgumentList "/online /add-package /PackagePath:C:\Updates\$kbid.cab /quiet /norestart /LogPath:C:\Windows\Temp\$kbid.log" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"

# install updated microsoft root cert
Write-Host "$(Get-Date -Format G): Importing Microsoft Root Cert"
$ExitCode = Start-Process-Legacy -FilePath "certutil" -ArgumentList "-addstore ""Root"" ""C:\Updates\MicrosoftRootCertificateAuthority2011.cer""" -Wait
Write-Host "$(Get-Date -Format G): Result: $ExitCode"

Remove-Item -LiteralPath "C:\Updates" -Force -Recurse
Write-Host "$(Get-Date -Format G): Finished installing. The VM will now reboot and continue the installation process."