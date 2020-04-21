@echo off
echo -------------------------------------------------------------------------------
echo  * Installing Visual Studio 2012u2 Remote Debugger (x64)...
start /wait "title" "%~dp0rtools_setup_x64.exe" /install /passive
powershell -Command "New-NetFirewallRule -Name VSRDBGx64 -DisplayName VisualStudioRemoteDebugger -Program '%ProgramFiles%\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x64\msvsmon.exe'"
powershell -Command "New-NetFirewallRule -Name VSRDBGx32 -DisplayName VisualStudioRemoteDebugger -Program '%ProgramFiles%\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x86\msvsmon.exe'"
