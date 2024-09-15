{ lib, config, ... }:
{
    imports = [
      ./base.nix
      ./desktop.nix
      ./home.nix
      ./doom.nix
    ];

    config.modules.ppdesktop.enable = lib.mkDefault false;
    config.modules.emacs.enable = lib.mkDefault false;
}
