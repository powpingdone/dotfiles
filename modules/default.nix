{ lib, config, ... }:
{
    imports = [
      ./base.nix
      ./desktop.nix
    ];

    desktop.enable = lib.mkDefault false;
}
