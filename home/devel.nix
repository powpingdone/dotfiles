{
  nixosConfig,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf nixosConfig.ppd.devenv.enable {
    home.packages = [pkgs.devenv];
    programs.direnv = {
      enable = true;
    };
    programs.zsh.initExtra = ''eval "$(${config.programs.direnv.package}/bin/direnv hook zsh)"'';
  };
}
