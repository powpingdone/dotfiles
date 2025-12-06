{
  lib,
  config,
  pkgs,
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
    steam = {
      enable = lib.mkEnableOption "Install steam";
      gamemodeConfig = lib.mkOption {
        type = (pkgs.formats.ini {listsAsDuplicateKeys = true;}).type;
        description = "Settings for gamemode";
        default = {};
      };
    };
    desktop = {
      enable = lib.mkEnableOption "Enable desktop related things";
      gnome = lib.mkEnableOption "Use gnome";
      kde = lib.mkEnableOption "Use KDE";
    };

    # enable options
    emacs.enable = lib.mkEnableOption "Enable Emacs";
    nixIndex.enable = lib.mkEnableOption "Enable nix-index (aka command-not-found for flakes)";
    devenv.enable = lib.mkEnableOption "Install devenv related stuff";
    isHIDPI = lib.mkEnableOption "The default display has a DPI/PPI greater than 200";
    peekPoke.enable = lib.mkEnableOption "Install peekpoke, which toggles kernel options related to /dev/mem";
    idevice.enable = lib.mkEnableOption "Install git versions of software for recovering idevices.";
    ghidra.enable = lib.mkEnableOption "Ghidra, the NSA reverse engineering tool";
    libvirtd.enable = lib.mkEnableOption "Install libvirtd, the vm hosting tool";
    virtManager.enable = lib.mkEnableOption "Install virt-manager, the frontend for libvirtd";
    fonts.enable = lib.mkEnableOption "Install fonts";
    bootloader = {
      grub = lib.mkEnableOption "Enable grub bootloader";
      systemd-boot = lib.mkEnableOption "Enable systemd-boot bootloader (works with UEFI dtb)";
      wsl = lib.mkEnableOption "Use wsl for bootloader";
    };
    podman.enable = lib.mkEnableOption "Podman, the OCI runtime";
    lmms.enable = lib.mkEnableOption "A daw, but the nightly version";
    fex.enable = lib.mkEnableOption "Fex, the x86_64 emulator. Be sure to download a rootfs.";
  };

  # option defaults
  config.ppd = {
    steam.enable = lib.mkDefault config.ppd.desktop.enable;
    devenv.enable = lib.mkDefault config.ppd.desktop.enable;
    ghidra.enable = lib.mkDefault config.ppd.desktop.enable;
    fonts.enable = lib.mkDefault config.ppd.desktop.enable;
    # defaults to gnome
    desktop.gnome = lib.mkDefault (config.ppd.desktop.enable && !config.ppd.desktop.kde);
    nixIndex.enable = lib.mkDefault true;
  };
}
