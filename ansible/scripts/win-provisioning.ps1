$admin = [adsi]("WinNT://./{{ windows.local_admin_user }}, user")
$admin.PSBase.Invoke("SetPassword", "{{ windows.local_admin_password }}")

# update nuget
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
if([environment]::OSVersion.version.Major -lt 6) { return }