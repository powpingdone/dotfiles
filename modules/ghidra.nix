{
  config,
  lib,
  pkgs,
  ...
}: let
in {
  config = lib.mkIf config.ppd.ghidra.enable {
    environment.systemPackages = [
      (
        pkgs.ghidra.withExtensions (gext:
          with gext;
            [
              machinelearning
              ghidra-golanganalyzerextension
              ret-sync
              findcrypt
            ]
            ++ [
              pkgs.ghidra-switch-loader
              pkgs.ghidra-emotionengine-reloaded
            ])
      )
    ];

    nixpkgs.overlays = [
      (final: prev: {
        ghidra-switch-loader = prev.callPackage ./gsl/gsl.nix {ghidra = prev.ghidra;};
        ghidra-emotionengine-reloaded = prev.callPackage ./ghidra-ee/ee.nix {ghidra = prev.ghidra;};
      })
    ];
  };
}
