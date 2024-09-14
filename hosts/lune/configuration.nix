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
    allowedTCPPorts = [ 80 443 ];
  };

  security.acme.defaults.email = "mo.geryy@gmail.com";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    recommendedTlsSettings = false;
    recommendedOptimisation = false;
    recommendedGzipSettings = false;
    recommendedProxySettings = false;
    virtualHosts = {
      # If the A and AAAA DNS records on example.org do not point on the same host as the
      # records for myhostname.example.org, you can easily move the /.well-known
      # virtualHost section of the code to the host that is serving example.org, while
      # the rest stays on myhostname.example.org with no other changes required.
      # This pattern also allows to seamlessly move the homeserver from
      # myhostname.example.org to myotherhost.example.org by only changing the
      # /.well-known redirection target.
      "mogery.me" = {
        enableACME = true;
        forceSSL = true;
        # This section is not needed if the server_name of matrix-synapse is equal to
        # the domain (i.e. example.org from @foo:example.org) and the federation port
        # is 8448.
        # Further reference can be found in the docs about delegation under
        # https://element-hq.github.io/synapse/latest/delegate.html
        locations."= /.well-known/matrix/server".extraConfig = ''
            default_type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '{"m.server": "matrix.mogery.me:443"}';
        '';
        # This is usually needed for homeserver discovery (from e.g. other Matrix clients).
        # Further reference can be found in the upstream docs at
        # https://spec.matrix.org/latest/client-server-api/#getwell-knownmatrixclient
        locations."= /.well-known/matrix/client".extraConfig = ''
            default_type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '{"m.homeserver": {"base_url": "https://matrix.mogery.me"}}';
        '';
      };
      "matrix.mogery.me" = {
        enableACME = true;
        forceSSL = true;
        # It's also possible to do a redirect here or something else, this vhost is not
        # needed for Matrix. It's recommended though to *not put* element
        # here, see also the section about Element.
        locations."/".extraConfig = ''
          return 404;
        '';
        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix".proxyPass = "http://[::1]:8448";
        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client".proxyPass = "http://[::1]:8448";
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings.server_name = "mogery.me";
    settings.public_baseurl = "matrix.mogery.me";
    settings.enable_registration = true;
    settings.listeners = [
        {
            port = 8448;
            bind_addresses = [ "::1" ];
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
                {
                    names = [ "client" "federation" ];
                    compress = true;
                }
            ];
        }
    ];
  };
}
