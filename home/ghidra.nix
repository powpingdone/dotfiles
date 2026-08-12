{
  nixosConfig,
  lib,
  pkgs,
  ...
}: let
  ghidra_pkg = pkgs.ghidra.withExtensions (gext:
    with gext; [
      machinelearning
      ghidra-golanganalyzerextension
      ret-sync
      findcrypt
      (pkgs.ghidra.buildGhidraExtension
        (finalAttrs: let
          rev = "183b0a0b8dca2dff23ab1c650fd77277297360ff";
        in {
          pname = "ghidra-switch-loader";
          version = rev;
          src = pkgs.fetchFromGitHub {
            owner = "Adubbz";
            repo = "ghidra-switch-loader";
            inherit rev;
            hash = "sha256-gHKFKS+RQD0CYuO7LrZt8Sse8C9coHemHFdp2uemCF4=";
          };
        }))
    ]);
in {
  config = lib.mkIf nixosConfig.ppd.ghidra.enable {
    home.packages = [ghidra_pkg];
  };
}
