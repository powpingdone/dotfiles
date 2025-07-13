{
  lib,
  pkgs,
  nixosConfig,
  ...
}:
lib.mkIf nixosConfig.ppd.desktop.gnome {
  programs.gnome-shell.enable = true;

  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    {package = alphabetical-app-grid;}
    {package = blur-my-shell;}
    {package = gamemode-shell-extension;}
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        # show battery percent
        show-battery-percentage = true;
      };

      "org/gnome/mutter" = {
        # unlimited workspaces
        dynamic-workspaces = true;
        # window tiling
        edge-tiling = true;
        # turn on "ok-ish" fractional scaling
        experimental-features = ["scale-monitor-framebuffer"];
        # on multi monitors, I only want one with workspaces
        workspaces-only-on-primary = true;
      };

      # power off on power button pressed
      "org/gnome/settings-daemon/plugins/power".power-button-action = "interactive";

      # win+enter for open terminal
      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "kgx";
        name = "Open Terminal";
      };

      # turn off panel blur-my-shell
      "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;

      # only show gamemoderun when it's actually active
      "org/gnome/shell/extensions/gamemodeshellextension".show-icon-only-when-active = true;
    };
  };
}
