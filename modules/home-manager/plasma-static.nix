{
  # This makes KDE Plasma "static": it won't lock itself or
  # go to sleep unless when it its explicitly wanted.
  programs.plasma.configFile = {
    "kscreenlockerrc"."Daemon"."Autolock" = false;
    "kscreenlockerrc"."Daemon"."LockOnResume" = false;
  };
  
  home.file = {
    ".config/powermanagementprofilesrc".force = true;
    ".config/powermanagementprofilesrc".text = ''
[AC]
icon=battery-charging

[AC][DimDisplay]
idleTime=300000

[AC][HandleButtonEvents]
lidAction=1
powerButtonAction=16
powerDownAction=16

[Battery]
icon=battery-060

[Battery][DPMSControl]
idleTime=300
lockBeforeTurnOff=0

[Battery][DimDisplay]
idleTime=120000

[Battery][HandleButtonEvents]
lidAction=1
powerButtonAction=16
powerDownAction=16

[Battery][SuspendSession]
idleTime=600000
suspendThenHibernate=false
suspendType=1

[LowBattery]
icon=battery-low

[LowBattery][BrightnessControl]
value=30

[LowBattery][DPMSControl]
idleTime=120
lockBeforeTurnOff=0

[LowBattery][DimDisplay]
idleTime=60000

[LowBattery][HandleButtonEvents]
lidAction=1
powerButtonAction=16
powerDownAction=16

[LowBattery][SuspendSession]
idleTime=300000
suspendThenHibernate=false
suspendType=1
'';
  };
}