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
    ../../modules/nixos/nginx.nix
    ../../modules/nixos/jellyfin.nix
    ../../modules/nixos/nushell.nix
    ../../modules/nixos/slskd.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/matrix/matrix-synapse.nix
    ../../modules/nixos/matrix/mautrix-discord.nix
    ../../modules/nixos/matrix/mautrix-imessage.nix
    ../../modules/nixos/matrix/mautrix-instagram.nix
    ../../modules/nixos/matrix/mautrix-messenger.nix
    ../../modules/nixos/shell-on-fail.nix
  ];

  system.stateVersion = "24.11";
  nixpkgs.overlays = [ inputs.nur.overlay ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "lune";
  networking.useDHCP = false;
  networking.interfaces."enp0s31f6".ipv4.addresses = [
    {
      address = "136.243.155.39";
      prefixLength = 24;
    }
  ];
  networking.interfaces."enp0s31f6".ipv6.addresses = [
    {
      address = "2a01:4f8:171:1d90::1";
      prefixLength = 64;
    }
  ];
  networking.defaultGateway = "136.243.155.1";
  networking.defaultGateway6 = { address = "fe80::1"; interface = "enp0s31f6"; };
  networking.nameservers = [ "1.1.1.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

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
    extraGroups = [ "networkmanager" "wheel" "nginx" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGHjO+acP+XXWdGGr4GwX6ncEX8Nf/rcgwDyEfUPKE9" # Hetzner key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAgkAOAzkBgfepWzLNoMQ6c1knNRi6pWN109f2kwxCoO" # Shortcuts on MG+
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

  networking.firewall.enable = true;

  services.nginx = {
    virtualHosts = {
      "mogery.me" = {
        enableACME = true;
        forceSSL = true;

        root = "/var/www/mogery.me";

        locations."= /".extraConfig = ''
            return 301 https://blog.mogery.me;
        '';

        locations."~ /fonts".extraConfig = ''
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Methods' 'GET';
        '';
      };
    };
  };

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = "1048576";
  };
}
