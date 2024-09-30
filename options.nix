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
    desktop.enable = lib.mkEnableOption "Enable Desktop";
    emacs.enable = lib.mkEnableOption "Enable Emacs";
    nixIndex.enable = lib.mkEnableOption "Enable nix-index (aka command-not-found for flakes)";
    steam.enable = lib.mkEnableOption "Install steam";
    devenv.enable = lib.mkEnableOption "Install devenv related stuff"
  };

  # option defaults
  config.ppd.desktop.enable = lib.mkDefault false;
  config.ppd.emacs.enable = lib.mkDefault false;
  config.ppd.nixIndex.enable = lib.mkDefault true;
  config.ppd.steam.enable = lib.mkDefault ppd.desktop.enable;
  config.ppd.devenv.enable = lib.mkdefault ppd.desktop.enable;
}
