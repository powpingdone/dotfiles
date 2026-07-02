{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ppd.waydroid.enable {
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
  environment.systemPackages = [pkgs.waydroid-helper];
}
