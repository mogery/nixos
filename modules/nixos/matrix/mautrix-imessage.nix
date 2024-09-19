{
    imports = [ ./permit-olm.nix ];
    
    users.users."mautrix-imessage" = {
        isSystemUser = true;
        description = "mautrix-imessage";
        home = "/opt/mautrix-imessage";
        createHome = true;
        group = "mautrix";
    };

    users.groups.mautrix = {};

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

    # TODO: move to libvirtd.nix?
    virtualisation.libvirtd.enable = true;
    users.users.mogery.extraGroups = [ "libvirtd" ];
    boot.extraModprobeConfig = ''
        options kvm_intel nested=1
        options kvm_intel emulate_invalid_guest_state=0
        options kvm ignore_msrs=1
    '';

    services.matrix-synapse.settings.app_service_config_files = [
        "/var/lib/matrix-synapse/imessage-registration.yaml"
    ];
}