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
    libreoffice
    hunspell
    hunspellDicts.en_US
    vlc
    bitwarden-desktop
    thunderbird
    signal-desktop
    prismlauncher
    coppwr

    # yubi stuff
    yubikey-manager
    yubico-piv-tool
    yubioath-flutter
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        # enable dark mode for most programs
        color-scheme = "prefer-dark";
      };

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
