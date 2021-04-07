#Created by https://github.com/VladimirKosyuk

#Installs windows updates to Windows 10

#About:

 <#

Does:

1. If PSWindowsUpdate not installed - installes it
2. Starts windows update servise
3. Execute update with reboot after installation, logging to $OutputLog
 #>

# Build date: 07.04.2021

$OutputLog = ""#example \\srv\log
$Name = Get-WmiObject -Class Win32_ComputerSystem |Select-Object -ExpandProperty "name"

if ((Test-Path $OutputLog) -eq "True"){$Log = $OutputLog}
else {$Log = "C:\"}


if ((Get-WMIObject win32_operatingsystem | select Caption) -like "*Windows 10*"){

Write-Output ((Get-Date -Format "dddd MM/dd HH:mm")+" "+"enabling updates") | Out-File $Log\$Name.log -Append
    if (!(Get-InstalledModule | ?{$_.name -eq "PSWindowsUpdate"})) {
        try{
            Write-Output ((Get-Date -Format "HH:mm")+" "+"installing PSWindowsUpdate"| Out-File $Log\$Name.log -Append)
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Install-PackageProvider -Name Nuget -minimumVersion 2.8.5.201 -force
            Install-Module -Name PSWindowsUpdate -Force
            Import-Module -Name PSWindowsUpdate -Force
            }
        catch{
            Write-Output ((Get-Date -Format "HH:mm")+($Error[0].Exception.Message )) | Out-File $Log\$Name.log -Append
            Break
            }
    }
$Wupdate = Get-WmiObject win32_service | Where-Object{($_.Name -eq 'wuauserv')}| Select-Object -ExpandProperty "Name" 
start-Service -name $Wupdate -ErrorAction SilentlyContinue
Set-Service $Wupdate -StartupType Manual

if (Get-WindowsUpdate ){Get-WindowsUpdate -acceptall -autoreboot -install -verbose | Out-File $Log\$Name.log -Append}
else {Write-Output ((Get-Date -Format "HH:mm")+" "+"no updates availible"| Out-File $Log\$Name.log -Append)}
}
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue