{
  config,
  lib,
  pkgs,
  ...
}: let
  ppPkg = {
    stdenv,
    fetchFromGitHub,
    ...
  }:
    stdenv.mkDerivation {
      name = "peekpoke";
      src = fetchFromGitHub {
        owner = "apritzel";
        repo = "peekpoke";
        rev = "913be80cee5ec44d01a1bf357250af4146a01d07";
        hash = "sha256-KW7Z5QrIgrz9JS5gETybtQACeiXHjIHczpUiPaN+xsQ=";
      };
      buildPhase = ''
        make
      '';
      installPhase = ''
        mkdir -p $out/bin
        cp ./peekpoke $out/bin
      '';
    };
in {
  config = lib.mkIf config.ppd.peekPoke.enable {
    specialisation.kernelDebug = {
      configuration = {
        environment.systemPackages = with pkgs; [
          (pkgs.callPackage ppPkg {})
        ];

        boot.kernelPatches = [
          {
            name = "crashdump-config";
            patch = null;
            extraConfig = ''
              STRICT_DEVMEM N
              IO_STRICT_DEVMEM N
            '';
          }
        ];
      };
    };
  };
}
