@echo off
echo -------------------------------------------------------------------------------
echo  * Installing Visual C++ Redistributable for Visual Studio 2012 Update 4...
start /wait cmd /c "%~dp0vs2012_vcredist_x64.exe /install /passive /norestart"
