{
  config,
  lib,
  ...
}:
lib.mkIf config.ppd.waydroid.enable {
  virtualisation.waydroid.enable = true;
}
