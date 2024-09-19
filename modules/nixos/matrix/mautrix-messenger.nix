{
    imports = [ ./permit-olm.nix ];
    
    users.users."mautrix-messenger" = {
        isSystemUser = true;
        description = "mautrix-messenger";
        home = "/opt/mautrix-messenger";
        createHome = true;
        group = "mautrix";
    };

    users.groups.mautrix = {};

    systemd.services."mautrix-messenger" = {
        enable = true;

        unitConfig = {
            Description = "mautrix-meta bridge for Messenger";
        };

        serviceConfig = {
            User = "mautrix-messenger";
            WorkingDirectory = "/opt/mautrix-messenger";
            # TODO: we should be getting mautrix-meta from nixpkgs
            ExecStart = "/opt/mautrix-messenger/mautrix-meta";
            Restart = "on-failure";
            RestartSec = "5s";
        };

        wantedBy = [ "multi-user.target" ];
    };

    services.postgresql = {
        enable = true;
        ensureUsers = [
            {
                name = "mautrix-messenger";
                ensureDBOwnership = true;
            }
        ];
        ensureDatabases = [ "mautrix-messenger" ];
    };

    services.matrix-synapse.settings.app_service_config_files = [
        "/var/lib/matrix-synapse/messenger-registration.yaml"
    ];
}