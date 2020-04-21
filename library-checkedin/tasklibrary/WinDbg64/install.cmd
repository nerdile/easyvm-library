@echo off
echo -------------------------------------------------------------------------------
echo  * Installing WinDBG...
start /wait msiexec /qb /i "%~dp0dbg_amd64.msi" INSTDIR=%SystemDrive%\Debuggers
