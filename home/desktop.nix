{
  nixosConfig,
  lib,
  ppd,
  pkgs,
  ...
}:
lib.mkIf nixosConfig.ppd.desktop.enable {
  programs.firefox.enable = true;
  ppd.emacs.enable = true;

  home.packages = with pkgs; [
    nextcloud-client
  ];

  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    {package = alphabetical-app-grid;}
    {package = blur-my-shell;}
  ];

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

  # add flathub repo
  home.activation = {
    flatpakSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.flatpak}/bin/flatpak remote-add $VERBOSE_ARG --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
