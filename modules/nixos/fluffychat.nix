{ pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "fluffychat-linux-1.20.0"
    "olm-3.2.16"
  ];

  environment.systemPackages = with pkgs; [
    fluffychat
  ];
}
