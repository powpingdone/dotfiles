{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ppd.steam.enable {
    environment.systemPackages = with pkgs;
      [
        gamescope
      ]
      ++ (
        if config.ppd.system == "aarch64-linux"
        then [
          (pkgs.steam-arm64.override { guest = false; })
          (pkgs.steam-x86.override { guest = false; })
        ]
        else [
          pkgs.steam-run
        ]
      );

    hardware.steam-hardware.enable = true;

    programs.gamemode = {
      enable = true;
    };

    programs.steam = {
      enable = config.ppd.system != "aarch64-linux";
      package = pkgs.steam.override {
        extraLibraries = pkgs: [pkgs.libxcb];
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
        dwproton-bin
      ];
    };
  };
}
