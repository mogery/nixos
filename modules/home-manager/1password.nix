{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password
    _1password-gui
  ];
  
  # Configure the 1Password SSH Agent
  programs.ssh = {
    enable = true;

    forwardAgent = true;
    extraConfig = "IdentityAgent ~/.1password/agent.sock"; # TODO: The path to this on darwin is different
  };
}
