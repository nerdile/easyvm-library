@echo off
echo -------------------------------------------------------------------------------
echo  * Setting up IIS...
powershell -Command "Add-WindowsFeature Web-Server -IncludeAllSubFeature -IncludeManagementTools"
powershell -Command "Add-WindowsFeature AS-HTTP-Activation -IncludeAllSubFeature -IncludeManagementTools"
powershell -Command "Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1"
powershell -Command "Set-Service -name WMSVC -StartupType Automatic"
%SYSTEMROOT%\System32\inetsrv\appcmd.exe delete site "Default Web Site"
