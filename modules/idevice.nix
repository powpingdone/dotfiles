{
  pkgs,
  lib,
  config,
  fetchFromGitHub,
  ppdOpts,
  ...
}: {
  config = lib.mkIf config.ppd.idevice.enable {
    # enable it
    environment.systemPackages = [pkgs.idevicerestore];
    services.usbmuxd.enable = true;
  };
}
