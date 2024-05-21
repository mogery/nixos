{ currentConfig, ... }:
{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    configFile = {
      # Turn off pointer acceleration
      "kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat".value = true;
      "kcminputrc"."Mouse"."XLbInptAccelProfileFlat".value = true;

      # Turn on macOS-style scrolling
      "kcminputrc"."Mouse"."XLbInptNaturalScroll".value = true;

      # Night Color
      "kwinrc"."NightColor"."Active".value = true;
      "kwinrc"."NightColor"."Mode".value = "Location";
      "kwinrc"."NightColor"."LatitudeFixed".value = 47.43;
      "kwinrc"."NightColor"."LongitudeFixed".value = 18.92;
      "kwinrc"."NightColor"."NightTemperature".value = 3000;

      # Wallpaper
      "plasmarc"."Wallpapers"."usersWallpapers".value = builtins.toString (./. + "../../wallpaper.png");
    };
  };

  programs.zsh.shellAliases = {
    pmdump = "nix run github:pjones/plasma-manager";
  };
}
