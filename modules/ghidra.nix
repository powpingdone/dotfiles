{
  config,
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
  config = lib.mkIf config.ppd.ghidra.enable {
    environment.systemPackages = [
      ghidra_pkg
    ];
    nixpkgs.overlays = [
                (final: prev: {
                  ghidra-extensions = prev.ghidra-extensions.overrideScope (gefinal: geprev: {
                    # I legit don't know why I need to pass the override over as well, but
                    # nixpkgs tries callinv override after I override the scope which is *very bizzare*
                    override = prev.ghidra-extensions.override;
                    ghidra-switch-loader = prev.callPackage ./gsl/gsl.nix;
                  });
                })
    ];
  };
}
