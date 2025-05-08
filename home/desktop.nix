{
  nixosConfig,
  lib,
  pkgs,
  ...
}:
lib.mkIf nixosConfig.ppd.desktop.enable {
  programs.firefox.enable = true;
  ppd.emacs.enable = true;

  home.packages = with pkgs; [
    nextcloud-client
    gimp
    (inkscape-with-extensions.override
      {
        inkscapeExtensions = with pkgs.inkscape-extensions; [silhouette];
      })
    (
      # install onlyoffice, fallback to libreoffice if platform unsupported
      if builtins.any (plat: nixosConfig.ppd.system == plat) onlyoffice-desktopeditors.meta.platforms
      then onlyoffice-desktopeditors
      else libreoffice
    )
    hunspell
    hunspellDicts.en_US
    vlc
    bitwarden-desktop

    # yubi stuff
    yubikey-manager
    yubikey-personalization
    yubikey-personalization-gui
    yubico-piv-tool
    yubioath-flutter
  ];

  programs.gnome-shell.enable = true;

  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    {package = alphabetical-app-grid;}
    {package = blur-my-shell;}
    {package = gamemode-shell-extension;}
  ];

  dconf = {
    enable = true;
    settings = {
      # enable dark mode for gtk4
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      "org/gnome/mutter" = {
        # regular things for me
        dynamic-workspaces = true;
        edge-tiling = true;
        # turn on fractional scaling
        experimental-features = ["scale-monitor-framebuffer"];
        # on multi monitors, I only want one with workspaces
        workspaces-only-on-primary = true;
      };
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
      # if we're also installing libvirtd and virt-manager, make the default vm host us
      "org/virt-manager/virt-manager/connections" = lib.mkIf (nixosConfig.ppd.libvirtd.enable
        && nixosConfig.ppd.virtManager.enable) {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  # add flathub repo
  home.activation = {
    flatpakSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if ${pkgs.flatpak}/bin/flatpak remotes --columns title | grep "Flathub" && ${pkgs.libressl}/bin/nc -zw20 google.com 443; then
        run ${pkgs.flatpak}/bin/flatpak remote-add $VERBOSE_ARG --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      fi
    '';
  };
}
