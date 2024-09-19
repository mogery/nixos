{ pkgs, ... }:

{
    imports = [ ./permit-olm.nix ];
    
    users.users."mautrix-discord" = {
        isSystemUser = true;
        description = "mautrix-discord";
        home = "/opt/mautrix-discord";
        createHome = true;
        group = "mautrix";
        packages = with pkgs; [ mautrix-discord ];
    };

    users.groups.mautrix = {};

    systemd.services."mautrix-discord" = {
        enable = true;

        unitConfig = {
            Description = "mautrix-discord bridge";
        };

        serviceConfig = {
            User = "mautrix-discord";
            WorkingDirectory = "/opt/mautrix-discord";
            # TODO: this should really use pkgs.mautrix-discord instead of a hard path
            ExecStart = "/etc/profiles/per-user/mautrix-discord/bin/mautrix-discord -c /opt/mautrix-discord/config.yaml";
            Restart = "on-failure";
            RestartSec = "5s";
        };

        wantedBy = [ "multi-user.target" ];
    };

    services.postgresql = {
        enable = true;
        ensureUsers = [
            {
                name = "mautrix-discord";
                ensureDBOwnership = true;
            }
        ];
        ensureDatabases = [ "mautrix-discord" ];
    };

    services.matrix-synapse.settings.app_service_config_files = [
        "/var/lib/matrix-synapse/discord-registration.yaml"
    ];
}