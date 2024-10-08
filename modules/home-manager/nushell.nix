{
    programs.nushell = {
        enable = true;
        extraConfig = ''
            $env.config.show_banner = false
        '';
    };

    programs.starship = {
        enable = true;
        settings = {
            add_newline = true;
            character = {
                success_symbol = "[➜](bold green)";
                error_symbol = "[➜](bold red)";
            };
            
            gcloud.disabled = true;
            aws.disabled = true;
            azure.disabled = true;
        };
    };
}
