{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nur.hmModules.nur
    ../../modules/home-manager/plasma.nix
    ../../modules/home-manager/plasma-static.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/1password.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/discord.nix
  ];

  home.username = "mogery";
  home.homeDirectory = "/home/mogery";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  programs.zsh.shellAliases = {
    update = "sudo nixos-rebuild switch --flake /home/mogery/nixos#blade";
  };
}
