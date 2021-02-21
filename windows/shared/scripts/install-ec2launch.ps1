$EC2LaunchZip = 'https://s3.amazonaws.com/ec2-downloads-windows/EC2Launch/latest/EC2-Windows-Launch.zip'
$OutPath = "C:\ProgramData\Amazon\EC2-Windows\EC2-Windows-Launch.zip"
$EC2LaunchInstall = 'https://s3.amazonaws.com/ec2-downloads-windows/EC2Launch/latest/install.ps1'
$OutInstallPath = "C:\ProgramData\Amazon\EC2-Windows\install.ps1"


# $LPath = 'C:\ProgramData\Amazon\EC2-Windows\Launch'
# New-Item -ItemType Directory -Force -Path $LPath

Invoke-WebRequest -Uri $EC2LaunchZip -OutFile $OutPath
Invoke-WebRequest -Uri $EC2LaunchInstall -OutFile $OutInstallPath
& $EC2LaunchInstall

# Expand-Archive -Path $OutPath -DestinationPath $LPath
# Remove-Item $OutPath

# prepare the custom unattend if it exists
if(test-path "A:\AWS_Unattend.xml"){
    Remove-Item -Path $("{0}\Sysprep\Unattend.xml" -f $LPath)
    Copy-Item -Path "A:\AWS_Unattend.xml" $("{0}\Sysprep\Unattend.xml" -f $LPath)
}