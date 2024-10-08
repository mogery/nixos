{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home-manager/plasma.nix
    ../../modules/home-manager/plasma-static.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/firefox-bare.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/1password.nix
#    ../../modules/home-manager/discord.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/thunderbird.nix
#    ../../modules/home-manager/slack.nix
    ../../modules/home-manager/feishin.nix
    ../../modules/home-manager/obsidian.nix
    ../../modules/home-manager/berkeley-mono.nix
    ../../modules/home-manager/nushell.nix
    ../../modules/home-manager/pomodoro.nix
  ];

  home.username = "mogery";
  home.homeDirectory = "/home/mogery";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  programs.zsh.shellAliases = {
    update = "nh os switch -- --impure";
  };

  programs.nushell.shellAliases = {
    update = "nh os switch -- --impure";
  };
}
