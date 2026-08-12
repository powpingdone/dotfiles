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
      ghidra-switch-loader
    ]);
in {
  config = lib.mkIf nixosConfig.ppd.ghidra.enable {
    environment.systemPackages = [ghidra_pkg];

    nixpkgs.overlays = [
      
      (final: prev: {
        ghidra =
          prev.ghidra.overrideScope
            (gfinal: gprev: {
              ghidra-switch-loader = (gprev.callPackage ./gsl/gsl.nix);
            })
          ;}
      )
    ];
  };
}
