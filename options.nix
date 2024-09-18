{
  lib,
  options,
  config,
  ...
}: {
  # actual config options
  options.ppd = {
    desktop.enable = lib.mkEnableOption "Enable Desktop";
    emacs.enable = lib.mkEnableOption "Enable Doom Emacs";
    system = lib.mkOption {
      type = lib.types.string;
      description = "System to be passed to nixosConfiguration";
      default = "";
    };
  };

  # defaults
  config.ppd.desktop.enable = lib.mkOptionDefault false;
  config.ppd.emacs.enable = lib.mkOptionDefault false;
}
