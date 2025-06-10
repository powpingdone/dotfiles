{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ppd.desktop.enable {
    # base packages that I *always* need.
    environment.systemPackages = with pkgs; [
      # debuginfod
      (lib.getBin (pkgs.elfutils.override {enableDebuginfod = true;}))
      # for fun things
      idevicerestore
    ];

    # enable usbmuxd for idevicerestore
    services.usbmuxd.enable = true;

    # enable extra hardware like rotation and light sensors
    hardware.sensor.iio.enable = true;

    # add ext for inkscape silloette, ifixit usb
    services.udev.packages = [
      (pkgs.writeTextFile {
        text = ''
          SUBSYSTEM=="usb", ATTR{idVendor}=="0b4d", ATTR{idProduct}=="113a", MODE:="0660", TAG+="uaccess"
          SUBSYSTEM=="tty", ATTR{idVendor}=="346c", ATTR{idProduct}=="1f01", MODE:="0660", TAG+="uaccess"
        '';
        name = "ppd-custom-udev rules";
        destination = "/lib/udev/rules.d/60-ppds-rules.rules";
      })
    ];

    # connectwise. make sure to nix-shell rpm and desktop-file-utils
    # to init it's stuff
    programs.java = {
      enable = true;
      package = pkgs.openjdk21;
    };

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
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."92-set-larger-quantum" = {
        "context.properties" = {
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 256;
        };
      };
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
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    systemd.user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = ["network.target" "sound.target"];
      wantedBy = ["default.target"];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };

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
          epson-escpr2
        ]));
    };
    # generic drivers
    # enable autodiscovery of network printers
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # setup gdm properly
    services.displayManager = {
      enable = true;
      # use gnome display manager
      gdm.enable = true;
      defaultSession = "gnome";
    };

    # use gnome
    services.desktopManager.gnome.enable = true;

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

    fonts = {
      packages = with pkgs; [
        # noto for reasonable, non bitmap coverage
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        # other, regular fonts
        winePackages.fonts
        roboto
        ubuntu_font_family
        dejavu_fonts
        freefont_ttf
        gyre-fonts
        liberation_ttf
        noto-fonts-color-emoji

        # nerd fonts, because I am gamer
        nerd-fonts.symbols-only
      ];
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
