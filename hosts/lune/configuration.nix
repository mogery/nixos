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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
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

        locations."= /".extraConfig = ''
            return 301 https://blog.mogery.me;
        '';

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
    settings.public_baseurl = "https://matrix.mogery.me";
    settings.enable_registration = false;
    settings.app_service_config_files = [
      "/var/lib/matrix-synapse/instagram-registration.yaml"
      "/var/lib/matrix-synapse/messenger-registration.yaml"
      "/var/lib/matrix-synapse/discord-registration.yaml"
      "/var/lib/matrix-synapse/imessage-registration.yaml"
    ];
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

  services.postgresql = {
    enable = true;
    ensureUsers = [
        {
            name = "matrix-synapse";
            ensureDBOwnership = true;
        }
        {
            name = "mautrix-instagram";
            ensureDBOwnership = true;
        }
        {
            name = "mautrix-messenger";
            ensureDBOwnership = true;
        }
        {
            name = "mautrix-discord";
            ensureDBOwnership = true;
        }
    ];
    ensureDatabases = [ "matrix-synapse" "mautrix-instagram" "mautrix-messenger" "mautrix-discord" ];
  };

  users.users."mautrix-instagram" = {
    isSystemUser = true;
    description = "mautrix-instagram";
    home = "/opt/mautrix-instagram";
    createHome = true;
    group = "mautrix";
  };

  users.users."mautrix-messenger" = {
    isSystemUser = true;
    description = "mautrix-messenger";
    home = "/opt/mautrix-messenger";
    createHome = true;
    group = "mautrix";
  };

  users.users."mautrix-discord" = {
    isSystemUser = true;
    description = "mautrix-discord";
    home = "/opt/mautrix-discord";
    createHome = true;
    group = "mautrix";
    packages = with pkgs; [ mautrix-discord ];
  };

  users.users."mautrix-imessage" = {
    isSystemUser = true;
    description = "mautrix-imessage";
    home = "/opt/mautrix-imessage";
    createHome = true;
    group = "mautrix";
  };

  users.groups.mautrix = {};

  systemd.services."mautrix-instagram" = {
    enable = true;

    unitConfig = {
      Description = "mautrix-meta bridge for Instagram";
    };

    serviceConfig = {
      User = "mautrix-instagram";
      WorkingDirectory = "/opt/mautrix-instagram";
      ExecStart = "/opt/mautrix-instagram/mautrix-meta";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    wantedBy = [ "multi-user.target" ];
  };

  systemd.services."mautrix-messenger" = {
    enable = true;

    unitConfig = {
      Description = "mautrix-meta bridge for Messenger";
    };

    serviceConfig = {
      User = "mautrix-messenger";
      WorkingDirectory = "/opt/mautrix-messenger";
      ExecStart = "/opt/mautrix-messenger/mautrix-meta";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    wantedBy = [ "multi-user.target" ];
  };

  systemd.services."mautrix-discord" = {
    enable = true;

    unitConfig = {
      Description = "mautrix-discord bridge";
    };

    serviceConfig = {
      User = "mautrix-discord";
      WorkingDirectory = "/opt/mautrix-discord";
      ExecStart = "/etc/profiles/per-user/mautrix-discord/bin/mautrix-discord -c /opt/mautrix-discord/config.yaml";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    wantedBy = [ "multi-user.target" ];
  };

  systemd.services."mautrix-imessage" = {
    enable = true;

    unitConfig = {
      Description = "mautrix-imessage bridge";
    };

    serviceConfig = {
      User = "mautrix-imessage";
      WorkingDirectory = "/opt/mautrix-imessage/OSX-KVM";
      ExecStart = "/opt/mautrix-imessage/OSX-KVM/OpenCore-Boot.sh";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    wantedBy = [ "multi-user.target" ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  virtualisation.libvirtd.enable = true;
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  # jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.slskd = {
    enable = true;
    domain = "slskd.mogery.me";
    group = "media";
    openFirewall = true;
    environmentFile = "/var/lib/slskd/.env";
    nginx = {
      enableACME = true;
      forceSSL = true;
    };
    settings = {
      shares = {
        filters = [ "\\[PRIVATE\\]" "\\.asd$" "\\.lrc$" ];
        directories = [ "/var/lib/jellyfin/libraries/music/" ];
      };
    };
  };

  users.groups.media = {};
}
