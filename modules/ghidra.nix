{
  config,
  lib,
  pkgs,
  ...
}: let
in {
  config = lib.mkIf config.ppd.ghidra.enable {
    environment.systemPackages = [
      (pkgs.ghidra.withExtensions (gext:
          with gext; [
            machinelearning
            ghidra-golanganalyzerextension
            ret-sync
            findcrypt
          ]
        ++ [
          pkgs.ghidra-switch-loader
        ])
      )
    ];

    nixpkgs.overlays = [
      (final: prev: {
        ghidra-switch-loader = prev.callPackage ./gsl/gsl.nix {ghidra = prev.ghidra;};
      })
    ];
  };
}
