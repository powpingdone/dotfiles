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
    libX11
    libXext
    libXrandr
    libXrender
    libxcb
    libXfixes
    libXcomposite
    libXcursor
    libXdamage
    libXi
    libXinerama
    libXScrnSaver
    libSM
    libICE
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
  platforms = ["i686-linux" "x86_64-linux" "i386-linux"];
in
  lib.mkIf config.ppd.box64.enable
  {
    nixpkgs.overlays = [
      (
        final: prev: {
          amd64set = import pkgs.path {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
        }
      )
    ];

    security.wrappers.bwrap = {
      owner  = "root";
      group  = "root";
      source = "${pkgs.bubblewrap}/bin/bwrap";
      setuid = true;
    };

    environment.systemPackages = let
      # A box64 testing script
      testx86 = pkgs.writeShellScriptBin "testx86" ''
        exec ${pkgs.amd64set.hello}/bin/hello
      '';

      steamcmdPkg = pkgs.amd64set.steamcmd;
      steamPkg = pkgs.amd64set.steam-unwrapped;

      steamFhs = pkgs.buildFHSEnv {
        name = "steam-box64-fhs";

        targetPkgs = p:
          with p; [
            box64
            bash
            coreutils
            curl
            glibc
            libgcc
            zlib
            bzip2
            xz
            gnutls
            udev
            libX11
            libXext
            libXfixes
            libXcursor
            libXrandr
            libXrender
            libxcb
            libXi
            libXinerama
            libXScrnSaver
            libSM
            libICE
            libGL
            libGLU
            vulkan-loader
            gtk2
            gtk3
            glib
            pango
            cairo
            freetype
            fontconfig
            dbus
            util-linux
            alsa-lib
            libpulseaudio
            libdrm
            libvdpau
            libvorbis
            libogg
          ];

        runScript = pkgs.writeShellScript "steam-fhs-inner" ''
          exec "$@"
        '';
      };

      steamcmdWrapper = pkgs.writeShellScriptBin "steamcmd" ''
        set -e
        STEAMROOT="$HOME/.local/share/Steam"
        PATH="$PATH''${PATH:+:}${pkgs.coreutils}/bin"

        if [ ! -e "$STEAMROOT" ]; then
          mkdir -p "$STEAMROOT"/{appcache,config,logs,Steamapps/common}
          mkdir -p ~/.steam
          ln -sf "$STEAMROOT" ~/.steam/root
          ln -sf "$STEAMROOT" ~/.steam/steam
        fi

        if [ ! -e "$STEAMROOT/steamcmd.sh" ]; then
          mkdir -p "$STEAMROOT/linux32"
          cd ${steamcmdPkg}/share/steamcmd
          find . -type f -exec install -Dm 755 "{}" "$STEAMROOT/{}" \;
        fi

        exec ${steamFhs}/bin/steam-box64-fhs "$STEAMROOT/steamcmd.sh" "$@"
      '';

      steamWrapper = pkgs.symlinkJoin {
        name = "steam-box64";
        paths = [steamPkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          rm -f $out/bin/steam

          makeWrapper ${steamFhs}/bin/steam-box64-fhs $out/bin/steam \
            --add-flags "${steamPkg}/bin/steam -no-cef-sandbox -cef-disable-gpu -cef-disable-software-rasterizer" \
            --set STEAM_OS linux \
            --set STEAM_RUNTIME 1
        '';
      };

      steamRunWrapper = pkgs.writeShellScriptBin "steam-run" ''
        set -e
        exec ${steamFhs}/bin/steam-box64-fhs "$@"
      '';
    in [testx86 steamcmdWrapper steamWrapper steamRunWrapper];

    nix.settings = {
      extra-sandbox-paths = [
        "/run/binfmt"
        "${interpreter}"
      ];

      extra-platforms = platforms;
    };

    # redirection
    boot.binfmt = lib.mkIf (config.nixpkgs.system == "aarch64-linux") {
      emulatedSystems = platforms;

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
