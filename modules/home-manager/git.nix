{
  # Configure Git with sane defaults
  programs.git = {
    enable = true;

    userName = "Gergő Móricz";
    userEmail = "mo.geryy@gmail.com";

    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
