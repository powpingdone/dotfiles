{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf nixosConfig.ppd.lmms.enable {
    home.packages = [
      (
        if nixosConfig.system == "x86_64-linux"
        then
          (pkgs.callPackage ./pkg.nix {
            withOptionals = true;
            withWine = true;
          })
        else
          (pkgs.callPackage ./pkg.nix {
            withOptionals = true;
          })
      )
    ];
  };
}
