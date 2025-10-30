{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf nixosConfig.ppd.lmms.enable {
      home.packages = [
        (pkgs.callPackage ./pkg.nix { withOptionals = true; })
      ];
    };
}
