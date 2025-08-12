{
  lib,
  config,
  pkgs,
  nixpkgs,
}: let
  box64_dynaRec = pkgs.box64.override {withDynarec = true;};
  box64_ = box64_dynaRec.overrideAttrs (finalAttrs: prevAttrs: {
    cmakeFlags =
      prevAttrs.cmakeFlags
      ++ config.ppd.box64.cmakeFlags
      ++ [(lib.cmakeBool "BOX32" true)];
  });
in
  lib.mkIf config.ppd.box64.enable {
    environment.systemPackages = [
      box64_
    ];
    programs.steam = lib.mkIf config.ppd.steam.enable {
      enable = true;
    };
  }
