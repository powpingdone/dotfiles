{
  nixosConfig,
  lib,
  ...
}:
lib.mkIf nixosConfig.ppd.desktop.kde {
}
