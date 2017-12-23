$vhdroot = "$pwd\library\vhd"
$isoroot = "$pwd\library\iso"
$temp = "$pwd\temp"

if (!(Test-Path .\library-vhds.xml)) { throw "library-vhds.xml not found in current directory"; }
if (!(Test-Path $vhdroot)) { [void](mkdir $vhdroot); }
if (!(Test-Path $temp)) { [void](mkdir $temp); }

$spec = [xml](gc .\library-vhds.xml)

Function Get-LibraryIso($id, $arch) {
  if (Test-Path "$temp\$id.$arch.iso") { return "$temp\$id.$arch.iso"; }
  if (Test-Path "$isoroot\$id.$arch.iso") { return "$isoroot\$id.$arch.iso"; }
  foreach ($folder in $spec.SelectNodes("/library/mediasearchfolders/folder")) {
    foreach ($pattern in $spec.SelectNodes("/library/sourcemedia/media[@id='$id']/isofile[@arch='$arch']")) {
      $found = dir -Recurse $folder.path $pattern.pattern
      if ($found.Count -ne 0) { return $found[0].FullName; }
    }
  }
}

Function Build-LibraryVhd($vspec) {
  $iso = Get-LibraryIso $vspec.sourcemedia $vspec.arch
  $isoid = "$($vspec.sourcemedia).$($vspec.arch)"
  if (!$iso) { Write-Error "Can't build $($vspec.id) - media not found: $isoid"; }

  $localiso = $iso;
  if ($iso.StartsWith("\\") -or ((new-object system.io.driveinfo((gi $iso).PSDrive.Root)).DriveType -eq "Network")) {
    $localiso = "$temp\$isoid.iso";
    Write-Verbose "Caching remote ISO in temp/: $iso"
    copy $iso $localiso;
  }

  if ($vspec.gen -eq "2") {
    Write-Verbose ".\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $localiso -Edition $($vspec.sku) -VHDFormat VHDX -VhdPartitionStyle GPT -VHDPath $vhdroot\$($vspec.id) -SizeBytes 200GB -Feature NetFx3"
    .\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $localiso -Edition $vspec.sku -VHDFormat VHDX -VhdPartitionStyle GPT -VHDPath "$vhdroot\$($vspec.id)" -SizeBytes 200GB -Feature NetFx3 -Verbose
  } else {
    Write-Verbose ".\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $localiso -Edition $($vspec.sku) -VHDFormat VHD -VhdPartitionStyle MBR -VHDPath $vhdroot\$($vspec.id) -SizeBytes 200GB -Feature NetFx3"
    .\Convert-WindowsImage\Convert-WindowsImage.ps1 -SourcePath $localiso -Edition $vspec.sku -VHDFormat VHD -VhdPartitionStyle MBR -VHDPath "$vhdroot\$($vspec.id)" -SizeBytes 200GB -Feature NetFx3 -Verbose
  }
}

Function Get-LibraryVhd($id) {
  if (Test-Path "$vhdroot\$id") { return "$vhdroot\$id"; }
}

Write-Verbose "Checking VHD's..."
foreach($v in $spec.SelectNodes("/library/targetvhds/vhd")) {
  $vid = $v.id
  if (Get-LibraryVhd $vid) {
    Write-Verbose "VHD already exists: $vid";
  } else {
    Write-Verbose "VHD not found: $vid";
    Build-LibraryVhd $v;
  }
}


