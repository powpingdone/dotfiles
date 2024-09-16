{ lib, config, ... }:
{
    imports = [
      ./base.nix
      ./desktop.nix
      #./doom.nix
    ];

    config.modules.ppdesktop.enable = lib.mkDefault false;
    #config.modules.emacs.enable = lib.mkDefault false;

}
