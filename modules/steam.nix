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

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraLibraries = pkgs: [pkgs.xorg.libxcb];
      };
      gamescopeSession = {
        enable = true;
        args = [
          "--hdr-enabled"
          "--hdr-itm-enable"
          "--hide-cursor-delay"
          "3000"
          "--fade-out-duration"
          "200"
          "--xwayland-count"
          "2"
          "-O"
          "*,eDP-1"
        ];
      };
      extest.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
