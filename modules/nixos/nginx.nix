{
    security.acme.defaults.email = "mo.geryy@gmail.com";
    security.acme.acceptTerms = true;

    services.nginx = {
        enable = true;
        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
}