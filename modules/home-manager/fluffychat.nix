{ pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "fluffychat-linux-1.20.0"
  ];

  home.packages = with pkgs; [
    fluffychat
  ];
}
