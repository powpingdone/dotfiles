{
  lib,
  config,
  ...
}:
lib.mkIf config.ppd.bootloader.wsl {
  wsl = {
    enable = true;
    defaultUser = "powpingdone";
  };

  ppd.fonts.enable = true;
}
