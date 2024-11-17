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

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "uas" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f0a2c768-aa61-44f2-b1b2-3ee2f48e1c58";
    fsType = "btrfs";
    options = ["subvol=root" "compress-force=zstd:15"];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/4C04-9A9D";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f0a2c768-aa61-44f2-b1b2-3ee2f48e1c58";
    fsType = "btrfs";
    options = ["subvol=nix" "noatime" "compress-force=zstd:15"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/cdcbc2c9-fd67-40f4-b1ae-d83866e8b32a";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/root" = {
    device = "/dev/disk/by-uuid/cdcbc2c9-fd67-40f4-b1ae-d83866e8b32a";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/cdcbc2c9-fd67-40f4-b1ae-d83866e8b32a";
    fsType = "btrfs";
    options = ["subvol=swap" "noatime"];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/cdcbc2c9-fd67-40f4-b1ae-d83866e8b32a";
    fsType = "btrfs";
    options = ["subvol=var" "compress=zstd"];
  };

  swapDevices = [{device = "/swap/swapfile";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0u1u3u1u2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "25.05"; # Did you read the comment?
}
