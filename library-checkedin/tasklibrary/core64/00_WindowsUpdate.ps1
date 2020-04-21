Add-Type -TypeDefinition @"
namespace MS.WindowsUpdate {
  public enum AutomaticUpdatesNotificationLevel {
    NotConfigured, Disabled, NotifyBeforeDownload, NotifyBeforeInstallation, ScheduledInstallation
  }
  public enum AutomaticUpdatesScheduledInstallationDay {
    EveryDay, EverySunday, EveryMonday, EveryTuesday, EveryWednesday, EveryThursday, EveryFriday, EverySaturday
  }
}
"@

Function Get-WindowsUpdateConfig () {
  $AUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings

  [void](Add-Member -inputObject $AUSettings -MemberType ScriptProperty -Name NotificationLevel2 -Value `
    { [MS.WindowsUpdate.AutomaticUpdatesNotificationLevel ]($this.NotificationLevel) } `
    { param([MS.WindowsUpdate.AutomaticUpdatesNotificationLevel ]$value) $this.NotificationLevel = [uint16]($value); });

  [void](Add-Member -inputObject $AUSettings -MemberType ScriptProperty -Name ScheduledInstallationDay2 -Value `
    { [MS.WindowsUpdate.AutomaticUpdatesScheduledInstallationDay]($this.ScheduledInstallationDay) } `
    { param([MS.WindowsUpdate.AutomaticUpdatesScheduledInstallationDay]$value) $this.ScheduledInstallationDay = [uint16]($value); });

  return $AUSettings;
}

Function Set-WindowsUpdateConfig ([System.__ComObject] $settings) {
  if ($settings.PSTypeNames[0] -ne "System.__ComObject#{b587f5c3-f57e-485f-bbf5-0d181c5cd0dc}") {
    throw "This is not a Microsoft.Update.AutoUpdate object";
  }
  [void]($settings.Save());
}

$cfg = Get-WindowsUpdateConfig
$cfg.NotificationLevel2 = "ScheduledInstallation"
$cfg.ScheduledInstallationDay2 = "EveryDay"
$cfg.ScheduledInstallationTime = 3
$cfg.IncludeRecommendedUpdates = $true
$cfg.NonAdministratorsElevated = $true
$cfg.FeaturedUpdatesEnabled = $true
Set-WindowsUpdateConfig $cfg
