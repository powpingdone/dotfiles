{ lib, config, nixpkgs, ... }:
{
  options = {
    ppdesktop.enable = lib.mkEnableOption "Enable Desktop";
  }

  config = lib.mkIf config.ppdesktop.enable {
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

    services.displayManager = {
      enable = true;
      defaultSession = "gnome";
    };

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
    ];

    programs.firefox.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
