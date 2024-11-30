{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf nixosConfig.ppd.devenv.enable {
    home.packages = [pkgs.devenv];
    programs.direnv = {
      enable = true;
    };
  };
}
