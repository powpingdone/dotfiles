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

  # part of firmware
  systemd.services.pd-mapper = {
    enable = true;
    description = "Qualcomm PD mapper service";
    serviceConfig = {
      ExecStart = "${pkgs.pd-mapper}/bin/pd-mapper";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };

  hardware.deviceTree = {
    enable = true;
    name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";
  };

  x1e.audio.enable = false;

  boot.kernelPatches = [];
}
