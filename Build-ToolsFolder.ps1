del -force -recurse "$pwd\tools" -ea 0
[void](mkdir "$pwd\tools\modules\easyvm");
copy "$pwd\easyvm\easyvm.psm1" tools\modules\easyvm\.

# Include any team-specific powershell modules, if desired

copy installer\install.bat tools\.

# Assume that the Library is shared as \\.\VMLibrary
# Include this in the installer so teammates don't get prompted for it.
$myhostname = (Get-WmiObject win32_computersystem).DNSHostName;
$mydomain = (Get-WmiObject win32_computersystem -ea 0).Domain
if ($mydomain) { $myhostname = "$myhostname.$mydomain"; }
Add-Content tools\install.bat "reg add HKCU\Software\Awesome\EasyVM /v homedir /d \\$myhostname\VMLibrary /t REG_SZ /f"
