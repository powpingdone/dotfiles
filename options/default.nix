{
  lib,
  options,
  config,
  ...
}: {
  options.ppd = {
    # regular options
    overlays = lib.mkOption {
      type = (
        with lib.types;
          listOf functionTo functionTo pkgs
      );
      default = [];
    };
    system = lib.mkOption {
      type = lib.types.str;
      description = "System to be passed to nixosConfiguration";
      default = "";
    };
    cores = lib.mkOption {
      type = lib.types.int;
      description = "Cores used per building of derivation";
      default = 1;
    };
    jobs = lib.mkOption {
      type = lib.types.int;
      description = "Derivations built concurrently with other derivations";
      default = 1;
    };
   
    # enable options
    desktop.enable = lib.mkEnableOption "Enable Desktop";
    emacs.enable = lib.mkEnableOption "Enable Emacs";
    nixIndex.enable = lib.mkEnableOption "Enable nix-index (aka command-not-found for flakes)";
    steam.enable = lib.mkEnableOption "Install steam";
    devenv.enable = lib.mkEnableOption "Install devenv related stuff";
    isHIDPI = lib.mkEnableOption "The default display has a DPI/PPI greater than 200";
    peekPoke.enable = lib.mkEnableOption "Install peekpoke, which toggles kernel options related to /dev/mem";
    idevice.enable = lib.mkEnableOption "Install git versions of software for recovering idevices.";
  };

  # option defaults
  config.ppd.peekPoke.enable = lib.mkDefault false;
  config.ppd.desktop.enable = lib.mkDefault false;
  config.ppd.emacs.enable = lib.mkDefault false;
  config.ppd.nixIndex.enable = lib.mkDefault true;
  config.ppd.steam.enable = lib.mkDefault config.ppd.desktop.enable;
  config.ppd.devenv.enable = lib.mkDefault config.ppd.desktop.enable;
  config.ppd.isHIDPI = lib.mkDefault false;
  config.ppd.idevice.enable = lib.mkDefault false;
}
