{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.ppd.steam.enable {
    environment.systemPackages = with pkgs; [
      steam-run
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extest.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
