@echo -------------------------------------------------------------------------------
@echo  * Installing SQL Server Enterprise...
"sql2017ent64\setup.exe" /ACTION=Install /QS /IACCEPTSQLSERVERLICENSETERMS /ERRORREPORTING=1 /SQMREPORTING=1 /FEATURES=SQL,Tools /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT="NT SERVICE\MSSQLSERVER" /SQLSYSADMINACCOUNTS="Builtin\Administrators"
powershell -Command "New-NetFirewallRule -Name SqlServer -DisplayName 'SQL Server' -Protocol TCP -LocalPort 1433"
powershell -Command "New-NetFirewallRule -Name SqlServerDbg -DisplayName 'SQL Server Debugging' -Program '%ProgramFiles%\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Binn\sqlservr.exe' -Protocol TCP -LocalPort RPC"
powershell -Command "New-NetFirewallRule -Name SqlServerDbg2 -DisplayName 'SQL Server Debugging (RPC Endpoint Mapper)' -Program '%systemroot%\System32\svchost.exe' -Protocol TCP -LocalPort RPCEPMAP"
