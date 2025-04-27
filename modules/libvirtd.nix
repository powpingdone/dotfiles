{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ppd.libvirtd.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        # TPM
        swtpm.enable = true;
        # uefi
        ovmf = {
          enable = true;
          packages = [
            pkgs.OVMFFull.fd
          ];
        };
        # dont run qemu as root
        runAsRoot = false;
        # shared folders
        vhostUserPackages = [pkgs.virtiofsd];
      };
      # do not start up vms automatically, I will configure that
      onBoot = "ignore";
    };
  };
}
