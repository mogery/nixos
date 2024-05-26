{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [ bitwig-studio ];
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
        "bitwig-studio"
    ];
}