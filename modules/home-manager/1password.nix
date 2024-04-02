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

  home.file.".config/autostart/1password.desktop" = {
    text = ''
      [Desktop Entry]
      Categories=Office;
      Comment=Password manager and secure wallet
      Exec=1password %U
      Icon=1password
      MimeType=x-scheme-handler/onepassword;
      Name=1Password
      StartupWMClass=1Password
      Terminal=false
      Type=Application
    '';
    executable = true;
  };
}
