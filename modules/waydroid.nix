{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ppd.waydroid.enable {
  virtualisation.waydroid.enable = true;
  environment.systemPackages = [pkgs.waydroid-helper];
}
