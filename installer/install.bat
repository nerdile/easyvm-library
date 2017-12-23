@echo off
REM Set this to your library share to avoid users being prompted
REM reg add HKCU\Software\Awesome\EasyVM /v homedir /d \\myserver.mydomain\VMLibrary /t REG_SZ /f

mkdir "%USERPROFILE%\Documents\WindowsPowerShell\Modules"
xcopy /s /y /d %~dp0\modules\* "%USERPROFILE%\Documents\WindowsPowerShell\Modules\"
