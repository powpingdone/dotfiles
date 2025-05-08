{
  pkgs,
  nixpkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  swapDevices = [{device = "/swap/swapfile";}];

  # specific quirks regarding this laptop

  # this saves battery
  powerManagement.cpuFreqGovernor = "conservative";

  # enable dtb
  hardware.deviceTree = {
    enable = true;
    name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";
  };

  hardware.lenovo-yoga-slim7x.enable = true;

  boot.kernelPatches = [];
}
