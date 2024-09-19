{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ppd.nixIndex.enable {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enable = true;
    programs.zsh.interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };
}
