{ pkgs, ... }:
{
    stylix.image = ../../wallpaper.png;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.name = "Bibata-Modern-ice";

    stylix.fonts = {
        monospace = {
            package = pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; };
            name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
            package = pkgs.inter;
            name = "Inter";
        };
    };
}