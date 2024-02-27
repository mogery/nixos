{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nur.hmModules.nur
    ../../modules/home-manager/zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mogery";
  home.homeDirectory = "/home/mogery";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    vscode # TODO: vscode-with-extensions
    _1password
    _1password-gui
    discord
  ];

  programs.firefox = {
    enable = true;
    profiles.mogery = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        onepassword-password-manager
      ];
    };
  };

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    configFile = {
      "kcminputrc"."Mouse"."XLbInptNaturalScroll" = true;
      "kscreenlockerrc"."Daemon"."Autolock" = false;
      "kscreenlockerrc"."Daemon"."LockOnResume" = false;
    };
  };

  # Configure Git with sane defaults
  programs.git = {
    enable = true;

    userName = "Gergo Moricz";
    userEmail = "mo.geryy@gmail.com";

    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  # Configure the 1Password SSH Agent
  programs.ssh = {
    enable = true;

    forwardAgent = true;
    extraConfig = "IdentityAgent ~/.1password/agent.sock";
  };

  programs.zsh.shellAliases.update = "sudo nixos-rebuild switch --flake /home/mogery/nixos#default";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/powermanagementprofilesrc".force = true;
    ".config/powermanagementprofilesrc".text = ''
[AC]
icon=battery-charging

[AC][DimDisplay]
idleTime=300000

[AC][HandleButtonEvents]
lidAction=1
powerButtonAction=16
powerDownAction=16

[Battery]
icon=battery-060

[Battery][DPMSControl]
idleTime=300
lockBeforeTurnOff=0

[Battery][DimDisplay]
idleTime=120000

[Battery][HandleButtonEvents]
lidAction=1
powerButtonAction=16
powerDownAction=16

[Battery][SuspendSession]
idleTime=600000
suspendThenHibernate=false
suspendType=1

[LowBattery]
icon=battery-low

[LowBattery][BrightnessControl]
value=30

[LowBattery][DPMSControl]
idleTime=120
lockBeforeTurnOff=0

[LowBattery][DimDisplay]
idleTime=60000

[LowBattery][HandleButtonEvents]
lidAction=1
powerButtonAction=16
powerDownAction=16

[LowBattery][SuspendSession]
idleTime=300000
suspendThenHibernate=false
suspendType=1
'';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mogery/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
