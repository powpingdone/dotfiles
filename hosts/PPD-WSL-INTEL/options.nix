{...}: {
  ppd = {
    system = "x86_64-linux";
    cores = 2;
    jobs = 2;

    emacs.enable = true;
    devenv.enable = true;
    bootloader.wsl = true;
  };
}
