# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, currentConfig, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../modules/nixos/flakes.nix
    ../../modules/nixos/tz-locale.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/nh.nix
  ];

  system.stateVersion = "24.11";
  nixpkgs.overlays = [ inputs.nur.overlay ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "lune";

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HAJQ-00000_S3W8NX0M112837";

  # Enable networking
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mogery = {
    isNormalUser = true;
    description = "mogery";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGHjO+acP+XXWdGGr4GwX6ncEX8Nf/rcgwDyEfUPKE9"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; inherit currentConfig; };
    backupFileExtension = "backup";
    users = {
      "mogery" = {
        imports = [
          ./home.nix
        ];
      };
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mogery";

  # SSH
  services.openssh.enable = true;
  services.openssh.openFirewall = false;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
