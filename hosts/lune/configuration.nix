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
    allowedTCPPorts = [
      6443 # k3s
    ];
  };

  # kubernetes
  services.k3s.enable = true;
  services.k3s.role = "server";

  environment.etc."kubenix.yaml".source = (inputs.kubenix.evalModules.x86_64-linux {
    module = { kubenix, ... }: {
        imports = [ kubenix.modules.k8s ];
        kubernetes.resources.deployments = {
            jellyfin = {
                metadata.labels = {
                    app = "media";
                    component = "jellyfin";
                };

                spec = {
                    selector.matchLabels = {
                        app = "media";
                        component = "jellyfin";
                    };

                    template = {
                        metadata.labels = {
                            app = "media";
                            component = "jellyfin";
                        };

                        spec = {
                            containers.jellyfin = {
                                image = "jellyfin/jellyfin:10.9.11.20240907-221241";
                                envFrom = [{ configMapRef.name = "jellyfin-env"; }];
                                ports.web.containerPort = 8096;

                                volumeMounts = [
                                    {
                                        name = "config";
                                        mountPath = "/config";
                                    }
                                    {
                                        name = "media";
                                        mountPath = "/media";
                                    }
                                ];
                            };

                            volumes = {
                                config.persistentVolumeClaim.claimName = "jellyfin-config";
                                media.persistentVolumeClaim.claimName = "media";
                            };
                        };
                    };
                };
            };
        };

        kubernetes.resources.clusterRoles = {
            metadata = {
                name = "service-reader";
            };
            rules = [
                {
                    apiGroups = [ "" ];
                    resources = [ "services" ];
                    verbs = [ "get" "watch" "list" ];
                }
            ];
        };
    };
  }).config.kubernetes.resultYAML;

  system.activationScripts.kubenix.text = ''
    ln -sf /etc/kubenix.yaml /var/lib/rancher/k3s/server/manifests/kubenix.yaml
  '';
}