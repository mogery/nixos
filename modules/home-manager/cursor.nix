{ pkgs, ... }:

{
  home.packages = with pkgs; [
    code-cursor
    (writeShellScriptBin "ncursor" ''
#!/bin/sh
nix develop path://$PWD -c cursor "''${@}"
'')
  ];
}
