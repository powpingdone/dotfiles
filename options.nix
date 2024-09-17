{ lib, options, config, ... }:
{
  # actual config options
  options.ppd = {
    desktop.enable = lib.mkEnableOption "Enable Desktop";
    emacs.enable = lib.mkEnableOption "Enable Doom Emacs";
  };
  
  # defaults
  config.ppd.desktop.enable = lib.mkOptionDefault false;
  config.ppd.emacs.enable = lib.mkOptionDefault false;
}
