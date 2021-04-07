#Created by https://github.com/VladimirKosyuk

#Disables Windows 10 update feature

# Build date: 07.04.2021

if ((Get-WMIObject win32_operatingsystem | select Caption) -like "*Windows 10*"){
    $Wupdate = Get-WmiObject win32_service | Where-Object{($_.Name -eq 'wuauserv')}| Select-Object -ExpandProperty "Name"
    Stop-Service -name $Wupdate -ErrorAction SilentlyContinue
    Set-Service $Wupdate -StartupType Disabled
    }
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue