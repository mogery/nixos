{ inputs, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };
  services.desktopManager.plasma6.enable = true;

  # Don't install Konsole (Alacritty preferred)
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ konsole ];

  # Use plasma-manager with home-manager
  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
}
