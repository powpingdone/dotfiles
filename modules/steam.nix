{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ppd.steam.enable {
    environment.systemPackages = with pkgs; [
      steam-run
      gamescope
    ];

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraLibraries = pkgs: [ pkgs.xorg.libxcb ];
      };
      gamescopeSession.enable = true;
      extest.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
