# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime.offload.enable = true;
    prime.offload.enableOffloadCmd = true;
    prime.nvidiaBusId = "PCI:1:0:0";
    prime.amdgpuBusId = "PCI:4:0:0";
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = true;
  };

  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ff860b1e-2e52-4ae4-b2bc-eaddcad0a597";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd:15"];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/1EDB-585B";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ff860b1e-2e52-4ae4-b2bc-eaddcad0a597";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ff860b1e-2e52-4ae4-b2bc-eaddcad0a597";
    fsType = "btrfs";
    options = ["subvol=nix" "compress-force=zstd:15"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f4u1u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "25.05"; # Did you read the comment?
}
