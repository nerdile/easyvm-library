[CmdletBinding()]
Param(
    [string[]] $AllowedUsers
)

New-SmbShare -Name "VMTools" -Path "$pwd\tools" -ReadAccess $AllowedUsers
New-SmbShare -Name "VMLibrary" -Path "$pwd\library" -ReadAccess $AllowedUsers
