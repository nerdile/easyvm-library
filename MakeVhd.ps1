[CmdletBinding()]
Param(
  [Parameter(Position=0,Mandatory=$True)]
  [string]$SourceFileName,
  [Parameter(Position=1)]
  [string]$OutputVhd,
  [Parameter(Mandatory=$True)]
  [string]$Edition,
  [Parameter()]
  [uint32]$Gen=0
)

Function Infer-GenFromFileName($name) {
  if ($name.Contains("x64")) { return 2; }
  if ($name.Contains("amd64")) { return 2; }
  if ($name.Contains("x86")) { return 1; }
  if ($name.Contains("i386")) { return 1; }
  throw "Unable to infer Gen 1 or Gen 2 - please specify explicitly";
}

if ($Gen -eq 0) {
  $Gen = Infer-GenFromFileName $SourceFileName;
}

if ($Gen -eq 2) {
  Write-Verbose ".\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $SourceFileName -Edition $Edition -VHDFormat VHDX -VhdPartitionStyle GPT -VHDPath $OutputVhd -SizeBytes 200GB -Feature NetFx3 -Verbose"
  .\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $SourceFileName -Edition $Edition -VHDFormat VHDX -VhdPartitionStyle GPT -VHDPath $OutputVhd -SizeBytes 200GB -Feature NetFx3 -Verbose
} else {
  Write-Verbose ".\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $SourceFileName -Edition $Edition -VHDFormat VHD -VhdPartitionStyle MBR -VHDPath $OutputVhd -SizeBytes 200GB -Feature NetFx3 -Verbose"
  .\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $SourceFileName -Edition $Edition -VHDFormat VHD -VhdPartitionStyle MBR -VHDPath $OutputVhd -SizeBytes 200GB -Feature NetFx3 -Verbose
}
