{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode # TODO: vscode-with-extensions
  ];
}
