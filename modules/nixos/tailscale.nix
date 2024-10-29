{ config, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    checkReversePath = "loose";
  };
  
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
