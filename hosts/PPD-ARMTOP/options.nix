{...}: {
  ppd = {
    system = "aarch64-linux";
    cores = 4;
    jobs = 3;

    desktop.enable = true;
    steam.enable = false;
    isHIDPI = true;
    bootloader.systemd-boot = true;
  };
}
