{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.ppd.podman.enable {
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };
}
