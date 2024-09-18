{
  lib,
  options,
  config,
  ...
}: {
  options.ppd = {
    overlays = lib.mkOption {
      type = (
        with lib.types;
          listOf functionTo functionTo pkgs
      );
      default = [];
    };
    system = lib.mkOption {
      type = lib.types.string;
      description = "System to be passed to nixosConfiguration";
      default = "";
    };
    # actual config options
    desktop.enable = lib.mkEnableOption "Enable Desktop";
    emacs.enable = lib.mkEnableOption "Enable Doom Emacs";
  };

  # option defaults
  config.ppd.desktop.enable = lib.mkOptionDefault false;
  config.ppd.emacs.enable = lib.mkOptionDefault false;
}
