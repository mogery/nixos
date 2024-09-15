{ pkgs, config, ... }:
{
    home.packages = with pkgs; [ httpie-desktop ];
}
