{ inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  
  # Use plasma-manager with home-manager
  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
}
