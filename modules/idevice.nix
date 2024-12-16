{
  pkgs,
  lib,
  config,
  fetchFromGitHub,
  ppdOpts,
  ...
}: {
  config =
    lib.mkIf config.ppd.idevice.enable {
    };
}
