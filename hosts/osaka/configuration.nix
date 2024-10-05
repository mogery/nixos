
## Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, currentConfig, ... }:

{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../modules/nixos/flakes.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/wifi.nix
    ../../modules/nixos/nh.nix
    ../../modules/nixos/plasma.nix
    ../../modules/nixos/tz-locale.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/fluffychat.nix
    ../../modules/nixos/berkeley-mono.nix
    ../../modules/nixos/eduroam.nix
    ../../modules/nixos/shell-on-fail.nix
    ../../modules/nixos/nushell.nix
  ];

  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.nixos-apple-silicon.overlays.apple-silicon-overlay ];

  networking.hostName = "osaka";

  hardware.asahi = {
    useExperimentalGPUDriver = true;
#    experimentalGPUInstallMode = "overlay";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mogery = {
    isNormalUser = true;
    description = "mogery";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mogery";

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

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
}
