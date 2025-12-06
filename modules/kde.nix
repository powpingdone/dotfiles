{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.ppd.desktop.kde {
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      settings.General.DisplayServer = "wayland";
    };
    defaultSession = "plasma";
  };

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter
  ];
}
