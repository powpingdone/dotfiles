{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.ppd.desktop.gnome {
  services.displayManager = {
    # use gnome display manager
    gdm.enable = true;
    defaultSession = "gnome";
  };

  # use gnome
  services.desktopManager.gnome.enable = true;

  # I don't need the gnome web browser and email client
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
