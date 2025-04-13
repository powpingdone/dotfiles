{
  nixosConfig,
  lib,
  pkgs,
  ...
}: let
  ghidra_pkg = pkgs.ghidra.withExtensions (gext:
    with gext; [
      wasm
      machinelearning
      ghidra-golanganalyzerextension
      gnudisassembler
      ret-sync
      findcrypt
    ]);
in {
  config = lib.mkIf nixosConfig.ppd.ghidra.enable {
    home.packages = [ghidra_pkg];
  };
}
