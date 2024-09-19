{
  nixosConfig,
  lib,
  ppd,
  ...
}:
lib.mkIf nixosConfig.ppd.desktop.enable {
  programs.firefox.enable = true;
  ppd.emacs.enable = true;

  # enable dark mode for gtk4
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
	edge-tiling = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "kgx";
        name = "Open Terminal";
      };
    };
  };
}
