{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.mogery = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        onepassword-password-manager
      ];
    };
  };
}
