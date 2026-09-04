# pretty much taken from https://github.com/Yeshey/nixos-box64-binfmt
{
  config,
  lib,
  pkgs,
  ...
}: let
  nativeLibs = with pkgs; [
    alsa-lib
    libpulseaudio
    libsndfile
    openal
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    SDL2_net
    SDL
    SDL_image
    SDL_mixer
    SDL_ttf
    SDL_net
    libGL
    libGLU
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libxcb
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXi
    xorg.libXinerama
    xorg.libXScrnSaver
    xorg.libSM
    xorg.libICE
    fontconfig
    freetype
    libdrm
    libvdpau
    libvorbis
    libogg
    gtk2
    gtk3
    glib
    dbus
    util-linux
  ];
  interpreter = pkgs.writeShellScript "box64-wrapper" ''
    export BOX64_LD_LIBRARY_PATH="${lib.makeLibraryPath nativeLibs}''${BOX64_LD_LIBRARY_PATH:+:$BOX64_LD_LIBRARY_PATH}"
    exec ${pkgs.box64}/bin/box64 "$@"
  '';
in
  lib.mkIf config.ppd.box64.enable
  {
    boot.binfmt.emulatedSystems = ["i686-linux" "x86_64-linux" "i386-linux" "i486-linux" "i586-linux" "i686-linux"];
    nix.settings.extra-platforms = ["i686-linux" "x86_64-linux" "i386-linux" "i486-linux" "i586-linux" "i686-linux"];

    boot.binfmt = lib.mkIf (config.nixpkgs.system == "aarch64-linux") {
      preferStaticEmulators = false;

      registrations = {
        # 64 bit
        "x86_64-linux" = {
          # normal setup
          inherit interpreter;
          recognitionType = "magic";

          # magic bytes
          magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
          mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';

          # flags
          preserveArgvZero = false;
          wrapInterpreterInShell = false;
          openBinary = false;
        };
        # 32 bit x86 elf
        "i386-linux" = {
          # normal setup
          inherit interpreter;
          recognitionType = "magic";

          # magic bytes
          magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
          mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';

          # flags
          preserveArgvZero = false;
          wrapInterpreterInShell = false;
          openBinary = false;
        };
        # other 32 bit x86 elf
        "i686-linux" = {
          # normal setup
          inherit interpreter;
          recognitionType = "magic";

          # magic bytes
          magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00'';
          mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';

          # flags
          preserveArgvZero = false;
          wrapInterpreterInShell = false;
          openBinary = false;
        };
      };
    };
  }
