{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ppd.desktop.enable {
    # base packages that I *always* need.
    environment.systemPackages = with pkgs; [
      # connectwise. make sure to nix-shell rpm and desktop-file-utils
      # to init it's stuff
      openjdk17
      # debuginfod
      (lib.getBin (pkgs.elfutils.override {enableDebuginfod = true;}))
    ];

    # enable debug info stuff
    environment.enableDebugInfo = true;
    services.nixseparatedebuginfod.enable = true;

    # Enable pipewire sound.
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable Bluetooth
    hardware.bluetooth.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # use gnome
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # setup gdm properly
    services.displayManager = {
      enable = true;
      defaultSession = "gnome";
    };

    # I don't need the gnome web browser and email client
    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
    ];

    # enable portals
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    # flatpak
    services.flatpak.enable = true;

    # use ozone on desktop
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # have reasonable font coverage
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];
      enableDefaultPackages = true;
      fontconfig =
        {
          enable = true;
          allowBitmaps = false;
        }
        //
        # fontconfig DPI settings
        lib.mkIf config.ppd.isHIDPI {
          antialias = false;
          hinting.enable = false;
          subpixel.lcdfilter = "none";
        }
        // lib.mkIf (!config.ppd.isHIDPI) {
          # I know this is redundant, but it's fine
          antialias = true;
          hinting.enable = true;
          subpixel.lcdfilter = "default";
        };
    };
  };
}
