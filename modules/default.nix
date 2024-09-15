{ lib, config, ... }:
{
    imports = [
      ./base.nix
      ./desktop.nix
      ./home.nix
    ];

    desktop.enable = lib.mkDefault false;
}
