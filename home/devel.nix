{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf nixosConfig.ppd.devenv.enable {
    home.packages = with pkgs; [
      gdb
      devenv
    ];

    programs.helix = {
      enable = true;
      settings = {
        theme = "onedark";
        editor.statusline = {
          mode.normal = "   NORMAL   ";
          mode.select = "   SELECT ##";
          mode.insert = "## INSERT   ";
        };
      };
    };

    programs.jujutsu.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # gdb script to add cool thing for detecting deadlocks with `blocked` command
    # taken from https://github.com/DamZiobro/gdb-automatic-deadlock-detector
    xdg.configFile = {
      "gdb/gdbinit".text = ''
        python
        ${lib.readFile ./gdbDisplayLockedThreads.py}
        end
      '';
    };
  };
}
