{
  pkgs,
  nixpkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.x1e-nixos-config.nixosModules.x1e
  ];

  swapDevices = [{device = "/swap/swapfile";}];

  environment.systemPackages = [];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # specific quirks regarding this laptop

  # this saves battery
  powerManagement.cpuFreqGovernor = "conservative";

  hardware.lenovo-yoga-slim7x.enable = true;

  boot.kernelPatches = [
    {
      name = "disable-amdgpu";
      patch = null;
    }
  ];
}
