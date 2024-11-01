{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nur.hmModules.nur
    ../../modules/home-manager/plasma.nix
    ../../modules/home-manager/plasma-static.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/cursor.nix
    ../../modules/home-manager/1password.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/discord.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/cider.nix
    ../../modules/home-manager/slack.nix
    ../../modules/home-manager/httpie.nix
    ../../modules/home-manager/thunderbird.nix
    ../../modules/home-manager/feishin.nix
    ../../modules/home-manager/berkeley-mono.nix
    ../../modules/home-manager/obsidian.nix
    ../../modules/home-manager/nushell.nix
    ../../modules/home-manager/pomodoro.nix
    ../../modules/home-manager/osu.nix
  ];

  home.username = "mogery";
  home.homeDirectory = "/home/mogery";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  programs.zsh.shellAliases = {
    update = "nh os switch";
  };

  programs.nushell.shellAliases = {
    update = "nh os switch";
  };
}
