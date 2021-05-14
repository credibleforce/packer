New-Item -Path "C:\Updates" -ItemType Directory -ErrorAction SilentlyContinue

$ProgressPreference = "SilentlyContinue"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# stage vc ++
(New-Object Net.WebClient).DownloadFile("https://aka.ms/vs/16/release/vc_redist.x86.exe", "C:\Updates\vc_redist.x86.exe")
(New-Object Net.WebClient).DownloadFile("https://aka.ms/vs/16/release/vc_redist.x64.exe", "C:\Updates\vc_redist.x64.exe")
$ExitCode = start-process -FilePath "C:\Updates\vc_redist.x86.exe" -ArgumentList "/install /q" -Wait
Write-Output "Result VC++ 2019 x86: $ExitCode"
$ExitCode = start-process -FilePath "C:\Updates\vc_redist.x64.exe" -ArgumentList "/install /q" -Wait
Write-Output "Result VC++ 2019 x64: $ExitCode"

# force repair to ensure dll registration (bug in windows 2012r2 vmwware tools install)
$ExitCode = start-process -FilePath "C:\Updates\vc_redist.x86.exe" -ArgumentList "/repair /q" -Wait
Write-Output "Result VC++ 2019 x86: $ExitCode"
$ExitCode = start-process -FilePath "C:\Updates\vc_redist.x64.exe" -ArgumentList "/repair /q" -Wait
Write-Output "Result VC++ 2019 x64: $ExitCode"

# install vmware tools
$version_url = "https://packages.vmware.com/tools/releases/latest/windows/x64/"
try{
$raw_package = (New-Object System.Net.WebClient).DownloadString($version_url)
}catch{
Write-Output "Error Finding VMWare Package: $_"
}

$raw_package -match "VMware-tools[\w-\d\.]*\.exe"
$package = $Matches.0
$url = "https://packages.vmware.com/tools/releases/latest/windows/x64/$package"
$exe = "C:\Updates\$package"
Write-Output "***** Downloading VMware Tools: $url to $exe"

try{
(New-Object System.Net.WebClient).DownloadFile($url, $exe)
}catch{
Write-Output "Error Downloading VMWare Package: $_"
}

Write-Output "***** Installing VMware Tools: $exe"
$ExitCode = Start-Process -FilePath "$exe" -ArgumentList '/S /v "/qn REBOOT=R ADDLOCAL=ALL"' -Wait
Write-Output "Result: $ExitCode"