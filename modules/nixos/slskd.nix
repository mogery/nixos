{
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