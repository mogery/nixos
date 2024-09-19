{
    imports = [ ./permit-olm.nix ];
    
    users.users."mautrix-instagram" = {
        isSystemUser = true;
        description = "mautrix-instagram";
        home = "/opt/mautrix-instagram";
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
            # TODO: we should be getting mautrix-meta from nixpkgs
            ExecStart = "/opt/mautrix-instagram/mautrix-meta";
            Restart = "on-failure";
            RestartSec = "5s";
        };

        wantedBy = [ "multi-user.target" ];
    };

    services.postgresql = {
        enable = true;
        ensureUsers = [
            {
                name = "mautrix-instagram";
                ensureDBOwnership = true;
            }
        ];
        ensureDatabases = [ "mautrix-instagram" ];
    };

    services.matrix-synapse.settings.app_service_config_files = [
        "/var/lib/matrix-synapse/instagram-registration.yaml"
    ];
}