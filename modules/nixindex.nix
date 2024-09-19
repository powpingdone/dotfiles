{ config, lib, ...}:
{
  config = lib.mkIf config.ppd.nixIndex.enable {
    programs.command-not-found.enable = false;

    environment.systemPackages = with pkgs; [
      pkgs.nix-index;
    ];

    programs.zsh.interactiveShellInit = ''
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';
    };
  };
}
