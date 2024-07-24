{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode # TODO: vscode-with-extensions
    (writeShellScriptBin "ncode" ''
#!/bin/sh
nix develop path://$PWD -c code "''${@}"
'')
  ];
}
