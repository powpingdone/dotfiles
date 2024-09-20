{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ppd.desktop.enable {
    # base packages that I *always* need.
    environment.systemPackages = with pkgs; [
      openjdk17
    ];
    
    # Enable pipewire sound.
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable Bluetooth
    hardware.bluetooth.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # use gnome
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # setup gdm properly
    services.displayManager = {
      enable = true;
      defaultSession = "gnome";
    };

    # I don't need the gnome web browser and email client
    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
    ];

    # enable portals
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    # use ozone on desktop
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
