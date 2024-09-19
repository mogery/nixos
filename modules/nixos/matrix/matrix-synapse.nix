{
    services.postgresql = {
        enable = true;
        ensureUsers = [
            {
                name = "matrix-synapse";
                ensureDBOwnership = true;
            }
        ];
        ensureDatabases = [ "matrix-synapse" ]; # NOTE: you must manually change collate to C
    };

    services.matrix-synapse = {
        enable = true;
        settings.server_name = "mogery.me";
        settings.public_baseurl = "https://matrix.mogery.me";
        settings.enable_registration = false;
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

    services.nginx.virtualHosts = {
        "mogery.me" = {
            enableACME = true;
            forceSSL = true;

            locations."= /.well-known/matrix/server".extraConfig = ''
                default_type application/json;
                add_header Access-Control-Allow-Origin *;
                return 200 '{"m.server": "matrix.mogery.me:443"}';
            '';

            locations."= /.well-known/matrix/client".extraConfig = ''
                default_type application/json;
                add_header Access-Control-Allow-Origin *;
                return 200 '{"m.homeserver": {"base_url": "https://matrix.mogery.me"}}';
            '';
        };
        "matrix.mogery.me" = {
            enableACME = true;
            forceSSL = true;

            locations."/".extraConfig = ''
                return 404;
            '';

            locations."/_matrix".proxyPass = "http://[::1]:8448";
            locations."/_synapse/client".proxyPass = "http://[::1]:8448";
        };
    };
}