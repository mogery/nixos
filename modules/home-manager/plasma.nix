{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    configFile = {
      "kcminputrc"."Mouse"."XLbInptNaturalScroll" = true; # macOS-style scrolling
    };
  };
}
