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
      # for fun things
      idevicerestore
    ];

    # enable usbmuxd for idevicerestore
    services.usbmuxd.enable = true;

    # nautilus a/v
    environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
    ];

    # enable debug info stuff
    environment.enableDebugInfo = true;
    services.nixseparatedebuginfod.enable = true;

    # Enable pipewire sound.
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        #extraConfig = {
        #  "log-level-debug" = {
        #    "context.properties" = {
        #      # Output Debug log messages as opposed to only the default level (Notice)
        #      "log.level" = "D";
        #    };
        #  };
        #};
      };
    };

    # Enable Bluetooth
    hardware.bluetooth.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = let
        addIfSupported = pkg:
          if
            builtins.any
            (support: config.ppd.system == support)
            pkg.meta.platforms
          then pkg
          else null;
      in
        builtins.filter (x: x != null) (map addIfSupported (with pkgs; [
          gutenprint
          gutenprintBin
          epson-escpr
          #epson-escpr2
        ]));
    };
    # generic drivers
    # enable autodiscovery of network printers
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

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
        nerd-fonts.symbols-only
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
