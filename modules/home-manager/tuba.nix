{ pkgs, ... }:
{
    home.packages = with pkgs; [ tuba ];
}