{
  lib,
  config,
  ...
}: {
  config =
    lib.mkIf config.ppd.libvirtd.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true; # enable using TPM
          ovmf.enable = true; # enable UEFI
          runAsRoot = false;
        };
      };
    }
    // lib.mkIf config.ppd.virtManager.enable {
      # if we're also installing libvirtd, make the default vm host us
      dconf.settings = lib.mkIf config.ppd.libvirtd.enable {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
      
      # base always installs my user, so just make him the god
      users.groups.libvirtd.members = [ "powpingdone" ];

      programs.virt-manager.enable = true;
    };
}
