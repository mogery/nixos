{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nur.hmModules.nur
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/nushell.nix
  ];

  home.username = "mogery";
  home.homeDirectory = "/home/mogery";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  programs.zsh.shellAliases = {
    update = "nh os switch";
  };

  programs.nushell.shellAliases = {
    update = "sudo nixos-rebuild switch --flake /home/mogery/nixos#lune";
  };
}
