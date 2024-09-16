{ pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "fluffychat-linux-1.20.0"
  ];

  environment.systemPackages = with pkgs; [
    fluffychat
  ];
}
