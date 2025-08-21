{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.ppd.podman.enable {
  virtualization.podman = {
    enable = true;
    dockerSocket.enable = true;
  };
}
