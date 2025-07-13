{...}: {
  ppd = {
    system = "x86_64-linux";
    cores = 6;
    jobs = 4;

    libvirtd.enable = true;
    virtManager.enable = true;
    desktop = {
      enable = true;
      kde = true;
    };
    steam = {
      enable = true;
      gamemodeConfig = {
        gpu = {
          apply_gpu_optimizations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };
    };
    bootloader.grub = true;
  };
}
