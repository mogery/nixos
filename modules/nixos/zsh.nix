{ pkgs, ... }:

{
  # zsh setup (needs to be done here too, unfortunately)
  programs.zsh.enable = true;

  # set zsh as shell for user mogery
  users.users.mogery.shell = pkgs.zsh;
}