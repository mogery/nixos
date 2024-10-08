{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-solanum
  ];
}