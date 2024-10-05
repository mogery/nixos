{ pkgs, ... }:

{
    # set nushell as shell for user mogery
    environment.systemPackages = with pkgs; [ nushell ];
    users.users.mogery.shell = pkgs.nushell;
}